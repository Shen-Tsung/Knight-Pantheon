local options = {}

local btn = {}
local border = {}
local musicPolz = {}
local musicBtn = {}
local soundPolz = {}
local soundBtn = {}

local timer

local icon
local game, soundTab, credits
local gameSleep, soundSleep, creditsSleep

function options:load()
	icon = love.graphics.newImage("assets/ui/optionsIcon.png")
	game = love.graphics.newImage("assets/ui/tabGameActive.png")
	soundTab = love.graphics.newImage("assets/ui/tabSoundActive.png")
	credits = love.graphics.newImage("assets/ui/tabCreditsActive.png")
	gameSleep = love.graphics.newImage("assets/ui/tabGameSleep.png")
	soundSleep = love.graphics.newImage("assets/ui/tabSoundSleep.png")
	creditsSleep = love.graphics.newImage("assets/ui/tabCreditsSleep.png")
end	

function options:whenAdded()
	timer = 0
	
	btn.back = {}
	btn.back.color = {1, 1, 1}
	btn.back.x = 150
	btn.back.y = HEIGHT / 2 - 40
	btn.back.w = 150
	btn.back.h = 80
	btn.back.angle = -math.rad(180)
	btn.back.angleB = -math.rad(180)
	btn.back.target = math.rad(0)
	btn.back.speed = 9
	btn.back.speedB = 8.5
	btn.back.press = false
	
	border.x = 1300
	border.y = -300
	border.w = 850
	border.h = 600
	border.tab = {}
	border.tab.x = border.x + border.w * 5
	border.tab.w = border.w / 6
	border.tab.h = border.h / 3
	border.tab.gameY = border.y
	border.tab.soundY = border.y + border.tab.h
	border.tab.creditsY = border.y + border.tab.h * 2
	border.tab.game = false
	border.tab.sound = true
	border.tab.credits = false
	
	musicPolz.border = {}
	musicPolz.line = {}
	musicPolz.border.x = border.x + 50
	musicPolz.border.y = border.y + 70
	musicPolz.border.w = 300
	musicPolz.border.h = 60
	musicPolz.line.w = (musicVolume * 100) * 3
	musicPolz.line.h = musicPolz.border.h
	musicPolz.text = "Музыка"
	musicPolz.percent = tostring(musicPolz.line.w / 3) .. "%"
	
	musicBtn = {}
	musicBtn.x = musicPolz.border.x
	musicBtn.y = musicPolz.border.y + 100
	musicBtn.w = 50
	musicBtn.h = 50
	if musicVolume == 0 then
	    musicBtn.text = "Включить музыку"
	    musicBtn.status = "fill"
	else
		musicBtn.text = "Выключить музыку"
	    musicBtn.status = "line"
	end	
	musicBtn.color = {1, 1, 1}
	
	soundPolz.border = {}
	soundPolz.line = {}
	soundPolz.border.x = border.x + 50
	soundPolz.border.y = border.y + 300
	soundPolz.border.w = 300
	soundPolz.border.h = 60
	soundPolz.line.w = (soundVolume * 100) * 3
	soundPolz.line.h = soundPolz.border.h
	soundPolz.text = "Звуки"
	soundPolz.percent = tostring(soundPolz.line.w / 3) .. "%"
	
	soundBtn = {}
	soundBtn.x = soundPolz.border.x
	soundBtn.y = soundPolz.border.y + 100
	soundBtn.w = 50
	soundBtn.h = 50
	if soundVolume == 0 then
	    soundBtn.text = "Включить звуки"
	    soundBtn.status = "fill"
	else
		soundBtn.text = "Выключить звуки"
	    soundBtn.status = "line"
	end	
	soundBtn.color = {1, 1, 1}
	
	textBtn = {}
	textBtn.x = border.x + 50
	textBtn.y = border.y + 50
	textBtn.w = 120
	textBtn.h = 80
	textBtn.text = "Обычный"
end

