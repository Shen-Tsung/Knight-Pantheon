local kris = {}
local anim = require "data/libs/anim8"
local walls

local anTime = 0

local inputRef = nil
function kris:setInput(input)
	inputRef = input
end	

hitboxes = false

function kris:getDirection(dx, dy)
    if dx == 0 and dy == 0 then
		return self.lastAngle or 0
	end
	
    local angle = math.atan2(dy, dx)
    self.lastAngle = angle
    return angle
end

function kris:getAngle(dx, dy)
    local angle = self:getDirection(dx, dy)
    local deg = math.deg(angle) % 360
    
    if deg >= 45 and deg < 135 then return "down" end
    if deg >= 135 and deg < 225 then return "left" end
    if deg >= 225 and deg < 315 then return "up" end
    return "right" -- 315-45
end

function kris.new(x, y, wall)
	local self = {
		x = x or 50,
		y = y or 50,
		w = 0, h = 0,
		cx = x + 5, cy = y + 60,
		cw = 20, ch = 10,
		speed = 150,
		sprite = nil,
		turn = "down",
		walk = false
	}
	
	self.png = love.graphics.newImage("data/game/kris.png")
	self.w, self.h = self.png:getDimensions()
	
	self.grid = {}
	self.grid.left = {}
	self.grid.right = {}
	self.grid.up = {}
	self.grid.down = {}
	
	for i = 1, 4 do
		self.grid.left[i] = love.graphics.newQuad(24 * (i - 1), 44, 19, 38, self.w, self.h)
		self.grid.right[i] = love.graphics.newQuad(24 * (i - 1), 88, 19, 38, self.w, self.h)
		self.grid.up[i] = love.graphics.newQuad(24 * (i - 1), 132, 19, 38, self.w, self.h)
		self.grid.down[i] = love.graphics.newQuad(24 * (i - 1), 0, 19, 38, self.w, self.h)
	end
	
	self.anim = {}
	self.anim.left = anim.newAnimation(self.grid.left, 0.2)
	self.anim.right = anim.newAnimation(self.grid.right, 0.2)
	self.anim.up = anim.newAnimation(self.grid.up, 0.2)
	self.anim.down = anim.newAnimation(self.grid.down, 0.2)
	self.anim.current = self.anim.down
	
	self.body = hc.rectangle(self.cx, self.cy, self.cw + 2, self.ch)
	
	walls = wall
	return setmetatable(self, {__index = kris})
end	

function kris:update(dt)
	local dx, dy = inputRef:getDirection()
	
	self.turn = self:getAngle(dx, dy)
	self.walk = inputRef.active
	
	self.cx = self.cx + dx * self.speed * dt
	self.cy = self.cy + dy * self.speed * dt
	self.body:moveTo(self.cx + 14, self.cy + 6)
	
	local wallsArray = {walls.a, walls.b, walls.c}
	for _, wall in ipairs(wallsArray) do
	    local collides, deltaX, deltaY
	    collides, deltaX, deltaY = self.body:collidesWith(wall)
	    
	    if collides then
		    self.cx, self.cy = self.cx + deltaX, self.cy + deltaY
		    self.body:moveTo(self.cx + 14, self.cy + 6)
	    end
	end
	
	self.x = self.cx - 5
	self.y = self.cy - 65
	
	if self.walk then
	    self.anim.current:update(dt)
		
		anTime = anTime + dt
		if anTime < 0.2 then
		if self.turn == "left" then
			self.anim.left:gotoFrame(2)
		elseif self.turn == "right" then
			self.anim.right:gotoFrame(2)
		elseif self.turn == "up" then
			self.anim.up:gotoFrame(2)
		elseif self.turn == "down" then
			self.anim.down:gotoFrame(2)
		end
		anTime = 1
		end
	else
		anTime = 0
	end
end

function kris:draw()
	if not self.walk then
	    if self.turn == "left" then
			self.anim.current = self.anim.left
			self.anim.left:pause()
		    self.anim.left:gotoFrame(1)
	    elseif self.turn == "right" then
			self.anim.current = self.anim.right
			self.anim.right:pause()
            self.anim.right:gotoFrame(1)
	    elseif self.turn == "up" then
			self.anim.current = self.anim.up
			self.anim.up:pause()
            self.anim.up:gotoFrame(1)
	    elseif self.turn == "down" then
			self.anim.current = self.anim.down
			self.anim.down:pause()
            self.anim.down:gotoFrame(1)
			
	    end
	else
		if self.turn == "left" then
			self.anim.current = self.anim.left
			self.anim.left:resume()
	    elseif self.turn == "right" then
			self.anim.current = self.anim.right
			self.anim.right:resume()
	    elseif self.turn == "up" then
			self.anim.current = self.anim.up
			self.anim.up:resume()
	    elseif self.turn == "down" then
			self.anim.current = self.anim.down
			self.anim.down:resume()
	    end
	end
	
	self.anim.current:draw(self.png, self.x, self.y, 0, 2, 2)
	
	if hitboxes then
	    love.graphics.rectangle("line", self.cx + 4, self.cy, self.cw, self.ch)
		
		love.graphics.circle("line", self.cx + 50, self.cy, 20, 20)
	love.graphics.line(self.cx + 50, self.cy, self.cx + 50, self.cy + 10)
	
	love.graphics.print(tostring(math.floor(self.cx + 50)), self.cx + 50, self.cy - 65)
	love.graphics.print(tostring(math.floor(self.cy)), self.cx + 50, self.cy - 50)
	end
end

return kris