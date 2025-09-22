from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from database import db
from models.class_model import Class
from models.user import User

class_bp = Blueprint('classes', __name__)

@class_bp.route('/', methods=['GET'])
def get_classes():
    """Get all available classes/grade levels"""
    try:
        classes = Class.query.filter_by(is_active=True).order_by(Class.grade_level).all()
        
        classes_data = [class_obj.to_dict() for class_obj in classes]
        
        return jsonify({
            'success': True,
            'data': {
                'classes': classes_data,
                'count': len(classes_data)
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get classes: {str(e)}'
        }), 500

@class_bp.route('/<int:class_id>', methods=['GET'])
def get_class(class_id):
    """Get a specific class by ID"""
    try:
        class_obj = Class.query.get(class_id)
        
        if not class_obj:
            return jsonify({
                'success': False,
                'message': 'Class not found'
            }), 404
        
        return jsonify({
            'success': True,
            'data': {
                'class': class_obj.to_dict()
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get class: {str(e)}'
        }), 500

@class_bp.route('/select', methods=['POST'])
@jwt_required()
def select_class():
    """Allow user to select their class"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404
        
        data = request.get_json()
        class_id = data.get('class_id')
        
        if not class_id:
            return jsonify({
                'success': False,
                'message': 'Class ID is required'
            }), 400
        
        # Validate class exists
        class_obj = Class.query.get(class_id)
        if not class_obj or not class_obj.is_active:
            return jsonify({
                'success': False,
                'message': 'Invalid class selected'
            }), 400
        
        # Update user's selected class
        user.selected_class_id = class_id
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Class selected successfully',
            'data': {
                'user': user.to_dict(),
                'selected_class': class_obj.to_dict()
            }
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': f'Failed to select class: {str(e)}'
        }), 500

@class_bp.route('/my-class', methods=['GET'])
@jwt_required()
def get_my_class():
    """Get the current user's selected class"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404
        
        if not user.selected_class_id:
            return jsonify({
                'success': True,
                'data': {
                    'selected_class': None,
                    'message': 'No class selected'
                }
            }), 200
        
        class_obj = Class.query.get(user.selected_class_id)
        
        return jsonify({
            'success': True,
            'data': {
                'selected_class': class_obj.to_dict() if class_obj else None
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get selected class: {str(e)}'
        }), 500