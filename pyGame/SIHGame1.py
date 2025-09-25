import pygame
import random
import sys
import math

# Initialize pygame
pygame.init()

# Screen settings
WIDTH, HEIGHT = 1200, 700
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Fraction Race - Simplify to Win!")

# Fonts
font = pygame.font.Font(None, 42)
small_font = pygame.font.Font(None, 28)
big_font = pygame.font.Font(None, 64)

# Enhanced Color Palette
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 82, 82)
GREEN = (76, 209, 55)
BLUE = (64, 156, 255)
YELLOW = (255, 193, 7)
PURPLE = (155, 89, 182)
GRAY = (108, 117, 125)
DARK_BLUE = (23, 32, 42)
LIGHT_BLUE = (174, 214, 241)
GOLD = (255, 215, 0)
EMERALD = (46, 204, 113)
CRIMSON = (220, 20, 60)

# Gradient colors
SKY_BLUE_TOP = (135, 206, 250)
SKY_BLUE_BOTTOM = (100, 149, 237)
TRACK_GRAY_TOP = (60, 60, 60)
TRACK_GRAY_BOTTOM = (80, 80, 80)

# Helper functions
def gcd(a, b):
    while b:
        a, b = b, a % b
    return a

def generate_fraction():
    original_num = random.randint(2, 12)
    original_den = random.randint(2, 12)
    multiplier = random.randint(2, 6)
    
    num = original_num * multiplier
    den = original_den * multiplier
    
    g = gcd(original_num, original_den)
    simplified_num = original_num // g
    simplified_den = original_den // g
    
    return num, den, simplified_num, simplified_den

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
            s = pygame.Surface((self.size * 2, self.size * 2))
            s.set_alpha(alpha)
            pygame.draw.circle(s, self.color, (self.size, self.size), self.size)
            screen.blit(s, (self.x - self.size, self.y - self.size))
            
    def is_dead(self):
        return self.lifetime <= 0

class Car:
    def __init__(self, y_pos, color):
        self.x = 50
        self.y = y_pos
        self.color = color
        self.speed = 0
        self.progress = 0
        self.trail_particles = []
        
    def draw(self):
        # Draw trail particles
        for particle in self.trail_particles:
            particle.draw(screen)
            
        # Draw car body with a subtle gradient effect
        body_height = 30
        for i in range(body_height):
            alpha = 1.0 - (i / body_height) * 0.3
            color = (int(self.color[0] * alpha), int(self.color[1] * alpha), int(self.color[2] * alpha))
            pygame.draw.rect(screen, color, (self.x, self.y + i, 60, 1))

        if self.color == BLUE: # Only draw "You" on the player's car
            text_surface = small_font.render("You", True, WHITE)
            text_rect = text_surface.get_rect(center=(self.x + 30, self.y + 15))
            screen.blit(text_surface, text_rect)
        
        # Add a white outline
        pygame.draw.rect(screen, WHITE, (self.x, self.y, 60, 30), 2)

        # Draw wheels
        pygame.draw.circle(screen, BLACK, (int(self.x + 15), int(self.y + 35)), 8)
        pygame.draw.circle(screen, BLACK, (int(self.x + 45), int(self.y + 35)), 8)
        
    def move(self, distance):
        self.progress += distance
        self.x = min(50 + self.progress * 3, WIDTH - 150)
        
        # Add trail particles
        if self.speed > 0:
            for _ in range(3):
                self.trail_particles.append(
                    Particle(self.x + random.randint(0, 60), self.y + 30, 
                             GRAY, size=random.randint(2, 4), lifetime=30)
                )

    def update(self):
        self.trail_particles = [p for p in self.trail_particles if not p.is_dead()]
        for particle in self.trail_particles:
            particle.update()

