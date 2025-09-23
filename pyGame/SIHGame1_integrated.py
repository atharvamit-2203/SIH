#!/usr/bin/env python3
"""
SIHGame1 - Fraction Race Game with StudyFun Backend Integration
This is an example of how to integrate your existing PyGame with the StudyFun backend
"""

import pygame
import random
import sys
import time
from game_integration import setup_studyfun_integration

# Initialize pygame
pygame.init()

# Screen settings
WIDTH, HEIGHT = 800, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("StudyFun - Fraction Race")

# Fonts
font = pygame.font.SysFont("arial", 28)
big_font = pygame.font.SysFont("arial", 36)
small_font = pygame.font.SysFont("arial", 20)

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (220, 20, 60)
GREEN = (34, 139, 34)
BLUE = (70, 130, 180)
YELLOW = (255, 215, 0)
PURPLE = (138, 43, 226)
GRAY = (128, 128, 128)

# Helper functions
def gcd(a, b):
    while b:
        a, b = b, a % b
    return a

def generate_fraction():
    # Generate fractions that can be simplified
    original_num = random.randint(2, 12)
    original_den = random.randint(2, 12)
    multiplier = random.randint(2, 6)
    
    num = original_num * multiplier
    den = original_den * multiplier
    
    # Simplified form
    g = gcd(original_num, original_den)
    simplified_num = original_num // g
    simplified_den = original_den // g
    
    return num, den, simplified_num, simplified_den

class Car:
    def __init__(self, y_pos, color):
        self.x = 50
        self.y = y_pos
        self.color = color
        self.speed = 0
        self.progress = 0
        
    def draw(self):
        # Draw car body
        pygame.draw.rect(screen, self.color, (self.x, self.y, 60, 30))
        # Draw wheels
        pygame.draw.circle(screen, BLACK, (self.x + 15, self.y + 35), 8)
        pygame.draw.circle(screen, BLACK, (self.x + 45, self.y + 35), 8)
        
    def move(self, distance):
        self.progress += distance
        self.x = min(50 + self.progress * 3, WIDTH - 100)

class FractionCard:
    def __init__(self, num, den, simp_num, simp_den):
        self.num = num
        self.den = den
        self.simp_num = simp_num
        self.simp_den = simp_den
        self.x = random.randint(100, WIDTH - 200)
        self.y = 0
        self.speed = 2
        self.width = 120
        self.height = 80
        
    def move(self):
        self.y += self.speed
        
    def draw(self):
        # Draw card background
        pygame.draw.rect(screen, WHITE, (self.x, self.y, self.width, self.height))
        pygame.draw.rect(screen, BLACK, (self.x, self.y, self.width, self.height), 3)
        
        # Draw fraction
        fraction_text = font.render(f"{self.num}", True, BLACK)
        line_rect = pygame.Rect(self.x + 20, self.y + 35, 80, 3)
        pygame.draw.rect(screen, BLACK, line_rect)
        den_text = font.render(f"{self.den}", True, BLACK)
        
        # Center the texts
        num_rect = fraction_text.get_rect(center=(self.x + 60, self.y + 20))
        den_rect = den_text.get_rect(center=(self.x + 60, self.y + 55))
        
        screen.blit(fraction_text, num_rect)
        screen.blit(den_text, den_rect)

