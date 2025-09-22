from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from database import db
from models.subject import Subject
from models.class_model import Class
from models.user import User

subject_bp = Blueprint('subjects', __name__)

@subject_bp.route('/', methods=['GET'])
def get_subjects():
    """Get all available subjects"""
    try:
        # Get optional class_id from query parameters
        class_id = request.args.get('class_id', type=int)
        
        if class_id:
            # Get subjects for a specific class
            subjects = Subject.query.filter_by(class_id=class_id, is_active=True).all()
        else:
            # Get all subjects
            subjects = Subject.query.filter_by(is_active=True).all()
        
        subjects_data = [subject.to_dict() for subject in subjects]
        
        return jsonify({
            'success': True,
            'data': {
                'subjects': subjects_data,
                'count': len(subjects_data)
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get subjects: {str(e)}'
        }), 500

@subject_bp.route('/<int:subject_id>', methods=['GET'])
def get_subject(subject_id):
    """Get a specific subject by ID"""
    try:
        subject = Subject.query.get(subject_id)
        
        if not subject:
            return jsonify({
                'success': False,
                'message': 'Subject not found'
            }), 404
        
        # Include games count for this subject
        subject_data = subject.to_dict()
        subject_data['games_count'] = len(subject.games) if subject.games else 0
        
        return jsonify({
            'success': True,
            'data': {
                'subject': subject_data
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get subject: {str(e)}'
        }), 500

@subject_bp.route('/my-subjects', methods=['GET'])
@jwt_required()
def get_my_subjects():
    """Get subjects for the current user's selected class"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404
        
        if not user.selected_class_id:
            # Return all subjects if no class selected
            subjects = Subject.query.filter_by(is_active=True).all()
        else:
            # Get subjects for user's class or general subjects (class_id is None)
            subjects = Subject.query.filter(
                (Subject.class_id == user.selected_class_id) | 
                (Subject.class_id == None),
                Subject.is_active == True
            ).all()
        
        subjects_data = []
        for subject in subjects:
            subject_data = subject.to_dict()
            subject_data['games_count'] = len(subject.games) if subject.games else 0
            subjects_data.append(subject_data)
        
        return jsonify({
            'success': True,
            'data': {
                'subjects': subjects_data,
                'count': len(subjects_data),
                'user_class_id': user.selected_class_id
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get user subjects: {str(e)}'
        }), 500

@subject_bp.route('/by-class/<int:class_id>', methods=['GET'])
def get_subjects_by_class(class_id):
    """Get subjects for a specific class"""
    try:
        # Validate class exists
        class_obj = Class.query.get(class_id)
        if not class_obj:
            return jsonify({
                'success': False,
                'message': 'Class not found'
            }), 404
        
        # Get subjects for this class or general subjects
        subjects = Subject.query.filter(
            (Subject.class_id == class_id) | (Subject.class_id == None),
            Subject.is_active == True
        ).all()
        
        subjects_data = []
        for subject in subjects:
            subject_data = subject.to_dict()
            subject_data['games_count'] = len(subject.games) if subject.games else 0
            subjects_data.append(subject_data)
        
        return jsonify({
            'success': True,
            'data': {
                'subjects': subjects_data,
                'count': len(subjects_data),
                'class': class_obj.to_dict()
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get subjects for class: {str(e)}'
        }), 500
