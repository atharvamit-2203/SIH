import pygame
import random
import sys
import math

pygame.init()

WIDTH, HEIGHT = 1000, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Geometry Runner")

font = pygame.font.SysFont(None, 36)
small_font = pygame.font.SysFont(None, 24)
big_font = pygame.font.SysFont(None, 48)
clock = pygame.time.Clock()

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
BLUE = (70, 130, 255)
RED = (255, 70, 70)
GREEN = (70, 255, 70)
YELLOW = (255, 255, 70)
PURPLE = (200, 70, 255)
ORANGE = (255, 150, 70)
GRAY = (150, 150, 150)
DARK_BLUE = (30, 60, 150)

class Player:
    def __init__(self):
        self.x = 100
        self.y = HEIGHT - 150
        self.width = 30
        self.height = 40
        self.vel_y = 0
        self.vel_x = 0
        self.on_ground = True
        self.on_platform = None
        self.color = BLUE
        self.speed = 5
        
    def update(self, keys):
        # Horizontal movement
        self.vel_x = 0
        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            self.vel_x = -self.speed
        if keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            self.vel_x = self.speed
            
        # Move with platform if on one
        if self.on_platform:
            self.vel_x += self.on_platform.speed
        
        self.x += self.vel_x
        
        # Keep player on screen
        if self.x < 0:
            self.x = 0
        elif self.x > WIDTH - self.width:
            self.x = WIDTH - self.width
        
        # Gravity
        if not self.on_ground:
            self.vel_y += 0.8
        
        self.y += self.vel_y
        
        # Ground collision
        if self.y >= HEIGHT - 150:
            self.y = HEIGHT - 150
            self.vel_y = 0
            self.on_ground = True
        else:
            self.on_ground = False
            
        self.on_platform = None
            
    def jump(self):
        if self.on_ground:
            self.vel_y = -15
            self.on_ground = False
    
    def draw(self, screen):
        pygame.draw.rect(screen, self.color, (self.x, self.y, self.width, self.height))
        # Simple face
        pygame.draw.circle(screen, WHITE, (self.x + 10, self.y + 10), 3)
        pygame.draw.circle(screen, WHITE, (self.x + 20, self.y + 10), 3)

class GeometryProblem:
    def __init__(self):
        self.generate_problem()
    
    def generate_problem(self):
        problem_types = ['rectangle_area', 'rectangle_perimeter', 'square_area', 'square_perimeter', 'triangle_area']
        self.type = random.choice(problem_types)
        
        if self.type == 'rectangle_area':
            self.length = random.randint(5, 15)
            self.width = random.randint(3, 12)
            self.correct_answer = self.length * self.width
            self.question = f"Rectangle: Length={self.length}, Width={self.width}. Area=?"
            
        elif self.type == 'rectangle_perimeter':
            self.length = random.randint(5, 15)
            self.width = random.randint(3, 12)
            self.correct_answer = 2 * (self.length + self.width)
            self.question = f"Rectangle: Length={self.length}, Width={self.width}. Perimeter=?"
            
        elif self.type == 'square_area':
            self.side = random.randint(4, 12)
            self.correct_answer = self.side * self.side
            self.question = f"Square: Side={self.side}. Area=?"
            
        elif self.type == 'square_perimeter':
            self.side = random.randint(4, 12)
            self.correct_answer = 4 * self.side
            self.question = f"Square: Side={self.side}. Perimeter=?"
            
        elif self.type == 'triangle_area':
            self.base = random.randint(4, 16)
            self.height = random.randint(3, 12)
            self.correct_answer = int((self.base * self.height) / 2)
            self.question = f"Triangle: Base={self.base}, Height={self.height}. Area=?"
    
    def get_options(self):
        options = [self.correct_answer]
        while len(options) < 4:
            if self.correct_answer < 20:
                option = self.correct_answer + random.randint(-5, 5)
            else:
                option = self.correct_answer + random.randint(-15, 15)
            if option > 0 and option not in options:
                options.append(option)
        random.shuffle(options)
        return options

