import pygame
import random
import sys
import math

# Initialize pygame
pygame.init()

# Screen settings
WIDTH, HEIGHT = 900, 700
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Equation Shooter - Master Linear Equations!")

# Fonts
title_font = pygame.font.SysFont("arial", 48, bold=True)
font = pygame.font.SysFont("arial", 28)
equation_font = pygame.font.SysFont("arial", 22, bold=True)
small_font = pygame.font.SysFont("arial", 18)
score_font = pygame.font.SysFont("arial", 32, bold=True)

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (220, 20, 60)
GREEN = (34, 139, 34)
BLUE = (70, 130, 180)
DARK_BLUE = (25, 25, 112)
LIGHT_BLUE = (173, 216, 230)
YELLOW = (255, 215, 0)
GOLD = (255, 215, 0)
PURPLE = (147, 112, 219)
ORANGE = (255, 165, 0)
PINK = (255, 192, 203)
GRAY = (128, 128, 128)
LIGHT_GRAY = (211, 211, 211)
DARK_GREEN = (0, 100, 0)
SILVER = (192, 192, 192)

# Background gradient colors
BG_TOP = (135, 206, 235)  # Sky blue
BG_BOTTOM = (255, 182, 193)  # Light pink

# Particle effects for visual enhancement
class Particle:
    def __init__(self, x, y, color):
        self.x = x
        self.y = y
        self.vx = random.uniform(-3, 3)
        self.vy = random.uniform(-5, -1)
        self.color = color
        self.life = 30
        self.max_life = 30
        
    def update(self):
        self.x += self.vx
        self.y += self.vy
        self.vy += 0.1  # Gravity
        self.life -= 1
        
    def draw(self):
        alpha = int(255 * (self.life / self.max_life))
        if alpha > 0:
            color_with_alpha = (*self.color, alpha)
            radius = int(3 * (self.life / self.max_life))
            if radius > 0:
                pygame.draw.circle(screen, self.color, (int(self.x), int(self.y)), radius)

# Enhanced equation generator
def generate_equation():
    difficulty_levels = [
        # Easy (Level 1-2)
        {"a_range": (1, 5), "x_range": (1, 9), "b_range": (-5, 5)},
        # Medium (Level 3-5)
        {"a_range": (1, 9), "x_range": (1, 12), "b_range": (-9, 9)},
        # Hard (Level 6+)
        {"a_range": (2, 12), "x_range": (1, 15), "b_range": (-15, 15)}
    ]
    
    # Choose difficulty based on current level
    if level <= 2:
        diff = difficulty_levels[0]
    elif level <= 5:
        diff = difficulty_levels[1]
    else:
        diff = difficulty_levels[2]
    
    a = random.randint(*diff["a_range"])
    x = random.randint(*diff["x_range"])
    b = random.randint(*diff["b_range"])
    c = a * x + b
    
    if b == 0:
        equation = f"{a}x = {c}"
    elif b > 0:
        equation = f"{a}x + {b} = {c}"
    else:
        equation = f"{a}x - {abs(b)} = {c}"
    
    return equation, x