def run_game():
    """Main game function with StudyFun integration"""
    
    # Setup StudyFun integration
    integration = setup_studyfun_integration("SIHGame1", screen, font)
    
    # Game variables
    player_car = Car(450, BLUE)
    ai_cars = [
        Car(350, RED),
        Car(380, GREEN),
        Car(410, PURPLE)
    ]
    
    cards = []
    current_input_num = ""
    current_input_den = ""
    input_mode = "numerator"  # "numerator" or "denominator"
    score = 0
    level = 1
    cards_solved = 0
    clock = pygame.time.Clock()
    
    # Game timing
    game_start_time = time.time()
    
    # Spawn first card
    num, den, simp_num, simp_den = generate_fraction()
    cards.append(FractionCard(num, den, simp_num, simp_den))
    
    # Game loop
    game_running = True
    while game_running:
        screen.fill((135, 206, 235))  # Sky blue background
        
        # Draw race track
        pygame.draw.rect(screen, GRAY, (0, 320, WIDTH, 200))
        for i in range(0, WIDTH, 40):
            pygame.draw.rect(screen, YELLOW, (i, 385, 20, 5))
        
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                game_running = False
                break
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_RETURN:
                    if cards and current_input_num and current_input_den:
                        if (int(current_input_num) == cards[0].simp_num and 
                            int(current_input_den) == cards[0].simp_den):
                            # Correct answer - player moves forward
                            player_car.move(20)
                            score += 10
                            cards_solved += 1
                            
                            # Check for level up
                            if cards_solved % 5 == 0:
                                level += 1
                            
                            cards.pop(0)
                            num, den, simp_num, simp_den = generate_fraction()
                            cards.append(FractionCard(num, den, simp_num, simp_den))
                        
                        # AI cars move randomly
                        for car in ai_cars:
                            car.move(random.randint(3, 8))
                        
                        current_input_num = ""
                        current_input_den = ""
                        input_mode = "numerator"
                        
                elif event.key == pygame.K_TAB:
                    input_mode = "denominator" if input_mode == "numerator" else "numerator"
                elif event.key == pygame.K_BACKSPACE:
                    if input_mode == "numerator":
                        current_input_num = current_input_num[:-1]
                    else:
                        current_input_den = current_input_den[:-1]
                else:
                    if event.unicode.isdigit():
                        if input_mode == "numerator":
                            current_input_num += event.unicode
                        else:
                            current_input_den += event.unicode
        
        # Update cards
        for card in cards:
            card.move()
            card.draw()
            
            if card.y > HEIGHT:  # Card missed
                cards.pop(0)
                num, den, simp_num, simp_den = generate_fraction()
                cards.append(FractionCard(num, den, simp_num, simp_den))
                # AI cars get advantage when player misses
                for car in ai_cars:
                    car.move(random.randint(5, 10))
        
        # Draw cars
        player_car.draw()
        for car in ai_cars:
            car.draw()
        
        # Check win condition
        if player_car.x >= WIDTH - 100:
            # Player wins - calculate final score and time
            final_time = int(time.time() - game_start_time)
            max_score = 100
            
            # Show integrated game over screen
            if integration.show_game_over_screen(screen, font, score, max_score, final_time):
                # Restart game
                player_car = Car(450, BLUE)
                ai_cars = [Car(350, RED), Car(380, GREEN), Car(410, PURPLE)]
                cards = []
                score = 0
                level = 1
                cards_solved = 0
                game_start_time = time.time()
                num, den, simp_num, simp_den = generate_fraction()
                cards.append(FractionCard(num, den, simp_num, simp_den))
                continue
            else:
                game_running = False
                break
        
        # Check if any AI car won
        for i, car in enumerate(ai_cars):
            if car.x >= WIDTH - 100:
                # AI wins - calculate final time
                final_time = int(time.time() - game_start_time)
                max_score = 100
                
                # Show game over screen
                if integration.show_game_over_screen(screen, font, score, max_score, final_time):
                    # Restart game
                    player_car = Car(450, BLUE)
                    ai_cars = [Car(350, RED), Car(380, GREEN), Car(410, PURPLE)]
                    cards = []
                    score = 0
                    level = 1
                    cards_solved = 0
                    game_start_time = time.time()
                    num, den, simp_num, simp_den = generate_fraction()
                    cards.append(FractionCard(num, den, simp_num, simp_den))
                    break
                else:
                    game_running = False
                    break
        
        # Draw UI elements
        # Current input display
        input_bg = pygame.Rect(10, 10, 300, 80)
        pygame.draw.rect(screen, WHITE, input_bg)
        pygame.draw.rect(screen, BLACK, input_bg, 2)
        
        # Show current input
        num_color = GREEN if input_mode == "numerator" else BLACK
        den_color = GREEN if input_mode == "denominator" else BLACK
        
        num_text = font.render(f"Numerator: {current_input_num}", True, num_color)
        den_text = font.render(f"Denominator: {current_input_den}", True, den_color)
        
        screen.blit(num_text, (15, 20))
        screen.blit(den_text, (15, 50))
        
        # Score and level
        score_text = font.render(f"Score: {score} | Level: {level} | Solved: {cards_solved}", True, BLACK)
        screen.blit(score_text, (10, HEIGHT - 40))
        
        # User info (if logged in)
        if integration.is_online():
            user_info = integration.get_user_info()
            user_text = small_font.render(f"Player: {user_info['username']} | Online Mode", True, BLUE)
            screen.blit(user_text, (WIDTH - 300, 10))
        else:
            offline_text = small_font.render("Offline Mode", True, GRAY)
            screen.blit(offline_text, (WIDTH - 120, 10))
        
        # Instructions
        instruction_text = small_font.render("Simplify fractions and press ENTER | Use TAB to switch fields", True, BLACK)
        screen.blit(instruction_text, (10, HEIGHT - 20))
        
        pygame.display.flip()
        clock.tick(60)

def main():
    """Main function"""
    try:
        run_game()
    except KeyboardInterrupt:
        print("\nGame interrupted by user")
    except Exception as e:
        print(f"Game error: {e}")
    finally:
        pygame.quit()
        sys.exit()

if __name__ == "__main__":
    main()