class MovingPlatform:
    def __init__(self, x, y, width, height, speed, direction='horizontal'):
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.speed = speed
        self.direction = direction
        self.start_x = x
        self.start_y = y
        self.move_range = 200
        
    def update(self):
        if self.direction == 'horizontal':
            self.x += self.speed
            if abs(self.x - self.start_x) > self.move_range:
                self.speed *= -1
        else:
            self.y += self.speed
            if abs(self.y - self.start_y) > self.move_range:
                self.speed *= -1
                
    def draw(self, screen):
        pygame.draw.rect(screen, GRAY, (self.x, self.y, self.width, self.height))

class AnswerBlock:
    def __init__(self, x, y, value, is_correct=False):
        self.x = x
        self.y = y
        self.width = 60
        self.height = 50
        self.value = value
        self.is_correct = is_correct
        self.vel_x = random.choice([-2, 2])
        self.vel_y = random.choice([-1, 1])
        self.bounce_range = 100
        self.start_x = x
        self.start_y = y
        self.collected = False
        # All blocks are blue now - no color hints!
        self.color = PURPLE
        
    def update(self):
        if self.collected:
            return
            
        self.x += self.vel_x
        self.y += self.vel_y
        
        # Bounce within range
        if abs(self.x - self.start_x) > self.bounce_range:
            self.vel_x *= -1
        if abs(self.y - self.start_y) > 30:
            self.vel_y *= -1
            
        # Keep within screen bounds
        if self.x < 0 or self.x > WIDTH - self.width:
            self.vel_x *= -1
        if self.y < 100 or self.y > HEIGHT - 200:
            self.vel_y *= -1
    
    def draw(self, screen):
        if self.collected:
            return
            
        # All blocks look the same - no green hint!
        pygame.draw.rect(screen, self.color, (self.x, self.y, self.width, self.height))
        pygame.draw.rect(screen, BLACK, (self.x, self.y, self.width, self.height), 2)
        
        # Draw value
        text = small_font.render(str(self.value), True, WHITE)
        text_rect = text.get_rect(center=(self.x + self.width//2, self.y + self.height//2))
        screen.blit(text, text_rect)
    
    def get_rect(self):
        return pygame.Rect(self.x, self.y, self.width, self.height)

class Game:
    def __init__(self):
        self.player = Player()
        self.score = 0
        self.level = 1
        self.problems_solved = 0
        self.current_problem = GeometryProblem()
        self.answer_blocks = []
        self.platforms = []
        self.camera_x = 0
        self.generate_level()
        
    def generate_level(self):
        self.answer_blocks = []
        self.platforms = []
        
        # Generate answer blocks
        options = self.current_problem.get_options()
        for i, option in enumerate(options):
            x = 300 + i * 150 + random.randint(-50, 50)
            y = HEIGHT - 300 - random.randint(0, 100)
            is_correct = (option == self.current_problem.correct_answer)
            block = AnswerBlock(x, y, option, is_correct)
            self.answer_blocks.append(block)
        
        # Generate moving platforms
        for i in range(3):
            x = 200 + i * 250
            y = HEIGHT - 250 - random.randint(0, 80)
            platform = MovingPlatform(x, y, 80, 20, random.choice([-2, 2]))
            self.platforms.append(platform)
    
    def check_collisions(self):
        player_rect = pygame.Rect(self.player.x, self.player.y, self.player.width, self.player.height)
        
        # Check answer block collisions
        for block in self.answer_blocks:
            if not block.collected and player_rect.colliderect(block.get_rect()):
                block.collected = True
                if block.is_correct:
                    self.score += 10 * self.level
                    self.problems_solved += 1
                    self.next_problem()
                    return "correct"
                else:
                    return "wrong"
        
        # Check platform collisions with proper platform riding
        for platform in self.platforms:
            platform_rect = pygame.Rect(platform.x, platform.y, platform.width, platform.height)
            
            # Check if player is landing on top of platform
            if (player_rect.colliderect(platform_rect) and 
                self.player.vel_y > 0 and 
                self.player.y < platform.y + 10):  # Small tolerance
                
                self.player.y = platform.y - self.player.height
                self.player.vel_y = 0
                self.player.on_ground = True
                self.player.on_platform = platform
        
        return None
    
    def next_problem(self):
        if self.problems_solved % 3 == 0:
            self.level += 1
        self.current_problem = GeometryProblem()
        self.generate_level()
    
    def update(self):
        keys = pygame.key.get_pressed()
        self.player.update(keys)
        
        for block in self.answer_blocks:
            block.update()
        
        for platform in self.platforms:
            platform.update()
        
        result = self.check_collisions()
        return result
    
    def draw(self, screen):
        screen.fill((135, 206, 250))  # Sky blue
        
        # Draw ground
        pygame.draw.rect(screen, GREEN, (0, HEIGHT - 100, WIDTH, 100))
        
        # Draw platforms
        for platform in self.platforms:
            platform.draw(screen)
        
        # Draw answer blocks
        for block in self.answer_blocks:
            block.draw(screen)
        
        # Draw player
        self.player.draw(screen)
        
        # Draw UI
        self.draw_ui(screen)
    
    def draw_ui(self, screen):
        # Problem
        problem_text = font.render(self.current_problem.question, True, BLACK)
        screen.blit(problem_text, (10, 10))
        
        # Instructions
        instruction_text = small_font.render("Arrow Keys/WASD to move, SPACE to jump. Collect blocks to find the answer!", True, DARK_BLUE)
        screen.blit(instruction_text, (10, 50))
        
        # Score and level
        score_text = font.render(f"Score: {self.score}", True, BLACK)
        screen.blit(score_text, (WIDTH - 200, 10))
        
        level_text = font.render(f"Level: {self.level}", True, BLACK)
        screen.blit(level_text, (WIDTH - 200, 45))
        
        problems_text = small_font.render(f"Problems Solved: {self.problems_solved}", True, BLACK)
        screen.blit(problems_text, (WIDTH - 200, 75))

def main():
    game = Game()
    running = True
    game_over = False
    wrong_answer_timer = 0
    
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_SPACE and not game_over:
                    game.player.jump()
                elif event.key == pygame.K_r and game_over:
                    game = Game()
                    game_over = False
                    wrong_answer_timer = 0
        
        if not game_over:
            result = game.update()
            
            if result == "wrong":
                game_over = True
                wrong_answer_timer = pygame.time.get_ticks()
        
        # Draw everything
        game.draw(screen)
        
        # Draw game over screen
        if game_over:
            overlay = pygame.Surface((WIDTH, HEIGHT))
            overlay.set_alpha(128)
            overlay.fill(BLACK)
            screen.blit(overlay, (0, 0))
            
            game_over_text = big_font.render("GAME OVER!", True, RED)
            game_over_rect = game_over_text.get_rect(center=(WIDTH//2, HEIGHT//2 - 50))
            screen.blit(game_over_text, game_over_rect)
            
            final_score_text = font.render(f"Final Score: {game.score}", True, WHITE)
            final_score_rect = final_score_text.get_rect(center=(WIDTH//2, HEIGHT//2))
            screen.blit(final_score_text, final_score_rect)
            
            restart_text = font.render("Press R to Restart", True, YELLOW)
            restart_rect = restart_text.get_rect(center=(WIDTH//2, HEIGHT//2 + 50))
            screen.blit(restart_text, restart_rect)
        
        pygame.display.flip()
        clock.tick(60)
    
    pygame.quit()
    sys.exit()

if __name__ == "__main__":
    main()