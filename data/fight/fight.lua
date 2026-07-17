local fight = {}

local touch = {}

local menu

local lines = {}

local timer

local Kris = require "data/game/krisFight"
local kris
local index

local Npc = {}
local npc = {}
local numOfNpc

local box = {}

local back = {}

function fight:whenAdded(getNpc)
	love.audio.stop()
	
	local altMusic = math.random(1, 100)
	
	if altMusic < 10 then
		playMusic("fightAlt")
	else	
	    playMusic("fight")
	end
		
	playSound("fightStart")
	
	timer = 0
	inputHide = true
	index = 1
	
	kris = nil
	kris = Kris.new(WIDTH / 4, HEIGHT / 3)
	
	Npc = {}
	npc = {}
	
	for i, npcName in ipairs(getNpc) do
		Npc[i] = require("data/chars/" .. npcName .. "/" .. npcName .. "Fight")
		npc[i] = Npc[i].new(WIDTH / 1.5, HEIGHT / 3)
		
		if i == 2 then
			npc[i].x = WIDTH / 1.5 + 100
			npc[i].y = HEIGHT / 3 - 50
		elseif i == 3 then
			npc[i].x = WIDTH / 1.5 + 100
			npc[i].y = HEIGHT / 3 + 50
		end	
	end
	
	menu = {}
	
	menu.state = "neutral"
	menu.text = true
	
	menu.hide = false
	menu.actionsHide = false
	menu.animSpeed = 8
	
	
	menu.png = love.graphics.newImage("data/fight/fight.png")
	menu.healthEn = love.graphics.newQuad(151, 0, 213, 38, menu.png:getWidth(), menu.png:getHeight())
	menu.actionsEn = love.graphics.newQuad(151, 36, 213, 38, menu.png:getWidth(), menu.png:getHeight())
	menu.fightEn = love.graphics.newQuad(151, 78, 31, 32, menu.png:getWidth(), menu.png:getHeight())
	menu.actEn = love.graphics.newQuad(183, 78, 31, 32, menu.png:getWidth(), menu.png:getHeight())
	menu.itemEn = love.graphics.newQuad(215, 78, 31, 32, menu.png:getWidth(), menu.png:getHeight())
	menu.spareEn = love.graphics.newQuad(247, 78, 31, 32, menu.png:getWidth(), menu.png:getHeight())
	menu.defendEn = love.graphics.newQuad(279, 78, 31, 32, menu.png:getWidth(), menu.png:getHeight())
	
	menu.healthRu = love.graphics.newQuad(365, 0, 213, 38, menu.png:getWidth(), menu.png:getHeight())
	menu.actionsRu = love.graphics.newQuad(365, 36, 213, 38, menu.png:getWidth(), menu.png:getHeight())
	menu.fightRu = love.graphics.newQuad(365, 76, 31, 32, menu.png:getWidth(), menu.png:getHeight())
	menu.actRu = love.graphics.newQuad(397, 76, 31, 32, menu.png:getWidth(), menu.png:getHeight())
	menu.itemRu = love.graphics.newQuad(429, 76, 31, 32, menu.png:getWidth(), menu.png:getHeight())
	menu.spareRu = love.graphics.newQuad(461, 76, 31, 32, menu.png:getWidth(), menu.png:getHeight())
	menu.defendRu = love.graphics.newQuad(493, 76, 31, 32, menu.png:getWidth(), menu.png:getHeight())
	
	menu.healthX = WIDTH / 12
	menu.healthY = 30
	menu.actionsX = WIDTH / 12
	menu.actionsY = HEIGHT - 80
	menu.hp = 90
	menu.maxHp = 90
	menu.hpPercent = math.floor((menu.hp / menu.maxHp) * 100)
	menu.picked = nil
	
	menu.fight = {}
	menu.fight.x = menu.actionsX + 31.5
	menu.fight.y = menu.actionsY + 4.5
	menu.fight.w = 46.5
	menu.fight.h = 48
	menu.fight.a = 0
	
	menu.act = {}
	menu.act.x = menu.fight.x + menu.fight.w + 6
	menu.act.y = menu.fight.y
	menu.act.a = 0
	
	menu.item = {}
	menu.item.x = menu.act.x + menu.fight.w + 6
	menu.item.y = menu.act.y
	menu.item.a = 0
	
	menu.spare = {}
	menu.spare.x = menu.item.x + menu.fight.w + 6
	menu.spare.y = menu.item.y
	menu.spare.a = 0
	
	menu.defend = {}
	menu.defend.x = menu.spare.x + menu.fight.w + 6
	menu.defend.y = menu.spare.y
	menu.defend.a = 0
	
	menu.bar = {}
	menu.bar.x = menu.healthX + 128
	menu.bar.y = menu.healthY + 21
	menu.bar.w = 76
	menu.bar.max = 76
	menu.bar.h = 9
	menu.bar.percent = math.floor((menu.bar.w / menu.bar.max) * 100)
	
	menu.lines = love.graphics.newQuad(151, 38, 1, 34, menu.png:getWidth(), menu.png:getHeight())
	lines.list = {}
	
	box.x = menu.actionsX + (213 * 3.2) + 10
	box.y = menu.actionsY - 10
	box.w = -(213 * 1.7)
	box.h = (38 * 1.5) + 20
	box.a = 1
	
	box.x1 = box.x - box.w + 30
	
	box.x2n3 = box.x - (box.w / 3) * 2 + 30
	box.x3n3 = box.x - (box.w / 3) + 30
	
	box.x2n4 = box.x - (box.w / 4) * 3 + 30
	box.x3n4 = box.x - (box.w / 4) * 2 + 30
	box.x4n4 = box.x - (box.w / 4) + 30
	
	back = {}
	back.x = WIDTH / 12
	back.y = menu.actionsY - 60
	back.w = 65
	back.h = 35
	back.c = {1, 1, 1, 1}