function options:update(dt)
	btn.back.angle = btn.back.angle + (btn.back.target - btn.back.angle) * btn.back.speed * dt
	btn.back.angleB = btn.back.angleB + (btn.back.target - btn.back.angleB) * btn.back.speedB * dt
	
	if border.x > 360 and not btn.back.press then
	    border.x = border.x - border.x * 6 * dt
		musicPolz.border.x = border.x + 50
		musicBtn.x = musicPolz.border.x
		soundPolz.border.x = border.x + 50
		soundBtn.x = soundPolz.border.x
		border.tab.x = border.x + border.tab.w * 5
	end
	
	
	if btn.back.press then
		timer = timer + dt
		btn.back.target = math.rad(180)
		border.x = border.x + border.x * 6 * dt
		border.tab.x = border.x + border.tab.w * 5
		musicPolz.border.x = border.x + 50
		musicBtn.x = musicPolz.border.x
		soundPolz.border.x = border.x + 50
		soundBtn.x = soundPolz.border.x
		if timer > 0.3 then
			scene:clearStack()
			scene:push("menu")
		end
	end		
end

function options:draw()
    love.graphics.setBackgroundColor(0, 0, 0)
	
	love.graphics.translate(0, HEIGHT / 2)
	
	love.graphics.draw(icon, -50, -50, 0, 7, 7)
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.circle("line", 0, 0, 100)
	
	love.graphics.push()
	love.graphics.rotate(btn.back.angleB)
	drawButton("Назад", btn.back.x, btn.back.y - HEIGHT / 2, btn.back.w, btn.back.h, {0.5, 0.5, 0.5}, {0.5, 0.5, 0.5})
	love.graphics.pop()
	love.graphics.push()
	love.graphics.rotate(btn.back.angle)
	drawButton("Назад", btn.back.x, btn.back.y - HEIGHT / 2, btn.back.w, btn.back.h, btn.back.color)
	love.graphics.pop()
	
	love.graphics.rectangle("line", border.x, border.y, border.w, border.h)
	
	love.graphics.setColor(0.5, 0.5, 0.5)
	
    love.graphics.rectangle("line", border.tab.x, border.tab.gameY, border.tab.w, border.tab.h)
	love.graphics.draw(gameSleep, border.tab.x + 15, border.tab.gameY + 40, 0, 7, 7)
	
    love.graphics.rectangle("line", border.tab.x, border.tab.soundY, border.tab.w, border.tab.h)
	love.graphics.draw(soundSleep, border.tab.x + 15, border.tab.soundY + 40, 0, 7, 7)
	
    love.graphics.rectangle("line", border.tab.x, border.tab.creditsY, border.tab.w, border.tab.h)
	love.graphics.draw(creditsSleep, border.tab.x + 15, border.tab.creditsY + 40, 0, 7, 7)
	
	love.graphics.setColor(1, 1, 1)
	
	if border.tab.game then
		love.graphics.rectangle("line", border.tab.x, border.tab.gameY, border.tab.w, border.tab.h)
		love.graphics.draw(game, border.tab.x + 15, border.tab.gameY + 40, 0, 7, 7)
	end
		
	if border.tab.sound then
		love.graphics.rectangle("line", border.tab.x, border.tab.soundY, border.tab.w, border.tab.h)
		love.graphics.draw(soundTab, border.tab.x + 15, border.tab.soundY + 40, 0, 7, 7)
		
		love.graphics.print(musicPolz.text, musicPolz.border.x + 10, musicPolz.border.y - 50)
	    love.graphics.rectangle("line", musicPolz.border.x, musicPolz.border.y, musicPolz.border.w, musicPolz.border.h)
	    love.graphics.rectangle("fill", musicPolz.border.x, musicPolz.border.y, musicPolz.line.w, musicPolz.line.h)
	    love.graphics.print(musicPolz.percent, musicPolz.border.x + 310, musicPolz.border.y + 12)
		
		love.graphics.setColor(musicBtn.color)
		love.graphics.rectangle(musicBtn.status, musicBtn.x, musicBtn.y, musicBtn.w, musicBtn.h)
		love.graphics.print(musicBtn.text, musicBtn.x + 60, musicBtn.y + 10)
	    
		love.graphics.setColor(1, 1, 1)
	    love.graphics.print(soundPolz.text, soundPolz.border.x + 10, soundPolz.border.y - 50)
	    love.graphics.rectangle("line", soundPolz.border.x, soundPolz.border.y, soundPolz.border.w, soundPolz.border.h)
	    love.graphics.rectangle("fill", soundPolz.border.x, soundPolz.border.y, soundPolz.line.w, soundPolz.line.h)
	    love.graphics.print(soundPolz.percent, soundPolz.border.x + 310, soundPolz.border.y + 12)
		
		love.graphics.setColor(soundBtn.color)
		love.graphics.rectangle(soundBtn.status, soundBtn.x, soundBtn.y, soundBtn.w, soundBtn.h)
		love.graphics.print(soundBtn.text, soundBtn.x + 60, soundBtn.y + 10)
		love.graphics.setColor(1, 1, 1)
	end
	
	if border.tab.credits then
		love.graphics.rectangle("line", border.tab.x, border.tab.creditsY, border.tab.w, border.tab.h)
		love.graphics.draw(credits, border.tab.x + 15, border.tab.creditsY + 40, 0, 7, 7)
		
		love.graphics.print("Автор игры :   Шпундель\nТестер :           Энсгис кис кис\n\n\n\nЭта игра - фанатское произведение,\nи не является коммерческим продуктом.", border.x + 50, border.y + 40)
		love.graphics.print("Made with löve...  powered by Löve2D", border.x + 140, border.y + 525)
	end	
	
	love.graphics.origin()
