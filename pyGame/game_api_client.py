#!/usr/bin/env python3
"""
PyGame-Backend API Integration Layer
Connects PyGame educational games with the StudyFun Flask backend API
"""

import requests
import json
import time
from typing import Optional, Dict, Any
from datetime import datetime

class GameAPIClient:
    """
    Client to integrate PyGame games with StudyFun backend API
    """
    
    def __init__(self, base_url: str = "http://localhost:5000"):
        """
        Initialize API client
        
        Args:
            base_url: Backend API base URL
        """
        self.base_url = base_url
        self.session = requests.Session()
        self.session.headers.update({'Content-Type': 'application/json'})
        self.access_token = None
        self.user_data = None
        self.current_game_session = None
        
    def authenticate_user(self, username: str, password: str) -> Dict[str, Any]:
        """
        Authenticate user with backend API
        
        Args:
            username: User's username
            password: User's password
            
        Returns:
            Dict containing success status and user data
        """
        try:
            response = self.session.post(
                f"{self.base_url}/api/auth/login",
                json={"username": username, "password": password}
            )
            
            if response.status_code == 200:
                data = response.json()
                if data.get('success'):
                    self.access_token = data['data']['access_token']
                    self.user_data = data['data']['user']
                    
                    # Set authorization header for future requests
                    self.session.headers.update({
                        'Authorization': f'Bearer {self.access_token}'
                    })
                    
                    return {
                        'success': True,
                        'user': self.user_data,
                        'message': 'Authentication successful'
                    }
                else:
                    return {
                        'success': False,
                        'message': data.get('message', 'Login failed')
                    }
            else:
                return {
                    'success': False,
                    'message': f'HTTP {response.status_code}: Authentication failed'
                }
                
        except requests.exceptions.RequestException as e:
            return {
                'success': False,
                'message': f'Network error: {str(e)}'
            }
    
    def get_game_info(self, game_name: str) -> Optional[Dict[str, Any]]:
        """
        Get game information from backend
        
        Args:
            game_name: Name of the game
            
        Returns:
            Game data or None if not found
        """
        try:
            response = self.session.get(f"{self.base_url}/api/games/")
            
            if response.status_code == 200:
                data = response.json()
                if data.get('success'):
                    games = data['data']['games']
                    
                    # Find game by name (case-insensitive)
                    for game in games:
                        if game['name'].lower() == game_name.lower():
                            return game
                    
                    # If exact match not found, try partial match
                    for game in games:
                        if game_name.lower() in game['name'].lower():
                            return game
            
            return None
            
        except requests.exceptions.RequestException:
            return None
    
    def start_game_session(self, game_id: int) -> Dict[str, Any]:
        """
        Start a new game session
        
        Args:
            game_id: ID of the game being played
            
        Returns:
            Session start response
        """
        try:
            response = self.session.post(f"{self.base_url}/api/games/start/{game_id}")
            
            if response.status_code == 200:
                data = response.json()
                if data.get('success'):
                    self.current_game_session = {
                        'game_id': game_id,
                        'start_time': time.time(),
                        'user_id': self.user_data['id'] if self.user_data else None
                    }
                    return {'success': True, 'message': 'Game session started'}
                else:
                    return {'success': False, 'message': data.get('message', 'Failed to start session')}
            else:
                return {'success': False, 'message': 'Failed to start game session'}
                
        except requests.exceptions.RequestException as e:
            return {'success': False, 'message': f'Network error: {str(e)}'}
    
    def submit_game_score(self, game_id: int, score: int, max_score: int = 100, 
                         time_taken: Optional[int] = None) -> Dict[str, Any]:
        """
        Submit game score to backend
        
        Args:
            game_id: ID of the game
            score: Player's score
            max_score: Maximum possible score for the game
            time_taken: Time taken in seconds (optional)
            
        Returns:
            Score submission response
        """
        if not self.access_token:
            return {'success': False, 'message': 'User not authenticated'}
        
        # Calculate time taken if not provided and session exists
        if time_taken is None and self.current_game_session:
            time_taken = int(time.time() - self.current_game_session['start_time'])
        
        try:
            response = self.session.post(
                f"{self.base_url}/api/scores/",
                json={
                    'game_id': game_id,
                    'score': score,
                    'max_score': max_score,
                    'time_taken': time_taken,
                    'is_completed': True
                }
            )
            
            if response.status_code == 201:
                data = response.json()
                if data.get('success'):
                    # Clear current session after successful score submission
                    self.current_game_session = None
                    return {
                        'success': True,
                        'score_data': data['data']['score'],
                        'message': 'Score submitted successfully'
                    }
                else:
                    return {'success': False, 'message': data.get('message', 'Score submission failed')}
            else:
                return {'success': False, 'message': f'HTTP {response.status_code}: Score submission failed'}
                
        except requests.exceptions.RequestException as e:
            return {'success': False, 'message': f'Network error: {str(e)}'}
    
    def get_user_progress(self) -> Dict[str, Any]:
        """
        Get current user's game progress
        
        Returns:
            User's game progress data
        """
        if not self.access_token:
            return {'success': False, 'message': 'User not authenticated'}
        
        try:
            response = self.session.get(f"{self.base_url}/api/games/my-progress")
            
            if response.status_code == 200:
                data = response.json()
                if data.get('success'):
                    return {
                        'success': True,
                        'games': data['data']['games'],
                        'message': 'Progress loaded successfully'
                    }
                else:
                    return {'success': False, 'message': data.get('message', 'Failed to load progress')}
            else:
                return {'success': False, 'message': 'Failed to fetch user progress'}
                
        except requests.exceptions.RequestException as e:
            return {'success': False, 'message': f'Network error: {str(e)}'}
    
    def get_leaderboard(self, game_id: Optional[int] = None, limit: int = 10) -> Dict[str, Any]:
        """
        Get leaderboard for a specific game or overall
        
        Args:
            game_id: Specific game ID (None for overall leaderboard)
            limit: Number of top players to retrieve
            
        Returns:
            Leaderboard data
        """
        try:
            params = {'limit': limit}
            if game_id:
                params['game_id'] = game_id
            
            response = self.session.get(f"{self.base_url}/api/scores/leaderboard", params=params)
            
            if response.status_code == 200:
                data = response.json()
                if data.get('success'):
                    return {
                        'success': True,
                        'leaderboard': data['data']['leaderboard'],
                        'message': 'Leaderboard loaded successfully'
                    }
                else:
                    return {'success': False, 'message': data.get('message', 'Failed to load leaderboard')}
            else:
                return {'success': False, 'message': 'Failed to fetch leaderboard'}
                
        except requests.exceptions.RequestException as e:
            return {'success': False, 'message': f'Network error: {str(e)}'}
    
    def check_backend_connection(self) -> bool:
        """
        Check if backend is accessible
        
        Returns:
            True if backend is accessible, False otherwise
        """
        try:
            response = self.session.get(f"{self.base_url}/api/health", timeout=5)
            return response.status_code == 200
        except requests.exceptions.RequestException:
            return False
    
    def logout(self) -> None:
        """
        Logout user and clear session data
        """
        self.access_token = None
        self.user_data = None
        self.current_game_session = None
        if 'Authorization' in self.session.headers:
            del self.session.headers['Authorization']

