from database import db
from datetime import datetime

class Game(db.Model):
    __tablename__ = 'games'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)  # e.g., "Addition Adventure"
    emoji = db.Column(db.String(10), nullable=True)  # e.g., "➕"
    description = db.Column(db.Text, nullable=True)
    subject_id = db.Column(db.Integer, db.ForeignKey('subjects.id'), nullable=False)
    game_type = db.Column(db.String(50), nullable=True)  # e.g., "math", "quiz", "puzzle"
    difficulty_level = db.Column(db.String(20), default='beginner')  # beginner, intermediate, advanced
    instructions = db.Column(db.Text, nullable=True)
    max_score = db.Column(db.Integer, default=100)
    time_limit = db.Column(db.Integer, nullable=True)  # in seconds
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relationships
    scores = db.relationship('Score', backref='game', lazy=True)
    
    def __init__(self, name, subject_id, emoji=None, description=None, game_type=None, 
                 difficulty_level='beginner', instructions=None, max_score=100, time_limit=None):
        self.name = name
        self.subject_id = subject_id
        self.emoji = emoji
        self.description = description
        self.game_type = game_type
        self.difficulty_level = difficulty_level
        self.instructions = instructions
        self.max_score = max_score
        self.time_limit = time_limit
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'emoji': self.emoji,
            'description': self.description,
            'subject_id': self.subject_id,
            'game_type': self.game_type,
            'difficulty_level': self.difficulty_level,
            'instructions': self.instructions,
            'max_score': self.max_score,
            'time_limit': self.time_limit,
            'is_active': self.is_active,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
    
    def __repr__(self):
        return f'<Game {self.name}>'