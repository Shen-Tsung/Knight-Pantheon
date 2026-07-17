local krisFight = {}
local anim = require "data/libs.anim8"

function krisFight.new(x, y)
    local self = {
        x = x or 50,
        y = y or 50,
        w = 0, h = 0,
        sprite = nil,
        animation = "start",
        anTime = 0
    }
    
    self.png = love.graphics.newImage("data/game/kris.png")
    self.w, self.h = self.png:getDimensions()
    
    self.quad = {}
    self.quad.start = {}
    self.quad.idle = {}
    self.quad.finish = {}
    self.quad.attack = {}
    self.quad.hurt = love.graphics.newQuad(92, 90, 63, 44, self.w, self.h)
    self.quad.prepare = {}
    self.quad.backToIdle = {}
	self.quad.backAttack = {}
    self.quad.act = {}
    self.quad.item = {}
    self.quad.shield = {}
    self.quad.spare = {}
    self.quad.clap = {}
    self.quad.bow = love.graphics.newQuad(673, 90, 32, 40, self.w, self.h)
    self.quad.turn = love.graphics.newQuad(706, 90, 29, 39, self.w, self.h)
    
    for i = 1, 12 do
        self.quad.start[i] = love.graphics.newQuad(92 + (71 * (i - 1)), 225, 66, 47, self.w, self.h)
    end
    
    for i = 1, 6 do
        self.quad.idle[i] = love.graphics.newQuad(92 + (41 * (i - 1)), 0, 36, 38, self.w, self.h)
        self.quad.shield[i] = love.graphics.newQuad(404 + (40 * (i - 1)), 90, 35, 40, self.w, self.h)
    end
    
    for i = 1, 9 do
        self.quad.finish[i] = love.graphics.newQuad(334 + (39 * (i - 1)), 0, 34, 37, self.w, self.h)
    end
    
    for i = 1, 8 do
        self.quad.attack[i] = love.graphics.newQuad(92 + (68 * (i - 1)), 39, 63, 50, self.w, self.h)
        self.quad.item[i] = love.graphics.newQuad(92 + (68 * (i - 1)), 180, 63, 44, self.w, self.h)
        self.quad.spare[i] = love.graphics.newQuad(92 + (68 * (i - 1)), 135, 63, 44, self.w, self.h)
        self.quad.act[i] = love.graphics.newQuad(92 + (68 * (i - 1)), 135, 63, 44, self.w, self.h)
    end
    
    for i = 1, 2 do
        self.quad.backAttack[i] = love.graphics.newQuad(776 + (68 * (i - 1)), 39, 63, 50, self.w, self.h)
        self.quad.prepare[i] = love.graphics.newQuad(160 + (68 * (i - 1)), 90, 63, 44, self.w, self.h)
    end
    
    for i = 1, 3 do
        self.quad.backToIdle[i] = love.graphics.newQuad(636 + (68 * (i - 1)), 135, 63, 44, self.w, self.h)
        self.quad.clap[i] = love.graphics.newQuad(703 + (28 * (i - 1)), 0, 23, 37, self.w, self.h)
    end
    
    self.anim = {}
    self.anim.start = anim.newAnimation(self.quad.start, 0.1)
    self.anim.idle = anim.newAnimation(self.quad.idle, 0.1)
    self.anim.finish = anim.newAnimation(self.quad.finish, 0.1)
    self.anim.prepare = anim.newAnimation(self.quad.prepare, 0.1)
    self.anim.backToIdle = anim.newAnimation(self.quad.backToIdle, 0.1)
    self.anim.backAttack = anim.newAnimation(self.quad.backAttack, 0.1)
    self.anim.attack = anim.newAnimation(self.quad.attack, 0.1)
    self.anim.act = anim.newAnimation(self.quad.act, 0.1)
    self.anim.spare = anim.newAnimation(self.quad.spare, 0.1)
    self.anim.item = anim.newAnimation(self.quad.item, 0.1)
    self.anim.shield = anim.newAnimation(self.quad.shield, 0.1)
    self.anim.clap = anim.newAnimation(self.quad.clap, 0.1)
    
    self.anim.current = self.anim.start
    
    return setmetatable(self, {__index = krisFight})
