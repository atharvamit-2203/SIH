import pygame, random, math, sys

pygame.init()
WIDTH, HEIGHT = 800, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Micelle Counter Cleaner")
clock = pygame.time.Clock()
font = pygame.font.SysFont(None, 36)

# --- Colors ---
BLACK  = (0,0,0)
WHITE  = (255,255,255)
BLUE   = (30,144,255)
BROWN  = (139,69,19)
GREY   = (210,210,210)
DARKBLUE = (0, 100, 255)

class Dust:
    def __init__(self):
        self.x = random.randint(120, WIDTH-180)
        self.y = random.randint(80, HEIGHT-80)
        self.radius = 15
        self.scrub_count = 0
        self.required_scrubs = 10
        self.collected = False   # becomes True once attached to micelle
        self.scrub_timer = 0   # NEW: tracks how long space is held over dust
    def draw(self):
        pygame.draw.circle(screen, BROWN, (self.x, self.y), self.radius)

class Micelle:
    def __init__(self):
        self.x, self.y = WIDTH//2, HEIGHT//2
        self.speed = 5
        self.radius = 30
    def move(self, keys):
        if keys[pygame.K_LEFT]:  self.x -= self.speed
        if keys[pygame.K_RIGHT]: self.x += self.speed
        if keys[pygame.K_UP]:    self.y -= self.speed
        if keys[pygame.K_DOWN]:  self.y += self.speed
        self.x = max(self.radius, min(WIDTH-self.radius, self.x))
        self.y = max(self.radius, min(HEIGHT-self.radius, self.y))
    def draw(self):
        pygame.draw.circle(screen, BLUE, (self.x, self.y), self.radius, 3)
        for a in range(0,360,30):
            dx = int(math.cos(math.radians(a)) * (self.radius-5))
            dy = int(math.sin(math.radians(a)) * (self.radius-5))
            pygame.draw.line(screen, BLUE,
                             (self.x, self.y),
                             (self.x+dx, self.y+dy), 2)

def reset_level(level):
    dusts = [Dust() for _ in range(level + 2)]
    base_timer = 60  # seconds for level 1
    timer = max(10, int(base_timer * (0.9 ** (level-1))))  # decrease 10% per level, minimum 10s
    return dusts, timer


def game_over():
    over_txt = font.render("GAME OVER - Press Enter to Quit", True, WHITE)
    screen.blit(over_txt, (WIDTH//2 - over_txt.get_width()//2, HEIGHT//2))
    pygame.display.flip()
    while True:
        for e in pygame.event.get():
            if e.type == pygame.QUIT: sys.exit()
            if e.type == pygame.KEYDOWN and e.key == pygame.K_RETURN: return

def draw_water_stream(time):
    # Make a wavy blue stream at the right edge
    stream_rect = pygame.Rect(WIDTH-80, 0, 80, HEIGHT)
    pygame.draw.rect(screen, DARKBLUE, stream_rect)
    # Add moving “waves”
    for y in range(0, HEIGHT, 40):
        offset = int(10*math.sin((time/300) + y))
        pygame.draw.circle(screen, BLUE, (WIDTH-40 + offset, y+20), 20, 2)
    label = font.render("WATER", True, WHITE)
    screen.blit(label, (WIDTH-78, 10))

def main():
    level = 1
    micelle = Micelle()
    dusts, timer = reset_level(level)
    carrying = None
    start_ticks = pygame.time.get_ticks()

    while True:
        dt = clock.tick(60)
        keys = pygame.key.get_pressed()
        for e in pygame.event.get():
            if e.type == pygame.QUIT:
                pygame.quit(); sys.exit()

        micelle.move(keys)

        #scrubbing/carrying logic: hold space to carry, release to drop
        carrying = None  # start with nothing carried

        for d in dusts:
            dist = math.hypot(micelle.x - d.x, micelle.y - d.y)
            if dist < micelle.radius + d.radius:
                if keys[pygame.K_SPACE]:
                    carrying = d  # attach dust while holding space
                break  # only attach one dust at a time

        # Carry dust with micelle
        if carrying:
            carrying.x, carrying.y = micelle.x, micelle.y
            # Drop in water stream
            if micelle.x > WIDTH - 80:
                dusts.remove(carrying)
                carrying = None




        # Carry dust with micelle
        if carrying:
            carrying.x, carrying.y = micelle.x, micelle.y
            # Drop in water
            if micelle.x > WIDTH - 80:
                dusts.remove(carrying)
                carrying = None

        # Timer
        elapsed = (pygame.time.get_ticks() - start_ticks) / 1000
        time_left = max(0, int(timer - elapsed))
        if time_left <= 0:
            game_over()
            return

        # Next level
        if not dusts:
            level += 1
            dusts, timer = reset_level(level)
            micelle = Micelle()
            carrying = None
            start_ticks = pygame.time.get_ticks()

        # --- Draw ---
        screen.fill(GREY)
        draw_water_stream(pygame.time.get_ticks())
        for d in dusts:
            if not d.collected:    # draw only ground dust
                d.draw()
        micelle.draw()
        if carrying:               # draw carried dust
            carrying.draw()

        hud = font.render(f"Level {level} | Time {time_left}s | Dust left {len(dusts)}",
                          True, BLACK)
        screen.blit(hud, (20, 20))

        pygame.display.flip()

if __name__ == "__main__":
    main()
