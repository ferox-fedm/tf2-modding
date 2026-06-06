local fileFilters = {
	["model/vehicle"] = { },
	["model/person"] = { },
	["model/car"] = { },
	["model/rock"] = { },
	["model/tree"] = { },
	["model/signal"] = { },
	["model/animal"] = { },
	["model/other"] = { },

	multipleUnit = { },
	street = { },
	track = { },
	bridge = { },
	tunnel = { },
	railroadCrossing = { },
	trafficLight = { },
	environment = { },
	construction = { },
	["module"] = {},
	autoGroundTex = { },
	groundTex = { },
	terrainGenerator = { },
	playlist = { },
	terrainMaterial = { },
	cargoType = { },
	grass = { },
	gameScript = { },
	climate = { },
}

function addFileFilter(cat, fn)
	local ff = fileFilters[cat]
	ff[#ff + 1] = fn
end

function clearFileFilter(cat)
	fileFilters[cat] = {}
end

function applyFileFilters(cat, fileName, data)
	local function filter(filters, fileName, data)
		for i, fn in ipairs(filters) do
			if not fn(fileName, data) then
				return nil
			end
		end

		return data
	end

	if string.ends(cat, "/") then
		for k, v in pairs(fileFilters) do
			if string.starts(k, cat) then
				local result = filter(v, fileName, data)
				if result then
					return result
				end
			end
		end

		return nil
	end

	return filter(fileFilters[cat], fileName, data)
end



local modifiers = {
	loadModel = { },
	loadModule = { },
	loadMultipleUnit = { },
	loadStreet = { },
	loadTrack = { },
	loadBridge = { },
	loadTunnel = { },
	loadRailroadCrossing = { },
	loadTrafficLight = { },
	loadEnvironment = { },
	loadConstruction = { },
	loadConstructionCategory = { },
	loadConstructionMenu = { },
	loadSoundSet = { },
	loadScript = { },
	loadTerrainMaterial = { },
	loadGrass = { },
	loadGameScript = { },
	loadGroundTex = { },
	loadTerrainGenerator = { },
	loadPlaylist = { },
	loadClimate = { },
	loadCargoType = { },
}

function addModifier(key, fun)
	table.insert(modifiers[key], fun)
end

function applyModifiers(key, name, data)
	for i, v in ipairs(modifiers[key]) do
		data = v(name, data)
	end

	return data
end



local i18n = { }

function setStrings(mod, strings)
	i18n[mod] = {
		strings = strings
	}
end

function translateModStr(modId, locale, id)
	--print("translate: ", id, " to ", locale, "\n")

	if not i18n[modId] then
		return id
	end

	local strings = i18n[modId].strings

	if strings[locale] then
		local result = strings[locale][id]
		if result then return result end
	end
	
	if locale:len() > 2 then
		local shortLocale = string.sub(locale, 1, 2)
		--print("  shortLocale: ", shortLocale, "\n")
		if strings[shortLocale] then
			local result = strings[shortLocale][id]
			if result then return result end
		end
	end
	
	if locale ~= "en" then
		if strings["en"] then
			local result = strings["en"][id]
			if result then return result end
		end
	end
	
	return id
end

function getTextRes(id)
    return pGetTextRes(nil, id)
end

function pGetText(context, id)
	if id == nil then
		return id
	end
	
    local concatId = ((context == nil) and "" or (context .. "<|ctx|>")) .. id
	if _locale:len() == 0  then
		return concatId
	end
	if _currentModIdTr ~= nil then
		local txt = translateModStr(_currentModIdTr, _locale, concatId)
		if txt ~= concatId then
			return txt
		end
	end
	if _getTextNow then
		return pGetTextRes(context, id)
	end
	return concatId
end

function _(id)
	if type(id) == "table" then
		print("Skipped translation: Called _ with a table instead of a string:")
		debugPrint(id)
		return id
	end
    return pGetText(nil, id)
end