end

function options:touchpressed(id, x, y)
	if zone(btn.back.x, btn.back.y, btn.back.w, btn.back.h, x, y) then
		btn.back.color = {0.5, 0.5, 0.5}
    elseif zone(musicBtn.x, musicBtn.y + HEIGHT / 2, musicBtn.w, musicBtn.h, x, y) then
	    musicBtn.color = {0.5, 0.5, 0.5}
	elseif zone(soundBtn.x, soundBtn.y + HEIGHT / 2, soundBtn.w, soundBtn.h, x, y) then
		soundBtn.color = {0.5, 0.5, 0.5}
	end
	
	if zone(musicPolz.border.x, musicPolz.border.y + HEIGHT / 2, musicPolz.border.w, musicPolz.border.h, x, y) then
		if x < 415 then
		    musicPolz.line.w = 0
			musicBtn.status = "fill"
		    musicBtn.text = "Включить музыку"
		elseif x > 685 then
			musicPolz.line.w = 300
			musicBtn.status = "line"
		    musicBtn.text = "Выключить музыку"
		else
			musicPolz.line.w = x - 400
			musicBtn.status = "line"
		    musicBtn.text = "Выключить музыку"
		end
		musicPolz.percent = tostring(math.floor(musicPolz.line.w / 3)) .. "%"
		musicVolume = (math.floor(musicPolz.line.w / 3)) / 100
		music.menu:setVolume((math.floor(musicPolz.line.w / 3)) / 100)
	end
	
	if zone(soundPolz.border.x, soundPolz.border.y + HEIGHT / 2, soundPolz.border.w, soundPolz.border.h, x, y) then
		if x < 415 then
		    soundPolz.line.w = 0
			soundBtn.status = "fill"
		    soundBtn.text = "Включить звуки"
		elseif x > 685 then
			soundPolz.line.w = 300
			soundBtn.status = "line"
		    soundBtn.text = "Выключить звуки"
		else
			soundPolz.line.w = x - 400
			soundBtn.status = "line"
		    soundBtn.text = "Выключить звуки"
		end
		soundPolz.percent = tostring(math.floor(soundPolz.line.w / 3)) .. "%"
		soundVolume = (math.floor(soundPolz.line.w / 3)) / 100
	end	
end

