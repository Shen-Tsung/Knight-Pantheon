local options = {}

--библиотеки
local f = require "main"

--переменные
local btn = {}
local border = {}
local enBtn = {}
local ruBtn = {}
local langText = {}
local joystickBtn = {}
local buttonsBtn = {}
local inputText = {}
local musicPolz = {}
local musicBtn = {}
local soundPolz = {}
local soundBtn = {}

--системные переменные
local timer
local touch = {}

--изображения
local icon
local game, soundTab, credits
local gameSleep, soundSleep, creditsSleep

function options:clean()
	f = nil
	btn = nil
	border = nil
	enBtn = nil
	ruBtn = nil
	langText = nil
	joystickBtn = nil
	buttonsBtn = nil
	inputText = nil
	musicPolz = nil
	musicBtn = nil
	soundPolz = nil
	soundBtn = nil
	timer = nil
	touch = nil
	icon = nil
	game = nil
	soundTab = nil
	credits = nil
	gameSleep = nil
	soundSleep = nil
	creditsSleep = nil
end	

function options:whenAdded()
	icon = love.graphics.newImage("data/menu/optionsIcon.png")
	game = love.graphics.newImage("data/menu/tabGameActive.png")
	soundTab = love.graphics.newImage("data/menu/tabSoundActive.png")
	credits = love.graphics.newImage("data/menu/tabCreditsActive.png")
	gameSleep = love.graphics.newImage("data/menu/tabGameSleep.png")
	soundSleep = love.graphics.newImage("data/menu/tabSoundSleep.png")
	creditsSleep = love.graphics.newImage("data/menu/tabCreditsSleep.png")
	
	langData = json.decode(love.filesystem.read("langData.json"))
    saveData = json.decode(love.filesystem.read("saveData.json"))
    currentLang = saveData.options.currentLang
	
	timer = 0
	
	--кнопка назад
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
	
	--область настроек
	border.x = WIDTH + 425
	border.y = -150
	border.w = 425
	border.h = 300
	
	--вкладки
	border.tab = {}
	border.tab.x = border.x + border.w * 10
	border.tab.w = border.w / 6
	border.tab.h = border.h / 3
	border.tab.gameY = border.y
	border.tab.soundY = border.y + border.tab.h
	border.tab.creditsY = border.y + border.tab.h * 2
	border.tab.game = true
	border.tab.sound = false
	border.tab.credits = false
	
	--надпись текущей вкладки
	border.tab.name = {}
	border.tab.name.w = 150
	border.tab.name.h = 25
	border.tab.name.x = border.x + (border.tab.x - border.tab.name.w) / 2
	border.tab.name.y = border.y
	border.tab.name.text = t("menu", "game")
	
	--ползунок музыки
	musicPolz.border = {}
	musicPolz.line = {}
	musicPolz.border.x = border.x + 25
	musicPolz.border.y = border.y + 75
	musicPolz.border.w = 200
	musicPolz.border.h = 30
	musicPolz.line.w = (saveData.options.music * 100) * 2
	musicPolz.line.h = musicPolz.border.h
	musicPolz.line.value = saveData["options"]["music"]
	musicPolz.text = t("menu", "music")
	musicPolz.percent = tostring(musicPolz.line.w / 2) .. "%"
	
	--кнопка переключения музыки
	musicBtn.x = musicPolz.border.x
	musicBtn.y = musicPolz.border.y + 40
	musicBtn.w = 25
	musicBtn.h = 25
	if saveData.options.music == 0 then
	    musicBtn.text = t("menu", "enableMusic")
	    musicBtn.status = "fill"
	else
		musicBtn.text = t("menu", "disableMusic")
	    musicBtn.status = "line"
	end	
	musicBtn.color = {1, 1, 1}
	
	--ползунок звука
	soundPolz.border = {}
	soundPolz.line = {}
	soundPolz.border.x = border.x + 25
	soundPolz.border.y = musicBtn.y + 75
	soundPolz.border.w = 200
	soundPolz.border.h = 30
	soundPolz.line.w = (saveData.options.sound * 100) * 2
	soundPolz.line.h = soundPolz.border.h
	soundPolz.line.value = saveData["options"]["sound"]
	soundPolz.text = t("menu", "sound")
	soundPolz.percent = tostring(soundPolz.line.w / 2) .. "%"
	
	--кнопка переключения звука
	soundBtn.x = soundPolz.border.x
	soundBtn.y = soundPolz.border.y + 40
	soundBtn.w = 25
	soundBtn.h = 25
	if saveData.options.sound == 0 then
	    soundBtn.text = t("menu", "enableSound")
	    soundBtn.status = "fill"
	else
		soundBtn.text = t("menu", "disableSound")
	    soundBtn.status = "line"
	end	
	soundBtn.color = {1, 1, 1}
	
	--надпись "языки"
	langText.text = t("menu", "language")
	langText.x = border.x + 30
	langText.y = border.y + 50
	
	--кнопка "English"
	enBtn.x = border.x + 25
	enBtn.y = langText.y + 25
	enBtn.w = 90
	enBtn.h = 50
	enBtn.text = "English"
	enBtn.color = {1, 1, 1}
	
	--кнопка "Русский"
	ruBtn.x = enBtn.x + 100
	ruBtn.y = enBtn.y
	ruBtn.w = 90
	ruBtn.h = 50
	ruBtn.text = "Русский"
	ruBtn.color = {1, 1, 1}
	
	--надпись "Управление"
	inputText.text = t("menu", "input")
	inputText.x = border.x + 30
	inputText.y = enBtn.y + 75
	
	--кнопка "Джойстик"
	joystickBtn.x = border.x + 25
	joystickBtn.y = inputText.y + 25
	joystickBtn.w = 125
	joystickBtn.h = 60
	joystickBtn.text = t("menu", "joystick")
	joystickBtn.color = {1, 1, 1}
	
	--кнопка "Кнопки"
	buttonsBtn.x = joystickBtn.x + joystickBtn.w + 50
	buttonsBtn.y = inputText.y + 25
    buttonsBtn.w = 125
	buttonsBtn.h = 60
	buttonsBtn.text = t("menu", "buttons")
	buttonsBtn.color = {1, 1, 1}
