local gr = {}

local out

local camera = require "data/libs/camera"
local cam
local cx, cy

local anim = require "data/libs/anim8"

local Kris = require "data/game/kris"
local kris

local Snake = require "data/chars/snake/snake"
local snake

local input = require "data/game/input"

local room = {}
local wall = {}

local world

local c = json.decode(love.filesystem.read("data/locations/gersonRoom/rightRoom_collision.json"))

function gr:clean()
	out = nil
	camera = nil
	cam = nil
	cx = nil
	cy = nil
	anim = nil
	Kris = nil
	kris = nil
	Snake = nil
	snake = nil
	input = nil
	room = nil
	wall = nil
	world = nil
	c = nil
end	

function getCoords(table)
	local coords = {}
	for i = 1, #table do
		coords[#coords + 1] = table[i].x
		coords[#coords + 1] = table[i].y
	end
	return coords
end

function gr:load()
	
end

function gr:whenAdded(startX, startY)
	playMusic("gersonRoom")
	
	out = false
	fade = 1
	
	-- Спрайты и анимация
	room.png = love.graphics.newImage("data/locations/gersonRoom/rightRoom.png")
	
	-- Стены
	world = hc.new(50)
	
	wall.a = hc.polygon(unpack(getCoords(c.a)))
	wall.b = hc.polygon(unpack(getCoords(c.b)))
	
	-- Игрок
	kris = Kris.new(startX, startY, wall)
	
	-- Нпс
	snake = Snake.new(600, 250, kris.body)
	
	-- Камера
	cam = camera()
	cx, cy = cam:position()
end

function gr:update(dt)
	if PAUSE then return end	
	
	kris:update(dt)
	snake:update(dt)
	
	if not out and fade > 0 then
		fade = fade - dt * 3
	end
	
	if out then
		fade = fade + dt * 3
		if fade >= 1 then
		    scene:pop("gr1")
			scene:pop("input")
		    scene:push("gr", 950, 950)
			scene:push("input")
		end
	end		
	
	if kris.cx <= 50 then
		out = true
	end
	
	-- Камера и границы
	local minX = 70 + screenW / 2
	local maxX = 900 - screenW / 2
	local minY = 100 + screenH / 2
	local maxY = 300 - screenH / 2
	
	local targetX = kris.x + 40
	local targetY = kris.y + 30
	
	targetX = math.max(minX, math.min(targetX, maxX))
	targetY = math.max(minY, math.min(targetY, maxY))
	
	cam:lookAt(targetX, targetY)
	cx, cy = cam:position()
end

function gr:draw()
	cam:attach()
	
	love.graphics.draw(room.png, 50, 50, 0, 2, 2)
	
	if kris.y < snake.y - 10 then
		kris:draw()
		snake:draw()
	else
		snake:draw()
		kris:draw()
	end
	
	if hitboxes then
	    love.graphics.polygon("line", getCoords(c.a))
        love.graphics.polygon("line", getCoords(c.b))
	end
	
	cam:detach()
end

function gr:drawUI()
	love.graphics.setColor(0, 0, 0, fade)
	love.graphics.rectangle("fill", 0, 0, screenW, screenH)
end		

return gr