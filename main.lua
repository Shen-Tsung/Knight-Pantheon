scene = require "data/libs/sceneMan"
push = require "data/libs/push"
hc = require "data/libs/HC-master"
file = require "data/libs/fileManager"

json = require "data/libs/json"
langData = json.decode(love.filesystem.read("langData.json"))
saveData = json.decode(love.filesystem.read("saveData.json"))

-- проверка файла

--[[
local function saveCheck()
	local info = love.filesystem.getInfo("data/saveData.json")
	
	if info then
		local data = json.decode(love.filesystem.read("data/saveData.json"))
		if data and data.options then
			return data
		end
	end
	
	return {
		options = {
            currentLang = "ru",
            music = 1.0,
            sound = 1.0,
            input = "joystick"
        }
	}
end
]]


--[[
local success, data = pcall(json.decode, love.filesystem.read("saveData.json"))
if success and data and data.options then
    saveData = data
else
    saveData = {
        options = {
            currentLang = "ru",
            music = 1.0,
            sound = 1.0,
            input = "joystick"
        }
    }
    love.filesystem.write("saveData.json", json.encode(saveData))
end
]]

--love.filesystem.write("data/saveData.json", json.encode(saveCheck()))

currentLang = saveData.options.currentLang or "ru"

KRIS = {}

fade = 0

talk = nil

PAUSE = false
inputHide = false

music = {}
sound = {}

WIDTH, HEIGHT = 640, 350
screenW, screenH = 0, 0

local touchX, touchy

function quads(tbl, png, xx, yy, w, h, margin, row, col)
	for y = 1, col do
		for x = 1, row do
			local quad = love.graphics.newQuad(
				xx + ((w + margin) * (x - 1)),
				yy + ((h + margin) * (y - 1)),
				w,
				h,
				png:getWidth(), png:getHeight())
			table.insert(tbl, quad)
		end
	end
end

function love.load()
	-- экран
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	screenW, screenH = love.graphics.getDimensions()
	WIDTH = love.graphics.getPixelWidth() / 2.86
    push:setupScreen(math.max(640, WIDTH), HEIGHT, screenW, screenH, {
        fullscreen = true,
        resizable = false,
        pixelperfect = false,
        highdpi = false,
		stretched = true
    })
	
	-- шрифты
	title = love.graphics.newFont("data/assets/font/title.ttf", 32)
	regular = love.graphics.newFont("data/assets/font/regular.ttf", 20)
	regularBig = love.graphics.newFont("data/assets/font/regular.ttf", 30)
	hpFont = love.graphics.newImageFont("data/assets/font/hpFont.png", "0123456789-+")
	love.graphics.setFont(regular)
	
	-- музыка
	music.current = nil
	music.name = nil
	
	--[[
	music.menu = love.audio.newSource("data/menu/everHigher.mp3", "stream")
	music.gr = love.audio.newSource("data/locations/gersonRoom/fireplace.mp3", "stream")
	music.fight = love.audio.newSource("data/fight/rudeBuster.mp3", "stream")
	music.fightAlt = love.audio.newSource("data/fight/rudeBusterBusted.mp3", "stream")
	
	music.menu:setLooping(true)
	music.gr:setLooping(true)
	music.fight:setLooping(true)
	music.fightAlt:setLooping(true)
	
	music.fightStart = 0.7
	music.fightFinish = 76
	
	music.fightAltStart = 1
	music.fightAltFinish = 100
	
	-- звуки
	sound.select = love.audio.newSource("data/assets/sound/select.wav", "static")
	sound.bip = love.audio.newSource("data/assets/sound/menuMove.wav", "static")
	sound.text = love.audio.newSource("data/assets/sound/text.wav", "static")
	sound.fightStart = love.audio.newSource("data/assets/sound/fightStart.wav", "static")
	sound.krisAttack = love.audio.newSource("data/assets/sound/krisAttack.wav", "static")
	sound.enemyAlert = love.audio.newSource("data/assets/sound/enemyAlert.wav", "static")
	sound.gameOver1 = love.audio.newSource("data/assets/sound/gameOver1.wav", "static")
	sound.gameOver2 = love.audio.newSource("data/assets/sound/gameOver2.wav", "static")
	
	-- сцены с прочим
	local pause = require "data/game/pause"
	local input = require "data/game/input"
	local textBox = require "data/game/textBox"
	
	scene:newScene("pause", pause)
	scene:newScene("input", input)
	scene:newScene("textBox", textBox)
	
	-- сцены битв
	local fightBg = require "data/fight/fightBg"
	local fight = require "data/fight/fight"
	local fightBox = require "data/fight/fightBox"
	local fightAttack = require "data/fight/fightAttack"
	local fightAct = require "data/fight/fightAct"
	local rudinnAttack = require "data/fight/fightAct"
	
	scene:newScene("fightBg", fightBg)
	scene:newScene("fight", fight)
	scene:newScene("fightBox", fightBox)
	scene:newScene("fightAttack", fightAttack)
	scene:newScene("fightAct", fightAct)
	scene:newScene("rudinnAttack", rudinnAttack)
	
	-- сцены меню
	local intro = require "data/menu/intro"
	local bgMenu = require "data/menu/bg"
    local menu = require "data/menu/menu"
	local play = require "data/menu/play"
    local options = require "data/menu/options"
	
    scene:newScene("intro", intro)
	scene:newScene("bgMenu", bgMenu)
    scene:newScene("menu", menu)
	scene:newScene("play", play)
    scene:newScene("options", options)
	
	-- сцены Gerson Room
	local gr = require "data/locations/gersonRoom/gersonRoom"
	local gr1 = require "data/locations/gersonRoom/rightRoom"
	
    scene:newScene("gr", gr)
	scene:newScene("gr1", gr1)
	]]
	
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
	file.audioLoad("text", "data/assets/sound/text.wav", "sound")
    
	scene:push("fightBg", {"rudinn", "rudinn", "rudinn"})
