local rudinnFight = {}
local anim = require "data/libs.anim8"

function rudinnFight.new(x, y)
    local self = {
        x = x or 50,
        y = y or 50,
        w = 0, h = 0,
		hp = 100, maxHp = 100,
		spared = false,
        sprite = nil,
        animation = "idle",
        anTime = 0
    }
    
    self.png = love.graphics.newImage("data/chars/rudinn/rudinn.png")
    self.w, self.h = self.png:getDimensions()
    
    self.quad = {}
    self.quad.idle = {}
    self.quad.attack = {}
	self.quad.spared = {}
    self.quad.hurt = love.graphics.newQuad(7, 197, 35, 40, self.w, self.h)
    
    for i = 1, 4 do
        self.quad.idle[i] = love.graphics.newQuad(1 + (36 * (i - 1)), 77, 35, 40, self.w, self.h)
        self.quad.spared[i] = love.graphics.newQuad(1 + (36 * (i - 1)), 132, 35, 40, self.w, self.h)
    end
    
    for i = 1, 6 do
        self.quad.attack[i] = love.graphics.newQuad(1 + (76 * (i - 1)), 252, 75, 50, self.w, self.h)
    end
    
    self.anim = {}
    self.anim.idle = anim.newAnimation(self.quad.idle, 0.2)
    self.anim.spared = anim.newAnimation(self.quad.spared, 0.2)
    self.anim.attack = anim.newAnimation(self.quad.attack, 0.2)
    
    self.anim.current = self.anim.idle
    
    return setmetatable(self, {__index = rudinnFight})
end

function rudinnFight:update(dt)
    if PAUSE then return end
    
    self:anUpdate(dt)
end

function rudinnFight:draw()
    self:anDraw()    
end

function rudinnFight:anSelect(an)
    self.animation = an
    self.anTime = 0
    
	if not self.spared and self.animation == "idle" then
		self.anim.current = self.anim.idle
	elseif self.animation == "idle" then
		self.anim.current = self.anim.spared
	elseif self.animation == "attack" then
		self.anim.current = self.anim.attack
	end	
		
    self.anim.current:gotoFrame(1)
    self.anim.current:resume()
end

function rudinnFight:anUpdate(dt)
    self.anTime = self.anTime + dt
    
	if self.animation == "attack" then
        if self.anTime >= 1.2 then
            self:anSelect("idle")
        end
	end	
    
    self.anim.current:update(dt)        
end

function rudinnFight:anDraw()
    if self.animation == "idle" or self.animation == "spared" then
        self.anim.current:draw(self.png, self.x, self.y, 0, 2, 2)
    elseif self.animation == "attack" then
        self.anim.current:draw(self.png, self.x, self.y, 0, 2, 2, 3, 8)
    else    
        self.anim.current:draw(self.png, self.x, self.y, 0, 2, 2, 0, 5)
    end
end

return rudinnFight