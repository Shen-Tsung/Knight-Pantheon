local fightAttack = {}

local bar = {}
local player = {}
local targetAttack = {}
local krisDamage
local state
local target

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
local Npc

local function attacking(t)
	if not player.finish then
	    playSound("krisAttack")
	
	    kris.anim.current:resume()
	    kris:anSelect("attack")
	    attack = true
		
		npc.data[t].hp = npc.data[t].hp - krisDamage
		
		if krisDamage >= 25 and krisDamage <= 27 then
			player.perfect = true
		end	
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
	targetAttack.quad = love.graphics.newQuad(289, 114, 10, 36, bar.png:getWidth(), bar.png:getHeight())
end

function fightAttack:whenAdded(Npc)
	state = "target"
	target = 1
	
	menu = fight.getMenu()
	box = fight.getBox()
	kris = fight.getKris()
	npc.data = fight.getNpc()
	npc.name = fight.getNpcs()
	Npc = Npc
	
	-- Меню выбора
	npc.props = {
		one = {
			x = box.x1, y = box.y + 10, name = t("fights", Npc, "name")},
		two = {
			x = box.x2n3, y = box.y + 10, name = t("fights", Npc, "name")},
		three = {
			x = box.x3n3, y = box.y + 10, name = t("fights", Npc, "name")}
	}
	
	npc.hpBar = {}
	
	if #npc.name == 1 then
		npc.props.one.x = box.x1
		npc.props.one.name = t("fights", Npc, "name")
		npc.props.one.a = 1
		
		npc.hpBar.one = {}
		npc.hpBar.one.x = npc.props.one.x
		npc.hpBar.one.y = npc.props.one.y + 20
		npc.hpBar.one.w = npc.data[1].hp
		npc.hpBar.one.border = npc.data[1].maxHp
	elseif #npc.name == 2 then
		npc.props.one.x = box.x1
		npc.props.one.name = t("fights", Npc, "name")
		npc.props.one.a = 1
		npc.props.two.x = box.x3n4
		npc.props.two.name = t("fights", Npc, "name")
		npc.props.two.a = 1
		
		npc.hpBar.one = {}
		npc.hpBar.one.x = npc.props.one.x
		npc.hpBar.one.y = npc.props.one.y + 20
		npc.hpBar.one.w = npc.data[1].hp
		npc.hpBar.one.border = npc.data[1].maxHp
		
		npc.hpBar.two = {}
		npc.hpBar.two.x = npc.props.two.x
		npc.hpBar.two.y = npc.props.two.y + 20
		npc.hpBar.two.w = npc.data[2].hp
		npc.hpBar.two.border = npc.data[2].maxHp
	elseif #npc.name == 3 then
		npc.props.one.x = box.x1
		npc.props.one.name = t("fights", Npc, "name")
		npc.props.one.a = 1
		npc.props.two.x = box.x2n3
		npc.props.two.name = t("fights", Npc, "name")
		npc.props.two.a = 1
		npc.props.three.x = box.x3n3
		npc.props.three.name = t("fights", Npc, "name")
		npc.props.three.a = 1
		
		npc.hpBar.one = {}
		npc.hpBar.one.x = npc.props.one.x
		npc.hpBar.one.y = npc.props.one.y + 20
		npc.hpBar.one.w = npc.data[1].hp
		npc.hpBar.one.border = npc.data[1].maxHp
		
		npc.hpBar.two = {}
		npc.hpBar.two.x = npc.props.two.x
		npc.hpBar.two.y = npc.props.two.y + 20
		npc.hpBar.two.w = npc.data[2].hp
		npc.hpBar.two.border = npc.data[2].maxHp
		
		npc.hpBar.three = {}
		npc.hpBar.three.x = npc.props.three.x
		npc.hpBar.three.y = npc.props.three.y + 20
		npc.hpBar.three.w = npc.data[3].hp
		npc.hpBar.three.border = npc.data[3].maxHp
	end
	
	-- Атака
	menu.actionsHide = true
	
	timer = 0
	attack = false
	
	bar.w = 119 * 1.7
	bar.h = 35 * 1.7
	bar.x = box.x + (-(box.w * 2) - bar.w) / 2
	bar.y = box.y + (box.h - bar.h) / 2
	
	targetAttack.x = bar.x
	targetAttack.y = bar.y - 2
	
	player.x = bar.x + bar.w + 10
	player.y = targetAttack.y + (18 * 1.7)
	player.size = 1.7
	player.a = 1
	player.color = {1, 1, 1, player.a}
	player.perfect = false
	player.finish = false
	
	krisDamage = 0
end

