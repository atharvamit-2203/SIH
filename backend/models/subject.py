from database import db
from datetime import datetime

class Subject(db.Model):
    __tablename__ = 'subjects'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)  # e.g., "Maths", "Science", "English"
    emoji = db.Column(db.String(10), nullable=True)  # e.g., "➗", "🔬", "📚"
    description = db.Column(db.Text, nullable=True)
    class_id = db.Column(db.Integer, db.ForeignKey('classes.id'), nullable=True)
    color_primary = db.Column(db.String(7), nullable=True)  # Hex color code
    color_secondary = db.Column(db.String(7), nullable=True)  # Hex color code
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relationships
    games = db.relationship('Game', backref='subject', lazy=True)
    
    def __init__(self, name, emoji=None, description=None, class_id=None, color_primary=None, color_secondary=None):
        self.name = name
        self.emoji = emoji
        self.description = description
        self.class_id = class_id
        self.color_primary = color_primary
        self.color_secondary = color_secondary
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'emoji': self.emoji,
            'description': self.description,
            'class_id': self.class_id,
            'color_primary': self.color_primary,
            'color_secondary': self.color_secondary,
            'is_active': self.is_active,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
    
    def __repr__(self):
        return f'<Subject {self.name}>'