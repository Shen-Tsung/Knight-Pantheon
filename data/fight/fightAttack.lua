local fightAttack = {}

local bar = {}
local player = {}
local target = {}
local state

local timer
local attack

local touch = {}

local trail = {}
local images = {}

local fight = require "data/fight/fight"
local kris
local menu
local box
local npc = {}

local function attacking()
	if not player.finish then
	    playSound("krisAttack")
	
	    kris.anim.current:resume()
	    kris:anSelect("attack")
	    attack = true
	end	
end

function images.after()
	local image = {}
	image.x = player.x
	image.y = player.y
	image.a = 0.75
	
	table.insert(trail, image)
	
	return image
end

function images:update(dt)
	for i, image in ipairs(trail) do
		if image.a > 0 then
		    image.a = image.a - 0.025
		else
			table.remove(trail, i)
		end		
	end
end

function images:draw()
	for _, image in pairs(trail) do
		love.graphics.setColor(1, 1, 1, image.a)
		love.graphics.draw(bar.png, player.quad, image.x, image.y, 0, 1.7, 1.7, 3, 18)
	end	
end	
	 
function fightAttack:load()
	bar.png = love.graphics.newImage("data/fight/fight.png")
	bar.quad = love.graphics.newQuad(156, 115, 119, 35, bar.png:getWidth(), bar.png:getHeight())
	player.quad = love.graphics.newQuad(282, 114, 6, 36, bar.png:getWidth(), bar.png:getHeight())
	target.quad = love.graphics.newQuad(289, 114, 10, 36, bar.png:getWidth(), bar.png:getHeight())
end

function fightAttack:whenAdded(npcData)
	state = "target"
	
	menu = fight.getMenu()
	box = fight.getBox()
	kris = fight.getKris()
	npc.data = fight.getNpc()
	
	npc.name = npcData
	
	npc.props = {
		one = {
			x = box.x1, y = box.y + 10, name = },
		two = {
			x = box.x2n3, y = box.y + 10, name = npc.data[2]},
		three = {
			x = box.x3n3, y = box.y + 10, name = npc.data[3]}
	}
	
	if #npcs == 1 then
		npc.props.one.x = box.x1
		npc.props.one.name = npcs[1]
	elseif #npcs == 2 then
		npc.props.one.x = box.x1
		npc.props.one.name = npcs[1]
		npc.props.two.x = box.x3n4
		npc.props.two.name = npcs[2]
	elseif #npcs == 3 then
		npc.props.one.x = box.x1
		npc.props.one.name = npcs[1]
		npc.props.two.x = box.x2n3
		npc.props.two.name = npcs[2]
		npc.props.three.x = box.x3n3
		npc.props.three.name = npcs[3]
	end		
	
	kris.anim.current:pause()
	
	menu.actionsHide = true
	
	timer = 0
	attack = false
	
	bar.w = 119 * 1.7
	bar.h = 35 * 1.7
	bar.x = box.x + (-(box.w * 2) - bar.w) / 2
	bar.y = box.y + (box.h - bar.h) / 2
	
	target.x = bar.x
	target.y = bar.y - 2
	
	player.x = math.random(bar.x + bar.w, box.x - box.w)
	player.y = target.y + (18 * 1.7)
	player.size = 1.7
	player.a = 1
	player.color = {1, 1, 1, player.a}
	player.finish = false
end

function fightAttack:update(dt)
	if PAUSE then return end
	if state == "target" then
		if #npcs == 1 then
			npc.props.one.x = box.x1
		elseif #npcs == 2 then
			npc.props.one.x = box.x1
			npc.props.two.x = box.x3n4
		elseif #npcs == 3 then
			npc.props.one.x = box.x1
			npc.props.two.x = box.x2n3
			npc.props.three.x = box.x3n3
		end
	elseif state == "attack" then
		timer = timer + dt
	
		if attack then
			player.x = player.x
			player.a = player.a - 3 * dt
			player.color = {1, 1, 0, player.a}
			player.size = player.size + 7.5 * dt
			if player.a <= -5 then
				kris:anSelect("backAttack")
				scene:pop("fightAttack")
				menu.actionsHide = false
				menu.text = true
				menu.state = "neutral"
			end
		else
			if timer >= 0.15 then
				images.after()
				timer = 0
			end	
			player.x = player.x - 120 * dt
		end
	end	
	
	if player.x < target.x - 30 then
		attacking()
		player.finish = true
	end
	
	images:update(dt)	
end

function fightAttack:drawUI()
	love.graphics.setScissor(box.x - box.w, box.y, box.w, box.h)
	
	if state == "target" then
		if #npcs == 1 then
			love.graphics.printf()
		elseif #npcs == 2 then
			love.graphics.printf(t("fights", npc), action.one.x, box.y + 10, 140, "left")
		elseif #npcs == 3 then
			
		end
	elseif state == "attack" then	
	love.graphics.setColor(1, 1, 1, player.a)
	love.graphics.draw(bar.png, bar.quad, bar.x, bar.y, 0, 1.7, 1.7)
	
	images:draw()
	
	love.graphics.setColor(player.color)
	love.graphics.draw(bar.png, player.quad, player.x, player.y, 0, player.size, player.size, 3, 18)
	
	love.graphics.setColor(1, 1, 1, player.a)
	love.graphics.printf(t("hud", "press"), target.x - 60, target.y + 5, 50, "right")
	love.graphics.draw(bar.png, target.quad, target.x, target.y, 0, 1.7, 1.7)
	
	love.graphics.setScissor()
end

function fightAttack:touchpressed(id, x, y)
	if PAUSE then return end
	
	touch[id] = "attack"
end	

function fightAttack:touchreleased(id, x, y)
	if PAUSE then return end
	
	if touch[id] == "attack" and not attack then
	    attacking()
	end
	
	touch[id] = nil		
end	

return fightAttack