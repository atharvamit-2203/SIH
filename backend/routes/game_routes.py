from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from database import db
from models.game import Game
from models.subject import Subject
from models.user import User
from models.score import Score

game_bp = Blueprint('games', __name__)

@game_bp.route('/', methods=['GET'])
def get_games():
    """Get all available games"""
    try:
        # Get optional subject_id from query parameters
        subject_id = request.args.get('subject_id', type=int)
        difficulty = request.args.get('difficulty')
        
        query = Game.query.filter_by(is_active=True)
        
        if subject_id:
            query = query.filter_by(subject_id=subject_id)
        
        if difficulty:
            query = query.filter_by(difficulty_level=difficulty)
        
        games = query.all()
        games_data = [game.to_dict() for game in games]
        
        return jsonify({
            'success': True,
            'data': {
                'games': games_data,
                'count': len(games_data)
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get games: {str(e)}'
        }), 500

@game_bp.route('/<int:game_id>', methods=['GET'])
def get_game(game_id):
    """Get a specific game by ID"""
    try:
        game = Game.query.get(game_id)
        
        if not game:
            return jsonify({
                'success': False,
                'message': 'Game not found'
            }), 404
        
        game_data = game.to_dict()
        
        # Include subject information
        if game.subject:
            game_data['subject'] = game.subject.to_dict()
        
        return jsonify({
            'success': True,
            'data': {
                'game': game_data
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get game: {str(e)}'
        }), 500

@game_bp.route('/by-subject/<int:subject_id>', methods=['GET'])
def get_games_by_subject(subject_id):
    """Get games for a specific subject"""
    try:
        # Validate subject exists
        subject = Subject.query.get(subject_id)
        if not subject:
            return jsonify({
                'success': False,
                'message': 'Subject not found'
            }), 404
        
        games = Game.query.filter_by(subject_id=subject_id, is_active=True).all()
        games_data = [game.to_dict() for game in games]
        
        return jsonify({
            'success': True,
            'data': {
                'games': games_data,
                'count': len(games_data),
                'subject': subject.to_dict()
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get games for subject: {str(e)}'
        }), 500

@game_bp.route('/math-games', methods=['GET'])
def get_math_games():
    """Get all math games specifically"""
    try:
        # Find the Maths subject
        maths_subject = Subject.query.filter_by(name='Maths').first()
        
        if not maths_subject:
            return jsonify({
                'success': False,
                'message': 'Maths subject not found'
            }), 404
        
        games = Game.query.filter_by(subject_id=maths_subject.id, is_active=True).all()
        games_data = [game.to_dict() for game in games]
        
        return jsonify({
            'success': True,
            'data': {
                'games': games_data,
                'count': len(games_data),
                'subject': maths_subject.to_dict()
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get math games: {str(e)}'
        }), 500

@game_bp.route('/my-progress', methods=['GET'])
@jwt_required()
def get_my_game_progress():
    """Get current user's game progress"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404
        
        # Get all games with user's scores
        games = Game.query.filter_by(is_active=True).all()
        games_data = []
        
        for game in games:
            game_data = game.to_dict()
            game_data['subject'] = game.subject.to_dict() if game.subject else None
            
            # Get user's best score for this game
            best_score = Score.query.filter_by(user_id=user_id, game_id=game.id).order_by(Score.percentage.desc()).first()
            
            if best_score:
                game_data['user_progress'] = {
                    'best_score': best_score.score,
                    'best_percentage': best_score.percentage,
                    'total_attempts': Score.query.filter_by(user_id=user_id, game_id=game.id).count(),
                    'last_played': best_score.updated_at.isoformat() if best_score.updated_at else None
                }
            else:
                game_data['user_progress'] = None
            
            games_data.append(game_data)
        
        return jsonify({
            'success': True,
            'data': {
                'games': games_data,
                'count': len(games_data)
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get game progress: {str(e)}'
        }), 500

@game_bp.route('/start/<int:game_id>', methods=['POST'])
@jwt_required()
def start_game(game_id):
    """Start a game session (returns game details and instructions)"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404
        
        game = Game.query.get(game_id)
        
        if not game or not game.is_active:
            return jsonify({
                'success': False,
                'message': 'Game not found or inactive'
            }), 404
        
        game_data = game.to_dict()
        game_data['subject'] = game.subject.to_dict() if game.subject else None
        
        # Get user's previous scores for this game
        previous_scores = Score.query.filter_by(user_id=user_id, game_id=game_id).order_by(Score.created_at.desc()).limit(5).all()
        
        game_data['previous_scores'] = [score.to_dict() for score in previous_scores]
        game_data['total_attempts'] = Score.query.filter_by(user_id=user_id, game_id=game_id).count()
        
        return jsonify({
            'success': True,
            'message': f'Game "{game.name}" started',
            'data': {
                'game': game_data,
                'session_id': f"{user_id}-{game_id}-{len(previous_scores) + 1}"  # Simple session tracking
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to start game: {str(e)}'
        }), 500