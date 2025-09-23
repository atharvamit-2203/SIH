#!/usr/bin/env python3
"""
StudyFun PyGame Integration Helper
Easy-to-use wrapper for integrating PyGame games with the backend API
"""

import pygame
import sys
from typing import Optional, Tuple, Dict, Any
from game_api_client import GameAPIClient, create_game_client, get_or_create_math_game

class StudyFunGameIntegration:
    """
    Easy integration wrapper for PyGame games with StudyFun backend
    """
    
    def __init__(self, game_name: str, backend_url: str = "http://localhost:5000"):
        """
        Initialize game integration
        
        Args:
            game_name: Name of your PyGame (e.g., "SIHGame1", "fraction_race")
            backend_url: Backend API URL
        """
        self.game_name = game_name
        self.client = GameAPIClient(backend_url)
        self.game_id = None
        self.is_connected = False
        self.current_user = None
        self.game_started = False
        
        # Try to connect to backend
        self._initialize_connection()
    
    def _initialize_connection(self):
        """Initialize backend connection"""
        self.is_connected = self.client.check_backend_connection()
        if not self.is_connected:
            print(f"⚠️  Backend not accessible - {self.game_name} will run in offline mode")
    
    def show_login_screen(self, screen, font) -> bool:
        """
        Display login screen and handle user authentication
        
        Args:
            screen: Pygame screen surface
            font: Pygame font object
            
        Returns:
            True if login successful, False otherwise
        """
        if not self.is_connected:
            return False
        
        # Colors
        WHITE = (255, 255, 255)
        BLACK = (0, 0, 0)
        BLUE = (70, 130, 180)
        GREEN = (34, 139, 34)
        RED = (220, 20, 60)
        GRAY = (128, 128, 128)
        
        username = ""
        password = ""
        input_active = "username"
        message = "Enter your StudyFun credentials"
        message_color = BLACK
        
        clock = pygame.time.Clock()
        
        while True:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    return False
                
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_ESCAPE:
                        return False
                    
                    elif event.key == pygame.K_RETURN:
                        if username and password:
                            # Attempt login
                            message = "Authenticating..."
                            message_color = BLUE
                            pygame.display.flip()
                            
                            auth_result = self.client.authenticate_user(username, password)
                            if auth_result['success']:
                                self.current_user = auth_result['user']
                                
                                # Get game ID
                                self.game_id = get_or_create_math_game(self.client, self.game_name)
                                if self.game_id:
                                    message = f"Welcome {self.current_user['username']}! Starting game..."
                                    message_color = GREEN
                                    pygame.display.flip()
                                    pygame.time.wait(1500)
                                    return True
                                else:
                                    message = "Game not found in backend"
                                    message_color = RED
                            else:
                                message = auth_result['message']
                                message_color = RED
                        else:
                            message = "Please enter both username and password"
                            message_color = RED
                    
                    elif event.key == pygame.K_TAB:
                        input_active = "password" if input_active == "username" else "username"
                    
                    elif event.key == pygame.K_BACKSPACE:
                        if input_active == "username":
                            username = username[:-1]
                        else:
                            password = password[:-1]
                    
                    elif event.key == pygame.K_F1:
                        # Use test user for quick testing
                        username = "testuser"
                        password = "password123"
                        message = "Test user loaded - press Enter to login"
                        message_color = BLUE
                    
                    else:
                        if len(event.unicode) == 1 and event.unicode.isprintable():
                            if input_active == "username":
                                username += event.unicode
                            else:
                                password += event.unicode
            
            # Draw login screen
            screen.fill(WHITE)
            
            # Title
            title = font.render(f"StudyFun - {self.game_name}", True, BLUE)
            screen.blit(title, (screen.get_width()//2 - title.get_width()//2, 50))
            
            # Instructions
            instructions = [
                "Login to track your progress and compete with others!",
                "Use TAB to switch between fields",
                "Press F1 for test user credentials",
                "Press ESC to skip login and play offline"
            ]
            
            y_offset = 120
            for instruction in instructions:
                text = font.render(instruction, True, GRAY)
                screen.blit(text, (screen.get_width()//2 - text.get_width()//2, y_offset))
                y_offset += 30
            
            # Username field
            username_color = BLUE if input_active == "username" else BLACK
            username_label = font.render("Username:", True, username_color)
            screen.blit(username_label, (200, 300))
            
            username_rect = pygame.Rect(200, 330, 400, 35)
            pygame.draw.rect(screen, WHITE, username_rect)
            pygame.draw.rect(screen, username_color, username_rect, 2)
            
            username_surface = font.render(username, True, BLACK)
            screen.blit(username_surface, (username_rect.x + 10, username_rect.y + 5))
            
            # Password field
            password_color = BLUE if input_active == "password" else BLACK
            password_label = font.render("Password:", True, password_color)
            screen.blit(password_label, (200, 380))
            
            password_rect = pygame.Rect(200, 410, 400, 35)
            pygame.draw.rect(screen, WHITE, password_rect)
            pygame.draw.rect(screen, password_color, password_rect, 2)
            
            password_display = "*" * len(password)
            password_surface = font.render(password_display, True, BLACK)
            screen.blit(password_surface, (password_rect.x + 10, password_rect.y + 5))
            
            # Message
            message_surface = font.render(message, True, message_color)
            screen.blit(message_surface, (screen.get_width()//2 - message_surface.get_width()//2, 480))
            
            # Buttons
            login_button = pygame.Rect(250, 520, 100, 40)
            skip_button = pygame.Rect(450, 520, 100, 40)
            
            pygame.draw.rect(screen, GREEN, login_button)
            pygame.draw.rect(screen, GRAY, skip_button)
            
            login_text = font.render("Login", True, WHITE)
            skip_text = font.render("Skip", True, WHITE)
            
            screen.blit(login_text, (login_button.x + 25, login_button.y + 10))
            screen.blit(skip_text, (skip_button.x + 25, skip_button.y + 10))
            
            pygame.display.flip()
            clock.tick(60)
    
    def start_game_session(self) -> bool:
        """
        Start a new game session with the backend
        
        Returns:
            True if session started successfully
        """
        if not self.is_connected or not self.current_user or not self.game_id:
            return False
        
        result = self.client.start_game_session(self.game_id)
        self.game_started = result['success']
        return self.game_started
    
    def submit_score(self, score: int, max_score: int = 100, time_taken: Optional[int] = None) -> Dict[str, Any]:
        """
        Submit game score to backend
        
        Args:
            score: Player's final score
            max_score: Maximum possible score
            time_taken: Time taken in seconds (optional)
            
        Returns:
            Submission result dictionary
        """
        if not self.is_connected or not self.current_user or not self.game_id:
            return {'success': False, 'message': 'Not connected to backend'}
        
        return self.client.submit_game_score(self.game_id, score, max_score, time_taken)
    
    def show_game_over_screen(self, screen, font, score: int, max_score: int = 100, 
                            time_taken: Optional[int] = None) -> bool:
        """
        Show game over screen with score submission
        
        Args:
            screen: Pygame screen surface
            font: Pygame font object
            score: Player's final score
            max_score: Maximum possible score
            time_taken: Time taken in seconds
            
        Returns:
            True to restart game, False to quit
        """
        # Submit score if connected
        score_submitted = False
        score_result = None
        
        if self.is_connected and self.current_user:
            score_result = self.submit_score(score, max_score, time_taken)
            score_submitted = score_result['success']
        
        # Colors
        WHITE = (255, 255, 255)
        BLACK = (0, 0, 0)
        BLUE = (70, 130, 180)
        GREEN = (34, 139, 34)
        RED = (220, 20, 60)
        GOLD = (255, 215, 0)
        
        clock = pygame.time.Clock()
        
        while True:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    return False
                
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_r:
                        return True  # Restart
                    elif event.key == pygame.K_q or event.key == pygame.K_ESCAPE:
                        return False  # Quit
            
            # Draw game over screen
            screen.fill(WHITE)
            
            # Title
            title = font.render("GAME OVER", True, RED)
            screen.blit(title, (screen.get_width()//2 - title.get_width()//2, 100))
            
            # Score information
            score_text = font.render(f"Your Score: {score}/{max_score}", True, BLACK)
            screen.blit(score_text, (screen.get_width()//2 - score_text.get_width()//2, 180))
            
            percentage = (score / max_score) * 100 if max_score > 0 else 0
            percentage_text = font.render(f"Percentage: {percentage:.1f}%", True, BLACK)
            screen.blit(percentage_text, (screen.get_width()//2 - percentage_text.get_width()//2, 220))
            
            if time_taken:
                time_text = font.render(f"Time: {time_taken}s", True, BLACK)
                screen.blit(time_text, (screen.get_width()//2 - time_text.get_width()//2, 260))
            
            # Score submission status
            y_offset = 320
            if self.is_connected and self.current_user:
                if score_submitted:
                    success_text = font.render("✅ Score submitted successfully!", True, GREEN)
                    screen.blit(success_text, (screen.get_width()//2 - success_text.get_width()//2, y_offset))
                    
                    if score_result and 'score_data' in score_result:
                        rank_text = font.render("Check leaderboards to see your ranking!", True, BLUE)
                        screen.blit(rank_text, (screen.get_width()//2 - rank_text.get_width()//2, y_offset + 40))
                else:
                    error_text = font.render("❌ Failed to submit score", True, RED)
                    screen.blit(error_text, (screen.get_width()//2 - error_text.get_width()//2, y_offset))
            else:
                offline_text = font.render("Playing in offline mode", True, BLACK)
                screen.blit(offline_text, (screen.get_width()//2 - offline_text.get_width()//2, y_offset))
            
            # Instructions
            instructions = [
                "Press R to play again",
                "Press Q or ESC to quit"
            ]
            
            y_offset = 450
            for instruction in instructions:
                text = font.render(instruction, True, BLACK)
                screen.blit(text, (screen.get_width()//2 - text.get_width()//2, y_offset))
                y_offset += 40
            
            pygame.display.flip()
            clock.tick(60)
    
    def get_user_info(self) -> Optional[Dict[str, Any]]:
        """
        Get current user information
        
        Returns:
            User data or None if not logged in
        """
        return self.current_user
    
    def is_online(self) -> bool:
        """
        Check if connected to backend
        
        Returns:
            True if connected to backend
        """
        return self.is_connected and self.current_user is not None

# Convenience function for easy integration
def setup_studyfun_integration(game_name: str, screen, font) -> StudyFunGameIntegration:
    """
    Quick setup function for StudyFun integration
    
    Args:
        game_name: Name of your game
        screen: Pygame screen surface
        font: Pygame font object
        
    Returns:
        StudyFunGameIntegration instance
    """
    integration = StudyFunGameIntegration(game_name)
    
    # Show login screen
    login_successful = integration.show_login_screen(screen, font)
    
    if login_successful:
        integration.start_game_session()
        print(f"✅ {game_name} connected to StudyFun backend!")
        print(f"   User: {integration.current_user['username']}")
        print(f"   Game ID: {integration.game_id}")
    else:
        print(f"⚠️  {game_name} running in offline mode")
    
    return integration

# Example usage
if __name__ == "__main__":
    pygame.init()
    screen = pygame.display.set_mode((800, 600))
    pygame.display.set_caption("StudyFun Integration Test")
    font = pygame.font.SysFont("arial", 24)
    
    # Test integration
    integration = setup_studyfun_integration("SIHGame1", screen, font)
    
    # Simulate game over
    if integration.is_online():
        integration.show_game_over_screen(screen, font, 85, 100, 120)
    
    pygame.quit()
