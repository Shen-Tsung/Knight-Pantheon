local intro = {}

local logo
local fade
local timer

function intro:clean()
	logo = nil
	fade = nil
	timer = nil
end

function intro:load()
	logo = love.graphics.newImage("data/menu/introLogo.png")
	
	fade = 1
	timer = 0
	
	file.sceneClean("full")
	
	file.sceneLoad("bg", "data/menu/bg")
	file.sceneLoad("menu", "data/menu/menu")
end

function intro:update(dt)
	timer = timer + dt
	
	if timer > 2 then
		scene:clearStack()
		intro:clean()
		file.sceneClean("intro")
		scene:push("bg")
		scene:push("menu")
	elseif timer > 1.5 and fade < 1 then
		fade = fade + 2 * dt
	elseif timer > 0 and fade > 0 then
	    fade = fade - 2 * dt		
	end
end

function intro:drawUI()
	love.graphics.draw(logo, (WIDTH - logo:getWidth() / 2) / 2.4, 70, 0, 1, 1)
	love.graphics.setColor(0, 0, 0, fade)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
end

function intro:touchreleased()
	scene:clearStack()
	intro:clean()
	file.sceneClean("intro")
	
	scene:push("bg")
	scene:push("menu")
end

return intro