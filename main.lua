scene = require "libs/sceneMan"
push = require "libs/push"
tA = require "libs/textAnim"

music = {}
musicVolume = 1
sound = {}
soundVolume = 1

function playMusic(name)
	local current = music[name]
	if current then
		current:setVolume(musicVolume)
		current:play()
	end
end

function playSound(name)
	local current = sound[name]
	if current then
		current:setVolume(soundVolume)
		current:play()
	end
end

function drawButton(text, x, y, w, h, borderColor, textColor)
    if borderColor == nil then
		love.graphics.setColor(1, 1, 1)
	else
		love.graphics.setColor(borderColor[1], borderColor[2], borderColor[3])
	end	
    love.graphics.rectangle("line", x, y, w, h)
	
	if textColor == nil then
		love.graphics.setColor(1, 1, 1)
	else	
        love.graphics.setColor(textColor[1], textColor[2], textColor[3])
	end
    local font = love.graphics.getFont()
    local textX = x + (w - font:getWidth(text)) / 2
    local textY = y + (h - font:getHeight()) / 2
    
    love.graphics.print(text, textX, textY)
end

WIDTH, HEIGHT = 1280, 720
winWidth, winHeight = 0, 0

function zone(x, y, w, h, xx, yy)
    return xx > x and xx < x + w and
           yy > y and yy < y + h
end

function love.load()
	music.menu = love.audio.newSource("assets/music/everHigher.mp3", "stream")
	music.menu:setLooping(true)
	
	sound.select = love.audio.newSource("assets/sound/select.wav", "static")
	sound.menuMove = love.audio.newSource("assets/sound/menuMove.wav", "static")
	
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	winWidth, winHeight = love.graphics.getDimensions()
    push:setupScreen(WIDTH, HEIGHT, winWidth, winHeight, {
        fullscreen = true,
        resizable = false,
        pixelperfect = false,
        highdpi = false
    })
	
	title = love.graphics.newFont("assets/font/title.ttf", 64)
	regular = love.graphics.newFont("assets/font/regular.ttf", 40)
	regularMid = love.graphics.newFont("assets/font/regular.ttf", 64)
	love.graphics.setFont(regular)
	
	local intro = require "scenes/intro"
    local menu = require "scenes/menu"
    local options = require "scenes/options"
	
    scene:newScene("intro", intro)
    scene:newScene("menu", menu)
    scene:newScene("options", options)
    
    scene:push("intro")
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    scene:event("update", dt)
end

function love.draw()
    push:start()
	
	love.graphics.setLineWidth(4)
    scene:event("draw")
	
	--love.graphics.setLineWidth(4)
	--love.graphics.rectangle("line", 0, 0, WIDTH, HEIGHT)
	--love.graphics.setLineWidth(2)
	
    push:finish()
end

function love.touchpressed(id, x, y)
    local success, tx, ty = pcall(push.toGame, push, x, y)
    if success and tx and ty then
        scene:event("touchpressed", id, tx, ty)
    else
        scene:event("touchpressed", id, -1, -1)
    end
    touchX, touchY = x, y
end

function love.touchreleased(id, x, y)
    local success, tx, ty = pcall(push.toGame, push, x, y)
    if success and tx and ty then
        scene:event("touchreleased", id, tx, ty)
    else
        scene:event("touchreleased", id, -1, -1)
    end
    touchX, touchY = x, y
end

function love.touchmoved(id, x, y)
    local success, tx, ty = pcall(push.toGame, push, x, y)
    if success and tx and ty then
        scene:event("touchmoved", id, tx, ty)
    else
        scene:event("touchmoved", id, -1, -1)
    end
    touchX, touchY = x, y
end