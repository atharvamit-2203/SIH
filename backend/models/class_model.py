from database import db
from datetime import datetime

class Class(db.Model):
    __tablename__ = 'classes'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)  # e.g., "6th Grade", "7th Grade"
    description = db.Column(db.Text, nullable=True)
    grade_level = db.Column(db.Integer, nullable=False)  # 6, 7, 8, 9, 10, 11, 12
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relationships
    subjects = db.relationship('Subject', backref='class_ref', lazy=True)
    
    def __init__(self, name, grade_level, description=None):
        self.name = name
        self.grade_level = grade_level
        self.description = description
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'grade_level': self.grade_level,
            'is_active': self.is_active,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
    
    def __repr__(self):
        return f'<Class {self.name}>'