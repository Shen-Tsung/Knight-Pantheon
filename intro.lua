local intro = {}

local logo
local fade
local timer

function intro:load()
	logo = love.graphics.newImage("assets/ui/introLogo.png")
end

function intro:whenAdded()
	fade = 1
	timer = 0
end	

function intro:update(dt)
	timer = timer + dt
	
	if timer > 2 then
		scene:clearStack()
		scene:push("menu")
	elseif timer > 1.5 and fade < 1 then
		fade = fade + 2 * dt
	elseif timer > 0 and fade > 0 then
	    fade = fade - 2 * dt		
	end
end

function intro:draw()
	love.graphics.draw(logo, 480, 150, 0, 1.5, 1.5)
	love.graphics.setColor(0, 0, 0, fade)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
end	

return intro