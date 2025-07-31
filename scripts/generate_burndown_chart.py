#!/usr/bin/env python3
"""
Burndown Chart Generator
Генерация burndown chart для спринта NutryFlow
"""

import json
import requests
import argparse
import sys
from datetime import datetime, timedelta
from typing import Dict, List, Tuple
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import pandas as pd
import numpy as np

class BurndownChartGenerator:
    def __init__(self, github_token: str, repo: str):
        self.github_token = github_token
        self.repo = repo
        self.headers = {
            'Authorization': f'token {github_token}',
            'Accept': 'application/vnd.github.v3+json'
        }
        self.base_url = f'https://api.github.com/repos/{repo}'
    
    def get_sprint_issues(self, sprint_label: str = 'sprint-active') -> List[Dict]:
        """Получить все задачи текущего спринта"""
        url = f'{self.base_url}/issues'
        params = {
            'state': 'all',
            'labels': sprint_label,
            'per_page': 100
        }
        
        response = requests.get(url, headers=self.headers, params=params)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Error fetching issues: {response.status_code}")
            return []
    
    def extract_story_points(self, issue: Dict) -> int:
        """Извлечь story points из задачи"""
        for label in issue.get('labels', []):
            if 'story-points' in label['name'].lower():
                try:
                    return int(label['name'].split('-')[-1])
                except ValueError:
                    continue
        
        body = issue.get('body', '')
        if 'Story Points:' in body:
            try:
                points_line = [line for line in body.split('\n') if 'Story Points:' in line][0]
                return int(points_line.split(':')[1].strip())
            except (ValueError, IndexError):
                pass
        
        return 0
    
    def calculate_ideal_burndown(self, total_points: int, sprint_duration: int) -> List[Tuple[datetime, float]]:
        """Рассчитать идеальную линию burndown"""
        ideal_line = []
        start_date = datetime.now() - timedelta(days=sprint_duration)
        
        for day in range(sprint_duration + 1):
            date = start_date + timedelta(days=day)
            remaining_points = total_points - (total_points / sprint_duration) * day
            ideal_line.append((date, max(0, remaining_points)))
        
        return ideal_line
    
    def calculate_actual_burndown(self, sprint_data: List[Dict], sprint_duration: int = 14) -> List[Tuple[datetime, float]]:
        """Рассчитать фактическую линию burndown"""
        total_points = sum(self.extract_story_points(issue) for issue in sprint_data)
        start_date = datetime.now() - timedelta(days=sprint_duration)
        
        actual_line = []
        completed_points_by_date = {}
        
        # Группируем завершенные задачи по дате
        for issue in sprint_data:
            if issue['state'] == 'closed' and issue.get('closed_at'):
                closed_date = datetime.fromisoformat(issue['closed_at'].replace('Z', '+00:00'))
                points = self.extract_story_points(issue)
                
                # Округляем до дня
                day_key = closed_date.replace(hour=0, minute=0, second=0, microsecond=0)
                completed_points_by_date[day_key] = completed_points_by_date.get(day_key, 0) + points
        
        # Строим фактическую линию
        cumulative_completed = 0
        for day in range(sprint_duration + 1):
            current_date = start_date + timedelta(days=day)
            
            # Добавляем точки, завершенные в этот день
            if current_date in completed_points_by_date:
                cumulative_completed += completed_points_by_date[current_date]
            
            remaining_points = total_points - cumulative_completed
            actual_line.append((current_date, max(0, remaining_points)))
        
        return actual_line
    
    def create_burndown_chart(self, sprint_data: List[Dict], sprint_duration: int = 14):
        """Создать burndown chart"""
        total_points = sum(self.extract_story_points(issue) for issue in sprint_data)
        
        if total_points == 0:
            print("No story points found in sprint data")
            return
        
        # Рассчитываем линии
        ideal_line = self.calculate_ideal_burndown(total_points, sprint_duration)
        actual_line = self.calculate_actual_burndown(sprint_data, sprint_duration)
        
        # Создаем график
        fig, ax = plt.subplots(figsize=(12, 8))
        
        # Идеальная линия
        ideal_dates = [point[0] for point in ideal_line]
        ideal_points = [point[1] for point in ideal_line]
        ax.plot(ideal_dates, ideal_points, 'b--', linewidth=2, label='Ideal Burndown', alpha=0.7)
        
        # Фактическая линия
        actual_dates = [point[0] for point in actual_line]
        actual_points = [point[1] for point in actual_line]
        ax.plot(actual_dates, actual_points, 'r-', linewidth=3, label='Actual Burndown', marker='o')
        
        # Настройка графика
        ax.set_xlabel('Date')
        ax.set_ylabel('Remaining Story Points')
        ax.set_title(f'Burndown Chart - Sprint (Total: {total_points} points)')
        ax.legend()
        ax.grid(True, alpha=0.3)
        
        # Форматирование оси X
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%m/%d'))
        ax.xaxis.set_major_locator(mdates.DayLocator(interval=2))
        plt.xticks(rotation=45)
        
        # Добавляем аннотации
        current_points = actual_points[-1] if actual_points else total_points
        ax.annotate(f'Current: {current_points:.1f} points', 
                   xy=(actual_dates[-1], current_points),
                   xytext=(10, 10), textcoords='offset points',
                   bbox=dict(boxstyle='round,pad=0.3', facecolor='yellow', alpha=0.7),
                   arrowprops=dict(arrowstyle='->', connectionstyle='arc3,rad=0'))
        
        plt.tight_layout()
        plt.savefig('burndown_chart.png', dpi=300, bbox_inches='tight')
        plt.close()
        
        # Создаем текстовый отчет
        self.create_burndown_report(ideal_line, actual_line, total_points)
    
    def create_burndown_report(self, ideal_line: List[Tuple[datetime, float]], 
                              actual_line: List[Tuple[datetime, float]], 
                              total_points: int):
        """Создать текстовый отчет по burndown"""
        current_points = actual_line[-1][1] if actual_line else total_points
        ideal_current = ideal_line[-1][1] if ideal_line else 0
        
        variance = current_points - ideal_current
        
        report = f"""# Burndown Chart Report - {datetime.now().strftime('%Y-%m-%d')}

## 📊 Burndown Analysis

### Current Status
- **Total Story Points**: {total_points}
- **Current Remaining**: {current_points:.1f} points
- **Ideal Remaining**: {ideal_current:.1f} points
- **Variance**: {variance:+.1f} points

### Performance Indicators
"""
        
        if variance > 0:
            report += f"- ⚠️ **Behind Schedule**: {variance:.1f} points behind ideal\n"
        elif variance < 0:
            report += f"- ✅ **Ahead of Schedule**: {abs(variance):.1f} points ahead of ideal\n"
        else:
            report += "- ✅ **On Schedule**: Exactly on track\n"
        
        # Прогноз завершения
        if actual_line:
            remaining_days = len([p for p in actual_line if p[1] > 0])
            report += f"\n### Completion Forecast\n"
            report += f"- **Estimated Days Remaining**: {remaining_days}\n"
            
            if variance > 0:
                report += f"- **Risk Level**: High - Consider scope reduction or additional resources\n"
            elif variance < -5:
                report += f"- **Opportunity**: Consider adding more stories to the sprint\n"
            else:
                report += f"- **Status**: On track for successful completion\n"
        
        # Рекомендации
        report += "\n## 💡 Recommendations\n"
        
        if variance > 5:
            report += "- 🔄 Consider reducing sprint scope\n"
            report += "- 👥 Review team capacity and blockers\n"
            report += "- 📋 Prioritize high-value stories\n"
        elif variance < -5:
            report += "- ➕ Consider adding more stories to the sprint\n"
            report += "- 🎯 Focus on quality and testing\n"
        else:
            report += "- ✅ Continue current pace\n"
            report += "- 📊 Monitor progress daily\n"
        
        report += "\n## 📈 Daily Progress\n"
        report += "| Date | Ideal | Actual | Variance |\n"
        report += "|------|-------|--------|----------|\n"
        
        for i, (ideal_date, ideal_points) in enumerate(ideal_line):
            if i < len(actual_line):
                actual_date, actual_points = actual_line[i]
                daily_variance = actual_points - ideal_points
                report += f"| {ideal_date.strftime('%m/%d')} | {ideal_points:.1f} | {actual_points:.1f} | {daily_variance:+.1f} |\n"
        
        with open('burndown_report.md', 'w', encoding='utf-8') as f:
            f.write(report)
        
        print("Burndown chart saved: burndown_chart.png")
        print("Burndown report saved: burndown_report.md")

def main():
    parser = argparse.ArgumentParser(description='Generate Burndown Chart')
    parser.add_argument('--github-token', required=True, help='GitHub token')
    parser.add_argument('--repo', required=True, help='Repository name (owner/repo)')
    parser.add_argument('--sprint-duration', type=int, default=14, help='Sprint duration in days')
    
    args = parser.parse_args()
    
    generator = BurndownChartGenerator(args.github_token, args.repo)
    sprint_data = generator.get_sprint_issues()
    
    if not sprint_data:
        print("No sprint data found. Please ensure issues are labeled with 'sprint-active'")
        sys.exit(1)
    
    generator.create_burndown_chart(sprint_data, args.sprint_duration)

if __name__ == '__main__':
    main() 