# Enhanced Balloon class with animations
class Balloon:
    def __init__(self, eq, ans):
        self.eq = eq
        self.ans = ans
        self.x = random.randint(100, WIDTH - 100)
        self.y = -50
        self.speed = random.uniform(1.5, 3.0 + level * 0.2)
        self.float_offset = 0
        self.float_speed = random.uniform(0.05, 0.1)
        self.scale = random.uniform(0.8, 1.2)
        self.color = random.choice([BLUE, PURPLE, PINK, ORANGE, GREEN])
        self.glow = 0
        self.glow_direction = 1
        
    def move(self):
        self.y += self.speed
        self.float_offset += self.float_speed
        self.glow += self.glow_direction * 2
        if self.glow >= 20 or self.glow <= 0:
            self.glow_direction *= -1

    def draw(self):
        # Calculate floating motion
        float_y = self.y + math.sin(self.float_offset) * 3
        
        # Draw glow effect
        glow_radius = int(60 * self.scale + self.glow)
        glow_color = (*self.color[:3], 30)  # Semi-transparent
        
        # Main balloon body (ellipse)
        balloon_width = int(100 * self.scale)
        balloon_height = int(70 * self.scale)
        
        # Draw shadow
        shadow_offset = 5
        pygame.draw.ellipse(screen, GRAY, 
                          (self.x - balloon_width//2 + shadow_offset, 
                           float_y - balloon_height//2 + shadow_offset, 
                           balloon_width, balloon_height))
        
        # Draw main balloon
        pygame.draw.ellipse(screen, self.color, 
                          (self.x - balloon_width//2, float_y - balloon_height//2, 
                           balloon_width, balloon_height))
        
        # Draw highlight
        highlight_color = tuple(min(255, c + 50) for c in self.color)
        pygame.draw.ellipse(screen, highlight_color,
                          (self.x - balloon_width//2 + 5, float_y - balloon_height//2 + 5,
                           balloon_width//3, balloon_height//4))
        
        # Draw balloon string
        pygame.draw.line(screen, BLACK, 
                        (self.x, float_y + balloon_height//2),
                        (self.x, float_y + balloon_height//2 + 20), 2)
        
        # Draw equation with better formatting
        equation_surface = equation_font.render(self.eq, True, WHITE)
        equation_rect = equation_surface.get_rect(center=(self.x, float_y))
        
        # Draw text background for better readability
        bg_rect = equation_rect.inflate(10, 4)
        pygame.draw.rect(screen, (0, 0, 0, 100), bg_rect, border_radius=5)
        
        screen.blit(equation_surface, equation_rect)

# Enhanced background with gradient
def draw_gradient_background():
    for y in range(HEIGHT):
        ratio = y / HEIGHT
        r = int(BG_TOP[0] * (1 - ratio) + BG_BOTTOM[0] * ratio)
        g = int(BG_TOP[1] * (1 - ratio) + BG_BOTTOM[1] * ratio)
        b = int(BG_TOP[2] * (1 - ratio) + BG_BOTTOM[2] * ratio)
        pygame.draw.line(screen, (r, g, b), (0, y), (WIDTH, y))

# Draw floating clouds
def draw_clouds():
    cloud_positions = [
        (150, 100), (400, 80), (650, 120), (800, 90)
    ]
    
    for i, (x, y) in enumerate(cloud_positions):
        # Animate clouds slowly
        offset = math.sin(pygame.time.get_ticks() * 0.001 + i) * 10
        cloud_x = x + offset
        
        # Draw cloud circles
        pygame.draw.circle(screen, WHITE, (int(cloud_x), y), 25)
        pygame.draw.circle(screen, WHITE, (int(cloud_x + 20), y), 35)
        pygame.draw.circle(screen, WHITE, (int(cloud_x + 40), y), 25)
        pygame.draw.circle(screen, WHITE, (int(cloud_x - 15), y), 20)

# Enhanced UI drawing
def draw_enhanced_ui():
    # Draw title
    title_text = title_font.render("EQUATION SHOOTER", True, DARK_BLUE)
    title_shadow = title_font.render("EQUATION SHOOTER", True, GRAY)
    
    # Title with shadow effect
    screen.blit(title_shadow, (WIDTH//2 - title_shadow.get_width()//2 + 3, 23))
    screen.blit(title_text, (WIDTH//2 - title_text.get_width()//2, 20))
    
    # Draw enhanced input box
    input_box_rect = pygame.Rect(WIDTH//2 - 150, HEIGHT - 100, 300, 50)
    
    # Input box shadow
    shadow_rect = input_box_rect.copy()
    shadow_rect.x += 3
    shadow_rect.y += 3
    pygame.draw.rect(screen, GRAY, shadow_rect, border_radius=10)
    
    # Main input box
    pygame.draw.rect(screen, WHITE, input_box_rect, border_radius=10)
    pygame.draw.rect(screen, DARK_BLUE, input_box_rect, 3, border_radius=10)
    
    # Input text
    input_surface = font.render(current_text, True, BLACK)
    input_rect = input_surface.get_rect(center=input_box_rect.center)
    screen.blit(input_surface, input_rect)
    
    # Input placeholder
    if not current_text:
        placeholder_text = small_font.render("Enter x value...", True, GRAY)
        placeholder_rect = placeholder_text.get_rect(center=input_box_rect.center)
        screen.blit(placeholder_text, placeholder_rect)

# Enhanced score display
def draw_score_panel():
    panel_rect = pygame.Rect(20, 80, 200, 140)
    
    # Panel shadow
    shadow_rect = panel_rect.copy()
    shadow_rect.x += 3
    shadow_rect.y += 3
    pygame.draw.rect(screen, GRAY, shadow_rect, border_radius=15)
    
    # Main panel
    pygame.draw.rect(screen, WHITE, panel_rect, border_radius=15)
    pygame.draw.rect(screen, DARK_BLUE, panel_rect, 3, border_radius=15)
    
    # Score
    score_text = score_font.render(f"SCORE", True, DARK_BLUE)
    score_value = score_font.render(f"{score}", True, GREEN)
    
    # Level
    level_text = font.render(f"LEVEL", True, DARK_BLUE)
    level_value = font.render(f"{level}", True, ORANGE)
    
    # Streak
    streak_text = small_font.render(f"STREAK: {streak}", True, PURPLE)
    
    # Position text
    screen.blit(score_text, (30, 95))
    screen.blit(score_value, (30, 125))
    screen.blit(level_text, (130, 95))
    screen.blit(level_value, (130, 125))
    screen.blit(streak_text, (30, 160))
    
    # Level progress bar
    progress = (score % 50) / 50  # Level up every 50 points
    bar_rect = pygame.Rect(30, 180, 160, 10)
    pygame.draw.rect(screen, LIGHT_GRAY, bar_rect, border_radius=5)
    progress_rect = pygame.Rect(30, 180, int(160 * progress), 10)
    pygame.draw.rect(screen, GOLD, progress_rect, border_radius=5)

# Game variables
balloons = []
particles = []
current_text = ""
score = 0
level = 1
streak = 0
max_streak = 0
missed_balloons = 0
clock = pygame.time.Clock()
last_spawn_time = 0
spawn_delay = 2000  # milliseconds

# Spawn first balloon
eq, ans = generate_equation()
balloons.append(Balloon(eq, ans))

# Game loop
running = True
while running:
    current_time = pygame.time.get_ticks()
    
    # Draw gradient background
    draw_gradient_background()
    draw_clouds()
    
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_RETURN:
                if balloons and current_text.strip().lstrip("-").isdigit():
                    if int(current_text) == balloons[0].ans:
                        # Correct answer - create celebration particles
                        balloon_x, balloon_y = balloons[0].x, balloons[0].y
                        for _ in range(20):
                            particles.append(Particle(balloon_x, balloon_y, random.choice([GOLD, GREEN, YELLOW])))
                        
                        balloons.pop(0)
                        score += 10 + streak * 2  # Bonus for streaks
                        streak += 1
                        max_streak = max(max_streak, streak)
                        
                        # Level up every 50 points
                        if score // 50 + 1 > level:
                            level = score // 50 + 1
                            # Level up particles
                            for _ in range(30):
                                particles.append(Particle(WIDTH//2, HEIGHT//2, PURPLE))
                        
                        # Spawn new balloon
                        eq, ans = generate_equation()
                        balloons.append(Balloon(eq, ans))
                    else:
                        # Wrong answer - reset streak
                        streak = 0
                        # Red particles for wrong answer
                        if balloons:
                            balloon_x, balloon_y = balloons[0].x, balloons[0].y
                            for _ in range(10):
                                particles.append(Particle(balloon_x, balloon_y, RED))
                
                current_text = ""
            elif event.key == pygame.K_BACKSPACE:
                current_text = current_text[:-1]
            else:
                if event.unicode.isdigit() or event.unicode == "-":
                    if len(current_text) < 10:  # Limit input length
                        current_text += event.unicode

    # Update balloons
    for balloon in balloons[:]:
        balloon.move()
        
        if balloon.y > HEIGHT:  # Missed balloon
            balloons.remove(balloon)
            missed_balloons += 1
            streak = 0  # Reset streak on miss
            eq, ans = generate_equation()
            balloons.append(Balloon(eq, ans))
    
    # Spawn additional balloons based on level (more challenge)
    if current_time - last_spawn_time > spawn_delay and len(balloons) < level:
        eq, ans = generate_equation()
        balloons.append(Balloon(eq, ans))
        last_spawn_time = current_time
        spawn_delay = max(1000, 2000 - level * 100)  # Faster spawning at higher levels

    # Update particles
    for particle in particles[:]:
        particle.update()
        if particle.life <= 0:
            particles.remove(particle)

    # Draw balloons
    for balloon in balloons:
        balloon.draw()

    # Draw particles
    for particle in particles:
        particle.draw()

    # Draw UI
    draw_score_panel()
    draw_enhanced_ui()

    # Instructions with better styling
    instruction_bg = pygame.Rect(WIDTH//2 - 200, HEIGHT - 40, 400, 25)
    pygame.draw.rect(screen, (0, 0, 0, 100), instruction_bg, border_radius=10)
    
    info_text = small_font.render("Solve equations and press ENTER to shoot! Build streaks for bonus points!", True, WHITE)
    info_rect = info_text.get_rect(center=instruction_bg.center)
    screen.blit(info_text, info_rect)

    # Game stats in corner
    stats_text = small_font.render(f"Best Streak: {max_streak} | Missed: {missed_balloons}", True, BLACK)
    screen.blit(stats_text, (WIDTH - 250, HEIGHT - 30))

    pygame.display.flip()
    clock.tick(60)

pygame.quit()
sys.exit()