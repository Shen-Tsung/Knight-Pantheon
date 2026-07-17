local menu = {}

--библиотеки
local tA = require "data/libs/textAnim"
local f = require "main"

--переменные
local menuIcon, quitIcon

local btn = {}

local titleY = {}
local titleX
local titleTime
local titlePng = {}

local timer
local touch = {}
local fade

local font
local suring
local suringText

function menu:clean()
	tA = nil
	f = nil
	menuIcon = nil
	quitIcon = nil
	btn = nil
	titleY = nil
	titleX = nil
	titleTime = nil
	titlePng = nil
	timer = nil
	touch = nil
	fade = nil
	font = nil
	suring = nil
	suringText = nil
end

function menu:load()
	menuIcon = love.graphics.newImage("data/menu/menuIcon.png")
	quitIcon = love.graphics.newImage("data/menu/quitIcon.png")
	titlePng.icon = love.graphics.newImage("data/menu/title.png")
	
	font = love.graphics.getFont()
	
	fade = 1
end	

function menu:whenAdded()
	-- Загрузка аудио и сцен
	file.audioLoad("menu", "data/menu/everHigher.mp3", "music")
	file.audioLoad("select", "data/assets/sound/select.wav", "sound")
	file.audioLoad("bip", "data/assets/sound/menuMove.wav", "sound")
	
	file.sceneLoad("play", "data.menu.play")
	file.sceneLoad("options", "data/menu/options")
	
	langData = json.decode(love.filesystem.read("langData.json"))
    saveData = json.decode(love.filesystem.read("saveData.json"))
    currentLang = saveData.options.currentLang

	playMusic("menu")
	
	timer = 0
	
	titleY.a = 0
	titleY.b = 0
	titleY.c = 0
	titleTime = 0
	titleX = WIDTH
	
	titlePng.x = titleX
	titlePng.y = titleY.a
	titlePng.size = 5.2
	
    btn.play = {}
	btn.play.color = {1, 1, 1}
    btn.play.x = 100
    btn.play.y = HEIGHT / 2 - 105
    btn.play.w = 110
    btn.play.h = 55
	btn.play.angle = -math.rad(180)
	btn.play.angleB = -math.rad(180)
	btn.play.target = math.rad(0)
	btn.play.speed = 6
	btn.play.speedB = 5.5
	btn.play.press = false
	
	btn.options = {}
	btn.options.color = {1, 1, 1}
	btn.options.x = btn.play.x
	btn.options.y = btn.play.y + 80
	btn.options.w = 110
	btn.options.h = 55
	btn.options.angle = -math.rad(180)
	btn.options.angleB = -math.rad(180)
	btn.options.target = math.rad(0)
	btn.options.speed = 7
	btn.options.speedB = 6.5
	btn.options.press = false
	
	btn.quit = {}
	btn.quit.color = {1, 1, 1}
	btn.quit.x = btn.options.x
	btn.quit.y = btn.options.y + 80
	btn.quit.w = 110
	btn.quit.h = 55
	btn.quit.angle = -math.rad(180)
	btn.quit.angleB = -math.rad(180)
	btn.quit.target = math.rad(0)
	btn.quit.speed = 9
	btn.quit.speedB = 8.5
	btn.quit.press = false
	
	btn.yes = {}
	btn.yes.color = {1, 1, 1}
    btn.yes.x = 100
    btn.yes.y = HEIGHT / 2 - 15
    btn.yes.w = 70
    btn.yes.h = 35
	btn.yes.angle = -math.rad(180)
	btn.yes.angleB = -math.rad(180)
	btn.yes.target = -math.rad(180)
	btn.yes.speed = 7
	btn.yes.speedB = 6.5
	btn.yes.press = false
	
	btn.no = {}
	btn.no.color = {1, 1, 1}
	btn.no.x = btn.yes.x + 80
	btn.no.y = btn.yes.y
	btn.no.w = 70
	btn.no.h = 35
	btn.no.angle = -math.rad(180)
	btn.no.angleB = -math.rad(180)
	btn.no.target = -math.rad(180)
	btn.no.speed = 7
	btn.no.speedB = 6.5
	btn.no.press = false
	
	suringText = ""
	suring = tA.new(suringText, 0.05, 150, -10)
end

