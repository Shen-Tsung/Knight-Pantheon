local pause = {}

local border = {}
local continue = {}
local options = {}
local quit = {}
local sure = {}
local yes = {}
local no = {}

local optionsShow

local touch = {}

local audios = {}

function pause:whenAdded()
	audios = love.audio.pause()
	
	optionsShow = false
	
	border.w = 220
	border.h = 300
	border.x = (WIDTH - border.w) / 10
	border.y = (HEIGHT - border.h) / 2
	
	border.name = {}
	border.name.w = 80
	border.name.h = 25
	border.name.x = border.x + border.w / 2 - border.name.w / 2
	border.name.y = border.y
	border.name.text = t("menu", "pause")
	
	continue.w = 110
	continue.h = 55
	continue.x = border.x + border.w / 2 - continue.w / 2
	continue.y = (HEIGHT / 2) - continue.h - 30
	continue.text = t("menu", "continue")
	continue.color = {1, 1, 1}
	
	options.w = 110
	options.h = 55
	options.x = continue.x
	options.y = continue.y + continue.h + 10
	options.text = t("menu", "options")
	options.color = {1, 1, 1}
	
	quit.w = 110
	quit.h = 55
	quit.x = options.x
	quit.y = options.y + options.h + 10
	quit.text = t("menu", "quit")
	quit.active = false
	quit.color = {1, 1, 1}
	
	sure.w = border.w
	sure.h = 120
	sure.x = WIDTH / 1.9
	sure.y = (HEIGHT - sure.h) / 2
	sure.text = t("menu", "sure")
	
	yes.w = 70
	yes.h = 40
	yes.x = sure.x + 30
	yes.y = sure.y + 50
	yes.text = t("menu", "yes")
	yes.color = {1, 1, 1}
	
	no.w = yes.w
	no.h = yes.h
	no.x = yes.x + yes.w + 30
	no.y = yes.y
	no.text = t("menu", "no")
	no.color = {1, 1, 1}
end

function pause:update(dt)
	continue.text = t("menu", "continue")
	options.text = t("menu", "options")
	quit.text = t("menu", "quit")
end

function pause:drawUI()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", border.x, border.y, border.w, border.h)
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("line", border.x, border.y, border.w, border.h)
	
	drawButton(border.name.text, border.name.x, border.name.y, border.name.w, border.name.h)
	
	drawButton(continue.text, continue.x, continue.y, continue.w, continue.h, continue.color)
	drawButton(options.text, options.x, options.y, options.w, options.h, options.color)
	drawButton(quit.text, quit.x, quit.y, quit.w, quit.h, quit.color)
	
	if quit.active then
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", sure.x, sure.y, sure.w, sure.h)
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle("line", sure.x, sure.y, sure.w, sure.h)
		
		love.graphics.printf(sure.text, sure.x, sure.h + 10, sure.w, "center")
		
		drawButton(yes.text, yes.x, yes.y, yes.w, yes.h, yes.color)
		drawButton(no.text, no.x, no.y, no.w, no.h, no.color)
	end	
end

function pause:touchpressed(id, x, y)
	if zone(continue.x, continue.y, continue.w, continue.h, x, y) then
		continue.color = {0.5, 0.5, 0.5}
		touch[id] = "continue"
	elseif zone(options.x, options.y, options.w, options.h, x, y) then
		options.color = {0.5, 0.5, 0.5}
		touch[id] = "options"
	elseif zone(quit.x, quit.y, quit.w, quit.h, x, y) then
		quit.color = {0.5, 0.5, 0.5}
		touch[id] = "quit"
	end
	
	if quit.active then
		if zone(yes.x, yes.y, yes.w, yes.h, x, y) then
			yes.color = {0.5, 0.5, 0.5}
			touch[id] = "yes"
		elseif zone(no.x, no.y, no.w, no.h, x, y) then
			no.color = {0.5, 0.5, 0.5}
			touch[id] = "no"
		end
	end		
end

function pause:touchreleased(id, x, y)
	if touch[id] == "continue" then
		continue.color = {1, 1, 1}
		PAUSE = false
		for _, music in pairs(audios) do
			music:setVolume(saveData["options"]["music"])
		end	
		love.audio.play(audios)
		playSound("bip")
		scene:pop("pause")
		if optionsShow then
		    scene:pop("options")
		end	
	elseif touch[id] == "options" then
		options.color = {1, 1, 1}
		playSound("bip")
		
		if optionsShow then
			scene:pop("options")
			optionsShow = false
		elseif not optionsShow then
			if quit.active then
				quit.active = false
			end
			
			scene:push("options")
			optionsShow = true	
		end	
	elseif touch[id] == "quit" then
		quit.color = {1, 1, 1}
		playSound("bip")
		
		if quit.active then
			quit.active = false
		elseif not quit.active then	
			if optionsShow then
				optionsShow = false
				scene:pop("options")
			end
			quit.active = true
		end	
	end
	
	if quit.active then
		if touch[id] == "yes" then
			yes.color = {1, 1, 1}
			quit.active = false
			love.audio.stop()
			scene:clearStack()
			
			file.sceneLoad("intro", "data.menu.intro")
			
			scene:push("intro")
			PAUSE = false
		elseif touch[id] == "no" then
			no.color = {1, 1, 1}
			quit.active = false
		end
	end			
	touch[id] = nil
end

return pause