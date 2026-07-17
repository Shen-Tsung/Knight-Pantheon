local attack = {}

local timer

local fight = require "data/fight"
local rudinn

local soul

--Создание экземпляра врага
function attack.new(x, y)
	--Сортировка рудинов из таблицы
	local sort = fight.getNpc()
	for i, npc in ipairs(sort) do
		if npc == "rudinn" then
			rudinn = npc
		end
	end
	
	pattern = 1
	
	--Переменные экземпляра
	local self = {}
	
	--Расчёт стартовой точки в зависимости от паттерна
	self.x = x or rudinn.x - 50
	self.y = y or rudinn.y - 50
	
	self.s = random(5, 10)
	--Расчёт поворота
	self.targetX = soul.x
	self.targetY = soul.y
	self.dx = soul.x - self.x
	self.dy = soul.y - self.y
	self.angle = math.atan2(dy, dx)
	self.timer = 0
	
	--Загрузка спрайта
	self.png = love.graphics.newImage("data/chars/rudinn/rudinn.png")
	self.w, self.h = self.png:getDimensions()
	
	--Вырез нужной области
	self.quad = love.graphics.newQuad(1, 317, 29, 29, self.w, self.h)
end

function attack:whenAdded()
	timer = 0
	
	soul = fight.getSoul()
	
	pattern = 1
end	

function attack:update(dt)
	if PAUSE then return end
	
	timer = timer + dt
	
	if pattern == 1 then
		self.x = self.x + (self.targetX - self.x) * self.s * dt
		self.y = self.y + (self.targetY - self.y) * self.s * dt
	end
end

function attack:draw()
	love.graphics.draw(self.png, self.quad, self.x, self.y, self.angle, 2, 2, self.w / 2, self.h / 2)
end