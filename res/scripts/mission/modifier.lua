local t = {}

t.util = {}

function t.util.all(...)
	local fns = table.pack(...)
	return function(data)
		for i = 1, #fns do
			fns[i](data)
		end
	end
end

function t.util.disable(data)
	local av = data.availability or data.metadata.availability
	if av == nil then return end
	av.yearFrom = 1850
	av.yearTo = 1849
end

function t.util.availability(from, to)
	return function(data)
		local av = data.availability or data.metadata.availability
		if av == nil then return end
		if from ~= nil then av.yearFrom = from end
		if to ~= nil then av.yearTo = to end
	end
end

function t.util.cargotypes(cargotypes, capacity)
	return function(data)
		if data.metadata.transportVehicle.compartmentsList ~= nil then
			local comp = data.metadata.transportVehicle.compartmentsList
			for i = 1, #comp do
				local cap = capacity or comp[i].loadConfigs[1].cargoEntries[1].capacity
				local cargoBay = comp[i].loadConfigs[1].cargoEntries[1].cargoBay
				comp[i] = { loadConfigs = {} }
				local c = comp[i]
				for j = 1, #cargotypes do
					table.insert(c.loadConfigs, { cargoEntries = { { type = cargotypes[j], cargoBay = cargoBay, capacity = cap } } })
				end
			end
		else
			local comp = data.metadata.transportVehicle.compartments
			for i = 1, #comp do
				local cap = capacity or comp[i][1][1].capacity
				local cargoBay = comp[i][1][1].cargoBay
				comp[i] = { }
				local c = comp[i]
				for j = 1, #cargotypes do
					c[#c + 1] = { { type = cargotypes[j], cargoBay = cargoBay, capacity = cap } }
				end
			end

		end
	end
end

function t.util.patchCargotypes(cargotypes, capacity)
	return function(data)
		local removed = {}
		for k,v in pairs(cargotypes) do
			local t = string.sub(v, 2)
			if string.sub(v, 1, 1) == "-" then
				removed[t] = true
			end
		end
		
		if data.metadata.transportVehicle.compartmentsList ~= nil then
			local comp = data.metadata.transportVehicle.compartmentsList
			
			for i = 1, #comp do
				local cap = capacity or comp[i].loadConfigs[1].cargoEntries[1].capacity
				local cargoBay = comp[i].loadConfigs[1].cargoEntries[1].cargoBay
				local c = { loadConfigs = {} }
				for k,v in pairs(comp[i].loadConfigs) do
					local loadConfig = { cargoEntries = {} }
					for j, w in pairs(v.cargoEntries) do
						if not removed[w.type] then
							table.insert(loadConfig.cargoEntries, w)
						end
					end
					table.insert(c.loadConfigs, loadConfig)
				end
				for j = 1, #cargotypes do
					local t = string.sub(cargotypes[j], 2)
					if string.sub(cargotypes[j], 1, 1) == "+" then
						table.insert(c.loadConfigs, { cargoEntries = { { type = t, cargoBay = cargoBay, capacity = cap } } })
					end
				end
				comp[i] = c
			end
		else
			local comp = data.metadata.transportVehicle.compartments
			
			for i = 1, #comp do
				local cap = capacity or comp[i][1][1].capacity
				local cargoBay = comp[i][1][1].cargoBay
				local c = {}
				for k,v in pairs(comp[i]) do
					local loadConfig = { }
					for j, w in pairs(v) do
						if not removed[w.type] then
							table.insert(loadConfig, w)
						end
					end
					table.insert(c, loadConfig)
				end
				for j = 1, #cargotypes do
					local t = string.sub(cargotypes[j], 2)
					if string.sub(cargotypes[j], 1, 1) == "+" then
						table.insert(c, { { type = t, cargoBay = cargoBay, capacity = cap } })
					end
				end
				comp[i] = c
			end
		end
	end
end

local function applyTree(tree, fileName, data)
	local structure = {}
	local respos = -1
	local i = 1
	for str in string.gmatch(fileName, "([^/]+)") do
		table.insert(structure, str)
		if respos == -1 and str == "res" then respos = i end
		i = i + 1
	end
	local node = tree
	for i = respos + 1, #structure do
		local f = structure[i]
		node = node[f] or node["default"]
		if node == nil then
			return data
		end
		if type(node) == "function" then
			node(data)
			return data
		elseif type(node) ~= "table" then
			return data
		end
	end
	error("logic error in mission/modifier.lua")
end

function t.treevisitor(tree)
	addModifier("loadSoundSet", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadEnvironment", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadGameScript", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadScript", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadGroundTex", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadClimate", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadTerrainGenerator", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadPlaylist", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadGrass", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadTerrainMaterial", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadBridge", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadCargoType", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadModel", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadModule", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadMultipleUnit", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadRailroadCrossing", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadStreet", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadTrack", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadTrafficLight", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadTunnel", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
	addModifier("loadConstruction", function (fileName, data)
		return applyTree(tree, fileName, data)
	end)
end

return t
