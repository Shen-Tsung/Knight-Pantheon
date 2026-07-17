local play = {}

--библиотеки
local f = require "main"
local anim = require "data/libs/anim8"

--переменные
local sound

local btn = {}
local border = {}
local continue = {}
local window = {}
local newGame = {}

local timer
local touch = {}

local icon

local noisePng
local noise

function play:clean()
	f = nil
	anim = nil
	
	sound = nil
	
	btn = nil
	border = nil
	continue = nil
	window = nil
	newGame = nil	

	timer = nil
	touch = nil

	icon = nil

	noisePng = nil
	noise = nil
end	
	
function play:load()
	icon = love.graphics.newImage("data/menu/playIcon.png")
	noisePng = love.graphics.newImage("data/menu/noise.png")
	
	local noiseGrid = anim.newGrid(100, 100, noisePng:getWidth(), noisePng:getHeight())
	noise = anim.newAnimation(noiseGrid("1-3", 1), 0.1)
end	

function play:whenAdded()
	inputHide = false
	
	playMusic("menu")
	
	langData = json.decode(love.filesystem.read("langData.json"))
    saveData = json.decode(love.filesystem.read("saveData.json"))
    currentLang = saveData.options.currentLang

	timer = 0
	
	btn.back = {}
	btn.back.color = {1, 1, 1}
	btn.back.x = 100
	btn.back.y = HEIGHT / 2 - 30
	btn.back.w = 110
	btn.back.h = 55
	btn.back.angle = -math.rad(180)
	btn.back.angleB = -math.rad(180)
	btn.back.target = math.rad(0)
	btn.back.speed = 9
	btn.back.speedB = 8.5
	btn.back.press = false
	
	border.x = WIDTH + 425
	border.y = -150
	border.w = 200
	border.h = 300
	
	continue.w = border.w / 1.2
	continue.h = 60
	continue.x = border.x + (border.w - continue.w) / 2
	continue.y = border.y + 140
	continue.text = t("menu", "continue")
	continue.color = {1, 1, 1}
	
	window.x = continue.x
	window.y = continue.y - 130
	window.w = continue.w
	window.h = 130
	
	newGame.w = border.w / 1.2
	newGame.h = 60
	newGame.x = border.x + (border.w - newGame.w) / 2
	newGame.y = continue.y + continue.h + 25
	newGame.text = t("menu", "newGame")
	newGame.color = {1, 1, 1}
end

function play:update(dt)
	noise:update(dt)
	
	btn.back.angle = btn.back.angle + (btn.back.target - btn.back.angle) * btn.back.speed * dt
	btn.back.angleB = btn.back.angleB + (btn.back.target - btn.back.angleB) * btn.back.speedB * dt
	
	if border.x + border.w > WIDTH - 30 and not btn.back.press then
	    border.x = border.x - border.x * 5 * dt
		continue.x = border.x + (border.w - continue.w) / 2
		window.x = continue.x
		newGame.x = border.x + (border.w - newGame.w) / 2
	end
	
	
	if btn.back.press then
		timer = timer + dt
		btn.back.target = math.rad(180)
		border.x = border.x + border.x * 5 * dt
		continue.x = border.x + (border.w - continue.w) / 2
		window.x = continue.x
		newGame.x = border.x + (border.w - newGame.w) / 2
		if timer > 0.3 then
			touch = {}
			scene:pop("play")
			scene:push("menu")
		end
	end		
end

function play:drawUI()
    love.graphics.setBackgroundColor(0, 0, 0)
	
	love.graphics.translate(0, HEIGHT / 2)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", 0, 0, 65)
	love.graphics.setColor(1, 1, 1)
	love.graphics.circle("line", 0, 0, 65)
	
	love.graphics.draw(icon, -35, -40, 0, 5, 5)
	
	love.graphics.push()
	love.graphics.rotate(btn.back.angleB)
	drawButton(t("menu", "back"), btn.back.x, btn.back.y - HEIGHT / 2, btn.back.w, btn.back.h, {0.5, 0.5, 0.5}, {0.5, 0.5, 0.5})
	love.graphics.pop()
	love.graphics.push()
	love.graphics.rotate(btn.back.angle)
	drawButton(t("menu", "back"), btn.back.x, btn.back.y - HEIGHT / 2, btn.back.w, btn.back.h, btn.back.color)
	love.graphics.pop()
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", border.x, border.y, border.w, border.h)
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("line", border.x, border.y, border.w, border.h)
	
	noise:draw(noisePng, window.x, window.y, 0, 1.66, 1.66)
	love.graphics.rectangle("line", window.x, window.y, window.w, window.h)
	drawButton(continue.text, continue.x, continue.y, continue.w, continue.h, continue.color)
	drawButton(newGame.text, newGame.x, newGame.y, newGame.w, newGame.h, newGame.color)
	
	love.graphics.origin()
end

function play:touchpressed(id, x, y)
	if zone(btn.back.x, btn.back.y, btn.back.w, btn.back.h, x, y) then
		btn.back.color = {0.5, 0.5, 0.5}
		touch[id] = "back"
	elseif zone(continue.x, continue.y, continue.w, continue.h, x, y - HEIGHT / 2) then
		continue.color = {0.5, 0.5, 0.5}
		touch[id] = "continue"
	elseif zone(newGame.x, newGame.y, newGame.w, newGame.h, x, y - HEIGHT / 2) then
		newGame.color = {0.5, 0.5, 0.5}
		touch[id] = "newGame"
	end
end

function play:touchreleased(id, x, y)
	if touch[id] == "back" then
		btn.back.color = {1, 1, 1}
		btn.back.press = true
		playSound("select")
	elseif touch[id] == "continue" then
		continue.color = {1, 1, 1}
		playSound("select")
		music.menu:stop()
		scene:pop("play")
		scene:pop("bgMenu")
		
		file.sceneLoad("gr", "data/locations/gersonRoom/gersonRoom")
		file.sceneLoad("input", "data/game/input")
		file.sceneLoad("pause", "data/game/pause")
		file.sceneLoad("textBox", "data/game/textBox")
		file.sceneLoad("options", "data.menu.options")
		
		local kris = require "data/game/kris"
    	local input = require "data/game/input"
    	kris:setInput(input)
    	input:setKris(kris)
		
		scene:push("gr", 400, 750)
		scene:push("input")
		
		file.sceneClean("menu")
		file.sceneClean("play")
		file.sceneClean("bg")
		collectgarbage()
	elseif touch[id] == "newGame" then
		newGame.color = {1, 1, 1}
		playSound("select")
		music.menu:stop()
		scene:pop("play")
		scene:pop("bgMenu")
		
		file.sceneLoad("gr", "data/locations/gersonRoom/gersonRoom")
		file.sceneLoad("input", "data/game/input")
		file.sceneLoad("pause", "data/game/pause")
		file.sceneLoad("textBox", "data/game/textBox")
		file.sceneLoad("options", "data.menu.options")
		
		local kris = require "data/game/kris"
    	local input = require "data/game/input"
    	kris:setInput(input)
    	input:setKris(kris)
		
		scene:push("gr", 400, 750)
		scene:push("input")
		
		file.sceneClean("menu")
		file.sceneClean("play")
		file.sceneClean("bg")
		collectgarbage()
	end
	
	touch[id] = nil
end

return play