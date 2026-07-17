local fileManager = {}

-- Управление загрузкой сцен
local scenes = {}

function fileManager.sceneLoad(name, path)
	local sceneIndex = nil
	for i = #scenes, 1, -1 do
		if scene[i] == name then
			sceneIndex = i
		end
	end		
	
	table.remove(scenes, sceneIndex)
	scene:deleteScene(name)
	
	package.loaded[path] = nil
	
	scene:newScene(name, require(path))
	table.insert(scenes, name)
end

function fileManager.sceneClean(name)
	if name == "full" then
		for i = 1, #scenes, 1 do
			table.remove(scenes, i)
		end
	else
		scene:deleteScene(name)
		for i = #scenes, 1, -1 do
			if scenes[i] == name then
				table.remove(scenes, i)
			end
		end
	end
end

-- Управление загрузкой аудио
local audios = {}
local musicData = {
	fight = {0.7, 76},
	fightAlt = {1, 100}
}

function fileManager.audioLoad(name, path, kind)
	for i, v in pairs(audios) do
		if v == name then
			return
		end
	end
	
	package.loaded[path] = nil
	
	if kind == "music" then
		music[name] = love.audio.newSource(path, "stream")
		music[name]:setLooping(true)
		for k, v in pairs(musicData) do
			if k == name then
				music[name .. "Start"] = v[1]
				music[name .. "Finish"] = v[2]
			end
		end
	elseif kind == "sound" then
		sound[name] = love.audio.newSource(path, "static")	
	end
	
	table.insert(audios, name)
end

function fileManager.audioClean(name, kind)
	if kind == "music" then
		music[name] = nil
		for k, v in pairs(musicData) do
			if k == name then
				music[name .. "Start"] = nil
				music[name .. "Finish"] = nil
			end
		end
	elseif kind == "sound" then
		sound[name] = nil
	end
	
	for i = #audios, 1, -1 do
		if audios[i] == name then
			table.remove(audios, i)
		end	
	end
end	

return fileManager