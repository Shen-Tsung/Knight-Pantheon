local bgMenu = {}

local bullet
local bulletBg
local tile

function bulletBackground()
	local bullets = {}
	for i = 1, 20 do
		table.insert(bullets, {
			x = 0 - 20 * i - 1,
			y = love.math.random(0, HEIGHT),
			size = love.math.random(3, 10),
			speed = love.math.random(3 * 10, 10 * 10)
		})
	end
	return bullets	
end

function tileBackground()
	local tiles = {}
		for i = 1, 3 do
			table.insert(tiles, {
				x = 640 * (i - 1)
			})
		end
	return tiles
end

function backgroundUpdate(bullets, tiles, dt)	
	for _, b in ipairs(bullets) do
		b.x = b.x + b.speed * dt
		
		if b.x > WIDTH + 100 then
			b.x = -100
			b.y = love.math.random(0, HEIGHT)
		end	
	end
	
	for _, t in ipairs(tiles) do
		t.x = t.x + 100 * dt
		
		if t.x > WIDTH + 320 then
			t.x = t.x - 640 * 3
		end
	end		
end

function bgMenu:load()
	bullet = love.graphics.newImage("data/menu/bulletBg.png")
	tile = love.graphics.newImage("data/menu/tileBg.png")
	
	gradient = love.graphics.newShader[[
		extern number width;
		
		vec4 effect(vec4 color, Image texture, vec2 uv, vec2 px) {
			vec4 pixel = Texel(texture, uv);
			float fac = (px.x / 2.5) / width;
			pixel.rgb = pixel.rgb * (1.0 - fac);
			return pixel;
		}
	]]
	
	gradient:send("width", WIDTH)
end

function bgMenu:whenAdded()
	bulletBg = bulletBackground()
	tileBg = tileBackground()
end

function bgMenu:update(dt)
	backgroundUpdate(bulletBg, tileBg, dt)
end

function bgMenu:drawUI()
	love.graphics.setShader(gradient)
	for _, t in ipairs(tileBg) do
		love.graphics.draw(tile, t.x, 0, 0, 2, 2)
	end
	
	--love.graphics.draw(tile, 0, 0, 0, 2, 2)
	
	for _, b in ipairs(bulletBg) do
		love.graphics.draw(bullet, b.x, b.y, 0, b.size / 10, b.size / 10)
	end
	love.graphics.setShader()
end

return bgMenu