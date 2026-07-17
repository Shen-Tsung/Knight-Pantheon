local fightBg = {}

local grid = {}
local bgFade

function fightBg:whenAdded(getNpc)
	scene:push("fight", getNpc)
	
    bgFade = 0
	
	grid.aOffset = 0
    grid.bOffset = 0
    grid.aColor = {0.14, 0, 0.14}
    grid.bColor = {0.26, 0, 0.26}
    grid.aSpeed = -25
    grid.bSpeed = 25
    
    grid.aX = 0
    grid.aY = 0
    
    grid.bX = -98
    grid.bY = -98
    
    grid.size = 80
    grid.amount = 15
    grid.aCanvas = love.graphics.newCanvas(2048, 2048)
    grid.bCanvas = love.graphics.newCanvas(2048, 2048)
    
    doGrid(grid.aCanvas, grid.aColor)
    doGrid(grid.bCanvas, grid.bColor)
end

function doGrid(canvas, color)
    love.graphics.setCanvas(canvas)
    
    love.graphics.push()
    love.graphics.setColor(color)
    love.graphics.setLineWidth(2)
    
    for y = -1, grid.amount + 1 do
        for x = -1, grid.amount + 1 do
            love.graphics.rectangle("line", x * grid.size, y * grid.size, grid.size, grid.size)
        end
    end
    love.graphics.pop()
    love.graphics.setCanvas()
end

function fightBg:update(dt)
    if bgFade > 0 then
        bgFade = bgFade - 1 * dt
    end
	
	if PAUSE then return end
    
    grid.aX = (grid.aX + grid.aSpeed * dt) % grid.size
    grid.aY = (grid.aY + grid.aSpeed * dt) % grid.size
	
	grid.bX = (grid.bX + grid.bSpeed * dt) % grid.size
	grid.bY = (grid.bY + 0.2 + grid.bSpeed * dt) % grid.size
end

function fightBg:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setBackgroundColor(0, 0, 0)
    
    love.graphics.draw(grid.aCanvas, grid.aX - grid.size, grid.aY - grid.size)
    love.graphics.draw(grid.aCanvas, grid.aX, grid.aY)
	
    love.graphics.draw(grid.bCanvas, grid.bX - grid.size, grid.bY - grid.size)
    love.graphics.draw(grid.bCanvas, grid.bX, grid.bY)
	
	love.graphics.setLineWidth(1)
end

return fightBg