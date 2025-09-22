#!/usr/bin/env python3
"""
Database initialization script for StudyFun Backend
This script creates the database tables and populates them with initial data.
"""

from flask import Flask
from database import db
from config.config import Config

# Create Flask app instance
app = Flask(__name__)
app.config.from_object(Config)

# Initialize database
db.init_app(app)

# Import all models
from models.user import User
from models.class_model import Class
from models.subject import Subject  
from models.game import Game
from models.score import Score

def init_classes():
    """Initialize the classes (grade levels) table"""
    classes_data = [
        {"name": "6th Grade", "grade_level": 6, "description": "Elementary to Middle School transition"},
        {"name": "7th Grade", "grade_level": 7, "description": "Middle School Foundation"},
        {"name": "8th Grade", "grade_level": 8, "description": "Middle School Advanced"},
        {"name": "9th Grade", "grade_level": 9, "description": "High School Freshman"},
        {"name": "10th Grade", "grade_level": 10, "description": "High School Sophomore"},
        {"name": "11th Grade", "grade_level": 11, "description": "High School Junior"},
        {"name": "12th Grade", "grade_level": 12, "description": "High School Senior"}
    ]
    
    for class_data in classes_data:
        if not Class.query.filter_by(name=class_data["name"]).first():
            new_class = Class(
                name=class_data["name"],
                grade_level=class_data["grade_level"],
                description=class_data["description"]
            )
            db.session.add(new_class)
    
    db.session.commit()
    print("✓ Classes initialized successfully!")

def init_subjects():
    """Initialize the subjects table"""
    subjects_data = [
        {"name": "Maths", "emoji": "➗", "description": "Mathematics and problem solving", "color_primary": "#FF6B6B", "color_secondary": "#FFE66D"},
        {"name": "Science", "emoji": "🔬", "description": "Scientific concepts and experiments", "color_primary": "#4ECDC4", "color_secondary": "#45B7D1"},
        {"name": "English", "emoji": "📚", "description": "Language arts and literature", "color_primary": "#96CEB4", "color_secondary": "#FFEAA7"},
        {"name": "History", "emoji": "🏰", "description": "Historical events and civilizations", "color_primary": "#DDA0DD", "color_secondary": "#98D8C8"},
        {"name": "Geography", "emoji": "🌍", "description": "World geography and cultures", "color_primary": "#F7DC6F", "color_secondary": "#BB8FCE"},
        {"name": "Comp Sci", "emoji": "💻", "description": "Computer science and programming", "color_primary": "#85C1E9", "color_secondary": "#F8C471"}
    ]
    
    for subject_data in subjects_data:
        if not Subject.query.filter_by(name=subject_data["name"]).first():
            new_subject = Subject(
                name=subject_data["name"],
                emoji=subject_data["emoji"],
                description=subject_data["description"],
                color_primary=subject_data["color_primary"],
                color_secondary=subject_data["color_secondary"]
            )
            db.session.add(new_subject)
    
    db.session.commit()
    print("✓ Subjects initialized successfully!")

def init_games():
    """Initialize the games table with math games"""
    # Get the Maths subject
    maths_subject = Subject.query.filter_by(name="Maths").first()
    if not maths_subject:
        print("❌ Maths subject not found! Please initialize subjects first.")
        return
    
    math_games_data = [
        {
            "name": "Addition Adventure",
            "emoji": "➕",
            "description": "Master addition with fun challenges",
            "game_type": "math",
            "difficulty_level": "beginner",
            "instructions": "Solve addition problems correctly to advance through levels",
            "max_score": 100,
            "time_limit": 300
        },
        {
            "name": "Subtraction Sprint",
            "emoji": "➖",
            "description": "Race against time with subtraction problems",
            "game_type": "math",
            "difficulty_level": "beginner",
            "instructions": "Complete subtraction problems as quickly as possible",
            "max_score": 100,
            "time_limit": 240
        },
        {
            "name": "Multiplication Mayhem",
            "emoji": "✖️",
            "description": "Multiplication tables made fun",
            "game_type": "math",
            "difficulty_level": "intermediate",
            "instructions": "Solve multiplication problems to unlock new challenges",
            "max_score": 150,
            "time_limit": 360
        },
        {
            "name": "Division Dash",
            "emoji": "➗",
            "description": "Division skills development",
            "game_type": "math",
            "difficulty_level": "intermediate",
            "instructions": "Practice division with interactive problems",
            "max_score": 150,
            "time_limit": 420
        },
        {
            "name": "Fraction Frenzy",
            "emoji": "1️⃣/2️⃣",
            "description": "Learn fractions through gameplay",
            "game_type": "math",
            "difficulty_level": "advanced",
            "instructions": "Understand and solve fraction problems",
            "max_score": 200,
            "time_limit": 480
        }
    ]
    
    for game_data in math_games_data:
        if not Game.query.filter_by(name=game_data["name"], subject_id=maths_subject.id).first():
            new_game = Game(
                name=game_data["name"],
                subject_id=maths_subject.id,
                emoji=game_data["emoji"],
                description=game_data["description"],
                game_type=game_data["game_type"],
                difficulty_level=game_data["difficulty_level"],
                instructions=game_data["instructions"],
                max_score=game_data["max_score"],
                time_limit=game_data["time_limit"]
            )
            db.session.add(new_game)
    
    db.session.commit()
    print("✓ Math games initialized successfully!")

def create_sample_user():
    """Create a sample user for testing"""
    if not User.query.filter_by(username="testuser").first():
        sample_user = User(
            username="testuser",
            password="password123",
            email="test@studyfun.com",
            full_name="Test User"
        )
        
        # Set their class to 8th Grade
        grade_8 = Class.query.filter_by(name="8th Grade").first()
        if grade_8:
            sample_user.selected_class_id = grade_8.id
        
        db.session.add(sample_user)
        db.session.commit()
        print("✓ Sample user created successfully!")
        print("  Username: testuser")
        print("  Password: password123")

def initialize_database():
    """Main function to initialize the entire database"""
    print("🚀 Initializing StudyFun Database...")
    print("=" * 50)
    
    with app.app_context():
        # Drop all tables and recreate them (for development)
        print("📦 Creating database tables...")
        db.create_all()
        
        # Initialize data in order
        init_classes()
        init_subjects()
        init_games()
        create_sample_user()
        
        print("=" * 50)
        print("✅ Database initialization completed successfully!")
        print("🎮 StudyFun Backend is ready to use!")

if __name__ == "__main__":
    initialize_database()