class FractionCard:
    def __init__(self, num, den, simp_num, simp_den):
        self.num = num
        self.den = den
        self.simp_num = simp_num
        self.simp_den = simp_den
        self.x = random.randint(300, WIDTH - 300)
        self.y = 0
        self.speed = 1
        self.width = 120
        self.height = 80
        self.pulse_offset = random.uniform(0, math.pi * 2)

    def move(self):
        self.y += self.speed
        
    def draw(self, is_current=False):
        # Card background with shadow
        shadow_rect = pygame.Rect(self.x + 5, self.y + 5, self.width, self.height)
        pygame.draw.rect(screen, DARK_BLUE, shadow_rect, border_radius=10)
        
        main_rect = pygame.Rect(self.x, self.y, self.width, self.height)
        pygame.draw.rect(screen, WHITE, main_rect, border_radius=10)
        pygame.draw.rect(screen, BLACK, main_rect, 3, border_radius=10)

        # Draw fraction
        fraction_text = font.render(f"{self.num}", True, BLACK)
        line_rect = pygame.Rect(self.x + 20, self.y + 35, 80, 3)
        pygame.draw.rect(screen, BLACK, line_rect)
        den_text = font.render(f"{self.den}", True, BLACK)
        
        num_rect = fraction_text.get_rect(center=(self.x + 60, self.y + 20))
        den_rect = den_text.get_rect(center=(self.x + 60, self.y + 55))
        
        screen.blit(fraction_text, num_rect)
        screen.blit(den_text, den_rect)
        
        if is_current:
            pulse = math.sin(pygame.time.get_ticks() * 0.008 + self.pulse_offset) * 0.5 + 0.5
            glow_size = int(6 + pulse * 4)
            glow_rect = pygame.Rect(self.x - glow_size, self.y - glow_size, 
                                   self.width + glow_size * 2, self.height + glow_size * 2)
            
            # Clamp color values to prevent them from exceeding 255
            glow_color = (
                min(255, YELLOW[0] + int(pulse * 30)),
                min(255, YELLOW[1] + int(pulse * 30)),
                min(255, YELLOW[2] + int(pulse * 30))
            )
            
            pygame.draw.rect(screen, glow_color, glow_rect, 4, border_radius=15)

class InputBox:
    def __init__(self, x, y, width, height, text=""):
        self.rect = pygame.Rect(x, y, width, height)
        self.text = text
        self.color = WHITE
        self.active = False
        
    def draw(self, screen, is_active=False):
        # Draw background and border
        border_color = GOLD if is_active else WHITE
        border_width = 3 if is_active else 2
        
        # Pulsing glow for active box
        if is_active:
            pulse = math.sin(pygame.time.get_ticks() * 0.01) * 0.5 + 0.5
            glow_size = int(5 + pulse * 3)
            glow_rect = self.rect.inflate(glow_size, glow_size)
            pygame.draw.rect(screen, GOLD, glow_rect, border_radius=10)
        
        pygame.draw.rect(screen, self.color, self.rect, border_radius=8)
        pygame.draw.rect(screen, border_color, self.rect, border_width, border_radius=8)
        
        # Draw text
        text_surface = font.render(self.text, True, BLACK)
        screen.blit(text_surface, (self.rect.x + 5, self.rect.y + 5))

# Game variables
player_car = Car(550, BLUE)
ai_cars = [
    Car(400, RED),
    Car(450, GREEN),
    Car(500, PURPLE)
]

cards = []
numerator_input = InputBox(50, 50, 100, 40)
denominator_input = InputBox(50, 105, 100, 40)
active_input = numerator_input

score = 0
level = 1
cards_solved = 0
clock = pygame.time.Clock()
particles = []

# Spawn first card
num, den, simp_num, simp_den = generate_fraction()
cards.append(FractionCard(num, den, simp_num, simp_den))