function fightAttack:update(dt)
	if PAUSE then return end
	
	if state == "target" then
		if #npc.name == 1 then
			npc.props.one.x = box.x1
			npc.hpBar.one.x = npc.props.one.x
		elseif #npc.name == 2 then
			npc.props.one.x = box.x1
			npc.props.two.x = box.x3n4
			npc.hpBar.one.x = npc.props.one.x
			npc.hpBar.two.x = npc.props.two.x
		elseif #npc.name == 3 then
			npc.props.one.x = box.x1
			npc.props.two.x = box.x2n3
			npc.props.three.x = box.x3n3
			npc.hpBar.one.x = npc.props.one.x
			npc.hpBar.two.x = npc.props.two.x
			npc.hpBar.three.x = npc.props.three.x
		end
	elseif state == "attack" then
		timer = timer + dt
		
		if not attack and player.x > targetAttack.x + 10 then
			krisDamage = krisDamage + 20 * dt
		end
		
		if attack then
			player.x = player.x
			player.a = player.a - 3 * dt
			if player.perfect then
				player.color = {1, 1, 0, player.a}
			else	
				player.color = {0, 1, 1, player.a}
			end	
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
			player.x = player.x - 150 * dt
		end
	end	
	
	if player.x < targetAttack.x - 30 then
		krisDamage = 10
		attacking(target)
		player.finish = true
	elseif player.x < targetAttack.x + 10 then
		if not attack then
			krisDamage = krisDamage - 50 * dt
		end	
	end
	
	images:update(dt)	
end

function fightAttack:drawUI()
	love.graphics.setScissor(box.x - box.w, box.y, box.w, box.h)
	
	if state == "target" then
		love.graphics.setColor(1, 1, 1, 1)
		
		if #npc.name == 1 then
			love.graphics.setColor(1, 1, 1, npc.props.one.a)
			love.graphics.printf(npc.props.one.name, npc.props.one.x, npc.props.one.y, 140, "left")
			
			love.graphics.setColor(1, 0, 0, 1)
			love.graphics.rectangle("fill", npc.hpBar.one.x, npc.hpBar.one.y, npc.hpBar.one.w, 20)
			love.graphics.setColor(1, 1, 1)
			love.graphics.rectangle("line", npc.hpBar.one.x, npc.hpBar.one.y, npc.hpBar.one.border, 20)
		elseif #npc.name == 2 then
			love.graphics.setColor(1, 1, 1, npc.props.one.a)
			love.graphics.printf(npc.props.one.name, npc.props.one.x, npc.props.one.y, 140, "left")
			love.graphics.setColor(1, 1, 1, npc.props.two.a)
			love.graphics.printf(npc.props.two.name, npc.props.two.x, npc.props.two.y, 140, "left")
			
			love.graphics.setColor(1, 1, 1, 0.5)
			love.graphics.line(box.x3n4 - 30, box.y, box.x3n4 - 30, box.y + box.h)
			
			love.graphics.setColor(1, 0, 0, 1)
			love.graphics.rectangle("fill", npc.hpBar.one.x, npc.hpBar.one.y, npc.hpBar.one.w, 20)
			love.graphics.setColor(1, 1, 1)
			love.graphics.rectangle("line", npc.hpBar.one.x, npc.hpBar.one.y, npc.hpBar.one.border, 20)
			love.graphics.setColor(1, 0, 0, 1)
			love.graphics.rectangle("fill", npc.hpBar.two.x, npc.hpBar.two.y, npc.hpBar.two.w, 20)
			love.graphics.setColor(1, 1, 1)
			love.graphics.rectangle("line", npc.hpBar.two.x, npc.hpBar.two.y, npc.hpBar.two.border, 20)
		elseif #npc.name == 3 then
			love.graphics.setColor(1, 1, 1, npc.props.one.a)
			love.graphics.printf(npc.props.one.name, npc.props.one.x, npc.props.one.y, 140, "left")
			love.graphics.setColor(1, 1, 1, npc.props.two.a)
			love.graphics.printf(npc.props.two.name, npc.props.two.x, npc.props.two.y, 140, "left")
			love.graphics.setColor(1, 1, 1, npc.props.three.a)
			love.graphics.printf(npc.props.three.name, npc.props.three.x, npc.props.three.y, 140, "left")
			
			love.graphics.setColor(1, 1, 1, 0.5)
			love.graphics.line(box.x2n3 - 30, box.y, box.x2n3 - 30, box.y + box.h)
			love.graphics.line(box.x3n3 - 30, box.y, box.x3n3 - 30, box.y + box.h)
			
			love.graphics.setColor(1, 0, 0, 1)
			love.graphics.rectangle("fill", npc.hpBar.one.x, npc.hpBar.one.y, npc.hpBar.one.w, 20)
			love.graphics.setColor(1, 1, 1)
			love.graphics.rectangle("line", npc.hpBar.one.x, npc.hpBar.one.y, npc.hpBar.one.border, 20)
			love.graphics.setColor(1, 0, 0, 1)
			love.graphics.rectangle("fill", npc.hpBar.two.x, npc.hpBar.two.y, npc.hpBar.two.w, 20)
			love.graphics.setColor(1, 1, 1)
			love.graphics.rectangle("line", npc.hpBar.two.x, npc.hpBar.two.y, npc.hpBar.two.border, 20)
			love.graphics.setColor(1, 0, 0, 1)
			love.graphics.rectangle("fill", npc.hpBar.three.x, npc.hpBar.three.y, npc.hpBar.three.w, 20)
			love.graphics.setColor(1, 1, 1)
			love.graphics.rectangle("line", npc.hpBar.three.x, npc.hpBar.three.y, npc.hpBar.three.border, 20)
		end
	elseif state == "attack" then	
		love.graphics.setColor(1, 1, 1, player.a)
		love.graphics.draw(bar.png, bar.quad, bar.x, bar.y, 0, 1.7, 1.7)
		
		images:draw()
		
		love.graphics.setColor(player.color)
		love.graphics.draw(bar.png, player.quad, player.x, player.y, 0, player.size, player.size, 3, 18)
		
		love.graphics.setColor(1, 1, 1, player.a)
		love.graphics.printf(t("hud", "press"), targetAttack.x - 60, targetAttack.y + 5, 50, "right")
		love.graphics.draw(bar.png, targetAttack.quad, targetAttack.x, targetAttack.y, 0, 1.7, 1.7)
	end
	
	love.graphics.setScissor()
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(math.floor(krisDamage, 0), 100, 100, 100, "right")
end

