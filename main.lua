io.stdout:setvbuf('no')
--variables
local Lander = {}
local Land = {}

Lander.x = 0
Lander.y = 0
Lander.angle = 270
Lander.vx = 0
Lander.vy = 0
Lander.speed = 3
Lander.engineIsOn = false
Lander.landerIsDestroy = false
Lander.img = love.graphics.newImage("images/ship.png")
Lander.imgEngine = love.graphics.newImage("images/engine.png")

Land.sol = love.graphics.newImage("images/sol.png")
Land.mur = love.graphics.newImage("images/mur.png")
Land.ciel = love.graphics.newImage("images/ciel.png")

draw = love.graphics.draw
touche = love.keyboard.isDown

function love.load()
  largeur = love.graphics.getWidth()--recupere la taille de la fenetre de jau
  hauteur = love.graphics.getHeight()--recupere la taille de la fenetre de jau

  Lander.x = largeur/2--place le vaisseau aui milieu
  Lander.y = hauteur/2--place le vaisseau aui milieu
end

function love.update(dt)    
  --utilisation des touche gauche droite et haut
  if touche("right") then
    Lander.angle = Lander.angle + (90 * dt)
    if Lander.angle > 360 then Lander.angle = 0 end
  end
  
  if touche("left") then
    Lander.angle = Lander.angle - (90 * dt)
    if Lander.angle < 0 then Lander.angle = 360 end
  end
  
  if touche("up") then
    Lander.engineOn = true
    --inertie
    local angle_radian = math.rad(Lander.angle)
    local force_x = math.cos(angle_radian) * (Lander.speed * dt)
    local force_y = math.sin(angle_radian) * (Lander.speed * dt)
    if math.abs(force_x) < 0.001 then force_x = 0 end
    if math.abs(force_y) < 0.001 then force_y = 0 end
    Lander.vx = Lander.vx + force_x
    Lander.vy = Lander.vy + force_y
  else
    Lander.engineOn = false
  end

  Lander.vy = Lander.vy + (0.6 * dt) --simulation de la gravitee

  --limitation de la vitesse 
  if math.abs(Lander.vx) > 1 then
    if Lander.vx > 0 then
      Lander.vx = 1
    else
      Lander.vx = -1
    end
  end
  if math.abs(Lander.vy) > 1 then
    if Lander.vy > 0 then
      Lander.vy = 1
    else
      Lander.vy = -1
    end
  end
  --empeche de sortir de l ecran et detruit le vaisseau si on est trop rapide a l aterisage

  if Lander.y > 585 then
    if Lander.vy > 0.4 then
      Lander.landerIsDestroy = true
    else
      Lander.y = 585
      Lander.vx = 0
      Lander.vy = 0
    end
  end

  --empeche de sortir de l ecran
  if Lander.x < 10 or Lander.x > largeur - 10 or Lander.y < 10 then
    Lander.landerIsDestroy = true
  end

  Lander.x = Lander.x + Lander.vx
  Lander.y = Lander.y + Lander.vy
end

function love.draw()
  --afffiche le sol et les murs
  draw(Land.ciel, 0, 0)
  draw(Land.mur, 0, 0)
  draw(Land.mur, 790, 0)
  draw(Land.sol, 0, 595)
  
  if Lander.landerIsDestroy == false then
    draw(Lander.img, Lander.x, Lander.y, 
      math.rad(Lander.angle), 1, 1, Lander.img:getWidth()/2, Lander.img:getHeight()/2)
  else
    love.graphics.print("perdu", 0, 0, 0, 10, 10)
  end

  if Lander.engineOn == true and Lander.landerIsDestroy == false then
    draw(Lander.imgEngine, Lander.x, Lander.y, 
      math.rad(Lander.angle), 1, 1, Lander.imgEngine:getWidth()/2, Lander.imgEngine:getHeight()/2)
  end
end