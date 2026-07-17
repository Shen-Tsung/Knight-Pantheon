local fightAct = {}

local action = {}
local act
local isIdle

local npc

local timer

local touch = {}

local fight = require "data/fight/fight"
local kris
local menu
local box

local tA = require "data/libs/textAnim"
local text
local textIndex
local display
local delay
local oneMsg
local chooseAction
local voice

local function acting()
	act = true
	
	menu.state = "neutral"
	
	oneMsg = #langData[currentLang]["fights"][npc][chooseAction] > 10
	
	text = tA.new(display, delay, box.x - box.w + 20, box.y + 10, voice)
	
	if oneMsg then
	    text:setText(t("fights", npc, chooseAction))
	else
		text:setText(t("fights", npc, chooseAction, textIndex))
	end
	
	kris:anSelect(t("fights", npc, "animation", chooseAction))
end

function fightAct:whenAdded(Npc)
	menu = fight.getMenu()
	box = fight.getBox()
	kris = fight.getKris()
	
	npc = Npc
	
	act = false
	
	action.one = {}
	action.two = {}
	action.three = {}
	action.four = {}
	
	for key in pairs(action) do
		action[key].x = 0
		action[key].x = box.w / 4
		action[key].a = 1
	end	
	
	action.one.x = box.x1
	action.two.x = box.x2n4
	action.three.x = box.x3n4
	action.four.x = box.x4n4
	
	menu.actionsHide = true
	
	timer = 0
	
	voice = "data/assets/sound/text.wav"
	
	textIndex = 1
	
	display = ""
	delay = 0.04
end

function fightAct:update(dt)
	if PAUSE then return end
	
	action.one.x = box.x1
	action.two.x = box.x2n4
	action.three.x = box.x3n4
	action.four.x = box.x4n4
	
	if act then
		text:update(dt)
	end
end

function fightAct:drawUI()
	love.graphics.setScissor(box.x - box.w, box.y, box.w, box.h)
	
	if not act then
		love.graphics.setColor(1, 1, 1, 0.5)
		love.graphics.line(box.x2n4 - 30, box.y, box.x2n4 - 30, box.y + box.h)
		love.graphics.line(box.x3n4 - 30, box.y, box.x3n4 - 30, box.y + box.h)
		love.graphics.line(box.x4n4 - 30, box.y, box.x4n4 - 30, box.y + box.h)
		
		love.graphics.setColor(1, 1, 1, action.one.a)
		love.graphics.print("*", action.one.x - 20, box.y + 10)
		love.graphics.printf(t("fights", npc, "actions", 1), action.one.x, box.y + 10, 140, "left")
		love.graphics.setColor(1, 1, 1, action.two.a)
		love.graphics.print("*", action.two.x - 20, box.y + 10)
		love.graphics.printf(t("fights", npc, "actions", 2), action.two.x, box.y + 10, 140, "left")
		love.graphics.setColor(1, 1, 1, action.three.a)
		love.graphics.print("*", action.three.x - 20, box.y + 10)
		love.graphics.printf(t("fights", npc, "actions", 3), action.three.x, box.y + 10, 140, "left")
		love.graphics.setColor(1, 1, 1, action.four.a)
		love.graphics.print("*", action.four.x - 20, box.y + 10)
		love.graphics.printf(t("fights", npc, "actions", 4), action.four.x, box.y + 10, 140, "left")
	else
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print("*", action.one.x - 20, box.y + 10)
		text:draw()
	end
	
	love.graphics.setScissor()
end

function fightAct:touchpressed(id, x, y)
	if PAUSE or act then return end
	
	if zone(action.one.x - 30, box.y, box.w / 4, box.h, x, y) then
		touch[id] = "one"
		action.one.a = 0.5
	elseif zone(action.two.x - 30, box.y, box.w / 4, box.h, x, y) then
		touch[id] = "two"
		action.two.a = 0.5
	elseif zone(action.three.x - 30, box.y, box.w / 4, box.h, x, y) then
		touch[id] = "three"
		action.three.a = 0.5
	elseif zone(action.four.x - 30, box.y, box.w / 4, box.h, x, y) then
		touch[id] = "four"
		action.four.a = 0.5
	end			
end	

function fightAct:touchreleased(id, x, y)
	if PAUSE then return end
	
	if act then
		if not text.isComplete then
			text:skip()
			return
		end
		
		textIndex = textIndex + 1
		display = ""
		if oneMsg then
				scene:pop("fightAct")
				menu.state = "neutral"
		else
			text:setText(t("fights", npc, chooseAction, textIndex))
		end
	
		if textIndex > #langData[currentLang]["fights"][npc][chooseAction] then
			scene:pop("fightAct")
			menu.actionsHide = false
			menu.text = true
			menu.state = "neutral"
			if kris.animation ~= "idle" then
				kris:anSelect("backToIdle")
			end	
		end
	end
	
	if touch[id] == "one" then
		action.one.a = 0.5
		chooseAction = "one"
		acting()
	elseif touch[id] == "two" then
		action.two.a = 0.5
		chooseAction = "two"
		acting()
	elseif touch[id] == "three" then
		action.three.a = 0.5
		chooseAction = "three"
		acting()
	elseif touch[id] == "four" then
		action.four.a = 0.5
		chooseAction = "four"
		acting()
	end
	
	touch[id] = nil		
end	

return fightAct