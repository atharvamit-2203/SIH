import pygame
import random
import sys
import math

pygame.init()

WIDTH, HEIGHT = 1200, 700
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Geometry Runner - Enhanced Edition")

# Fonts
font = pygame.font.Font(None, 42)
small_font = pygame.font.Font(None, 28)
big_font = pygame.font.Font(None, 64)
huge_font = pygame.font.Font(None, 96)
clock = pygame.time.Clock()

# Enhanced Color Palette
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
BLUE = (64, 156, 255)
RED = (255, 82, 82)
GREEN = (76, 209, 55)
YELLOW = (255, 193, 7)
PURPLE = (155, 89, 182)
ORANGE = (255, 149, 0)
GRAY = (108, 117, 125)
DARK_BLUE = (23, 32, 42)
LIGHT_BLUE = (174, 214, 241)
GOLD = (255, 215, 0)
EMERALD = (46, 204, 113)
CORAL = (255, 127, 80)
CRIMSON = (220, 20, 60)

# Gradient colors
SKY_BLUE_TOP = (135, 206, 250)
SKY_BLUE_BOTTOM = (100, 149, 237)

class Particle:
    def __init__(self, x, y, color, size=3, lifetime=60):
        self.x = x
        self.y = y
        self.vel_x = random.uniform(-3, 3)
        self.vel_y = random.uniform(-5, -1)
        self.color = color
        self.size = size
        self.max_lifetime = lifetime
        self.lifetime = lifetime
        self.gravity = 0.1
        
    def update(self):
        self.x += self.vel_x
        self.y += self.vel_y
        self.vel_y += self.gravity
        self.lifetime -= 1
        
    def draw(self, screen):
        if self.lifetime > 0:
            alpha = int(255 * (self.lifetime / self.max_lifetime))
            color_with_alpha = (*self.color, alpha)
            s = pygame.Surface((self.size * 2, self.size * 2))
            s.set_alpha(alpha)
            pygame.draw.circle(s, self.color, (self.size, self.size), self.size)
            screen.blit(s, (self.x - self.size, self.y - self.size))
            
    def is_dead(self):
        return self.lifetime <= 0