# Game loop
game_running = True
while game_running:
    # Draw gradient background
    for y in range(HEIGHT):
        ratio = y / HEIGHT
        r = int(SKY_BLUE_TOP[0] * (1 - ratio) + SKY_BLUE_BOTTOM[0] * ratio)
        g = int(SKY_BLUE_TOP[1] * (1 - ratio) + SKY_BLUE_BOTTOM[1] * ratio)
        b = int(SKY_BLUE_TOP[2] * (1 - ratio) + SKY_BLUE_BOTTOM[2] * ratio)
        pygame.draw.line(screen, (r, g, b), (0, y), (WIDTH, y))

    # Draw race track with gradient and details
    track_height = 200
    for y in range(HEIGHT - track_height, HEIGHT):
        ratio = (y - (HEIGHT - track_height)) / track_height
        r = int(TRACK_GRAY_TOP[0] * (1 - ratio) + TRACK_GRAY_BOTTOM[0] * ratio)
        g = int(TRACK_GRAY_TOP[1] * (1 - ratio) + TRACK_GRAY_BOTTOM[1] * ratio)
        b = int(TRACK_GRAY_TOP[2] * (1 - ratio) + TRACK_GRAY_BOTTOM[2] * ratio)
        pygame.draw.line(screen, (r, g, b), (0, y), (WIDTH, y))
    
    # Draw lane dividers
    for i in range(0, WIDTH, 40):
        pulse = math.sin(pygame.time.get_ticks() * 0.005 + (i * 0.1)) * 5 + 5
        pygame.draw.rect(screen, YELLOW, (i, 485, 20, pulse))

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if numerator_input.rect.collidepoint(event.pos):
                active_input = numerator_input
            elif denominator_input.rect.collidepoint(event.pos):
                active_input = denominator_input
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_RETURN:
                if active_input == numerator_input:
                    active_input = denominator_input
                elif active_input == denominator_input and cards and numerator_input.text and denominator_input.text:
                    if (int(numerator_input.text) == cards[0].simp_num and 
                        int(denominator_input.text) == cards[0].simp_den):
                        # Correct answer - player moves forward
                        player_car.move(20)
                        score += 10
                        cards_solved += 1
                        
                        # Add confetti particles
                        for _ in range(30):
                            particles.append(
                                Particle(player_car.x + 30, player_car.y,
                                         random.choice([YELLOW, GREEN, BLUE, WHITE]), 
                                         size=random.randint(2, 5), lifetime=50)
                            )
                        
                        if cards_solved % 5 == 0:
                            level += 1
                            
                        # Remove card and spawn a new one
                        cards.pop(0)
                        num, den, simp_num, simp_den = generate_fraction()
                        cards.append(FractionCard(num, den, simp_num, simp_den))
                    
                    # AI cars move randomly
                    for car in ai_cars:
                        car.move(random.randint(3, 8))
                    
                    # Reset input and return to numerator
                    numerator_input.text = ""
                    denominator_input.text = ""
                    active_input = numerator_input
                    
            elif event.key == pygame.K_BACKSPACE:
                active_input.text = active_input.text[:-1]
            else:
                if event.unicode.isdigit():
                    active_input.text += event.unicode

    # Update cards
    for card in cards:
        card.move()
        card.draw(is_current=(card == cards[0]))
        
        if card.y > HEIGHT:
            cards.pop(0)
            num, den, simp_num, simp_den = generate_fraction()
            cards.append(FractionCard(num, den, simp_num, simp_den))
            for car in ai_cars:
                car.move(random.randint(5, 10))
                
    # Update cars
    player_car.update()
    for car in ai_cars:
        car.update()

    # Draw cars
    player_car.draw()
    for car in ai_cars:
        car.draw()
    
    # Update and draw particles
    particles = [p for p in particles if not p.is_dead()]
    for p in particles:
        p.update()
        p.draw(screen)
    
    # Check win condition
    if player_car.x >= WIDTH - 150:
        win_text = big_font.render("YOU WON!", True, EMERALD)
        win_rect = win_text.get_rect(center=(WIDTH//2, HEIGHT//2 - 50))
        win_box = win_rect.inflate(40, 20)
        pygame.draw.rect(screen, DARK_BLUE, win_box, border_radius=15)
        pygame.draw.rect(screen, EMERALD, win_box, 5, border_radius=15)
        screen.blit(win_text, win_rect)
        
        restart_text = font.render("Press R to Restart", True, WHITE)
        restart_rect = restart_text.get_rect(center=(WIDTH//2, HEIGHT//2 + 20))
        screen.blit(restart_text, restart_rect)
        
        keys = pygame.key.get_pressed()
        if keys[pygame.K_r]:
            player_car = Car(550, BLUE)
            ai_cars = [Car(400, RED), Car(450, GREEN), Car(500, PURPLE)]
            score = 0
            level = 1
            cards_solved = 0
            cards = []
            num, den, simp_num, simp_den = generate_fraction()
            cards.append(FractionCard(num, den, simp_num, simp_den))
            numerator_input.text = ""
            denominator_input.text = ""
    
    # Check lose condition
    for car in ai_cars:
        if car.x >= WIDTH - 150:
            lose_text = big_font.render("AI WON!", True, CRIMSON)
            lose_rect = lose_text.get_rect(center=(WIDTH//2, HEIGHT//2 - 50))
            lose_box = lose_rect.inflate(40, 20)
            pygame.draw.rect(screen, DARK_BLUE, lose_box, border_radius=15)
            pygame.draw.rect(screen, CRIMSON, lose_box, 5, border_radius=15)
            screen.blit(lose_text, lose_rect)
            
            restart_text = font.render("Press R to Restart", True, WHITE)
            restart_rect = restart_text.get_rect(center=(WIDTH//2, HEIGHT//2 + 20))
            screen.blit(restart_text, restart_rect)
            
            keys = pygame.key.get_pressed()
            if keys[pygame.K_r]:
                player_car = Car(550, BLUE)
                ai_cars = [Car(400, RED), Car(450, GREEN), Car(500, PURPLE)]
                score = 0
                level = 1
                cards_solved = 0
                cards = []
                num, den, simp_num, simp_den = generate_fraction()
                cards.append(FractionCard(num, den, simp_num, simp_den))
                numerator_input.text = ""
                denominator_input.text = ""

    # Draw input boxes
    numerator_input.draw(screen, active_input == numerator_input)
    pygame.draw.rect(screen, BLACK, (60, 95, 80, 3))
    denominator_input.draw(screen, active_input == denominator_input)
    
    # Draw UI
    # Stats box
    stats_bg = pygame.Rect(WIDTH - 250, 20, 230, 100)
    pygame.draw.rect(screen, (0, 0, 0, 100), stats_bg, border_radius=10)
    pygame.draw.rect(screen, GOLD, stats_bg, 3, border_radius=10)
    
    score_text = font.render(f"Score: {score}", True, GOLD)
    screen.blit(score_text, (WIDTH - 240, 30))
    
    level_text = font.render(f"Level: {level}", True, LIGHT_BLUE)
    screen.blit(level_text, (WIDTH - 240, 60))
    
    problems_text = small_font.render(f"Solved: {cards_solved}", True, EMERALD)
    screen.blit(problems_text, (WIDTH - 240, 90))

    # Instructions
    inst_bg = pygame.Rect(200, 20, 500, 70)
    pygame.draw.rect(screen, (0, 0, 0, 100), inst_bg, border_radius=10)
    pygame.draw.rect(screen, WHITE, inst_bg, 3, border_radius=10)
    
    inst1 = small_font.render("Click on a box to type. ENTER to go down.", True, WHITE)
    inst2 = small_font.render("ENTER again to submit. Simplify the fraction!", True, WHITE)
    screen.blit(inst1, (210, 30))
    screen.blit(inst2, (210, 55))

    pygame.display.flip()
    clock.tick(60)
