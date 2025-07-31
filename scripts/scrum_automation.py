#!/usr/bin/env python3
"""
Scrum Master Automation Script
Автоматизация процессов Scrum для проекта NutryFlow
"""

import json
import requests
import os
from datetime import datetime, timedelta
from typing import Dict, List, Optional
import argparse
import sys

class ScrumAutomation:
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
    
    def calculate_velocity(self, sprint_data: List[Dict]) -> int:
        """Рассчитать velocity команды"""
        completed_points = 0
        for issue in sprint_data:
            if issue['state'] == 'closed':
                # Извлекаем story points из labels или body
                points = self.extract_story_points(issue)
                completed_points += points
        
        return completed_points
    
    def extract_story_points(self, issue: Dict) -> int:
        """Извлечь story points из задачи"""
        # Проверяем labels на наличие story points
        for label in issue.get('labels', []):
            if 'story-points' in label['name'].lower():
                try:
                    return int(label['name'].split('-')[-1])
                except ValueError:
                    continue
        
        # Проверяем body на наличие story points
        body = issue.get('body', '')
        if 'Story Points:' in body:
            try:
                points_line = [line for line in body.split('\n') if 'Story Points:' in line][0]
                return int(points_line.split(':')[1].strip())
            except (ValueError, IndexError):
                pass
        
        return 0
    
    def generate_burndown_data(self, sprint_data: List[Dict], sprint_duration: int = 14) -> Dict:
        """Генерировать данные для burndown chart"""
        total_points = sum(self.extract_story_points(issue) for issue in sprint_data)
        remaining_points = []
        dates = []
        
        # Имитируем идеальную линию
        for day in range(sprint_duration):
            ideal_remaining = total_points - (total_points / sprint_duration) * day
            remaining_points.append(max(0, ideal_remaining))
            dates.append((datetime.now() - timedelta(days=sprint_duration-day)).strftime('%Y-%m-%d'))
        
        return {
            'dates': dates,
            'remaining_points': remaining_points,
            'total_points': total_points
        }
    
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
    
    def generate_daily_report(self) -> str:
        """Генерировать ежедневный отчет"""
        sprint_data = self.get_sprint_issues()
        
        velocity = self.calculate_velocity(sprint_data)
        defect_rate = self.calculate_defect_rate(sprint_data)
        cycle_time = self.calculate_cycle_time(sprint_data)
        
        # Статистика по статусам
        status_counts = {}
        for issue in sprint_data:
            status = issue['state']
            status_counts[status] = status_counts.get(status, 0) + 1
        
        report = f"""
# Daily Scrum Report - {datetime.now().strftime('%Y-%m-%d')}

## 📊 Sprint Metrics
- **Velocity**: {velocity} story points
- **Defect Rate**: {defect_rate:.1f}%
- **Average Cycle Time**: {cycle_time:.1f} days

## 📋 Issue Status
"""
        
        for status, count in status_counts.items():
            report += f"- **{status.title()}**: {count} issues\n"
        
        # Блокеры
        blockers = [issue for issue in sprint_data if 'blocker' in [label['name'] for label in issue.get('labels', [])]]
        if blockers:
            report += "\n## 🚧 Blockers\n"
            for blocker in blockers:
                report += f"- {blocker['title']} (#{blocker['number']})\n"
        
        return report
    
    def send_notification(self, webhook_url: str, message: str):
        """Отправить уведомление в Slack/Discord"""
        payload = {
            "text": message
        }
        
        try:
            response = requests.post(webhook_url, json=payload)
            if response.status_code == 200:
                print("Notification sent successfully")
            else:
                print(f"Failed to send notification: {response.status_code}")
        except Exception as e:
            print(f"Error sending notification: {e}")
    
    def create_sprint_planning_template(self, sprint_number: int, start_date: str, end_date: str, goal: str) -> str:
        """Создать шаблон для Sprint Planning"""
        template = f"""# Sprint {sprint_number} Planning

## Sprint Information
- **Sprint Number**: {sprint_number}
- **Duration**: {start_date} - {end_date}
- **Sprint Goal**: {goal}

## Capacity Planning
- **Team Velocity**: [TO BE CALCULATED]
- **Available Hours**: [TO BE DEFINED]
- **Holidays/Time Off**: [TO BE DEFINED]

## Selected User Stories
| ID | Title | Story Points | Assignee | Priority |
|----|-------|--------------|----------|----------|
|    |       |              |          |          |

## Sprint Backlog
- [ ] [TASK_1]
- [ ] [TASK_2]
- [ ] [TASK_3]

## Definition of Done
- [ ] Code written and tested
- [ ] Unit tests cover new functionality
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] Feature tested on device
- [ ] No critical defects
- [ ] Meets UX/UI requirements

## Sprint Metrics Tracking
- **Planned Points**: [TO BE DEFINED]
- **Actual Points**: [TO BE TRACKED]
- **Goal Achievement**: [TO BE TRACKED]
"""
        return template
    
    def create_retrospective_template(self, sprint_number: int) -> str:
        """Создать шаблон для ретроспективы"""
        template = f"""# Sprint {sprint_number} Retrospective

## Sprint Information
- **Sprint Number**: {sprint_number}
- **Date**: {datetime.now().strftime('%Y-%m-%d')}
- **Participants**: [TEAM_MEMBERS]

## What Went Well
- [POSITIVE_1]
- [POSITIVE_2]
- [POSITIVE_3]

## What Could Be Improved
- [IMPROVEMENT_1]
- [IMPROVEMENT_2]
- [IMPROVEMENT_3]

## Action Items
| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
|        |       |          |        |

## Team Happiness Index
- **Average Score**: [SCORE]/5
- **Comments**: [COMMENTS]

## Metrics Review
- **Velocity**: [POINTS]
- **Defect Rate**: [PERCENTAGE]
- **Cycle Time**: [DAYS]
- **Sprint Goal Achievement**: [PERCENTAGE]
"""
        return template