# Game integration helper functions
def create_game_client() -> GameAPIClient:
    """
    Create and return a new GameAPIClient instance
    """
    return GameAPIClient()

def get_or_create_math_game(client: GameAPIClient, game_name: str) -> Optional[int]:
    """
    Get existing math game ID or create mapping for new game
    
    Args:
        client: GameAPIClient instance
        game_name: Name of the PyGame
        
    Returns:
        Game ID if found/created, None otherwise
    """
    # Map PyGame names to backend game names
    game_mapping = {
        "fraction_race": "Fraction Frenzy",
        "equation_shooter": "Addition Adventure",  # Can be mapped to appropriate math game
        "geometry_tower": "Multiplication Mayhem",  # Can be mapped to appropriate math game
        "SIHGame1": "Fraction Frenzy",
        "SIHGame4": "Addition Adventure", 
        "SIHGame5": "Multiplication Mayhem",
        "SIHGame6": "Division Dash"
    }
    
    backend_game_name = game_mapping.get(game_name, game_name)
    game_info = client.get_game_info(backend_game_name)
    
    if game_info:
        return game_info['id']
    else:
        # If game not found, try to use the first math game as default
        math_games_response = client.session.get(f"{client.base_url}/api/games/math-games")
        if math_games_response.status_code == 200:
            data = math_games_response.json()
            if data.get('success') and data['data']['games']:
                return data['data']['games'][0]['id']
    
    return None

# Example usage for PyGame integration
if __name__ == "__main__":
    # Test the API client
    client = create_game_client()
    
    print("Testing StudyFun PyGame-Backend Integration...")
    
    # Test backend connection
    if client.check_backend_connection():
        print("✅ Backend connection successful")
        
        # Test authentication with sample user
        auth_result = client.authenticate_user("testuser", "password123")
        if auth_result['success']:
            print(f"✅ Authentication successful: {auth_result['user']['username']}")
            
            # Test getting game info
            game_id = get_or_create_math_game(client, "SIHGame1")
            if game_id:
                print(f"✅ Game found with ID: {game_id}")
                
                # Test starting game session
                session_result = client.start_game_session(game_id)
                if session_result['success']:
                    print("✅ Game session started")
                    
                    # Test score submission
                    score_result = client.submit_game_score(game_id, 85, 100, 120)
                    if score_result['success']:
                        print("✅ Score submitted successfully")
                        percentage = score_result['score_data']['percentage']
                        print(f"   Score: {score_result['score_data']['score']}/100 ({percentage}%)")
                    else:
                        print(f"❌ Score submission failed: {score_result['message']}")
                else:
                    print(f"❌ Failed to start game session: {session_result['message']}")
            else:
                print("❌ No suitable game found in backend")
        else:
            print(f"❌ Authentication failed: {auth_result['message']}")
    else:
        print("❌ Backend connection failed - make sure backend is running")