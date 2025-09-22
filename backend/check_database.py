#!/usr/bin/env python3
"""
Simple database check script to verify StudyFun backend data
"""

from flask import Flask
from database import db
from config.config import Config

# Import all models in the correct order
from models.user import User
from models.class_model import Class
from models.subject import Subject
from models.game import Game
from models.score import Score

def check_database():
    """Check database contents and health"""
    app = Flask(__name__)
    app.config.from_object(Config)
    db.init_app(app)
    
    with app.app_context():
        print('📊 StudyFun Database Health Check')
        print('=' * 60)
        
        # Count records
        user_count = User.query.count()
        class_count = Class.query.count()
        subject_count = Subject.query.count()
        game_count = Game.query.count()
        score_count = Score.query.count()
        
        print(f'👥 Users in database: {user_count}')
        print(f'🎓 Classes available: {class_count}')  
        print(f'📚 Subjects available: {subject_count}')
        print(f'🎮 Games available: {game_count}')
        print(f'🏆 Scores recorded: {score_count}')
        
        print('\n' + '='*60)
        
        # Show all users
        if user_count > 0:
            print('📋 Registered Users:')
            for user in User.query.all():
                email = user.email or 'Not provided'
                full_name = user.full_name or 'Not provided'
                selected_class = 'None'
                if user.selected_class_id:
                    class_obj = Class.query.get(user.selected_class_id)
                    if class_obj:
                        selected_class = class_obj.name
                
                print(f'  👤 {user.username}')
                print(f'     📧 Email: {email}')
                print(f'     👤 Name: {full_name}')
                print(f'     🎓 Class: {selected_class}')
                print(f'     📅 Joined: {user.created_at}')
                print()
        
        # Show sample of other data
        if class_count > 0:
            print('🎓 Available Grade Levels:')
            for cls in Class.query.order_by(Class.grade_level).all():
                print(f'  📚 {cls.name} (Grade {cls.grade_level})')
        
        if subject_count > 0:
            print(f'\n📚 Available Subjects ({subject_count} total):')
            for subject in Subject.query.all()[:3]:  # Show first 3
                print(f'  {subject.emoji} {subject.name}: {subject.description}')
            if subject_count > 3:
                print(f'  ... and {subject_count - 3} more subjects')
        
        if game_count > 0:
            print(f'\n🎮 Available Games ({game_count} total):')
            for game in Game.query.all()[:3]:  # Show first 3
                print(f'  {game.emoji} {game.name} ({game.difficulty_level})')
            if game_count > 3:
                print(f'  ... and {game_count - 3} more games')
        
        # Health assessment
        print('\n' + '='*60)
        print('🔍 Backend Health Assessment:')
        
        if user_count >= 1 and class_count >= 7 and subject_count >= 6 and game_count >= 5:
            print('✅ EXCELLENT: All core data is present!')
            print('✅ Backend is fully functional')
            print('✅ Database is properly initialized')
        elif user_count >= 1 and class_count > 0 and subject_count > 0:
            print('✅ GOOD: Basic data is present')
            print('⚠️  Some sample data might be missing')
        elif user_count > 0:
            print('⚠️  PARTIAL: Users exist but core data missing')
            print('❓ Run: python init_db.py to initialize sample data')
        else:
            print('❌ EMPTY: No data found in database')
            print('🔧 Run: python init_db.py to initialize database')
        
        print('\n' + '='*60)
        print('🚀 To test your backend with Flutter:')
        print('1. Start backend: python main.py')
        print('2. Backend will be available at: http://localhost:5000')
        print('3. Test with sample user: testuser / password123')
        print('4. API docs: Check API_DOCUMENTATION.md')

if __name__ == '__main__':
    check_database()