from flask import Blueprint, jsonify, request
from models.topic import Topic
from models.subject import Subject
from models.class_model import Class
from models.board import Board
from database import db

topic_bp = Blueprint('topics', __name__, url_prefix='/api/topics')

@topic_bp.route('/', methods=['GET'])
def get_topics():
    """Get topics with optional filters"""
    try:
        board_id = request.args.get('board_id', type=int)
        class_id = request.args.get('class_id', type=int)
        subject_id = request.args.get('subject_id', type=int)
        difficulty = request.args.get('difficulty')
        limit = request.args.get('limit', type=int)
        
        query = Topic.query.filter(Topic.is_active == True)
        
        if board_id:
            query = query.filter(Topic.board_id == board_id)
        if class_id:
            query = query.filter(Topic.class_id == class_id)
        if subject_id:
            query = query.filter(Topic.subject_id == subject_id)
        if difficulty:
            query = query.filter(Topic.difficulty == difficulty)
            
        query = query.order_by(Topic.order_index, Topic.name)
        
        if limit:
            query = query.limit(limit)
            
        topics = query.all()
        
        return jsonify({
            'success': True,
            'data': [topic.to_dict_minimal() for topic in topics],
            'count': len(topics)
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@topic_bp.route('/by-subject/<int:subject_id>', methods=['GET'])
def get_topics_by_subject(subject_id):
    """Get all topics for a specific subject"""
    try:
        class_id = request.args.get('class_id', type=int)
        board_id = request.args.get('board_id', type=int)
        difficulty = request.args.get('difficulty')
        
        query = Topic.query.filter(Topic.is_active == True, Topic.subject_id == subject_id)
        
        if board_id:
            query = query.filter(Topic.board_id == board_id)
        if class_id:
            query = query.filter(Topic.class_id == class_id)
        if difficulty:
            query = query.filter(Topic.difficulty == difficulty)
            
        topics = query.order_by(Topic.order_index, Topic.name).all()
        
        subject = Subject.query.get(subject_id)
        if not subject:
            return jsonify({
                'success': False,
                'error': 'Subject not found'
            }), 404
        
        return jsonify({
            'success': True,
            'subject': {
                'id': subject.id,
                'name': subject.name,
                'emoji': subject.emoji,
                'description': subject.description
            },
            'topics': [topic.to_dict_minimal() for topic in topics],
            'count': len(topics)
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500