end

function fight:update(dt)
	if PAUSE then return end
	
	menu.hpPercent = math.floor((menu.hp / menu.maxHp) * 100)
	
	lines:update(dt)
	
	timer = timer + dt
	
	if timer > 0.5 then
		timer = 0
		lines.new(true)
		lines.new(false)
	end
	
	local actionsTargetX
	local boxTargetW
	
	if menu.actionsHide then
    	actionsTargetX = -320
		boxTargetW = 213 * 3.3
	else
    	actionsTargetX = WIDTH / 12
		boxTargetW = 213 * 1.7
	end

	if math.abs(actionsTargetX - menu.actionsX) > 0.5 then
    	menu.actionsX = menu.actionsX + (actionsTargetX - menu.actionsX) * menu.animSpeed * dt
		box.w = box.w + (boxTargetW - box.w) * menu.animSpeed * dt
	else
    	menu.actionsX = actionsTargetX
		box.w = boxTargetW
	end
	
	box.x1 = box.x - box.w + 30
	
	box.x2n3 = box.x - (box.w / 3) * 2 + 30
	box.x3n3 = box.x - (box.w / 3) + 30
	
	box.x2n4 = box.x - (box.w / 4) * 3 + 30
	box.x3n4 = box.x - (box.w / 4) * 2 + 30
	box.x4n4 = box.x - (box.w / 4) + 30
	
	menu.fight.x = menu.actionsX + 31.5
	menu.act.x = menu.fight.x + menu.fight.w + 6
	menu.item.x = menu.act.x + menu.fight.w + 6
	menu.spare.x = menu.item.x + menu.fight.w + 6
	menu.defend.x = menu.spare.x + menu.fight.w + 6
	
	kris:update(dt)
	for i, npcName in ipairs(npc) do
		npc[i]:update(dt)
	end
end

