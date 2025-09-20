import pygame, sys, random, time, math
pygame.init()

WIDTH, HEIGHT = 1000, 650
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Flower Genetics – Unique Parents & Incomplete Dominance")
font = pygame.font.SysFont(None, 28)
clock = pygame.time.Clock()

#Genetics
def gametes(geno):
    # geno like "Rr Gg"
    a = geno.split()
    g1, g2 = a[0], a[1]
    return [x+y for x in g1 for y in g2]

def can_produce(p1, p2, child):
    target = child.replace(' ','')
    target_sorted = ''.join(sorted(target))
    for gA in gametes(p1):
        for gB in gametes(p2):
            combo = gA[0]+gB[0]+gA[1]+gB[1]
            if ''.join(sorted(combo)) == target_sorted:
                return True
    return False

def phenotype(geno):
    petal_gene, leaf_gene = geno.split()
    petal_gene = ''.join(sorted(petal_gene))
    if petal_gene == "RR":   petal = "Red"
    elif petal_gene == "rr": petal = "White"
    else:                    petal = "Pink"   # incomplete dominance
    leaf_gene = ''.join(sorted(leaf_gene))
    leaf = "Green" if "G" in leaf_gene else "Yellow"
    return petal, leaf

all_petal = ["RR","Rr","rR","rr"]
all_leaf  = ["GG","Gg","gG","gg"]

def random_genotype():
    return f"{random.choice(all_petal)} {random.choice(all_leaf)}"

#Round Generation
def unique_round():
    """
    Returns:
      child genotype,
      4 unique parent genotypes
    Guarantees: only ONE parent pair can produce child.
    """
    while True:
        p1, p2 = random_genotype(), random_genotype()
        if p1 == p2:
            continue
        # all possible children from p1,p2
        possibles = []
        for gA in gametes(p1):
            for gB in gametes(p2):
                c = gA[0]+gB[0]+" "+gA[1]+gB[1]
                possibles.append(c)
        child = random.choice(possibles)

        parents = {p1, p2}
        tries = 0
        while len(parents) < 4 and tries < 1000:
            g = random_genotype()
            if g in parents:
                tries += 1
                continue
            # ensure adding g won't create an alternate correct pair
            temp = list(parents) + [g]
            if not any(
                can_produce(a,b,child)
                for i,a in enumerate(temp)
                for j,b in enumerate(temp)
                if i<j and not({a,b}=={p1,p2})
            ):
                parents.add(g)
            tries += 1

        if len(parents) == 4:
            return child, list(parents)

#Drawing
def draw_flower(center, petal_color, leaf_color, size=60):
    cx, cy = center
    for i in range(6):
        ang = math.radians(i*60)
        x = cx + math.cos(ang)*size/2
        y = cy + math.sin(ang)*size/2
        rect = pygame.Rect(0,0,size//2,size)
        rect.center=(x,y)
        pygame.draw.ellipse(screen, petal_color, rect)
    pygame.draw.circle(screen,(255,200,0),(cx,cy),size//4)
    # leaves
    pygame.draw.ellipse(screen, leaf_color,
                        pygame.Rect(cx-size//2, cy+size//2, size//2, size//3))
    pygame.draw.ellipse(screen, leaf_color,
                        pygame.Rect(cx, cy+size//2, size//2, size//3))

def petal_rgb(name):
    return {
        "Red":   (255,0,0),
        "Pink":  (255,105,180),
        "White": (255,255,255)
    }[name]

def leaf_rgb(name):
    return (0,180,0) if name=="Green" else (190,190,50)

#Game State
score = 0
time_limit = 80
start_time = time.time()
child_geno, parents = unique_round()

# store solution pair
solution_pair = None
for i,a in enumerate(parents):
    for j,b in enumerate(parents):
        if i<j and can_produce(a,b,child_geno):
            solution_pair = {i,j}

selected = []
positions = [(200,400),(400,400),(600,400),(800,400)]
game_over = False

#Main Loop
while True:
    dt = clock.tick(30)
    screen.fill((60,140,60))
    remaining = max(0,int(time_limit - (time.time()-start_time)))

    for e in pygame.event.get():
        if e.type == pygame.QUIT:
            pygame.quit(); sys.exit()
        if e.type == pygame.MOUSEBUTTONDOWN and not game_over:
            mx,my = e.pos
            for i,(x,y) in enumerate(positions):
                if (x-60<mx<x+60 and y-60<my<y+60):
                    if i not in selected:
                        selected.append(i)
                    if len(selected)==2:
                        if set(selected)==solution_pair:
                            score += 1
                        # next round
                        child_geno, parents = unique_round()
                        # find solution pair
                        for a in range(4):
                            for b in range(a+1,4):
                                if can_produce(parents[a], parents[b], child_geno):
                                    solution_pair = {a,b}
                        selected=[]

    if remaining==0 and not game_over:
        game_over = True

    if game_over:
        txt = font.render(f"Game Over! Final Score: {score}", True, (255,255,255))
        screen.blit(txt,(WIDTH//2 - txt.get_width()//2, HEIGHT//2))
        pygame.display.flip()
        continue

    # Child
    ppetal, pleaf = phenotype(child_geno)
    title = font.render(
        f"Child: {child_geno} ({ppetal} petals, {pleaf} leaves)", True, (255,255,0))
    screen.blit(title,(WIDTH//2 - title.get_width()//2, 40))
    draw_flower((WIDTH//2,150), petal_rgb(ppetal), leaf_rgb(pleaf), 80)

    # Parents (all unique now)
    for i,(x,y) in enumerate(positions):
        g = parents[i]
        pet, leaf = phenotype(g)
        draw_flower((x,y), petal_rgb(pet), leaf_rgb(leaf), 60)
        label = font.render(g, True, (0,0,0))
        screen.blit(label,(x-label.get_width()//2, y+80))
        if i in selected:
            pygame.draw.circle(screen,(0,0,255),(x,y),70,4)

    # HUD
    screen.blit(font.render(f"Score: {score}", True, (255,255,255)), (20,20))
    screen.blit(font.render(f"Time: {remaining}", True, (255,255,255)),
                (WIDTH-150,20))

    pygame.display.flip()