class Player:
    def __init__(self):
        self.x = 100
        self.y = HEIGHT - 200
        self.width = 36
        self.height = 48
        self.vel_y = 0
        self.vel_x = 0
        self.on_ground = True
        self.on_platform = None
        self.color = BLUE
        self.speed = 6
        self.animation_frame = 0
        self.facing_right = True
        self.trail_particles = []
        
    def update(self, keys):
        # Horizontal movement with smooth acceleration
        target_vel_x = 0
        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            target_vel_x = -self.speed
            self.facing_right = False
        if keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            target_vel_x = self.speed
            self.facing_right = True
            
        # Smooth acceleration
        self.vel_x = self.vel_x * 0.8 + target_vel_x * 0.2
        
        # Move with platform if on one
        if self.on_platform:
            self.vel_x += self.on_platform.speed
        
        self.x += self.vel_x
        
        # Keep player on screen with smooth boundaries
        if self.x < 0:
            self.x = 0
        elif self.x > WIDTH - self.width:
            self.x = WIDTH - self.width
        
        # Gravity
        if not self.on_ground:
            self.vel_y += 0.8
        
        self.y += self.vel_y
        
        # Ground collision
        if self.y >= HEIGHT - 200:
            self.y = HEIGHT - 200
            self.vel_y = 0
            self.on_ground = True
        else:
            self.on_ground = False
            
        self.on_platform = None
        
        # Animation
        if abs(self.vel_x) > 0.5:
            self.animation_frame += 0.3
        else:
            self.animation_frame = 0
            
        # Trail particles when moving
        if abs(self.vel_x) > 2:
            if random.random() < 0.3:
                self.trail_particles.append(
                    Particle(self.x + self.width//2, self.y + self.height, 
                            LIGHT_BLUE, size=2, lifetime=20)
                )
        
        # Update trail particles
        self.trail_particles = [p for p in self.trail_particles if not p.is_dead()]
        for particle in self.trail_particles:
            particle.update()
            
    def jump(self):
            if self.on_ground or self.on_platform:
                self.vel_y = -16
                self.on_ground = False
                self.on_platform = None  # Crucial: detach from platform on jump
                # Jump particles
                for _ in range(8):
                    self.trail_particles.append(
                        Particle(self.x + self.width//2, self.y + self.height, 
                                YELLOW, size=3, lifetime=30)
                    )
    
    def draw(self, screen):
        # Draw trail particles
        for particle in self.trail_particles:
            particle.draw(screen)
            
        # Main body with gradient effect
        body_rect = pygame.Rect(self.x, self.y, self.width, self.height)
        
        # Create gradient effect
        for i in range(self.height):
            alpha = 1.0 - (i / self.height) * 0.3
            color = (int(self.color[0] * alpha), int(self.color[1] * alpha), int(self.color[2] * alpha))
            pygame.draw.rect(screen, color, (self.x, self.y + i, self.width, 1))
        
        # Border
        pygame.draw.rect(screen, WHITE, body_rect, 3)
        
        # Animated eyes
        eye_bounce = math.sin(self.animation_frame) * 2
        eye_size = 4
        if self.facing_right:
            pygame.draw.circle(screen, WHITE, (int(self.x + 12), int(self.y + 12 + eye_bounce)), eye_size)
            pygame.draw.circle(screen, WHITE, (int(self.x + 24), int(self.y + 12 + eye_bounce)), eye_size)
            pygame.draw.circle(screen, BLACK, (int(self.x + 14), int(self.y + 12 + eye_bounce)), 2)
            pygame.draw.circle(screen, BLACK, (int(self.x + 26), int(self.y + 12 + eye_bounce)), 2)
        else:
            pygame.draw.circle(screen, WHITE, (int(self.x + 12), int(self.y + 12 + eye_bounce)), eye_size)
            pygame.draw.circle(screen, WHITE, (int(self.x + 24), int(self.y + 12 + eye_bounce)), eye_size)
            pygame.draw.circle(screen, BLACK, (int(self.x + 10), int(self.y + 12 + eye_bounce)), 2)
            pygame.draw.circle(screen, BLACK, (int(self.x + 22), int(self.y + 12 + eye_bounce)), 2)

class GeometryProblem:
    def __init__(self):
        self.generate_problem()
    
    def generate_problem(self):
        problem_types = ['rectangle_area', 'rectangle_perimeter', 'square_area', 'square_perimeter', 'triangle_area', 'circle_area', 'circle_circumference']
        self.type = random.choice(problem_types)
        
        if self.type == 'rectangle_area':
            self.length = random.randint(5, 15)
            self.width = random.randint(3, 12)
            self.correct_answer = self.length * self.width
            self.question = f"Rectangle Area: L={self.length}, W={self.width}"
            
        elif self.type == 'rectangle_perimeter':
            self.length = random.randint(5, 15)
            self.width = random.randint(3, 12)
            self.correct_answer = 2 * (self.length + self.width)
            self.question = f"Rectangle Perimeter: L={self.length}, W={self.width}"
            
        elif self.type == 'square_area':
            self.side = random.randint(4, 12)
            self.correct_answer = self.side * self.side
            self.question = f"Square Area: Side={self.side}"
            
        elif self.type == 'square_perimeter':
            self.side = random.randint(4, 12)
            self.correct_answer = 4 * self.side
            self.question = f"Square Perimeter: Side={self.side}"
            
        elif self.type == 'triangle_area':
            self.base = random.randint(4, 16)
            self.height = random.randint(3, 12)
            self.correct_answer = int((self.base * self.height) / 2)
            self.question = f"Triangle Area: Base={self.base}, Height={self.height}"
            
        elif self.type == 'circle_area':
            self.radius = random.randint(3, 10)
            self.correct_answer = int(math.pi * self.radius * self.radius)
            self.question = f"Circle Area: Radius={self.radius} (π≈3.14)"
            
        elif self.type == 'circle_circumference':
            self.radius = random.randint(3, 10)
            self.correct_answer = int(2 * math.pi * self.radius)
            self.question = f"Circle Circumference: Radius={self.radius} (π≈3.14)"
    
    def get_options(self):
        options = [self.correct_answer]
        while len(options) < 4:
            if self.correct_answer < 20:
                option = self.correct_answer + random.randint(-8, 8)
            else:
                option = self.correct_answer + random.randint(-20, 20)
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
        self.glow_intensity = 0
        self.glow_direction = 1
        
    def update(self):
        if self.direction == 'horizontal':
            self.x += self.speed
            if abs(self.x - self.start_x) > self.move_range:
                self.speed *= -1
        else:
            self.y += self.speed
            if abs(self.y - self.start_y) > self.move_range:
                self.speed *= -1
                
        # Glow animation
        self.glow_intensity += self.glow_direction * 2
        if self.glow_intensity >= 50 or self.glow_intensity <= 0:
            self.glow_direction *= -1
                
    def draw(self, screen):
        # Glow effect
        glow_color = (GRAY[0] + self.glow_intensity, GRAY[1] + self.glow_intensity, GRAY[2] + self.glow_intensity)
        glow_rect = pygame.Rect(self.x - 3, self.y - 3, self.width + 6, self.height + 6)
        pygame.draw.rect(screen, glow_color, glow_rect, border_radius=8)
        
        # Main platform
        main_rect = pygame.Rect(self.x, self.y, self.width, self.height)
        pygame.draw.rect(screen, GRAY, main_rect, border_radius=5)
        pygame.draw.rect(screen, WHITE, main_rect, 2, border_radius=5)

