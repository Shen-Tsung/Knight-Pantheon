local fightBox = {}

local Box = {}
local boxes = {}
local player
local attacks

local timer
local flag = {}

local animation

function Box.new(alpha)
	local box = {}
	box.w = 150
	box.h = 150
	box.x = WIDTH / 1.8
	box.y = HEIGHT / 2
	box.png = love.graphics.newImage("data/fight/fight.png")
	box.quad = love.graphics.newQuad(0, 0, 150, 150, box.png:getWidth(), box.png:getHeight())
	box.size = 0
	box.rotate = -3
	box.timer = 0
	box.animation = true
	box.a = alpha
	
	table.insert(boxes, box)
	
	return box
end

function Box:update(dt)
	for i, box in ipairs(boxes) do
	
	    if box.animation then
			if box.size < 1.5 then
			    box.size = box.size + 0.03
				box.rotate = box.rotate + 0.06
			end
	    else
		    if box.size > 0 then
			    box.size = box.size - 0.03
			    box.rotate = box.rotate - 0.06
		    else
			    table.remove(boxes, i)
		    end	
	    end
		
	
	    box.timer = box.timer + dt
	
	    if box.timer > 5 then
		    box.animation = false
	    end
	end	
end

function Box:draw()
	for _, box in pairs(boxes) do
		love.graphics.setColor(1, 1, 1, box.a)
	    love.graphics.draw(box.png, box.quad, box.x, box.y, box.rotate, box.size, box.size, box.w / 2, box.h / 2)
		love.graphics.setColor(1, 1, 1, 1)
	end	
end	

function fightBox:whenAdded()
	for i = #boxes, 1, -1 do
		table.remove(boxes, i)
	end	
	
	timer = 0
	flag.a = true
	flag.b = true
	
	Box.new(1)
end

function fightBox:update(dt)
	Box:update(dt)
	
	timer = timer + dt
	
	if timer >= 0.07 and flag.a then
		Box.new(0.5)
		flag.a = false
	elseif timer >= 0.14 and flag.b then
		Box.new(0.3)
		flag.b = false
	end		
	
	if timer > 6 then
		scene:pop("fightBox")
	end	
end

function fightBox:draw()
	Box:draw()
end

return fightBox