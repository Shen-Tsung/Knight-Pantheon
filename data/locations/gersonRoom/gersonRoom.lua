local gr = {}

local f = require "main"

local out
local way

local camera = require "data/libs/camera"
local cam
local cx, cy
camStart, camEnd = 0, 0

local anim = require "data/libs/anim8"

local Kris = require "data/game/kris"
local kris

local input = require "data/game/input"

local room = {}
local wall = {}
local door
local fireplace
local waterFountain

local world

local c = json.decode(love.filesystem.read("data/locations/gersonRoom/gersonRoom_collision.json"))

function gr:clean()
	f = nil
	out = nil
	way = nil
	camera = nil
	cx = nil
	cy = nil
	anim = nil
	Kris = nil
	kris = nil
	input = nil
	room = nil
	wall = nil
	door = nil
	fireolace = nil
	waterfountain = nil
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
	room.png = love.graphics.newImage("data/locations/gersonRoom/gersonRoom.png")
	
	room.sprite = {}
	room.anim = {}
	
	room.sprite.main = love.graphics.newQuad(3, 3, 480, 600, room.png:getWidth(), room.png:getHeight())
	
	room.sprite.fireplace = {}
	room.sprite.fountain = {}
	room.sprite.lantern = {}
	room.sprite.smallLantern = {}
	
	quads(room.sprite.fireplace, room.png, 487, 3, 70, 34, 2, 3, 3)
	    table.remove(room.sprite.fireplace)
	quads(room.sprite.fountain, room.png, 487, 113, 48, 44, 2, 3, 3)
	quads(room.sprite.lantern, room.png, 705, 188, 15, 35, 2, 8, 1)
	quads(room.sprite.smallLantern, room.png, 705, 127, 66, 27, 2, 4, 2)
	
	room.anim.fireplace = anim.newAnimation(room.sprite.fireplace, 0.1)
	room.anim.fountain = anim.newAnimation(room.sprite.fountain, 0.15)
	room.anim.lantern = anim.newAnimation(room.sprite.lantern, 0.1)
	room.anim.smallLantern = anim.newAnimation(room.sprite.smallLantern, 0.1)
	
	file.sceneLoad("fightBg", "data/fight/fightBg")
	file.sceneLoad("fight", "data/fight/fight")
	file.sceneLoad("fightAttack", "data/fight/fightAttack")
	file.sceneLoad("fightAct", "data/fight/fightAct")
	file.sceneLoad("fightBox", "data/fight/fightBox")
	file.audioLoad("fight", "data/fight/rudeBuster.mp3", "music")
	file.audioLoad("fightAlt", "data/fight/rudeBusterBusted.mp3", "music")
	file.audioLoad("fightStart", "data/assets/sound/fightStart.wav", "sound")
	file.audioLoad("krisAttack", "data/assets/sound/krisAttack.wav", "sound")
	file.audioLoad("enemyAlert", "data/assets/sound/enemyAlert.wav", "sound")
	file.audioLoad("gameOver1", "data/assets/sound/gameOver1.wav", "sound")
	file.audioLoad("gameOver2", "data/assets/sound/gameOver2.wav", "sound")
	
	local menu = {
		menu = require "data.menu.menu",
		options = require "data.menu.options",
		play = require "data.menu.play",
		bg = require "data.menu.bg"
	}
	
	for i, v in ipairs(menu) do
		menu[i]:clean()
	end
end	

function gr:whenAdded(startX, startY)
	file.audioLoad("gr", "data/locations/gersonRoom/fireplace.mp3", "music")
	file.audioLoad("text", "data/assets/sound/text.wav", "sound")
	
	playMusic("gr")
	
	way = nil
	out = false
	fade = 1
	
	-- Стены
	world = hc.new(50)
	
	wall.a = hc.polygon(unpack(getCoords(c.a)))
	wall.b = hc.polygon(unpack(getCoords(c.b)))
	wall.c = hc.polygon(unpack(getCoords(c.c)))
	
	-- Объекты для взаимодействия
	door = hc.rectangle(460, 335, 145, 30)
	fireplace = hc.rectangle(465, 730, 140, 30)
	waterFountain = hc.rectangle(765, 335, 105, 30)
	
	--Игрок
	kris = Kris.new(startX, startY, wall)
	
	--Камера
	cam = camera()
	cam:lookAt(kris.x + 40 or 0, kris.y + 30 or 0)
	cx, cy = cam:position()
end

function gr:update(dt)
	if PAUSE then return end	
	
	room.anim.fireplace:update(dt)
	room.anim.fountain:update(dt)
	room.anim.lantern:update(dt)
	room.anim.smallLantern:update(dt)
	
	kris:update(dt)
	
	-- взаимодействия с объектами
	if door:collidesWith(kris.body) then
		talk = "grDoor"
	elseif fireplace:collidesWith(kris.body) then
		talk = "fireplace"
	elseif waterFountain:collidesWith(kris.body) then
		talk = "waterFountain"
	else	
		talk = nil
	end
	
	-- Затенение
	if not out and fade > 0 then
		fade = fade - dt * 3
	end
	
	-- Переходы между комнатами
	if out then
		fade = fade + dt * 3
		if fade >= 1 then
		    scene:pop("gr")
			scene:pop("input")
			if way == "gr1" then
				file.sceneLoad("gr1", "data.locations.gersonRoom.rightRoom")
				scene:push("gr1", 60, 240)
				scene:push("input")
			elseif way == "gr-1" then
				scene:push("fightBg", {"rudinn", "rudinn", "rudinn"})
				scene:push("input")
			end
		end
	end		
	
	-- Уход вправо и влево
	if kris.cx >= 1000 then
		out = true
		way = "gr1"
	elseif kris.cx <= 50 then
		out = true
		way = "gr-1"
	end	
	
	-- Камера и границы
	local minX = 70 + screenW / 2
	local maxX = 990 - screenW / 2
	local minY = 70 + screenH / 2
	local maxY = 1200 - screenH / 2
	
	local targetX = kris.x + 40
	local targetY = kris.y + 30
	
	targetX = math.max(minX, math.min(targetX, maxX))
	targetY = math.max(minY, math.min(targetY, maxY))
	
	cam:lookAt(targetX, targetY)
	cx, cy = cam:position()
end

function gr:draw()
	cam:attach()
	
	love.graphics.draw(room.png, room.sprite.main, 50, 50, 0, 2, 2)
	room.anim.fireplace:draw(room.png, 465, 665, 0, 2, 2)
	room.anim.fountain:draw(room.png, 772, 245, 0, 2, 2)
	room.anim.lantern:draw(room.png, 84, 177, 0, 2, 2)
	room.anim.lantern:draw(room.png, 84, 452, 0, 2, 2)
	room.anim.lantern:draw(room.png, 946, 177, 0, 2, 2)
	room.anim.lantern:draw(room.png, 946, 452, 0, 2, 2)
	room.anim.smallLantern:draw(room.png, 50, 50, 0, 2, 2)
	room.anim.smallLantern:draw(room.png, 1010, 50, 0, -2, 2)
	
	if hitboxes then
	    love.graphics.polygon("line", getCoords(c.a))
        love.graphics.polygon("line", getCoords(c.b))
        love.graphics.polygon("line", getCoords(c.c))
		
		love.graphics.rectangle("line", 460, 335, 145, 30)
	end
	
	kris:draw()
	
	cam:detach()
end


function gr:drawUI()
	love.graphics.setColor(0, 0, 0, fade)
	love.graphics.rectangle("fill", 0, 0, screenW, screenH)
end

return gr