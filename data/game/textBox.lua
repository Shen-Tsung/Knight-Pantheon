local textBox = {}
local portrait = {}
local text
local textIndex

local npc
local state

local oneMsg

local tA = require "data/libs/textAnim"

local display
local delay

local touch = {}

function textBox:load()
	textBox.png = love.graphics.newImage("data/assets/ui/hud/textBox.png")
end

function textBox:whenAdded(Npc, State)
	textBox.w, textBox.h = textBox.png:getDimensions()
	textBox.x = (WIDTH - textBox.w) / 1.5
	textBox.y = HEIGHT - textBox.h + 40
	
	npc = Npc
	state = State
	
	local path = "data/chars/" .. npc .. "/" .. npc .. "Portrait.png"
    if love.filesystem.getInfo(path) then
        portrait.png = love.graphics.newImage(path)
    else
        portrait.png = nil
    end
	
	path = "data/chars/" .. npc .. "/" .. npc .. "Voice.wav"
    if love.filesystem.getInfo(path) then
        voice = love.audio.newSource(path)
    else
        voice = "data/assets/sound/text.wav"
    end
	
	if #langData[currentLang][npc][state] > 10 then
	    oneMsg = true
	else
		oneMsg = false
	end	
	
	portrait.x = textBox.x + 20
	portrait.y = textBox.y + 15
	
	textIndex = 1
	
	display = ""
	delay = 0.04
	
	if portrait.png then
	    text = tA.new(display, delay, portrait.x + 175, portrait.y + 10, voice)
	else
		text = tA.new(display, delay, portrait.x + 20, portrait.y + 10, voice)
	end
		
	if oneMsg then
	    text:setText(t(npc, state))
	else
		text:setText(t(npc, state, textIndex))
	end	
end

function textBox:update(dt)
	if PAUSE then return end
		
	text:update(dt)
end	

function textBox:draw()
	love.graphics.draw(textBox.png, textBox.x, textBox.y, 0, 1, 1)
	if portrait.png then
	    love.graphics.draw(portrait.png, portrait.x, portrait.y, 0, 3, 3)
	end
	
	love.graphics.setFont(regularBig)
	if portrait.png then
	    love.graphics.print("*", portrait.x + 150, portrait.y + 10)
    end
	text:draw()
	love.graphics.setFont(regular)
end

function textBox:touchpressed(id, x, y)
	if PAUSE then return end
	if not zone(50 - 32, 70 - 32, 64, 64, x, y) then
		
	if not text.isComplete then
		text:skip()
		return
	end	
		
	textIndex = textIndex + 1
	display = ""
	if oneMsg then
	    scene:pop("textBox")
	    inputHide = false
	else
		text:setText(t(npc, state, textIndex))
	end
	
	if textIndex > #langData[currentLang][npc][state] then
		scene:pop("textBox")
	    inputHide = false
	end
	
	end	
end

return textBox