function fight:drawUI()
	kris:draw()
	for i, npcName in ipairs(npc) do
		npc[i]:draw()
	end	
	
	if saveData["options"]["currentLang"] == "en" then
	    love.graphics.draw(menu.png, menu.healthEn, menu.healthX, menu.healthY, 0, 1, 1)
		love.graphics.draw(menu.png, menu.actionsEn, menu.actionsX, menu.actionsY, 0, 1.5, 1.5)
		
		love.graphics.setColor(1, 1, 1, menu.fight.a)
		love.graphics.draw(menu.png, menu.fightEn, menu.fight.x, menu.fight.y, 0, 1.5, 1.5)
		love.graphics.setColor(1, 1, 1, menu.act.a)
		love.graphics.draw(menu.png, menu.actEn, menu.act.x, menu.act.y, 0, 1.5, 1.5)
		love.graphics.setColor(1, 1, 1, menu.item.a)
		love.graphics.draw(menu.png, menu.itemEn, menu.item.x, menu.item.y, 0, 1.5, 1.5)
		love.graphics.setColor(1, 1, 1, menu.spare.a)
		love.graphics.draw(menu.png, menu.spareEn, menu.spare.x, menu.spare.y, 0, 1.5, 1.5)
		love.graphics.setColor(1, 1, 1, menu.defend.a)
		love.graphics.draw(menu.png, menu.defendEn, menu.defend.x, menu.defend.y, 0, 1.5, 1.5)
	else	
	    love.graphics.draw(menu.png, menu.healthRu, menu.healthX, menu.healthY, 0, 1, 1)
		love.graphics.draw(menu.png, menu.actionsRu, menu.actionsX, menu.actionsY, 0, 1.5, 1.5)
		
		love.graphics.setColor(1, 1, 1, menu.fight.a)
		love.graphics.draw(menu.png, menu.fightRu, menu.fight.x, menu.fight.y, 0, 1.5, 1.5)
		love.graphics.setColor(1, 1, 1, menu.act.a)
		love.graphics.draw(menu.png, menu.actRu, menu.act.x, menu.act.y, 0, 1.5, 1.5)
		love.graphics.setColor(1, 1, 1, menu.item.a)
		love.graphics.draw(menu.png, menu.itemRu, menu.item.x, menu.item.y, 0, 1.5, 1.5)
		love.graphics.setColor(1, 1, 1, menu.spare.a)
		love.graphics.draw(menu.png, menu.spareRu, menu.spare.x, menu.spare.y, 0, 1.5, 1.5)
		love.graphics.setColor(1, 1, 1, menu.defend.a)
		love.graphics.draw(menu.png, menu.defendRu, menu.defend.x, menu.defend.y, 0, 1.5, 1.5)
	end
	
	love.graphics.setColor(0, 1, 1)
	love.graphics.rectangle("fill", menu.bar.x, menu.bar.y, (menu.hpPercent / 100) * menu.bar.max, menu.bar.h)
	love.graphics.setColor(1, 1, 1)
    
	love.graphics.setFont(hpFont)
	love.graphics.print(menu.hp, menu.healthX + 135, menu.healthY + 9, 0, 1, 1)
	love.graphics.print(menu.maxHp, menu.healthX + 180, menu.healthY + 9, 0, 1, 1)
	love.graphics.setFont(regular)
	
	lines:draw()
	
	love.graphics.setColor(0, 0, 0, box.a)
	love.graphics.rectangle("fill", box.x, box.y, -box.w, box.h)
    
	love.graphics.setLineWidth(2)
	love.graphics.setColor(1, 1, 1, box.a)
	love.graphics.rectangle("line", box.x, box.y, -box.w, box.h)
	love.graphics.setLineWidth(1)
	
	if menu.state == "attack" or
	   menu.state == "act" or
	   menu.state == "item" or
	   menu.state == "spare" then
		love.graphics.setLineWidth(2)   
		drawButton(t("menu", "back"), back.x, back.y, back.w, back.h, back.c)
	end
	
	love.graphics.setLineWidth(1)
	
	if menu.text then
		love.graphics.print("* Габади габади бу", box.x - box.w + 10, box.y + 10)
	end
	
	love.graphics.print(menu.state, 0, 0)
end

function fight:touchpressed(id, x, y)
	if PAUSE then return end
	
	if zone(back.x, back.y, back.w, back.h, x, y) then
		touch[id] = "back"
		back.c = {1, 1, 1, 0.5}
	end	
	
	if not menu.actionsHide then
	if zone(menu.fight.x, menu.fight.y, menu.fight.w, menu.fight.h, x, y) then
		menu.fight.a = 1
		touch[id] = "fight"
		
		menu.act.a = 0
		menu.item.a = 0
		menu.spare.a = 0
		menu.defend.a = 0
	elseif zone(menu.act.x, menu.act.y, menu.fight.w, menu.fight.h, x, y) then
		menu.act.a = 1
		touch[id] = "act"
		
		menu.fight.a = 0
		menu.item.a = 0
		menu.spare.a = 0
		menu.defend.a = 0
	elseif zone(menu.item.x, menu.item.y, menu.fight.w, menu.fight.h, x, y) then
		menu.item.a = 1
		touch[id] = "item"
		
		menu.fight.a = 0
		menu.act.a = 0
		menu.spare.a = 0
		menu.defend.a = 0
	elseif zone(menu.spare.x, menu.spare.y, menu.fight.w, menu.fight.h, x, y) then
		menu.spare.a = 1
		touch[id] = "spare"
		
		menu.fight.a = 0
		menu.act.a = 0
		menu.item.a = 0
		menu.defend.a = 0
	elseif zone(menu.defend.x, menu.defend.y, menu.fight.w, menu.fight.h, x, y) then
		menu.defend.a = 1
		touch[id] = "defend"
		
		menu.fight.a = 0
		menu.act.a = 0
		menu.item.a = 0
		menu.spare.a = 0
	end
	end
