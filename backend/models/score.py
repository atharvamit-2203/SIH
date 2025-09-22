from database import db
from datetime import datetime

class Score(db.Model):
    __tablename__ = 'scores'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    game_id = db.Column(db.Integer, db.ForeignKey('games.id'), nullable=False)
    score = db.Column(db.Integer, nullable=False, default=0)
    max_score = db.Column(db.Integer, nullable=False, default=100)
    percentage = db.Column(db.Float, nullable=False, default=0.0)
    time_taken = db.Column(db.Integer, nullable=True)  # in seconds
    attempts = db.Column(db.Integer, default=1)
    is_completed = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def __init__(self, user_id, game_id, score, max_score=100, time_taken=None, attempts=1, is_completed=True):
        self.user_id = user_id
        self.game_id = game_id
        self.score = score
        self.max_score = max_score
        self.percentage = (score / max_score) * 100 if max_score > 0 else 0.0
        self.time_taken = time_taken
        self.attempts = attempts
        self.is_completed = is_completed
    
    def update_score(self, new_score, new_time_taken=None):
        self.score = new_score
        self.percentage = (new_score / self.max_score) * 100 if self.max_score > 0 else 0.0
        if new_time_taken:
            self.time_taken = new_time_taken
        self.attempts += 1
        self.updated_at = datetime.utcnow()
    
    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'game_id': self.game_id,
            'score': self.score,
            'max_score': self.max_score,
            'percentage': round(self.percentage, 2),
            'time_taken': self.time_taken,
            'attempts': self.attempts,
            'is_completed': self.is_completed,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<Score user_id={self.user_id} game_id={self.game_id} score={self.score}>'