end

function options:update(dt)
	if PAUSE then
		if border.x + border.w > WIDTH - 30 and not btn.back.press then
			border.x = WIDTH - border.w - 40
		    border.tab.x = border.x + border.tab.w * 5
            border.tab.name.x = border.x + (border.w - border.tab.w - border.tab.name.w) / 2
		    enBtn.x = border.x + 25
		    ruBtn.x = enBtn.x + enBtn.w + 10
		    langText.x = border.x + 30
		    joystickBtn.x = border.x + 25
		    inputText.x = border.x + 30
		    buttonsBtn.x = joystickBtn.x + joystickBtn.w + 10
		    musicPolz.border.x = border.x + 25
		    musicBtn.x = musicPolz.border.x
		    soundPolz.border.x = border.x + 25
		    soundBtn.x = soundPolz.border.x
	    end
		return
	end
	
	btn.back.angle = btn.back.angle + (btn.back.target - btn.back.angle) * btn.back.speed * dt
	btn.back.angleB = btn.back.angleB + (btn.back.target - btn.back.angleB) * btn.back.speedB * dt
	
	if btn.back.press then
		timer = timer + dt
		btn.back.target = math.rad(180)
		border.x = border.x + border.x * 5 * dt
		border.tab.x = border.x + border.tab.w * 5
        border.tab.name.x = border.x + (border.w - border.tab.w - border.tab.name.w) / 2
		enBtn.x = border.x + 25
		ruBtn.x = enBtn.x + enBtn.w + 10
		langText.x = border.x + 30
		joystickBtn.x = border.x + 25
		inputText.x = border.x + 30
		buttonsBtn.x = joystickBtn.x + joystickBtn.w + 10
		musicPolz.border.x = border.x + 25
		musicBtn.x = musicPolz.border.x
		soundPolz.border.x = border.x + 25
		soundBtn.x = soundPolz.border.x
		if timer > 0.3 then
			touch = {}
			scene:pop("options")
			scene:push("menu")
		end
	end
	
	if border.x + border.w > WIDTH - 30 and not btn.back.press then
	    border.x = border.x - border.x * 5 * dt
		border.tab.x = border.x + border.tab.w * 5
        border.tab.name.x = border.x + (border.w - border.tab.w - border.tab.name.w) / 2
		enBtn.x = border.x + 25
		ruBtn.x = enBtn.x + enBtn.w + 10
		langText.x = border.x + 30
		joystickBtn.x = border.x + 25
		inputText.x = border.x + 30
		buttonsBtn.x = joystickBtn.x + joystickBtn.w + 10
		musicPolz.border.x = border.x + 25
		musicBtn.x = musicPolz.border.x
		soundPolz.border.x = border.x + 25
		soundBtn.x = soundPolz.border.x
	end	