end

function krisFight:update(dt)
    if PAUSE then return end
    
    self:anUpdate(dt)
end

function krisFight:draw()
    self:anDraw()    
end

function krisFight:anSelect(an)
    self.animation = an
    self.anTime = 0
    
    if self.animation == "start" then
        self.anim.current = self.anim.start
    elseif self.animation == "idle" then
        self.anim.current = self.anim.idle
    elseif self.animation == "finish" then
        self.anim.current = self.anim.finish
    elseif self.animation == "prepare" then
        self.anim.current = self.anim.prepare
    elseif self.animation == "backToIdle" then
        self.anim.current = self.anim.backToIdle
	elseif self.animation == "backAttack" then
        self.anim.current = self.anim.backAttack	
    elseif self.animation == "attack" then
        self.anim.current = self.anim.attack
    elseif self.animation == "act" then
        self.anim.current = self.anim.act
    elseif self.animation == "spare" then
        self.anim.current = self.anim.spare
    elseif self.animation == "item" then
        self.anim.current = self.anim.item
    elseif self.animation == "shield" then
        self.anim.current = self.anim.shield
    elseif self.animation == "clap" then
		self.anim.current = self.anim.clap
	end	
    
    self.anim.current:gotoFrame(1)
    self.anim.current:resume()
end

function krisFight:anUpdate(dt)
    self.anTime = self.anTime + dt
    
    if self.animation == "start" then
        if self.anTime >= 1 then
            self:anSelect("idle")
        end
    elseif self.animation == "finish" then
        if self.anTime >= 0.9 then
            self.anim.current:pause()
        end
    elseif self.animation == "backToIdle" then
        if self.anTime >= 0.27 then
            self:anSelect("idle")
        end
	elseif self.animation == "backAttack" then
        if self.anTime >= 0.18 then
            self:anSelect("idle")
        end	
    elseif self.animation == "attack" then
        if self.anTime >= 0.8 then
            self.anim.current:pause()
        end
    elseif self.animation == "act" then
        if self.anTime >= 0.8 then
            self.anim.current:pause()
        end
    elseif self.animation == "spare" then
        if self.anTime >= 0.8 then
            self.anim.current:pause()
        end
    elseif self.animation == "item" then
        if self.anTime >= 0.8 then
            self.anim.current:pause()
        end
    elseif self.animation == "shield" then
        if self.anTime >= 0.6 then
            self.anim.current:pause()
        end
    end
    
    self.anim.current:update(dt)        
end

function krisFight:anDraw()
    if self.animation == "idle" then
        self.anim.current:draw(self.png, self.x, self.y, 0, 2, 2)
    elseif self.animation == "attack" then
        self.anim.current:draw(self.png, self.x, self.y, 0, 2, 2, 0, 5)
    elseif self.animation == "start" then
        self.anim.current:draw(self.png, self.x, self.y, 0, 2, 2, 3, 8)
    elseif self.animation == "finish" then
        self.anim.current:draw(self.png, self.x, self.y, 0, 2, 2, -2, -1)
    elseif self.animation == "shield" then
        self.anim.current:draw(self.png, self.x, self.y, 0, 2, 2, 0, 2)
	elseif self.animation == "clap" then
        self.anim.current:draw(self.png, self.x, self.y, 0, 2, 2, -2, -1)	
    elseif self.animation == "hurt" then
        love.graphics.draw(self.png, self.quad.hurt, self.x, self.y, 0, 2, 2, 0, 5)
    elseif self.animation == "bow" then
        love.graphics.draw(self.png, self.quad.bow, self.x, self.y, 0, 2, 2, 0, 5)
    elseif self.animation == "turn" then
        love.graphics.draw(self.png, self.quad.turn, self.x, self.y, 0, 2, 2, 0, 5)
    else    
        self.anim.current:draw(self.png, self.x, self.y, 0, 2, 2, 0, 5)
    end
end

return krisFight