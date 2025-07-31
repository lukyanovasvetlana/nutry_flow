#!/usr/bin/env python3
"""
Sprint Metrics Generator
Генерация детальных метрик спринта для NutryFlow
"""

import json
import requests
import argparse
import sys
from datetime import datetime, timedelta
from typing import Dict, List
import matplotlib.pyplot as plt
import pandas as pd

class SprintMetricsGenerator:
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
    
    def calculate_velocity(self, sprint_data: List[Dict]) -> int:
        """Рассчитать velocity команды"""
        completed_points = 0
        for issue in sprint_data:
            if issue['state'] == 'closed':
                points = self.extract_story_points(issue)
                completed_points += points
        return completed_points
    
    def calculate_defect_rate(self, sprint_data: List[Dict]) -> float:
        """Рассчитать defect rate"""
        total_issues = len(sprint_data)
        defect_issues = len([issue for issue in sprint_data if 'bug' in [label['name'] for label in issue.get('labels', [])]])
        return (defect_issues / total_issues * 100) if total_issues > 0 else 0
    
    def calculate_cycle_time(self, sprint_data: List[Dict]) -> float:
        """Рассчитать средний cycle time"""
        cycle_times = []
        for issue in sprint_data:
            if issue['state'] == 'closed' and issue.get('closed_at'):
                created_at = datetime.fromisoformat(issue['created_at'].replace('Z', '+00:00'))
                closed_at = datetime.fromisoformat(issue['closed_at'].replace('Z', '+00:00'))
                cycle_time = (closed_at - created_at).days
                cycle_times.append(cycle_time)
        
        return sum(cycle_times) / len(cycle_times) if cycle_times else 0
    
    def calculate_sprint_goal_achievement(self, sprint_data: List[Dict]) -> float:
        """Рассчитать достижение целей спринта"""
        total_points = sum(self.extract_story_points(issue) for issue in sprint_data)
        completed_points = sum(
            self.extract_story_points(issue) for issue in sprint_data 
            if issue['state'] == 'closed'
        )
        return (completed_points / total_points * 100) if total_points > 0 else 0
    
    def generate_status_distribution(self, sprint_data: List[Dict]) -> Dict[str, int]:
        """Генерировать распределение по статусам"""
        status_counts = {}
        for issue in sprint_data:
            status = issue['state']
            status_counts[status] = status_counts.get(status, 0) + 1
        return status_counts
    
    def generate_priority_distribution(self, sprint_data: List[Dict]) -> Dict[str, int]:
        """Генерировать распределение по приоритетам"""
        priority_counts = {}
        for issue in sprint_data:
            for label in issue.get('labels', []):
                if 'priority' in label['name'].lower():
                    priority = label['name'].split('-')[-1]
                    priority_counts[priority] = priority_counts.get(priority, 0) + 1
                    break
        return priority_counts
    
    def generate_epic_distribution(self, sprint_data: List[Dict]) -> Dict[str, int]:
        """Генерировать распределение по эпикам"""
        epic_counts = {}
        for issue in sprint_data:
            for label in issue.get('labels', []):
                if 'epic' in label['name'].lower():
                    epic = label['name'].split('-')[-1]
                    epic_counts[epic] = epic_counts.get(epic, 0) + 1
                    break
        return epic_counts
    
    def create_metrics_visualization(self, sprint_data: List[Dict]):
        """Создать визуализацию метрик"""
        fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(15, 10))
        
        # 1. Распределение по статусам
        status_dist = self.generate_status_distribution(sprint_data)
        if status_dist:
            ax1.pie(status_dist.values(), labels=status_dist.keys(), autopct='%1.1f%%')
            ax1.set_title('Issue Status Distribution')
        
        # 2. Распределение по приоритетам
        priority_dist = self.generate_priority_distribution(sprint_data)
        if priority_dist:
            ax2.bar(priority_dist.keys(), priority_dist.values())
            ax2.set_title('Issue Priority Distribution')
            ax2.set_ylabel('Number of Issues')
        
        # 3. Распределение по эпикам
        epic_dist = self.generate_epic_distribution(sprint_data)
        if epic_dist:
            ax3.barh(list(epic_dist.keys()), list(epic_dist.values()))
            ax3.set_title('Issue Epic Distribution')
            ax3.set_xlabel('Number of Issues')
        
        # 4. Story Points по статусам
        points_by_status = {}
        for issue in sprint_data:
            status = issue['state']
            points = self.extract_story_points(issue)
            points_by_status[status] = points_by_status.get(status, 0) + points
        
        if points_by_status:
            ax4.bar(points_by_status.keys(), points_by_status.values())
            ax4.set_title('Story Points by Status')
            ax4.set_ylabel('Story Points')
        
        plt.tight_layout()
        plt.savefig('sprint_metrics.png', dpi=300, bbox_inches='tight')
        plt.close()
    
    def generate_metrics_report(self) -> str:
        """Генерировать полный отчет по метрикам"""
        sprint_data = self.get_sprint_issues()
        
        velocity = self.calculate_velocity(sprint_data)
        defect_rate = self.calculate_defect_rate(sprint_data)
        cycle_time = self.calculate_cycle_time(sprint_data)
        goal_achievement = self.calculate_sprint_goal_achievement(sprint_data)
        
        status_dist = self.generate_status_distribution(sprint_data)
        priority_dist = self.generate_priority_distribution(sprint_data)
        epic_dist = self.generate_epic_distribution(sprint_data)
        
        # Создаем визуализацию
        self.create_metrics_visualization(sprint_data)
        
        report = f"""# Sprint Metrics Report - {datetime.now().strftime('%Y-%m-%d')}

## 📊 Key Performance Indicators

### Velocity & Progress
- **Team Velocity**: {velocity} story points
- **Sprint Goal Achievement**: {goal_achievement:.1f}%
- **Average Cycle Time**: {cycle_time:.1f} days

### Quality Metrics
- **Defect Rate**: {defect_rate:.1f}%
- **Total Issues**: {len(sprint_data)}
- **Completed Issues**: {status_dist.get('closed', 0)}

## 📋 Issue Distribution

### Status Distribution
"""
        
        for status, count in status_dist.items():
            percentage = (count / len(sprint_data)) * 100 if sprint_data else 0
            report += f"- **{status.title()}**: {count} issues ({percentage:.1f}%)\n"
        
        if priority_dist:
            report += "\n### Priority Distribution\n"
            for priority, count in priority_dist.items():
                report += f"- **{priority.title()}**: {count} issues\n"
        
        if epic_dist:
            report += "\n### Epic Distribution\n"
            for epic, count in epic_dist.items():
                report += f"- **{epic.title()}**: {count} issues\n"
        
        # Блокеры
        blockers = [issue for issue in sprint_data if 'blocker' in [label['name'] for label in issue.get('labels', [])]]
        if blockers:
            report += "\n## 🚧 Blockers\n"
            for blocker in blockers:
                report += f"- {blocker['title']} (#{blocker['number']})\n"
        
        # Рекомендации
        report += "\n## 💡 Recommendations\n"
        
        if defect_rate > 20:
            report += "- ⚠️ High defect rate detected. Consider improving testing processes.\n"
        
        if cycle_time > 5:
            report += "- ⏱️ Long cycle time detected. Consider breaking down larger stories.\n"
        
        if goal_achievement < 80:
            report += "- 🎯 Sprint goal achievement below target. Review scope and priorities.\n"
        
        if velocity < 20:
            report += "- 📈 Low velocity detected. Consider team capacity and story sizing.\n"
        
        report += "\n## 📈 Trends\n"
        report += "- Velocity trend: [TO BE TRACKED OVER TIME]\n"
        report += "- Quality trend: [TO BE TRACKED OVER TIME]\n"
        report += "- Team happiness: [TO BE TRACKED OVER TIME]\n"
        
        return report

def main():
    parser = argparse.ArgumentParser(description='Generate Sprint Metrics')
    parser.add_argument('--github-token', required=True, help='GitHub token')
    parser.add_argument('--repo', required=True, help='Repository name (owner/repo)')
    parser.add_argument('--output', default='sprint_metrics_report.md', help='Output file path')
    
    args = parser.parse_args()
    
    generator = SprintMetricsGenerator(args.github_token, args.repo)
    report = generator.generate_metrics_report()
    
    with open(args.output, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"Metrics report generated: {args.output}")
    print("Visualization saved: sprint_metrics.png")

if __name__ == '__main__':
    main() 