end

function options:drawUI()
    love.graphics.setBackgroundColor(0, 0, 0)
	
	love.graphics.translate(0, HEIGHT / 2)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", border.x, border.y, border.w, border.h)
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("line", border.x, border.y, border.w, border.h)
	
	drawButton(border.tab.name.text, border.tab.name.x, border.tab.name.y, border.tab.name.w, border.tab.name.h)
	
	love.graphics.setColor(0.5, 0.5, 0.5)
	
    love.graphics.rectangle("line", border.tab.x, border.tab.gameY, border.tab.w, border.tab.h)
	love.graphics.draw(gameSleep, border.tab.x + 4, border.tab.gameY + 20, 0, 4, 4)
	
    love.graphics.rectangle("line", border.tab.x, border.tab.soundY, border.tab.w, border.tab.h)
	love.graphics.draw(soundSleep, border.tab.x + 4, border.tab.soundY + 20, 0, 4, 4)
	
    love.graphics.rectangle("line", border.tab.x, border.tab.creditsY, border.tab.w, border.tab.h)
	love.graphics.draw(creditsSleep, border.tab.x + 4, border.tab.creditsY + 20, 0, 4, 4)
	
	love.graphics.setColor(1, 1, 1)
	
	if border.tab.game then
		love.graphics.rectangle("line", border.tab.x, border.tab.gameY, border.tab.w, border.tab.h)
		love.graphics.draw(game, border.tab.x + 4, border.tab.gameY + 20, 0, 4, 4)
		
		love.graphics.print(langText.text, langText.x, langText.y)
		drawButton(enBtn.text, enBtn.x, enBtn.y, enBtn.w, enBtn.h, enBtn.color)
		drawButton(ruBtn.text, ruBtn.x, ruBtn.y, ruBtn.w, ruBtn.h, ruBtn.color)
		
		love.graphics.print(inputText.text, inputText.x, inputText.y)
		drawButton(joystickBtn.text, joystickBtn.x, joystickBtn.y, joystickBtn.w, joystickBtn.h, joystickBtn.color, nil, joystickBtn.x + 12)
		drawButton(buttonsBtn.text, buttonsBtn.x, buttonsBtn.y, buttonsBtn.w, buttonsBtn.h, buttonsBtn.color, nil, buttonsBtn.x + 12)
	end
		
	if border.tab.sound then
		love.graphics.rectangle("line", border.tab.x, border.tab.soundY, border.tab.w, border.tab.h)
		love.graphics.draw(soundTab, border.tab.x + 4, border.tab.soundY + 20, 0, 4, 4)
		
		love.graphics.print(musicPolz.text, border.x + 30, musicPolz.border.y - 25)
	    love.graphics.rectangle("line", musicPolz.border.x, musicPolz.border.y, musicPolz.border.w, musicPolz.border.h)
	    love.graphics.rectangle("fill", musicPolz.border.x, musicPolz.border.y, musicPolz.line.w, musicPolz.line.h)
	    love.graphics.print(musicPolz.percent, musicPolz.border.x + 210, musicPolz.border.y + 6)
		
		love.graphics.setColor(musicBtn.color)
		love.graphics.rectangle(musicBtn.status, musicBtn.x, musicBtn.y, musicBtn.w, musicBtn.h)
		love.graphics.print(musicBtn.text, musicBtn.x + 30, musicBtn.y + 3)
	    
		love.graphics.setColor(1, 1, 1)
	    love.graphics.print(soundPolz.text, border.x + 30, soundPolz.border.y - 25)
	    love.graphics.rectangle("line", soundPolz.border.x, soundPolz.border.y, soundPolz.border.w, soundPolz.border.h)
	    love.graphics.rectangle("fill", soundPolz.border.x, soundPolz.border.y, soundPolz.line.w, soundPolz.line.h)
	    love.graphics.print(soundPolz.percent, soundPolz.border.x + 210, soundPolz.border.y + 6)
		
		love.graphics.setColor(soundBtn.color)
		love.graphics.rectangle(soundBtn.status, soundBtn.x, soundBtn.y, soundBtn.w, soundBtn.h)
		love.graphics.print(soundBtn.text, soundBtn.x + 30, soundBtn.y + 3)
		love.graphics.setColor(1, 1, 1)
	end
	
	if border.tab.credits then
		love.graphics.rectangle("line", border.tab.x, border.tab.creditsY, border.tab.w, border.tab.h)
		love.graphics.draw(credits, border.tab.x + 4, border.tab.creditsY + 20, 0, 4, 4)
		
		love.graphics.print(t("menu", "creditsText"), border.x + 25, border.y + 50)
		love.graphics.print("Made with löve...  powered by Löve2D", border.x + 70, border.y + 272.5)
	end
	
	if PAUSE then
		love.graphics.origin()
		return
	end	
	
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
	
	love.graphics.origin()