def main():
    parser = argparse.ArgumentParser(description='Scrum Master Automation')
    parser.add_argument('--action', required=True, 
                       choices=['daily-report', 'velocity', 'burndown', 'planning-template', 'retrospective-template'],
                       help='Action to perform')
    parser.add_argument('--github-token', required=True, help='GitHub token')
    parser.add_argument('--repo', required=True, help='Repository name (owner/repo)')
    parser.add_argument('--webhook-url', help='Webhook URL for notifications')
    parser.add_argument('--sprint-number', type=int, help='Sprint number for templates')
    parser.add_argument('--start-date', help='Sprint start date')
    parser.add_argument('--end-date', help='Sprint end date')
    parser.add_argument('--goal', help='Sprint goal')
    
    args = parser.parse_args()
    
    scrum = ScrumAutomation(args.github_token, args.repo)
    
    if args.action == 'daily-report':
        report = scrum.generate_daily_report()
        print(report)
        
        if args.webhook_url:
            scrum.send_notification(args.webhook_url, report)
    
    elif args.action == 'velocity':
        sprint_data = scrum.get_sprint_issues()
        velocity = scrum.calculate_velocity(sprint_data)
        print(f"Team Velocity: {velocity} story points")
    
    elif args.action == 'burndown':
        sprint_data = scrum.get_sprint_issues()
        burndown_data = scrum.generate_burndown_data(sprint_data)
        print(json.dumps(burndown_data, indent=2))
    
    elif args.action == 'planning-template':
        if not all([args.sprint_number, args.start_date, args.end_date, args.goal]):
            print("Error: All template parameters required (sprint-number, start-date, end-date, goal)")
            sys.exit(1)
        
        template = scrum.create_sprint_planning_template(
            args.sprint_number, args.start_date, args.end_date, args.goal
        )
        print(template)
    
    elif args.action == 'retrospective-template':
        if not args.sprint_number:
            print("Error: sprint-number required for retrospective template")
            sys.exit(1)
        
        template = scrum.create_retrospective_template(args.sprint_number)
        print(template)

if __name__ == '__main__':
    main() 