from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from datetime import datetime
from database import db
from models.score import Score
from models.game import Game
from models.user import User

score_bp = Blueprint('scores', __name__)

@score_bp.route('/', methods=['POST'])
@jwt_required()
def submit_score():
    """Submit a new game score"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404
        
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['game_id', 'score']
        for field in required_fields:
            if field not in data:
                return jsonify({
                    'success': False,
                    'message': f'{field} is required'
                }), 400
        
        game_id = data['game_id']
        score_value = data['score']
        
        # Validate game exists
        game = Game.query.get(game_id)
        if not game or not game.is_active:
            return jsonify({
                'success': False,
                'message': 'Invalid game'
            }), 400
        
        # Validate score is within valid range
        if score_value < 0 or score_value > game.max_score:
            return jsonify({
                'success': False,
                'message': f'Score must be between 0 and {game.max_score}'
            }), 400
        
        # Create new score record
        new_score = Score(
            user_id=user_id,
            game_id=game_id,
            score=score_value,
            max_score=game.max_score,
            time_taken=data.get('time_taken'),
            attempts=1,
            is_completed=data.get('is_completed', True)
        )
        
        db.session.add(new_score)
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Score submitted successfully',
            'data': {
                'score': new_score.to_dict(),
                'game': game.to_dict()
            }
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': f'Failed to submit score: {str(e)}'
        }), 500

@score_bp.route('/my-scores', methods=['GET'])
@jwt_required()
def get_my_scores():
    """Get current user's scores"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404
        
        # Get optional filters
        game_id = request.args.get('game_id', type=int)
        limit = request.args.get('limit', type=int, default=50)
        
        query = Score.query.filter_by(user_id=user_id)
        
        if game_id:
            query = query.filter_by(game_id=game_id)
        
        scores = query.order_by(Score.created_at.desc()).limit(limit).all()
        
        scores_data = []
        for score in scores:
            score_data = score.to_dict()
            score_data['game'] = score.game.to_dict() if score.game else None
            scores_data.append(score_data)
        
        return jsonify({
            'success': True,
            'data': {
                'scores': scores_data,
                'count': len(scores_data)
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get scores: {str(e)}'
        }), 500

@score_bp.route('/leaderboard', methods=['GET'])
def get_leaderboard():
    """Get leaderboard for a specific game or overall"""
    try:
        game_id = request.args.get('game_id', type=int)
        limit = request.args.get('limit', type=int, default=10)
        
        if game_id:
            # Leaderboard for specific game
            game = Game.query.get(game_id)
            if not game:
                return jsonify({
                    'success': False,
                    'message': 'Game not found'
                }), 404
            
            # Get best scores for this game (one per user)
            subquery = db.session.query(
                Score.user_id,
                db.func.max(Score.percentage).label('best_percentage')
            ).filter_by(game_id=game_id).group_by(Score.user_id).subquery()
            
            scores = db.session.query(Score).join(
                subquery,
                (Score.user_id == subquery.c.user_id) & 
                (Score.percentage == subquery.c.best_percentage) &
                (Score.game_id == game_id)
            ).order_by(Score.percentage.desc(), Score.created_at.asc()).limit(limit).all()
            
            leaderboard_data = []
            for i, score in enumerate(scores):
                score_data = score.to_dict()
                score_data['user'] = {
                    'id': score.user.id,
                    'username': score.user.username,
                    'full_name': score.user.full_name
                } if score.user else None
                score_data['rank'] = i + 1
                leaderboard_data.append(score_data)
            
            return jsonify({
                'success': True,
                'data': {
                    'leaderboard': leaderboard_data,
                    'game': game.to_dict(),
                    'type': 'game_leaderboard'
                }
            }), 200
        
        else:
            # Overall leaderboard (total points across all games)
            # This is a simplified version - you might want to implement a more sophisticated scoring system
            user_totals = db.session.query(
                Score.user_id,
                db.func.sum(Score.score).label('total_score'),
                db.func.count(Score.id).label('games_played'),
                db.func.avg(Score.percentage).label('avg_percentage')
            ).group_by(Score.user_id).order_by(
                db.func.sum(Score.score).desc()
            ).limit(limit).all()
            
            leaderboard_data = []
            for i, (user_id, total_score, games_played, avg_percentage) in enumerate(user_totals):
                user = User.query.get(user_id)
                leaderboard_data.append({
                    'rank': i + 1,
                    'user': {
                        'id': user.id,
                        'username': user.username,
                        'full_name': user.full_name
                    } if user else None,
                    'total_score': int(total_score) if total_score else 0,
                    'games_played': int(games_played),
                    'average_percentage': round(float(avg_percentage), 2) if avg_percentage else 0.0
                })
            
            return jsonify({
                'success': True,
                'data': {
                    'leaderboard': leaderboard_data,
                    'type': 'overall_leaderboard'
                }
            }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get leaderboard: {str(e)}'
        }), 500

@score_bp.route('/stats', methods=['GET'])
@jwt_required()
def get_user_stats():
    """Get current user's statistics"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404
        
        # Calculate various statistics
        total_games_played = Score.query.filter_by(user_id=user_id).count()
        total_score = db.session.query(db.func.sum(Score.score)).filter_by(user_id=user_id).scalar() or 0
        avg_score = db.session.query(db.func.avg(Score.percentage)).filter_by(user_id=user_id).scalar() or 0
        best_score = Score.query.filter_by(user_id=user_id).order_by(Score.percentage.desc()).first()
        
        # Games by subject
        games_by_subject = db.session.query(
            db.func.count(Score.id).label('count'),
            Game.subject_id
        ).join(Game).filter(Score.user_id == user_id).group_by(Game.subject_id).all()
        
        subject_stats = {}
        for count, subject_id in games_by_subject:
            from models.subject import Subject
            subject = Subject.query.get(subject_id)
            if subject:
                subject_stats[subject.name] = count
        
        stats = {
            'total_games_played': total_games_played,
            'total_score': int(total_score),
            'average_percentage': round(float(avg_score), 2),
            'best_score': best_score.to_dict() if best_score else None,
            'games_by_subject': subject_stats,
            'user': user.to_dict()
        }
        
        return jsonify({
            'success': True,
            'data': {
                'stats': stats
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get user stats: {str(e)}'
        }), 500

@score_bp.route('/<int:score_id>', methods=['GET'])
@jwt_required()
def get_score(score_id):
    """Get a specific score by ID (only user's own scores)"""
    try:
        user_id = get_jwt_identity()
        score = Score.query.filter_by(id=score_id, user_id=user_id).first()
        
        if not score:
            return jsonify({
                'success': False,
                'message': 'Score not found'
            }), 404
        
        score_data = score.to_dict()
        score_data['game'] = score.game.to_dict() if score.game else None
        score_data['user'] = score.user.to_dict() if score.user else None
        
        return jsonify({
            'success': True,
            'data': {
                'score': score_data
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Failed to get score: {str(e)}'
        }), 500