end

function options:touchpressed(id, x, y)
	if not PAUSE and zone(btn.back.x, btn.back.y, btn.back.w, btn.back.h, x, y) then
		btn.back.color = {0.5, 0.5, 0.5}
		touch[id] = "back"
	end
	
	if zone(border.tab.x, border.tab.gameY + HEIGHT / 2, border.tab.w, border.tab.h, x, y) then
		touch[id] = "tabGame"
	elseif zone(border.tab.x, border.tab.soundY + HEIGHT / 2, border.tab.w, border.tab.h, x, y) then
		touch[id] = "tabSound"
	elseif zone(border.tab.x, border.tab.creditsY + HEIGHT / 2, border.tab.w, border.tab.h, x, y) then
		touch[id] = "tabCredits"
	end	
	
	if border.tab.game then
	    if zone(enBtn.x, enBtn.y + HEIGHT / 2, enBtn.w, enBtn.h, x, y) then
		    enBtn.color = {0.5, 0.5, 0.5}
			touch[id] = "en"
	    elseif zone(ruBtn.x, ruBtn.y + HEIGHT / 2, ruBtn.w, ruBtn.h, x, y) then
		    ruBtn.color = {0.5, 0.5, 0.5}
			touch[id] = "ru"
	    end
		
		if zone(joystickBtn.x, joystickBtn.y + HEIGHT / 2, joystickBtn.w, joystickBtn.h, x, y) then
			joystickBtn.color = {0.5, 0.5, 0.5}
			touch[id] = "joystick"
		elseif zone(buttonsBtn.x, buttonsBtn.y + HEIGHT / 2, buttonsBtn.w, buttonsBtn.h, x, y) then
			buttonsBtn.color = {0.5, 0.5, 0.5}
			touch[id] = "buttons"
		end	
	end	
		
	if border.tab.sound then	
        if zone(musicBtn.x, musicBtn.y + HEIGHT / 2, musicBtn.w, musicBtn.h, x, y) then
			musicBtn.color = {0.5, 0.5, 0.5}
			touch[id] = "musicBtn"
	    elseif zone(soundBtn.x, soundBtn.y + HEIGHT / 2, soundBtn.w, soundBtn.h, x, y) then
		    soundBtn.color = {0.5, 0.5, 0.5}
			touch[id] = "soundBtn"
	    end
	
	    if zone(musicPolz.border.x, musicPolz.border.y + HEIGHT / 2, musicPolz.border.w, musicPolz.border.h, x, y) then
			musicPolz.line.value = (x - musicPolz.border.x) / musicPolz.border.w
			musicPolz.line.w = musicPolz.border.w * musicPolz.line.value
			
			if x < musicPolz.border.x then
				musicPolz.line.w = 0
			    musicBtn.status = "fill"
				musicBtn.text = t("menu", "enableMusic")
		    elseif x > musicPolz.border.x + musicPolz.border.w then
				musicPolz.line.w = musicPolz.border.w
				musicBtn.status = "line"
				musicBtn.text = t("menu", "disableMusic")
			else	
			    musicBtn.status = "line"
				musicBtn.text = t("menu", "disableMusic")
		    end
		    musicPolz.percent = tostring(math.floor(musicPolz.line.w / 2)) .. "%"
		    saveData.options.music = (math.floor(musicPolz.line.w / 2)) / 100
		    music.menu:setVolume((math.floor(musicPolz.line.w / 2)) / 100)
			touch[id] = "musicPolz"
	    end
	
	    if zone(soundPolz.border.x, soundPolz.border.y + HEIGHT / 2, soundPolz.border.w, soundPolz.border.h, x, y) then
			soundPolz.line.value = (x - soundPolz.border.x) / soundPolz.border.w
			soundPolz.line.w = soundPolz.border.w * soundPolz.line.value
			
		    if x < soundPolz.border.x then
				soundPolz.line.w = 0
			    soundBtn.status = "fill"
				soundBtn.text = t("menu", "enableSound")
		    elseif x > soundPolz.border.x + soundPolz.border.w then
			    soundPolz.line.w = soundPolz.border.w
			    soundBtn.status = "line"
				soundBtn.text = t("menu", "disableSound")
		    else
			    soundBtn.status = "line"
				soundBtn.text = t("menu", "disableSound")
		    end
		    soundPolz.percent = tostring(math.floor(soundPolz.line.w / 2)) .. "%"
		    saveData.options.sound = (math.floor(soundPolz.line.w / 2)) / 100
			touch[id] = "soundPolz"
	    end
	end
