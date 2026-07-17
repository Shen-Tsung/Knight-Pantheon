local input = {}
local joystick = {}
local joy = {}
local stick = {}
local action = {}
local pause = {}

local touch = {}

local krisRef = nil
function input:setKris(kris)
	krisRef = kris
end	

function input:getDirection()
	local dx = (stick.x - joy.x) / joy.r
	local dy = (stick.y - joy.y) / joy.r
	
	local len = math.sqrt(dx * dx + dy * dy)
	
	if len > 0.2 then
		dx = dx / len
		dy = dy / len
		input.active = true
	else
		dx = 0
		dy = 0
		input.active = false
	end
	
	return dx, dy
end

function input:load()
	joy.png = love.graphics.newImage("data/assets/ui/hud/joy.png")
	stick.png = love.graphics.newImage("data/assets/ui/hud/stick.png")
	action.png = love.graphics.newImage("data/assets/ui/hud/action.png")
	action.idle = love.graphics.newImage("data/assets/ui/hud/unAction.png")
	pause.png = love.graphics.newImage("data/assets/ui/hud/pause.png")
	
	actionG = false
    joystickG = false
	joyG = {}
	joyG.x = nil
	joyG.y = nil
	stickG = {}
	stickG.x = nil
	stickG.y = nil
end

function input:whenAdded()
	input.active = false
	
	pause.x = WIDTH / 1.1
	pause.y = 50
	pause.alpha = 0.7
	pause.w = pause.png:getWidth()
	pause.h = pause.png:getHeight()
	
	joystick.x = WIDTH / 7
	joystick.y = HEIGHT - 100
	joystick.alpha = 0.7
	joystick.active = false
	
	joy.x = joystick.x
	joy.y = joystick.y
	joy.r = fit(70)
	
	stick.x = joystick.x
	stick.y = joystick.y
	stick.r = fit(60)
	
	action.x = (WIDTH / 2) + WIDTH / 2.8
	action.y = HEIGHT - 100
	action.w = action.png:getWidth()
	action.h = action.png:getHeight()
	action.r = fit(80)
	action.active = false
	action.alpha = 0.7
	
	if actionG then
		action.active = true
		action.alpha = 0.85
	end
	
	if joystickG then
		joystick.active = true
		input.active = true
		joystick.alpha = 0.85
		joy.x = joyG.x
	    joy.y = joyG.y
		stick.x = stickG.x
		stick.y = stickG.y
	end
end

function input:drawUI()
	love.graphics.setColor(1, 1, 1, pause.alpha)
	love.graphics.draw(pause.png, pause.x, pause.y, 0, fit(), fit(), pause.w / 2, pause.h / 2)
	
	if inputHide then return end	
	
	love.graphics.setColor(1, 1, 1, joystick.alpha)
	love.graphics.draw(joy.png, joy.x, joy.y, 0, fit(), fit(), joy.png:getWidth() / 2, joy.png:getHeight() / 2)
	love.graphics.draw(stick.png, stick.x, stick.y, 0, fit(), fit(), stick.png:getWidth() / 2, stick.png:getHeight() / 2)
	
	love.graphics.setColor(1, 1, 1, action.alpha)
	if talk then
	    love.graphics.draw(action.png, action.x, action.y, 0, fit(), fit(), action.w / 2, action.h / 2)
	else	
	    love.graphics.draw(action.idle, action.x, action.y, 0, fit(), fit(), action.w / 2, action.h / 2)
	end
end

function input:touchpressed(id, x, y)
	if not PAUSE and zone(pause.x - pause.w / 2, pause.y - pause.h / 2, pause.w, pause.h, x, y) then
		pause.alpha = 0.85
		touch[id] = "pause"
	end
	
	if PAUSE or inputHide then return end
	
	if zone(0, HEIGHT / 2, WIDTH / 2, HEIGHT / 2, x, y) and not joystick.active then
	    joystick.x = x
	    joystick.y = y
	    joy.x = joystick.x
	    joy.y = joystick.y
	    stick.x = joystick.x
	    stick.y = joystick.y
		
		local distance = math.sqrt((x - joy.x)^2 + (y - joy.y)^2)
	
	    if distance <= joy.r then
		    joystickG = true
		    input.active = true
			joystick.active = true
		    joystick.alpha = 0.85
		    touch[id] = "joystick"
	    end
	end
	
	if zone(action.x - action.w / 2, action.y - action.h / 2, action.w, action.h, x, y) and not action.active then
		actionG = true
		action.active = true
	    action.alpha = 0.85
		touch[id] = "action"
	end
end

function input:touchmoved(id, x, y)
	if PAUSE or inputHide then 
		joystickG = false
		joystick.active = false
		input.active = false
	    joystick.alpha = 0.7
	    stick.x, stick.y = joystick.x, joystick.y
	    joyG.x = nil
	    joyG.y = nil
		stickG.x = nil
	    stickG.y = nil
		
		return
	end
		
	if touch[id] == "joystick" then
		local dx, dy = x - joy.x, y - joy.y
		local distance = math.sqrt(dx * dx + dy * dy)
		
		if distance > joy.r then
			dx, dy = dx / distance * joy.r, dy / distance * joy.r
		end
		
		stick.x = joy.x + dx
		stick.y = joy.y + dy
		
		joyG.x = joy.x
		joyG.y = joy.y
		
		stickG.x = stick.x
		stickG.y = stick.y
	end
end

function input:touchreleased(id, x, y)
	if not PAUSE and touch[id] == "pause" or not PAUSE and inputHide and zone(pause.x - pause.w / 2, pause.y - pause.h / 2, pause.w, pause.h, x, y) then
		joystickG = false
		joystick.active = false
		input.active = false
	    joystick.alpha = 0.7
	    stick.x, stick.y = joystick.x, joystick.y
	    joyG.x = nil
	    joyG.y = nil
		stickG.x = nil
	    stickG.y = nil
		
		actionG = false
		action.active = false
		action.alpha = 0.7
		
		PAUSE = true
		
		pause.alpha = 0.7
		scene:push("pause")
		
		touch[id] = nil
	end
	
	if PAUSE or inputHide then return end	
	
	if touch[id] == "joystick" and joystick.active then
		joystickG = false
		joystick.active = false
		input.active = false
		joystick.alpha = 0.7
		
		joystick.x = WIDTH / 7
		joystick.y = HEIGHT - 100
		joy.x, joy.y = joystick.x, joystick.y
		stick.x, stick.y = joystick.x, joystick.y
		
		joyG.x = nil
	    joyG.y = nil
		
		stickG.x = nil
		stickG.y = nil
	end
	
	if touch[id] == "action" and action.active then
		if talk then
			joystickG = false
		    joystick.active = false
		    input.active = false
		    joystick.alpha = 0.7
		    stick.x, stick.y = joystick.x, joystick.y
		    joyG.x = nil
			joyG.y = nil
			stickG.x = nil
		    stickG.y = nil
		
			inputHide = true
			
			local states = {}
            for k in pairs(langData[currentLang][talk]) do
                states[#states + 1] = k
            end
            scene:push("textBox", talk, states[math.random(#states)])
		else
			if hitboxes then
			    hitboxes = false
		    else
			    hitboxes = true
		    end
		end		
		actionG = false
		action.active = false
	    action.alpha = 0.7
	end
	
	touch[id] = nil
end

return input