end	

function fight:touchreleased(id, x, y)
	if touch[id] == "back" then
		back.c = {1, 1, 1, 1}
		if menu.state == "attack" then
			scene:pop("fightAttack")
			menu.state = "neutral"
			menu.text = true
			menu.actionsHide = false
			kris:anSelect("idle")
		elseif menu.state == "act" then
			scene:pop("fightAct")
			menu.state = "neutral"
			menu.text = true
			menu.actionsHide = false
			kris:anSelect("backToIdle")
		elseif menu.state == "item" then
			scene:pop("fightItem")
			menu.state = "neutral"
			menu.text = true
			menu.actionsHide = false
			kris:anSelect("backToIdle")
		elseif menu.state == "spare" then
			scene:pop("fightSpare")
			menu.state = "neutral"
			menu.text = true
			menu.actionsHide = false
			kris:anSelect("idle")
		end
    elseif touch[id] == "fight" then
		if menu.state == "preAttack" then
			menu.fight.a = 0
			menu.state = "attack"
			menu.text = false
		    kris:anSelect("attack")
		    scene:push("fightAttack", "tutorial")
		else
		    menu.state = "preAttack"
		end	
	elseif touch[id] == "act" then
		if menu.state == "preAct" then
			menu.act.a = 0
			menu.state = "act"
			menu.text = false
		    kris:anSelect("prepare")
			scene:push("fightAct", "tutorial")
		else
		    menu.state = "preAct"
		end	
	elseif touch[id] == "item" then
		if menu.state == "preItem" then
			menu.item.a = 0
			menu.state = "item"
			menu.text = false
		    kris:anSelect("item")
		else
			menu.fight.a = 0
			menu.act.a = 0
			menu.spare.a = 0
			menu.defend.a = 0
			
		    menu.state = "preItem"
		end	
	elseif touch[id] == "spare" then
		if menu.state == "preSpare" then
			menu.spare.a = 0
			menu.state = "spare"
			menu.text = false
		    kris:anSelect("finish")
		else
			menu.fight.a = 0
			menu.act.a = 0
			menu.item.a = 0
			menu.defend.a = 0	
			
		    menu.state = "preSpare"
		end	
	elseif touch[id] == "defend" then
		if menu.state == "preDefend" then
			menu.defend.a = 0
			menu.state = "defend"
		    kris:anSelect("shield")
		else
			menu.fight.a = 0
			menu.act.a = 0
			menu.item.a = 0
			menu.spare.a = 0
			
		    menu.state = "preDefend"
		end	
	end
	
	touch[id] = nil	
end

-- анимация линий в окошке меню
function lines.new(side)
	local line = {}
	line.side = side
	-- true это слева, false это справа
	
	if line.side then
	    line.x = 0
	else
		line.x = 210 * 1.5
	end
		
	line.y = 0
	line.a = 1
	
	table.insert(lines.list, line)
	return line
end

function lines:update(dt)
	for i = #lines.list, 1, -1 do
		local line = lines.list[i]
		
		if line.side then
		    line.x = line.x + 20 * dt
		else
			line.x = line.x - 20 * dt
		end
		
		line.a = line.a - 0.6 * dt
		
		if line.a < 0 then
			table.remove(lines.list, i)
		end
	end
end

function lines.draw()
	for _, line in ipairs(lines.list) do
		love.graphics.setColor(1, 1, 1, line.a)
		love.graphics.draw(menu.png, menu.lines, menu.actionsX + line.x, menu.actionsY + line.y, 0, 4, 1.6)
	end
	
	love.graphics.setColor(1, 1, 1, 1)	
end

-- передача
function fight.getKris()
	return kris
end

function fight.getNpc()
	return npc
end

function fight.getMenu()
	return menu
end	

function fight.getBox()
	return box
end	

return fight