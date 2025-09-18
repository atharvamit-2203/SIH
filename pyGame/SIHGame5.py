import pygame
import random
import sys
import math

# Initialize pygame
pygame.init()

# Screen settings
WIDTH, HEIGHT = 1200, 800
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Geometry Tower Defense - Shape Power Battle!")

# Fonts
title_font = pygame.font.SysFont("arial", 48, bold=True)
font = pygame.font.SysFont("arial", 28)
equation_font = pygame.font.SysFont("arial", 24, bold=True)
small_font = pygame.font.SysFont("arial", 18)
score_font = pygame.font.SysFont("arial", 32, bold=True)
big_font = pygame.font.SysFont("arial", 36, bold=True)

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
CYAN = (0, 255, 255)

# Background gradient colors
BG_TOP = (20, 24, 82)      # Dark space blue
BG_MIDDLE = (65, 105, 225)  # Royal blue
BG_BOTTOM = (135, 206, 235) # Sky blue

# Particle effects
class Particle:
    def __init__(self, x, y, color, velocity=None):
        self.x = x
        self.y = y
        if velocity:
            self.vx, self.vy = velocity
        else:
            self.vx = random.uniform(-4, 4)
            self.vy = random.uniform(-6, -2)
        self.color = color
        self.life = 40
        self.max_life = 40
        self.size = random.uniform(2, 5)
        
    def update(self):
        self.x += self.vx
        self.y += self.vy
        self.vy += 0.15  # Gravity
        self.life -= 1
        
    def draw(self):
        if self.life > 0:
            alpha_factor = self.life / self.max_life
            size = int(self.size * alpha_factor)
            if size > 0:
                pygame.draw.circle(screen, self.color, (int(self.x), int(self.y)), size)