end

function options:touchmoved(id, x, y)
	if border.tab.game then
	    if touch[id] == "en" then
		    enBtn.color = {0.5, 0.5, 0.5}
	    elseif touch[id] == "ru" then
		    ruBtn.color = {0.5, 0.5, 0.5}
	    end
	end
	
	if border.tab.sound then
	    if touch[id] == "musicPolz" and border.x + border.w < WIDTH - 30 then
			musicPolz.line.value = (x - musicPolz.border.x) / musicPolz.border.w
			musicPolz.line.w = musicPolz.border.w * musicPolz.line.value
			
		    if x < musicPolz.border.x then
				musicPolz.line.w = 0
			    musicBtn.status = "fill"
				musicBtn.text = t("menu", "enableMusic")
		    elseif x > musicPolz.border.x + musicPolz.border.w then
			    musicPolz.line.w = musicPolz.border.w
			    musicBtn.status = "line"
				musicBtn.text = t("menu", "disableMusic")
		    else
			    musicBtn.status = "line"
				musicBtn.text = t("menu", "disableMusic")
		    end
		    musicPolz.percent = tostring(math.floor(musicPolz.line.w / 2)) .. "%"
		    saveData.options.music = (math.floor(musicPolz.line.w / 2)) / 100
		    music.menu:setVolume((math.floor(musicPolz.line.w / 2)) / 100)
			love.filesystem.write("saveData.json", json.encode(saveData))
		end	
	
	    if touch[id] == "soundPolz" and border.x + border.w < WIDTH - 30 then
			soundPolz.line.value = (x - soundPolz.border.x) / soundPolz.border.w
			soundPolz.line.w = soundPolz.border.w * soundPolz.line.value
		    if x < soundPolz.border.x then
				soundPolz.line.w = 0
			    soundBtn.status = "fill"
				soundBtn.text = t("menu", "enableSound")
		    elseif x > soundPolz.border.x + soundPolz.border.w then
			    soundPolz.line.w = soundPolz.border.w
			    soundBtn.status = "line"
				soundBtn.text = t("menu", "disableSound")
		    else
			    soundBtn.status = "line"
				soundBtn.text = t("menu", "disableSound")
		    end
		    soundPolz.percent = tostring(math.floor(soundPolz.line.w / 2)) .. "%"
		    saveData.options.sound = (math.floor(soundPolz.line.w / 2)) / 100
			love.filesystem.write("saveData.json", json.encode(saveData))
	    end
	end
end