function options:touchmoved(id, x, y)
	if zone(musicPolz.border.x, musicPolz.border.y + HEIGHT / 2, musicPolz.border.w, musicPolz.border.h, x, y) then
		if x < 415 then
		    musicPolz.line.w = 0
			musicBtn.status = "fill"
		    musicBtn.text = "Включить музыку"
		elseif x > 685 then
			musicPolz.line.w = 300
			musicBtn.status = "line"
		    musicBtn.text = "Выключить музыку"
		else
			musicPolz.line.w = x - 400
			musicBtn.status = "line"
		    musicBtn.text = "Выключить музыку"
		end
		musicPolz.percent = tostring(math.floor(musicPolz.line.w / 3)) .. "%"
		musicVolume = (math.floor(musicPolz.line.w / 3)) / 100
		music.menu:setVolume((math.floor(musicPolz.line.w / 3)) / 100)
	end
	
	if zone(soundPolz.border.x, soundPolz.border.y + HEIGHT / 2, soundPolz.border.w, soundPolz.border.h, x, y) then
		if x < 415 then
		    soundPolz.line.w = 0
			soundBtn.status = "fill"
		    soundBtn.text = "Включить звуки"
		elseif x > 685 then
			soundPolz.line.w = 300
			soundBtn.status = "line"
		    soundBtn.text = "Выключить звуки"
		else
			soundPolz.line.w = x - 400
			soundBtn.status = "line"
		    soundBtn.text = "Выключить звуки"
		end
		soundPolz.percent = tostring(math.floor(soundPolz.line.w / 3)) .. "%"
		soundVolume = (math.floor(soundPolz.line.w / 3)) / 100
	end
end	

function options:touchreleased(id, x, y)
	if zone(btn.back.x, btn.back.y, btn.back.w, btn.back.h, x, y) then
		btn.back.color = {1, 1, 1}
		btn.back.press = true
		playSound("select")
    elseif zone(border.tab.x, border.tab.gameY + HEIGHT / 2, border.tab.w, border.tab.h, x, y) then
		border.tab.sound = false
		border.tab.credits = false
		border.tab.game = true
		playSound("menuMove")
	elseif zone(border.tab.x, border.tab.soundY + HEIGHT / 2, border.tab.w, border.tab.h, x, y) then
		border.tab.game = false
		border.tab.credits = false
		border.tab.sound = true
		playSound("menuMove")
	elseif zone(border.tab.x, border.tab.creditsY + HEIGHT / 2, border.tab.w, border.tab.h, x, y) then
		border.tab.game = false
		border.tab.sound = false
		border.tab.credits = true
		playSound("menuMove")
	elseif zone(musicBtn.x, musicBtn.y + HEIGHT / 2, musicBtn.w, musicBtn.h, x, y) then
	    musicBtn.color = {1, 1, 1}
		if musicBtn.status == "line" then
			musicPolz.line.w = 0
			musicVolume = 0
			musicPolz.percent = tostring(math.floor(musicPolz.line.w / 3)) .. "%"
			music.menu:setVolume(0)
		    musicBtn.status = "fill"
		    musicBtn.text = "Включить музыку"
		else
			musicPolz.line.w = 300
			musicVolume = 1
			musicPolz.percent = tostring(math.floor(musicPolz.line.w / 3)) .. "%"
			music.menu:setVolume(1)
			musicBtn.status = "line"
			musicBtn.text = "Выключить музыку"
		end		
	elseif zone(soundBtn.x, soundBtn.y + HEIGHT / 2, soundBtn.w, soundBtn.h, x, y) then
		soundBtn.color = {1, 1, 1}
		if soundBtn.status == "line" then
			soundPolz.line.w = 0
			soundVolume = 0
			soundPolz.percent = tostring(math.floor(soundPolz.line.w / 3)) .. "%"
		    soundBtn.status = "fill"
		    soundBtn.text = "Включить звуки"
		else
			soundPolz.line.w = 300
			soundVolume = 1
			soundPolz.percent = tostring(math.floor(soundPolz.line.w / 3)) .. "%"
			soundBtn.status = "line"
			soundBtn.text = "Выключить звуки"
		end	
	end
end

return options