function fightAttack:touchpressed(id, x, y)
	if PAUSE then return end
	
	if state == "target" then
		if #npc.name == 1 then
			if zone(box.x, box.y, box.w, box.h, x, y) then
				touch[id] = 2
				npc.props.one.a = 0.5
			end	
		elseif #npc.name == 2 then
			if zone(npc.props.one.x - 30, box.y, box.w / 2, box.h, x, y) then
				touch[id] = 1
				npc.props.one.a = 0.5
			elseif zone(npc.props.two.x - 30, box.y, box.w / 2, box.h, x, y) then
				touch[id] = 2
				npc.props.two.a = 0.5
			end	
		elseif #npc.name == 3 then
			if zone(npc.props.one.x - 30, box.y, box.w / 3, box.h, x, y) then
				touch[id] = 1
				npc.props.one.a = 0.5
			elseif zone(npc.props.two.x - 30, box.y, box.w / 3, box.h, x, y) then
				touch[id] = 2
				npc.props.two.a = 0.5
			elseif zone(npc.props.three.x - 30, box.y, box.w / 3, box.h, x, y) then
				touch[id] = 3
				npc.props.three.a = 0.5
			end
		end
	else
		touch[id] = "attack"
	end
end

function fightAttack:touchmoved(id, x, y)
	if PAUSE then return end
	
	if state == "target" then
		if #npc.name == 1 then
			if zone(box.x, box.y, box.w, box.h, x, y) then
				touch[id] = 1
				npc.props.one.a = 0.5
			else
				touch[id] = nil
				npc.props.one.a = 1
			end	
		elseif #npc.name == 2 then
			if zone(npc.props.one.x - 30, box.y, box.w / 2, box.h, x, y) then
				touch[id] = 1
				npc.props.one.a = 0.5
				npc.props.two.a = 1
			elseif zone(npc.props.two.x - 30, box.y, box.w / 2, box.h, x, y) then
				touch[id] = 2
				npc.props.two.a = 0.5
				npc.props.one.a = 1
			else
				touch[id] = nil
				npc.props.one.a = 1
				npc.props.two.a = 1
			end	
		elseif #npc.name == 3 then
			if zone(npc.props.one.x - 30, box.y, box.w / 3, box.h, x, y) then
				touch[id] = 1
				npc.props.one.a = 0.5
				npc.props.two.a = 1
				npc.props.three.a = 1
			elseif zone(npc.props.two.x - 30, box.y, box.w / 3, box.h, x, y) then
				touch[id] = 2
				npc.props.two.a = 0.5
				npc.props.one.a = 1
				npc.props.three.a = 1
			elseif zone(npc.props.three.x - 30, box.y, box.w / 3, box.h, x, y) then
				touch[id] = 3
				npc.props.three.a = 0.5
				npc.props.one.a = 1
				npc.props.two.a = 1
			else
				touch[id] = nil
				npc.props.one.a = 1
				npc.props.two.a = 1
				npc.props.three.a = 1
			end	
		end
	else
		touch[id] = "attack"
	end
end	

function fightAttack:touchreleased(id, x, y)
	if PAUSE then return end
	
	if touch[id] == 1 then
		state = "attack"
		target = 1
		menu.state = "attacking"
	elseif touch[id] == 2 then
		state = "attack"
		target = 2
		menu.state = "attacking"
	elseif touch[id] == 3 then
		state = "attack"
		target = 3
		menu.state = "attacking"
	else		
		if touch[id] == "attack" and not attack then
			attacking(target)
		end
	end	
	
	touch[id] = nil		
end	

return fightAttack