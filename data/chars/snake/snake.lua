local snake = {}
local anim = require "data/libs/anim8"

local kris

hitboxes = false

function snake.new(x, y, Kris)
	local self = {
		x = x or 50,
		y = y or 50,
		cr = 50,
		sprite = nil,
		kris = Kris
	}
	
	self.png = love.graphics.newImage("data/chars/snake/snakeSit.png")
	
	self.body = hc.circle(self.x + 20, self.y + 40, self.cr)
	
	return setmetatable(self, {__index = snake})
end

function snake:update(dt)
	if PAUSE then
		return
	end	
	
	local collides, dx, dy = self.body:collidesWith(self.kris)
	
	if collides then
		talk = "snake"
	else
		talk = nil
	end	
end

function snake:draw()
	love.graphics.draw(self.png, self.x, self.y, 0, 2, 2)
	
	if hitboxes then
	    love.graphics.circle("line", self.x + 20, self.y + 40, self.cr)
	end
end

return snake