from database import db
from datetime import datetime

class Topic(db.Model):
    __tablename__ = 'topics'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text, nullable=True)
    difficulty = db.Column(db.String(20), nullable=True)  # basic, intermediate, advanced
    
    # Foreign Keys
    subject_id = db.Column(db.Integer, db.ForeignKey('subjects.id'), nullable=False)
    class_id = db.Column(db.Integer, db.ForeignKey('classes.id'), nullable=False)
    board_id = db.Column(db.Integer, db.ForeignKey('boards.id'), nullable=False)
    
    # Additional metadata
    order_index = db.Column(db.Integer, default=0)
    is_active = db.Column(db.Boolean, default=True)
    estimated_hours = db.Column(db.Integer, nullable=True)
    
    # Timestamps
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    subject = db.relationship('Subject', backref='topics')
    class_level = db.relationship('Class', backref='topics')
    board = db.relationship('Board', backref='topics')
    
    def __init__(self, name, subject_id, class_id, board_id, description=None, 
                 difficulty=None, order_index=0, estimated_hours=None):
        self.name = name
        self.subject_id = subject_id
        self.class_id = class_id
        self.board_id = board_id
        self.description = description
        self.difficulty = difficulty
        self.order_index = order_index
        self.estimated_hours = estimated_hours
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'difficulty': self.difficulty,
            'subject_id': self.subject_id,
            'class_id': self.class_id,
            'board_id': self.board_id,
            'order_index': self.order_index,
            'is_active': self.is_active,
            'estimated_hours': self.estimated_hours,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'subject_name': self.subject.name if self.subject else None,
            'class_name': self.class_level.name if self.class_level else None,
            'board_name': self.board.name if self.board else None
        }
    
    def to_dict_minimal(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'difficulty': self.difficulty,
            'order_index': self.order_index,
            'estimated_hours': self.estimated_hours
        }
    
    def __repr__(self):
        return f'<Topic {self.name}>'