class AnswerBlock:
    def __init__(self, x, y, value, is_correct=False):
        self.x = x
        self.y = y
        self.width = 80
        self.height = 60
        self.value = value
        self.is_correct = is_correct
        self.vel_x = random.choice([-1.5, 1.5])
        self.vel_y = random.choice([-0.8, 0.8])
        self.bounce_range = 120
        self.start_x = x
        self.start_y = y
        self.collected = False
        self.float_offset = random.uniform(0, math.pi * 2)
        self.pulse_offset = random.uniform(0, math.pi * 2)
        self.particles = []
        
    def update(self):
        if self.collected:
            return
            
        self.x += self.vel_x
        self.y += self.vel_y
        
        # Floating animation
        self.y += math.sin(pygame.time.get_ticks() * 0.003 + self.float_offset) * 0.5
        
        # Bounce within range
        if abs(self.x - self.start_x) > self.bounce_range:
            self.vel_x *= -1
        if abs(self.y - self.start_y) > 40:
            self.vel_y *= -1
            
        # Keep within screen bounds, above ground
        if self.x < 50 or self.x > WIDTH - self.width - 50:
            self.vel_x *= -1
        if self.y < 150 or self.y > HEIGHT - 250:
            self.vel_y *= -1
            
        # Generate sparkle particles
        if random.random() < 0.1:
            colors = [GOLD, YELLOW, WHITE, LIGHT_BLUE]
            self.particles.append(
                Particle(self.x + self.width//2, self.y + self.height//2,
                        random.choice(colors), size=2, lifetime=40)
            )
        
        # Update particles
        self.particles = [p for p in self.particles if not p.is_dead()]
        for particle in self.particles:
            particle.update()
    
    def draw(self, screen):
        if self.collected:
            return
        
        # Draw particles
        for particle in self.particles:
            particle.draw(screen)
            
        # Pulsing glow effect
        pulse = math.sin(pygame.time.get_ticks() * 0.008 + self.pulse_offset) * 0.5 + 0.5
        glow_size = int(6 + pulse * 4)
        
        # Outer glow
        glow_rect = pygame.Rect(self.x - glow_size, self.y - glow_size, 
                               self.width + glow_size * 2, self.height + glow_size * 2)
        glow_color = (PURPLE[0] + int(pulse * 30), PURPLE[1] + int(pulse * 30), PURPLE[2] + int(pulse * 30))
        pygame.draw.rect(screen, glow_color, glow_rect, border_radius=15)
        
        # Main block with gradient
        main_rect = pygame.Rect(self.x, self.y, self.width, self.height)
        
        # Gradient fill
        for i in range(self.height):
            alpha = 1.0 - (i / self.height) * 0.4
            color = (int(PURPLE[0] * alpha), int(PURPLE[1] * alpha), int(PURPLE[2] * alpha))
            pygame.draw.rect(screen, color, (self.x, self.y + i, self.width, 1))
        
        pygame.draw.rect(screen, WHITE, main_rect, 3, border_radius=10)
        
        # Value text with shadow
        text_shadow = font.render(str(self.value), True, BLACK)
        text_main = font.render(str(self.value), True, WHITE)
        
        shadow_rect = text_shadow.get_rect(center=(self.x + self.width//2 + 2, self.y + self.height//2 + 2))
        main_rect = text_main.get_rect(center=(self.x + self.width//2, self.y + self.height//2))
        
        screen.blit(text_shadow, shadow_rect)
        screen.blit(text_main, main_rect)
    
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
        self.particles = []
        self.timer = 15000  # 15 seconds in milliseconds
        self.timer_start = pygame.time.get_ticks()
        self.correct_screen_timer = 0
        self.show_correct_screen = False
        self.generate_level()
        self.timer_frozen = False
        self.frozen_time = 0
        
    def generate_level(self):
        # Reset player position
        self.player.x = 100
        self.player.y = HEIGHT - 200
        self.player.vel_y = 0
        self.player.on_ground = True
        
        self.answer_blocks = []
        self.platforms = []
        self.timer = 15000
        self.timer_start = pygame.time.get_ticks()
        
        # Unfreeze timer
        self.timer_frozen = False
        
        # Generate answer blocks with better positioning
        options = self.current_problem.get_options()
        positions = [
            (250, HEIGHT - 400),
            (450, HEIGHT - 300),
            (650, HEIGHT - 450),
            (850, HEIGHT - 350)
        ]
        
        for i, option in enumerate(options):
            x, y = positions[i]
            x += random.randint(-30, 30)
            y += random.randint(-20, 20)
            is_correct = (option == self.current_problem.correct_answer)
            block = AnswerBlock(x, y, option, is_correct)
            self.answer_blocks.append(block)
        
        # Generate moving platforms
        platform_configs = [
            (300, HEIGHT - 300, 100, 25, 2),
            (600, HEIGHT - 350, 80, 25, -1.5),
            (900, HEIGHT - 400, 90, 25, 1.8)
        ]
        
        for x, y, w, h, speed in platform_configs:
            platform = MovingPlatform(x, y, w, h, speed)
            self.platforms.append(platform)
    
    def check_collisions(self):
        player_rect = pygame.Rect(self.player.x, self.player.y, self.player.width, self.player.height)
        
        # Check answer block collisions
        for block in self.answer_blocks:
            if not block.collected and player_rect.colliderect(block.get_rect()):
                block.collected = True
                
                # Freeze the timer at current value
                if not self.timer_frozen:
                    elapsed = pygame.time.get_ticks() - self.timer_start
                    self.frozen_time = max(0, self.timer - elapsed)
                    self.timer_frozen = True
                
                # Explosion particles
                for _ in range(20):
                    color = EMERALD if block.is_correct else CRIMSON
                    self.particles.append(
                        Particle(block.x + block.width//2, block.y + block.height//2,
                                color, size=random.randint(2, 5), lifetime=60)
                    )
                
                if block.is_correct:
                    self.score += 100 * self.level
                    self.problems_solved += 1
                    self.show_correct_screen = True
                    self.correct_screen_timer = pygame.time.get_ticks()
                    return "correct"
                else:
                    return "wrong"
        
        # Check platform collisions
        for platform in self.platforms:
            platform_rect = pygame.Rect(platform.x, platform.y, platform.width, platform.height)
            
            if (player_rect.colliderect(platform_rect) and 
                self.player.vel_y > 0 and 
                self.player.y < platform.y + 15):
                
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
        # Check timer
        if not self.timer_frozen:
            elapsed = pygame.time.get_ticks() - self.timer_start
            remaining = max(0, self.timer - elapsed)
        else:
            remaining = self.frozen_time
        
        if remaining <= 0 and not self.show_correct_screen:
            return "timeout"
        
        # Handle correct screen
        if self.show_correct_screen:
            if pygame.time.get_ticks() - self.correct_screen_timer > 2000:  # 2 seconds
                self.show_correct_screen = False
                self.next_problem()
            return None
        
        keys = pygame.key.get_pressed()
        self.player.update(keys)
        
        for block in self.answer_blocks:
            block.update()
        
        for platform in self.platforms:
            platform.update()
        
        # Update particles
        self.particles = [p for p in self.particles if not p.is_dead()]
        for particle in self.particles:
            particle.update()
        
        result = self.check_collisions()
        return result
    
    def draw_gradient_background(self, screen):
        for y in range(HEIGHT):
            ratio = y / HEIGHT
            r = int(SKY_BLUE_TOP[0] * (1 - ratio) + SKY_BLUE_BOTTOM[0] * ratio)
            g = int(SKY_BLUE_TOP[1] * (1 - ratio) + SKY_BLUE_BOTTOM[1] * ratio)
            b = int(SKY_BLUE_TOP[2] * (1 - ratio) + SKY_BLUE_BOTTOM[2] * ratio)
            pygame.draw.line(screen, (r, g, b), (0, y), (WIDTH, y))
    
    def get_remaining_time(self):
        if self.timer_frozen:
            return self.frozen_time
        
        elapsed = pygame.time.get_ticks() - self.timer_start
        return max(0, self.timer - elapsed)
    
    def draw(self, screen):
        self.draw_gradient_background(screen)
        
        # Draw ground with grass texture
        ground_height = 150
        pygame.draw.rect(screen, GREEN, (0, HEIGHT - ground_height, WIDTH, ground_height))
        pygame.draw.rect(screen, EMERALD, (0, HEIGHT - ground_height, WIDTH, 20))
        
        # Add some grass details
        for x in range(0, WIDTH, 20):
            for i in range(3):
                grass_x = x + random.randint(-5, 5)
                grass_height = random.randint(5, 15)
                pygame.draw.line(screen, (34, 139, 34), 
                               (grass_x, HEIGHT - ground_height), 
                               (grass_x, HEIGHT - ground_height - grass_height), 2)
        
        # Draw platforms
        for platform in self.platforms:
            platform.draw(screen)
        
        # Draw particles
        for particle in self.particles:
            particle.draw(screen)
        
        # Draw answer blocks
        for block in self.answer_blocks:
            block.draw(screen)
        
        # Draw player
        self.player.draw(screen)
        
        # Draw UI
        self.draw_ui(screen)
        
        # Draw correct screen
        if self.show_correct_screen:
            self.draw_correct_screen(screen)
    
    def draw_correct_screen(self, screen):
        overlay = pygame.Surface((WIDTH, HEIGHT))
        overlay.set_alpha(180)
        overlay.fill(BLACK)
        screen.blit(overlay, (0, 0))
        
        # Animated "CORRECT!" text
        time_factor = (pygame.time.get_ticks() - self.correct_screen_timer) / 1000.0
        scale = min(1.0, time_factor * 2)
        
        correct_text = huge_font.render("CORRECT!", True, GOLD)
        original_size = correct_text.get_size()
        scaled_size = (int(original_size[0] * scale), int(original_size[1] * scale))
        
        if scale > 0:
            scaled_text = pygame.transform.scale(correct_text, scaled_size)
            text_rect = scaled_text.get_rect(center=(WIDTH//2, HEIGHT//2 - 50))
            screen.blit(scaled_text, text_rect)
        
        # Score bonus
        if time_factor > 0.5:
            bonus_text = font.render(f"+{100 * self.level} Points!", True, EMERALD)
            bonus_rect = bonus_text.get_rect(center=(WIDTH//2, HEIGHT//2 + 50))
            screen.blit(bonus_text, bonus_rect)
    
    def draw_ui(self, screen):
        # Problem with enhanced styling
        problem_bg = pygame.Rect(15, 15, 600, 70)
        pygame.draw.rect(screen, (0, 0, 0, 100), problem_bg, border_radius=10)
        pygame.draw.rect(screen, WHITE, problem_bg, 3, border_radius=10)
        
        problem_text = font.render(self.current_problem.question, True, WHITE)
        screen.blit(problem_text, (25, 25))
        
        instruction_text = small_font.render("WASD/Arrow Keys: Move • SPACE: Jump • Find the correct answer!", True, LIGHT_BLUE)
        screen.blit(instruction_text, (25, 55))
        
        # Timer with color coding
        remaining_time = self.get_remaining_time()
        seconds_left = remaining_time / 1000.0
        
        if seconds_left <= 5:
            timer_color = RED
            # Flash effect
            if int(seconds_left * 4) % 2:
                timer_color = CRIMSON
        elif seconds_left <= 10:
            timer_color = ORANGE
        else:
            timer_color = GREEN
        
        timer_text = big_font.render(f"Time: {seconds_left:.1f}s", True, timer_color)
        timer_rect = pygame.Rect(WIDTH - 250, 15, 230, 50)
        pygame.draw.rect(screen, (0, 0, 0, 100), timer_rect, border_radius=8)
        pygame.draw.rect(screen, timer_color, timer_rect, 3, border_radius=8)
        screen.blit(timer_text, (WIDTH - 240, 25))
        
        # Score and level with enhanced styling
        stats_bg = pygame.Rect(WIDTH - 250, 80, 230, 100)
        pygame.draw.rect(screen, (0, 0, 0, 100), stats_bg, border_radius=10)
        pygame.draw.rect(screen, GOLD, stats_bg, 3, border_radius=10)
        
        score_text = font.render(f"Score: {self.score}", True, GOLD)
        screen.blit(score_text, (WIDTH - 240, 90))
        
        level_text = font.render(f"Level: {self.level}", True, LIGHT_BLUE)
        screen.blit(level_text, (WIDTH - 240, 120))
        
        problems_text = small_font.render(f"Solved: {self.problems_solved}", True, EMERALD)
        screen.blit(problems_text, (WIDTH - 240, 150))

def main():
    game = Game()
    running = True
    game_over = False
    game_over_reason = ""
    
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_SPACE and not game_over and not game.show_correct_screen:
                    game.player.jump()
                elif event.key == pygame.K_r and game_over:
                    game = Game()
                    game_over = False
                    game_over_reason = ""
        
        if not game_over:
            result = game.update()
            
            if result == "wrong":
                game_over = True
                game_over_reason = "Wrong Answer!"
            elif result == "timeout":
                game_over = True
                game_over_reason = "Time's Up!"
        elif game.show_correct_screen:
            game.update()  # Still update for correct screen timing
        
        # Draw everything
        game.draw(screen)
        
        # Draw game over screen with enhanced styling
        if game_over:
            overlay = pygame.Surface((WIDTH, HEIGHT))
            overlay.set_alpha(160)
            overlay.fill(BLACK)
            screen.blit(overlay, (0, 0))
            
            # Game over box
            box_rect = pygame.Rect(WIDTH//2 - 300, HEIGHT//2 - 150, 600, 300)
            pygame.draw.rect(screen, DARK_BLUE, box_rect, border_radius=20)
            pygame.draw.rect(screen, RED, box_rect, 5, border_radius=20)
            
            game_over_text = big_font.render("GAME OVER!", True, RED)
            game_over_rect = game_over_text.get_rect(center=(WIDTH//2, HEIGHT//2 - 80))
            screen.blit(game_over_text, game_over_rect)
            
            reason_text = font.render(game_over_reason, True, ORANGE)
            reason_rect = reason_text.get_rect(center=(WIDTH//2, HEIGHT//2 - 30))
            screen.blit(reason_text, reason_rect)
            
            final_score_text = font.render(f"Final Score: {game.score}", True, GOLD)
            final_score_rect = final_score_text.get_rect(center=(WIDTH//2, HEIGHT//2 + 20))
            screen.blit(final_score_text, final_score_rect)
            
            problems_text = small_font.render(f"Problems Solved: {game.problems_solved}", True, EMERALD)
            problems_rect = problems_text.get_rect(center=(WIDTH//2, HEIGHT//2 + 60))
            screen.blit(problems_text, problems_rect)
            
            restart_text = font.render("Press R to Restart", True, YELLOW)
            restart_rect = restart_text.get_rect(center=(WIDTH//2, HEIGHT//2 + 100))
            screen.blit(restart_text, restart_rect)
        
        pygame.display.flip()
        clock.tick(60)
    
    pygame.quit()
    sys.exit()

if __name__ == "__main__":
    main()