function menu:update(dt)
	suring:setPosition(btn.yes.x + (btn.no.x + btn.no.w - font:getWidth(suringText)) / 2 - 70, 35)
	suring:update(dt)
	
	if fade > 0 then
	    fade = fade - 1 * dt
	end	
	
	if titleX > WIDTH - 300 and not btn.options.press and not btn.play.press then
	    titleX = titleX - titleX * 6 * dt
		titlePng.x = titleX
	end	
	
	titleTime = titleTime + dt
	titleY.a = math.sin(titleTime * 2) * 20
	titleY.b = math.sin(titleTime * 2 - 0.3) * 20
	titleY.c = math.sin(titleTime * 2 - 0.6) * 20
	titlePng.y = titleY.a
	
    btn.play.angle = btn.play.angle + (btn.play.target - btn.play.angle) * btn.play.speed * dt
	btn.play.angleB = btn.play.angleB + (btn.play.target - btn.play.angleB) * btn.play.speedB * dt
	
	btn.options.angle = btn.options.angle + (btn.options.target - btn.options.angle) * btn.options.speed * dt
	btn.options.angleB = btn.options.angleB + (btn.options.target - btn.options.angleB) * btn.options.speedB * dt
	
	btn.quit.angle = btn.quit.angle + (btn.quit.target - btn.quit.angle) * btn.quit.speed * dt
	btn.quit.angleB = btn.quit.angleB + (btn.quit.target - btn.quit.angleB) * btn.quit.speedB * dt
	
	btn.yes.angle = btn.yes.angle + (btn.yes.target - btn.yes.angle) * btn.yes.speed * dt
	btn.yes.angleB = btn.yes.angleB + (btn.yes.target - btn.yes.angleB) * btn.yes.speedB * dt
	
	btn.no.angle = btn.no.angle + (btn.no.target - btn.no.angle) * btn.no.speed * dt
	btn.no.angleB = btn.no.angleB + (btn.no.target - btn.no.angleB) * btn.no.speedB * dt
	
	if btn.play.press then
		timer = timer + dt
		btn.play.target = math.rad(180)
		btn.options.target = math.rad(180)
		btn.quit.target = math.rad(180)
		titleX = titleX + titleX * 6 * dt
		titlePng.x = titleX
		if timer > 0.3 then
			touch = {}
			scene:pop("menu")
			scene:push("play")
			btn.play.press = false
		end
	end		
	
	if btn.options.press then
		timer = timer + dt
		btn.play.target = math.rad(180)
		btn.options.target = math.rad(180)
		btn.quit.target = math.rad(180)
		titleX = titleX + titleX * 6 * dt
		titlePng.x = titleX
		if timer > 0.3 then
			touch = {}
			scene:pop("menu")
			scene:push("options")
		end
	end
	
	if btn.quit.press then
		timer = timer + dt
		btn.play.target = math.rad(180)
		btn.options.target = math.rad(180)
		btn.quit.target = math.rad(180)
		if timer > 0.3 then
			btn.yes.target = math.rad(0)
			btn.no.target = math.rad(0)
		end	
	end
	
	if btn.yes.press then
		scene:clearStack()
		love.event.quit()
	end
	
	if btn.no.press then
		timer = timer + dt
		btn.yes.target = math.rad(180)
		btn.no.target = math.rad(180)
		if timer > 0.3 then
			btn.play.angle = -math.rad(180)
		    btn.play.angleB = -math.rad(180)
	    	btn.options.angle = -math.rad(180)
    		btn.options.angleB = -math.rad(180)
    		btn.quit.angle = -math.rad(180)
    		btn.quit.angleB = -math.rad(180)
			
			btn.play.target = math.rad(0)
			btn.options.target = math.rad(0)
			btn.quit.target = math.rad(0)
			
			btn.yes.angle = -math.rad(180)
			btn.yes.angleB = -math.rad(180)
			btn.no.angle = -math.rad(180)
			btn.no.angleB = -math.rad(180)
			
			btn.yes.target = -math.rad(180)
			btn.no.target = -math.rad(180)
			
			btn.quit.press = false
			btn.no.press = false
		end	
	end
end

