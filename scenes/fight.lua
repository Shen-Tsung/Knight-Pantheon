local options = {}

local grid = {}
local bgFade

function options:load()
    grid.aOffset = 0
    grid.bOffset = -100
    grid.aColor = a
    grid.bColor = b
    grid.aSpeed = -100
    grid.bSpeed = -50
    
    grid.aX = 0
    grid.aY = 0
    
    grid.bX = 0
    grid.bY = 0
    
    grid.size = 100
    grid.amount = 15
    grid.aCanvas = love.graphics.newCanvas(2048, 2048)
    grid.bCanvas = love.graphics.newCanvas(2048, 2048)
    
    doGrid(grid.aCanvas, grid.aColor)
    doGrid(grid.bCanvas, grid.bColor)
end

function options:whenAdded()
    bgFade = 0
end

function doGrid(canvas, color)
    love.graphics.setCanvas(canvas)
    
    love.graphics.push()
    love.graphics.setColor(0.26, 0, 0.26)
    love.graphics.setLineWidth(2)
    
    for y = 0, grid.amount do
        for x = 0, grid.amount do
            love.graphics.rectangle("line", x * grid.size, y * grid.size, grid.size, grid.size)
        end
    end
    love.graphics.pop()
    love.graphics.setCanvas()
end

function options:update(dt)
    if bgFade > 0 then
        bgFade = bgFade - 1 * dt
    end
    
    grid.aX = grid.aX + grid.aSpeed * dt
    grid.aY = grid.aY + grid.aSpeed * dt
    
    grid.bX = grid.bX + grid.bSpeed * dt
    grid.bY = grid.bY + grid.bSpeed * dt
    
    if grid.bX < -98 then
        grid.aX = 0
        grid.aY = 0
        grid.bX = 0
        grid.bY = 0
    end
end

function options:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setBackgroundColor(0, 0, 0)
    
    love.graphics.draw(grid.aCanvas, grid.aX, grid.aY)
    love.graphics.draw(grid.bCanvas, grid.bX, grid.bY)
end

function options:touchreleased(id, x, y)
	if x > 1280 / 2 then
        scene:clearStack()
        scene:push("menu")
	end	
end

return options