function options:touchreleased(id, x, y)
	if not PAUSE and touch[id] == "back" then
		btn.back.color = {1, 1, 1}
		btn.back.press = true
		playSound("select")
    elseif touch[id] == "tabGame" then
		border.tab.sound = false
		border.tab.credits = false
		border.tab.game = true
		border.tab.name.text = t("menu", "game")
		playSound("bip")
	elseif touch[id] == "tabSound" then
		border.tab.game = false
		border.tab.credits = false
		border.tab.sound = true
		border.tab.name.text = t("menu", "sound")
		playSound("bip")
	elseif touch[id] == "tabCredits" then
		border.tab.game = false
		border.tab.sound = false
		border.tab.credits = true
		border.tab.name.text = t("menu", "credits")
		playSound("bip")
	end	
	
	if border.tab.game then
	    if touch[id] == "en" then
		    enBtn.color = {1, 1, 1}
		    currentLang = "en"
			
            if not saveData then
                saveData = {}
            end
            if not saveData.options then
                saveData.options = {}
            end
            saveData.options.currentLang = currentLang
            love.filesystem.write("saveData.json", json.encode(saveData))
			
			playSound("bip")
			
			border.tab.name.text = t("menu", "game")
			langText.text = t("menu", "language")
			inputText.text = t("menu", "input")
			joystickBtn.text = t("menu", "joystick")
			buttonsBtn.text = t("menu", "buttons")
			musicPolz.text = t("menu", "music")
			soundPolz.text = t("menu", "sound")
			if saveData.options.music == 1 then
				musicBtn.text = t("menu", "disableMusic")
			else
				musicBtn.text = t("menu", "enableMusic")
			end
			if saveData.options.sound == 1 then
				soundBtn.text = t("menu", "disableSound")
			else
				soundBtn.text = t("menu", "enableSound")
			end
	    elseif touch[id] == "ru" then
		    ruBtn.color = {1, 1, 1}
		    currentLang = "ru"
			
			if not saveData then
                saveData = {}
            end
            if not saveData.options then
                saveData.options = {}
            end
            saveData.options.currentLang = currentLang
            love.filesystem.write("saveData.json", json.encode(saveData))
		    
			playSound("bip")
			
			border.tab.name.text = t("menu", "game")
			langText.text = t("menu", "language")
			inputText.text = t("menu", "input")
			joystickBtn.text = t("menu", "joystick")
			buttonsBtn.text = t("menu", "buttons")
			musicPolz.text = t("menu", "music")
			soundPolz.text = t("menu", "sound")
			if saveData.options.music == 1 then
				musicBtn.text = t("menu", "disableMusic")
			else
				musicBtn.text = t("menu", "enableMusic")
			end
			if saveData.options.sound == 1 then
				soundBtn.text = t("menu", "disableSound")
			else
				soundBtn.text = t("menu", "enableSound")
			end		
		end	
	    
		if touch[id] == "joystick" then
			joystickBtn.color = {1, 1, 1}
			playSound("bip")
			saveData.options.input = "joystick"
		elseif touch[id] == "buttons" then
			buttonsBtn.color = {1, 1, 1}
			playSound("bip")
			saveData.options.input = "buttons"
		end
	end	
	
	if border.tab.sound then
		if touch[id] == "musicPolz" then
			love.filesystem.write("saveData.json", json.encode(saveData))
		end	
		
	    if touch[id] == "musicBtn" then
			musicBtn.color = {1, 1, 1}
		    if musicBtn.status == "line" then
			    musicPolz.line.w = 0
			    saveData.options.music = 0
			    musicPolz.percent = tostring(math.floor(musicPolz.line.w / 2)) .. "%"
			    music.menu:setVolume(0)
				musicBtn.status = "fill"
				musicBtn.text = t("menu", "enableMusic")
				playSound("bip")
		    else
			    musicPolz.line.w = 200
			    saveData.options.music = 1
			    musicPolz.percent = tostring(math.floor(musicPolz.line.w / 2)) .. "%"
			    music.menu:setVolume(1)
			    musicBtn.status = "line"
			    musicBtn.text = t("menu", "disableMusic")
				playSound("bip")
		    end
			love.filesystem.write("saveData.json", json.encode(saveData))
		end
		
		if touch[id] == "soundPolz" then
			love.filesystem.write("saveData.json", json.encode(saveData))
		end	
					
	    if touch[id] == "soundBtn" then
		    soundBtn.color = {1, 1, 1}
		    if soundBtn.status == "line" then
			    soundPolz.line.w = 0
			    saveData.options.sound = 0
			    soundPolz.percent = tostring(math.floor(soundPolz.line.w / 2)) .. "%"
				soundBtn.status = "fill"
				soundBtn.text = t("menu", "enableSound")
				playSound("bip")
		    else
			    soundPolz.line.w = 200
			    saveData.options.sound = 1
			    soundPolz.percent = tostring(math.floor(soundPolz.line.w / 2)) .. "%"
			    soundBtn.status = "line"
			    soundBtn.text = t("menu", "disableSound")
				playSound("bip")
		    end
			love.filesystem.write("saveData.json", json.encode(saveData))
	    end
	end
	touch[id] = nil
end

return options