function menu:drawUI()
	love.graphics.setBackgroundColor(0.2, 0.1, 0.5)
	
	love.graphics.setColor(1, 1, 1)
	
	love.graphics.translate(0, HEIGHT / 2)
	
	love.graphics.setFont(title)
	love.graphics.setColor(0.3, 0.3, 0.3)
	love.graphics.print("Knight Pantheon", titleX, titleY.c - 30)
	love.graphics.setColor(0.6, 0.6, 0.6)
	love.graphics.print("Knight Pantheon", titleX, titleY.b - 30)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Knight Pantheon", titleX, titleY.a - 30)
	
	love.graphics.draw(titlePng.icon, titlePng.x, titlePng.y, 0, titlePng.size, titlePng.size)
	
	love.graphics.setFont(regularBig)
	suring:draw()
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", 0, 0, 65)
	love.graphics.setColor(1, 1, 1)
	love.graphics.circle("line", 0, 0, 65)
	
	if btn.quit.press then
		love.graphics.draw(quitIcon, -35, -40, 0, 5, 5)
	else	
	    love.graphics.draw(menuIcon, -35, -40, 0, 5, 5)
	end
	
	love.graphics.setFont(regular)
	love.graphics.push()
	love.graphics.rotate(btn.play.angleB)
	drawButton(t("menu", "play"), btn.play.x, btn.play.y - HEIGHT / 2, btn.play.w, btn.play.h, {0.5, 0.5, 0.5}, {0.5, 0.5, 0.5})
	love.graphics.pop()
	love.graphics.push()
	love.graphics.rotate(btn.play.angle)
	drawButton(t("menu", "play"), btn.play.x, btn.play.y - HEIGHT / 2, btn.play.w, btn.play.h, btn.play.color)
	love.graphics.pop()
	
	love.graphics.push()
	love.graphics.rotate(btn.options.angleB)
	drawButton(t("menu", "options"), btn.options.x, btn.options.y - HEIGHT / 2, btn.options.w, btn.options.h, {0.5, 0.5, 0.5}, {0.5, 0.5, 0.5})
	love.graphics.pop()
	love.graphics.push()
	love.graphics.rotate(btn.options.angle)
	drawButton(t("menu", "options"), btn.options.x, btn.options.y - HEIGHT / 2, btn.options.w, btn.options.h, btn.options.color)
	love.graphics.pop()
	
	love.graphics.push()
	love.graphics.rotate(btn.quit.angleB)
	drawButton(t("menu", "quit"), btn.quit.x, btn.quit.y - HEIGHT / 2, btn.quit.w, btn.quit.h, {0.5, 0.5, 0.5}, {0.5, 0.5, 0.5})
	love.graphics.pop()
	love.graphics.push()
	love.graphics.rotate(btn.quit.angle)
	drawButton(t("menu", "quit"), btn.quit.x, btn.quit.y - HEIGHT / 2, btn.quit.w, btn.quit.h, btn.quit.color)
	love.graphics.pop()
	
	
	love.graphics.push()
	love.graphics.rotate(btn.yes.angleB)
	drawButton(t("menu", "yes"), btn.yes.x, btn.yes.y - HEIGHT / 2, btn.yes.w, btn.yes.h, {0.5, 0.5, 0.5}, {0.5, 0.5, 0.5})
	love.graphics.pop()
	love.graphics.push()
	love.graphics.rotate(btn.yes.angle)
	drawButton(t("menu", "yes"), btn.yes.x, btn.yes.y - HEIGHT / 2, btn.yes.w, btn.yes.h, btn.yes.color)
	love.graphics.pop()
	
	love.graphics.push()
	love.graphics.rotate(btn.no.angleB)
	drawButton(t("menu", "no"), btn.no.x, btn.no.y - HEIGHT / 2, btn.no.w, btn.no.h, {0.5, 0.5, 0.5}, {0.5, 0.5, 0.5})
	love.graphics.pop()
	love.graphics.push()
	love.graphics.rotate(btn.no.angle)
	drawButton(t("menu", "no"), btn.no.x, btn.no.y - HEIGHT / 2, btn.no.w, btn.no.h, btn.no.color)
	love.graphics.pop()
	
	love.graphics.origin()
	
	love.graphics.setColor(0, 0, 0, fade)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)
end

function menu:touchpressed(id, x, y)
	if not btn.quit.press then
		if zone(btn.play.x, btn.play.y, btn.play.w, btn.play.h, x, y) then
			btn.play.color = {0.5, 0.5, 0.5}
			touch[id] = "play"
	    elseif zone(btn.options.x, btn.options.y, btn.options.w, btn.options.h, x, y) then
			btn.options.color = {0.5, 0.5, 0.5}
			touch[id] = "options"
	    elseif zone(btn.quit.x, btn.quit.y, btn.quit.w, btn.quit.h, x, y) then
			btn.quit.color = {0.5, 0.5, 0.5}
			touch[id] = "quit"
		end	
	elseif btn.quit.press then		
        if zone(btn.yes.x, btn.yes.y, btn.yes.w, btn.yes.h, x, y) then
		    btn.yes.color = {0.5, 0.5, 0.5}
			touch[id] = "yes"
	    elseif zone(btn.no.x, btn.no.y, btn.no.w, btn.no.h, x, y) then
		    btn.no.color = {0.5, 0.5, 0.5}
			touch[id] = "no"
	    end
	end			
end	

function menu:touchreleased(id, x, y)
    if not btn.quit.press then
	    if touch[id] == "play" then
		    btn.play.color = {1, 1, 1}
		    timer = 0
		    btn.play.press = true
			playSound("select")
	    elseif touch[id] == "options" then
		    btn.options.color = {1, 1, 1}
		    timer = 0
			btn.options.press = true
			playSound("select")
	    elseif touch[id] == "quit" then
		    btn.quit.color = {1, 1, 1}
		    timer = 0
		    btn.quit.press = true
			suringText = t("menu", "sure")
			suring:setText(suringText)
			playSound("select")
	    end	
	elseif btn.quit.press then	
        if touch[id] == "yes" then
		    btn.yes.color = {1, 1, 1}
		    timer = 0
		    btn.yes.press = true
			playSound("select")
	    elseif touch[id] == "no" then
		    btn.no.color = {1, 1, 1}
		    timer = 0
		    btn.no.press = true
			suringText = ""
			suring:setText(suringText)
			playSound("select")
	    end
	end
	
	touch[id] = nil	
end

return menu