end

-- изменение размеров экрана (не используется)
function love.resize(w, h)
    push:resize(w, h)
end

-- обновление
function love.update(dt)
    scene:event("update", dt)
	
	if music.name then
		musicLoop(music.current, music[music.name .. "Start"], music[music.name .. "Finish"])
	end	
end

-- рисовка
function love.draw()
	love.graphics.setBackgroundColor(0.1, 0.2, 0.5)
	
	scene:event("draw")
	
	push:start()
    scene:event("drawUI")
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

function t(key, ...)
    local keys = {key, ...}
    local current = langData[currentLang]
    for _, k in ipairs(keys) do
        if type(current) ~= "table" then return "[" .. table.concat(keys, ".") .. "]" end
        current = current[k]
    end
    return current or "[" .. table.concat(keys, ".") .. "]"
end

-- проигрывание
function playMusic(name)
	local current = music[name]
	
	music.current = current
	music.name = name
		
	if current then
		current:setVolume(saveData["options"]["music"])
		current:play()
	end
end

function musicLoop(music, start, finish)
	if start == nil and finish == nil then
		return
	end	
	
	if music:isPlaying() then
		local currentPos = music:tell("seconds")
		
		if currentPos >= finish then
			music:seek(start)
		end	
	end	
end	

function playSound(name)
	local current = sound[name]		
		
	if current then
		current:setVolume(saveData["options"]["sound"])
		current:play()
	end
end

-- кнопка
function drawButton(text, x, y, w, h, borderColor, textColor, textPosX, textPosY)
    love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", x, y, w, h)
	
	if borderColor == nil then
		love.graphics.setColor(1, 1, 1)
	else
		love.graphics.setColor(borderColor)
	end
	
	love.graphics.rectangle("line", x, y, w, h)
	
	if textColor == nil then
		love.graphics.setColor(1, 1, 1)
	else	
        love.graphics.setColor(textColor)
	end
	
	text = text or ""
	
    local font = love.graphics.getFont()
    local textX = x + (w - font:getWidth(text)) / 2
    local textY = y + (h - font:getHeight()) / 2
    
	if textPosX then
		textX = textPosX
	end
	
	if textPosY then
		textY = textPosY
	end	
		
    love.graphics.print(text, textX, textY)
end

-- проверка области
function zone(x, y, w, h, xx, yy)
    return xx > x and xx < x + w and
           yy > y and yy < y + h
end

function outzone(x, y, w, h, xx, yy)
	return xx < x and xx > w and
	       yy < y and yy > h
end

-- оптимизация под экран
function fit(num)
	if num then
	    return num / (WIDTH / 410)
	else
		return WIDTH / 410
	end	
end