# Enhanced background with animated stars and gradient
def draw_animated_background():
    # Draw gradient background
    for y in range(HEIGHT):
        if y < HEIGHT // 3:
            ratio = y / (HEIGHT // 3)
            r = int(BG_TOP[0] * (1 - ratio) + BG_MIDDLE[0] * ratio)
            g = int(BG_TOP[1] * (1 - ratio) + BG_MIDDLE[1] * ratio)
            b = int(BG_TOP[2] * (1 - ratio) + BG_MIDDLE[2] * ratio)
        else:
            ratio = (y - HEIGHT // 3) / (2 * HEIGHT // 3)
            r = int(BG_MIDDLE[0] * (1 - ratio) + BG_BOTTOM[0] * ratio)
            g = int(BG_MIDDLE[1] * (1 - ratio) + BG_BOTTOM[1] * ratio)
            b = int(BG_MIDDLE[2] * (1 - ratio) + BG_BOTTOM[2] * ratio)
        pygame.draw.line(screen, (r, g, b), (0, y), (WIDTH, y))
    
    # Draw twinkling stars
    time_factor = pygame.time.get_ticks() * 0.01
    for i in range(50):
        x = (i * 23) % WIDTH
        y = (i * 17) % (HEIGHT // 2)
        brightness = abs(math.sin(time_factor + i * 0.1)) * 255
        star_color = (int(brightness), int(brightness), int(brightness * 0.8))
        if brightness > 100:
            pygame.draw.circle(screen, star_color, (x, y), 1)

# Shape problems generator
def generate_shape_problem():
    shape_types = [
        {
            "name": "Triangle",
            "angles": lambda: random.choice([
                (60, 60, 60),  # Equilateral
                (45, 45, 90),  # Right isosceles
                (30, 60, 90),  # 30-60-90
                (90, 45, 45),  # Right triangle
            ]),
            "question_type": "angle"
        },
        {
            "name": "Rectangle",
            "dimensions": lambda: (random.randint(4, 12), random.randint(3, 8)),
            "question_type": "area_perimeter"
        },
        {
            "name": "Circle",
            "radius": lambda: random.randint(3, 10),
            "question_type": "area_circumference"
        },
        {
            "name": "Square",
            "side": lambda: random.randint(4, 12),
            "question_type": "area_perimeter"
        }
    ]
    
    shape_data = random.choice(shape_types)
    return create_problem(shape_data)

def create_problem(shape_data):
    if shape_data["name"] == "Triangle":
        angles = shape_data["angles"]()
        missing_index = random.randint(0, 2)
        known_angles = [angles[i] if i != missing_index else "?" for i in range(3)]
        return {
            "type": "triangle",
            "angles": known_angles,
            "answer": angles[missing_index],
            "question": f"Find the missing angle in triangle with angles {angles[0]}°, {angles[1]}°, ?°"
        }
    
    elif shape_data["name"] == "Rectangle":
        width, height = shape_data["dimensions"]()
        question_type = random.choice(["area", "perimeter"])
        if question_type == "area":
            return {
                "type": "rectangle_area",
                "width": width,
                "height": height,
                "answer": width * height,
                "question": f"Find area of rectangle: {width} × {height}"
            }
        else:
            return {
                "type": "rectangle_perimeter",
                "width": width,
                "height": height,
                "answer": 2 * (width + height),
                "question": f"Find perimeter of rectangle: {width} × {height}"
            }
    
    elif shape_data["name"] == "Circle":
        radius = shape_data["radius"]()
        question_type = random.choice(["area", "circumference"])
        if question_type == "area":
            return {
                "type": "circle_area",
                "radius": radius,
                "answer": round(math.pi * radius * radius, 1),
                "question": f"Find area of circle with radius {radius} (π ≈ 3.14)"
            }
        else:
            return {
                "type": "circle_circumference",
                "radius": radius,
                "answer": round(2 * math.pi * radius, 1),
                "question": f"Find circumference of circle with radius {radius} (π ≈ 3.14)"
            }
    
    else:  # Square
        side = shape_data["side"]()
        question_type = random.choice(["area", "perimeter"])
        if question_type == "area":
            return {
                "type": "square_area",
                "side": side,
                "answer": side * side,
                "question": f"Find area of square with side {side}"
            }
        else:
            return {
                "type": "square_perimeter",
                "side": side,
                "answer": 4 * side,
                "question": f"Find perimeter of square with side {side}"
            }

# Enemy class representing geometry problems
class GeometryEnemy:
    def __init__(self, problem_data):
        self.problem = problem_data
        self.x = -100
        self.y = HEIGHT // 2 + random.randint(-200, 200)
        self.speed = random.uniform(1.0, 2.5)
        self.health = 3
        self.max_health = 3
        self.scale = 1.0
        self.pulse = 0
        self.color = self.get_color_by_type()
        self.trail = []
        
    def get_color_by_type(self):
        color_map = {
            "triangle": ORANGE,
            "rectangle_area": GREEN,
            "rectangle_perimeter": DARK_GREEN,
            "circle_area": BLUE,
            "circle_circumference": LIGHT_BLUE,
            "square_area": PURPLE,
            "square_perimeter": PINK
        }
        return color_map.get(self.problem["type"], RED)
    
    def move(self):
        self.x += self.speed
        self.pulse += 0.1
        self.scale = 1.0 + math.sin(self.pulse) * 0.1
        
        # Add trail effect
        self.trail.append((self.x, self.y))
        if len(self.trail) > 10:
            self.trail.pop(0)
    
    def draw(self):
        # Draw trail
        for i, (tx, ty) in enumerate(self.trail):
            alpha = i / len(self.trail)
            trail_color = tuple(int(c * alpha * 0.5) for c in self.color)
            if alpha > 0.3:
                pygame.draw.circle(screen, trail_color, (int(tx), int(ty)), int(20 * alpha))
        
        # Draw enemy shape based on type
        size = int(40 * self.scale)
        
        if self.problem["type"] == "triangle":
            points = [
                (self.x, self.y - size),
                (self.x - size, self.y + size//2),
                (self.x + size, self.y + size//2)
            ]
            pygame.draw.polygon(screen, self.color, points)
            pygame.draw.polygon(screen, BLACK, points, 3)
            
        elif "rectangle" in self.problem["type"]:
            rect = pygame.Rect(self.x - size, self.y - size//2, size*2, size)
            pygame.draw.rect(screen, self.color, rect)
            pygame.draw.rect(screen, BLACK, rect, 3)
            
        elif "circle" in self.problem["type"]:
            pygame.draw.circle(screen, self.color, (int(self.x), int(self.y)), size)
            pygame.draw.circle(screen, BLACK, (int(self.x), int(self.y)), size, 3)
            
        elif "square" in self.problem["type"]:
            rect = pygame.Rect(self.x - size, self.y - size, size*2, size*2)
            pygame.draw.rect(screen, self.color, rect)
            pygame.draw.rect(screen, BLACK, rect, 3)
        
        # Draw health bar
        bar_width = 60
        bar_height = 6
        bar_x = self.x - bar_width//2
        bar_y = self.y - size - 15
        
        # Background bar
        pygame.draw.rect(screen, RED, (bar_x, bar_y, bar_width, bar_height))
        # Health bar
        health_width = int((self.health / self.max_health) * bar_width)
        pygame.draw.rect(screen, GREEN, (bar_x, bar_y, health_width, bar_height))
        
        # Draw problem text on enemy
        problem_text = small_font.render("?", True, WHITE)
        text_rect = problem_text.get_rect(center=(self.x, self.y))
        # Text background
        bg_rect = text_rect.inflate(6, 4)
        pygame.draw.rect(screen, BLACK, bg_rect, border_radius=3)
        screen.blit(problem_text, text_rect)

# Tower class for player's defensive structures
class DefenseTower:
    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.range = 150
        self.damage = 1
        self.last_shot = 0
        self.shot_cooldown = 1000  # milliseconds
        self.level = 1
        
    def can_shoot(self, current_time):
        return current_time - self.last_shot > self.shot_cooldown
    
    def shoot(self, target, current_time):
        self.last_shot = current_time
        return Projectile(self.x, self.y, target.x, target.y, self.damage)
    
    def draw(self):
        # Draw tower base
        pygame.draw.circle(screen, GRAY, (int(self.x), int(self.y)), 25)
        pygame.draw.circle(screen, BLACK, (int(self.x), int(self.y)), 25, 3)
        
        # Draw range circle (semi-transparent)
        range_surface = pygame.Surface((self.range * 2, self.range * 2), pygame.SRCALPHA)
        pygame.draw.circle(range_surface, (*LIGHT_BLUE, 30), (self.range, self.range), self.range)
        screen.blit(range_surface, (self.x - self.range, self.y - self.range))
        
        # Draw tower cannon
        pygame.draw.circle(screen, DARK_BLUE, (int(self.x), int(self.y)), 15)
        pygame.draw.circle(screen, BLACK, (int(self.x), int(self.y)), 15, 2)

class Projectile:
    def __init__(self, start_x, start_y, target_x, target_y, damage):
        self.x = start_x
        self.y = start_y
        self.target_x = target_x
        self.target_y = target_y
        self.damage = damage
        self.speed = 8
        
        # Calculate direction
        dx = target_x - start_x
        dy = target_y - start_y
        distance = math.sqrt(dx*dx + dy*dy)
        if distance > 0:
            self.vx = (dx / distance) * self.speed
            self.vy = (dy / distance) * self.speed
        else:
            self.vx = self.vy = 0
        
        self.life = 100
        
    def update(self):
        self.x += self.vx
        self.y += self.vy
        self.life -= 1
        
    def draw(self):
        pygame.draw.circle(screen, GOLD, (int(self.x), int(self.y)), 4)
        pygame.draw.circle(screen, ORANGE, (int(self.x), int(self.y)), 2)

# Enhanced UI drawing functions
def draw_gradient_background():
    draw_animated_background()

def draw_enhanced_ui():
    # Title with glow effect
    title_text = title_font.render("GEOMETRY TOWER DEFENSE", True, WHITE)
    title_glow = title_font.render("GEOMETRY TOWER DEFENSE", True, CYAN)
    
    # Glow effect
    for offset in range(3):
        screen.blit(title_glow, (WIDTH//2 - title_glow.get_width()//2 + offset, 15 + offset))
    screen.blit(title_text, (WIDTH//2 - title_text.get_width()//2, 15))

def draw_problem_panel(current_problem):
    if not current_problem:
        return
        
    panel_rect = pygame.Rect(50, HEIGHT - 200, WIDTH - 100, 150)
    
    # Panel background with gradient
    pygame.draw.rect(screen, (0, 0, 50, 200), panel_rect, border_radius=15)
    pygame.draw.rect(screen, CYAN, panel_rect, 3, border_radius=15)
    
    # Problem question
    question_text = font.render("SOLVE TO DEFEND:", True, WHITE)
    screen.blit(question_text, (panel_rect.x + 20, panel_rect.y + 20))
    
    problem_text = equation_font.render(current_problem["question"], True, GOLD)
    screen.blit(problem_text, (panel_rect.x + 20, panel_rect.y + 50))
    
    # Input box
    input_rect = pygame.Rect(panel_rect.x + 20, panel_rect.y + 90, 200, 40)
    pygame.draw.rect(screen, WHITE, input_rect, border_radius=8)
    pygame.draw.rect(screen, DARK_BLUE, input_rect, 3, border_radius=8)
    
    input_surface = font.render(current_text, True, BLACK)
    input_text_rect = input_surface.get_rect(center=input_rect.center)
    screen.blit(input_surface, input_text_rect)
    
    # Instructions
    inst_text = small_font.render("Enter answer and press ENTER to attack!", True, WHITE)
    screen.blit(inst_text, (panel_rect.x + 250, panel_rect.y + 100))

def draw_game_stats():
    stats_rect = pygame.Rect(WIDTH - 300, 80, 280, 200)
    
    # Stats panel
    pygame.draw.rect(screen, (0, 0, 50, 200), stats_rect, border_radius=15)
    pygame.draw.rect(screen, GREEN, stats_rect, 3, border_radius=15)
    
    # Stats text
    stats_title = font.render("BATTLE STATUS", True, WHITE)
    screen.blit(stats_title, (stats_rect.x + 20, stats_rect.y + 20))
    
    score_text = equation_font.render(f"SCORE: {score}", True, GOLD)
    screen.blit(score_text, (stats_rect.x + 20, stats_rect.y + 60))
    
    level_text = equation_font.render(f"WAVE: {wave}", True, CYAN)
    screen.blit(level_text, (stats_rect.x + 20, stats_rect.y + 90))
    
    health_text = equation_font.render(f"BASE HP: {base_health}", True, RED if base_health <= 5 else GREEN)
    screen.blit(health_text, (stats_rect.x + 20, stats_rect.y + 120))
    
    enemies_text = small_font.render(f"Enemies: {len(enemies)}", True, WHITE)
    screen.blit(enemies_text, (stats_rect.x + 20, stats_rect.y + 150))

# Game variables
enemies = []
towers = []
projectiles = []
particles = []
current_problem = None
current_text = ""
score = 0
wave = 1
base_health = 20
last_enemy_spawn = 0
enemy_spawn_delay = 3000
clock = pygame.time.Clock()

# Create some towers
towers.append(DefenseTower(200, 300))
towers.append(DefenseTower(300, 500))
towers.append(DefenseTower(500, 200))

# Game loop
running = True
game_over = False

while running:
    current_time = pygame.time.get_ticks()
    
    draw_gradient_background()
    
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN and not game_over:
            if event.key == pygame.K_RETURN:
                if current_problem and current_text.strip().replace('.', '').isdigit():
                    user_answer = float(current_text)
                    if abs(user_answer - current_problem["answer"]) < 0.1:
                        # Correct answer - damage all enemies
                        for enemy in enemies:
                            enemy.health -= 2
                            # Create hit particles
                            for _ in range(10):
                                particles.append(Particle(enemy.x, enemy.y, GREEN))
                        
                        score += 10
                        current_problem = None
                    else:
                        # Wrong answer - create miss particles
                        for _ in range(5):
                            particles.append(Particle(WIDTH//2, HEIGHT//2, RED))
                
                current_text = ""
            elif event.key == pygame.K_BACKSPACE:
                current_text = current_text[:-1]
            else:
                if event.unicode.replace('.', '').isdigit() or event.unicode == '.':
                    if len(current_text) < 10:
                        current_text += event.unicode

    if not game_over:
        # Spawn enemies
        if current_time - last_enemy_spawn > enemy_spawn_delay:
            problem = generate_shape_problem()
            enemies.append(GeometryEnemy(problem))
            last_enemy_spawn = current_time
            enemy_spawn_delay = max(1500, 3000 - wave * 100)
        
        # Set current problem from first enemy
        if enemies and not current_problem:
            current_problem = enemies[0].problem
        
        # Update enemies
        for enemy in enemies[:]:
            enemy.move()
            
            # Remove dead enemies
            if enemy.health <= 0:
                enemies.remove(enemy)
                score += 5
                # Explosion particles
                for _ in range(20):
                    particles.append(Particle(enemy.x, enemy.y, random.choice([GOLD, ORANGE, RED])))
            
            # Check if enemy reached the end
            elif enemy.x > WIDTH:
                enemies.remove(enemy)
                base_health -= 1
                if enemy == enemies[0] if enemies else None:
                    current_problem = None
        
        # Tower shooting
        for tower in towers:
            if tower.can_shoot(current_time):
                # Find closest enemy in range
                closest_enemy = None
                closest_distance = tower.range
                
                for enemy in enemies:
                    distance = math.sqrt((enemy.x - tower.x)**2 + (enemy.y - tower.y)**2)
                    if distance < closest_distance:
                        closest_enemy = enemy
                        closest_distance = distance
                
                if closest_enemy:
                    projectiles.append(tower.shoot(closest_enemy, current_time))
        
        # Update projectiles
        for projectile in projectiles[:]:
            projectile.update()
            
            if projectile.life <= 0:
                projectiles.remove(projectile)
                continue
            
            # Check collision with enemies
            for enemy in enemies:
                if (abs(projectile.x - enemy.x) < 30 and 
                    abs(projectile.y - enemy.y) < 30):
                    enemy.health -= projectile.damage
                    projectiles.remove(projectile)
                    # Hit particles
                    for _ in range(5):
                        particles.append(Particle(enemy.x, enemy.y, YELLOW))
                    break
        
        # Update particles
        for particle in particles[:]:
            particle.update()
            if particle.life <= 0:
                particles.remove(particle)
        
        # Wave progression
        if not enemies and current_time - last_enemy_spawn > 2000:
            wave += 1
            enemy_spawn_delay = max(1000, enemy_spawn_delay - 200)
        
        # Game over check
        if base_health <= 0:
            game_over = True

    # Draw everything
    for tower in towers:
        tower.draw()
    
    for enemy in enemies:
        enemy.draw()
    
    for projectile in projectiles:
        projectile.draw()
    
    for particle in particles:
        particle.draw()
    
    # Draw UI
    draw_enhanced_ui()
    draw_problem_panel(current_problem)
    draw_game_stats()
    
    # Game over screen
    if game_over:
        game_over_bg = pygame.Rect(WIDTH//2 - 300, HEIGHT//2 - 150, 600, 300)
        pygame.draw.rect(screen, (0, 0, 0, 200), game_over_bg, border_radius=20)
        pygame.draw.rect(screen, RED, game_over_bg, 5, border_radius=20)
        
        game_over_text = big_font.render("GAME OVER!", True, RED)
        final_score_text = font.render(f"Final Score: {score} | Wave Reached: {wave}", True, WHITE)
        restart_text = small_font.render("Press R to restart or ESC to quit", True, WHITE)
        
        game_over_rect = game_over_text.get_rect(center=(WIDTH//2, HEIGHT//2 - 50))
        final_score_rect = final_score_text.get_rect(center=(WIDTH//2, HEIGHT//2))
        restart_rect = restart_text.get_rect(center=(WIDTH//2, HEIGHT//2 + 50))
        
        screen.blit(game_over_text, game_over_rect)
        screen.blit(final_score_text, final_score_rect)
        screen.blit(restart_text, restart_rect)
        
        keys = pygame.key.get_pressed()
        if keys[pygame.K_r]:
            # Reset game
            enemies = []
            projectiles = []
            particles = []
            current_problem = None
            current_text = ""
            score = 0
            wave = 1
            base_health = 20
            last_enemy_spawn = 0
            enemy_spawn_delay = 3000
            game_over = False
        elif keys[pygame.K_ESCAPE]:
            running = False

    pygame.display.flip()
    clock.tick(60)

pygame.quit()
sys.exit()