local constructionutil = require "constructionutil"
local colliderutil = require "colliderutil"

local addStocks = function(stocks, result)
	local maxStocks = 5
	assert(#stocks <= maxStocks)

	local stockModelList = { {}, {}, {}, {}, {} }
	for i=1, #result.models do
		for j=1, maxStocks do
			if result.models[i].id == "industry/common/stock_lane_" .. j .. ".mdl" then 
				table.insert(stockModelList[j], { i - 1, 0 }) 
				--print("found stock: " .. "industry/common/stock_lane_" .. j .. ".mdl")
			end
		end
	end
	
	result.stocks = {}
	for i=1, #stocks do
		result.stocks[#result.stocks + 1] = {
			cargoType = stocks[i],
			edges = stockModelList[i]
		}
	end
end

local addStreets = function(data, result)
	if data.static.curves and data.static.curves.street then
		for i=1, #data.static.curves.street do
			local edge = data.static.curves.street[i]
			constructionutil.addEdges(data.static.curves.street, result, "STREET", { type = "standard/country_small_new.lua" }, true)
		end
	end
end

local addGroundFaces = function(name, era, level, data, result)
	if data.static.curves and data.static.curves.ground_face then
		local minX = .0
		local minY = .0
		local maxX = .0
		local maxY = .0
		
		local face = data.static.curves.ground_face[1]
		
		for i=1, #face do
			local pos = face[i]
			minX = math.min(minX, pos[1])
			minY = math.min(minY, pos[2])
			maxX = math.max(maxX, pos[1])
			maxY = math.max(maxY, pos[2])
		end
		
		local diffX = maxX - minX
		local diffY = maxY - minY
		
		local texCoords = {}
		for i=1, #face do
			local pos = face[i]
			table.insert(texCoords, {
				(pos[1] - minX) / diffX,
				(pos[2] - minY) / diffY,
			})
		end

		result.groundFaces = { 
			{ 
				face = data.static.curves.ground_face[1], 
				modes = { { texCoords = texCoords, type = "FILL", key = "construction/industry/era_" .. era .. "/" .. name .. "_" .. level .. ".gtex.lua" } } 
			} 
		}
	end
end

local numbers = function(num)
	local res = {}
	for i=1, num do
		table.insert(res, tostring(i))
	end
	return res
end

local makeIndustryParams = function(levelCount)
	if levelCount == nil then levelCount = 5 end
	return {
		{
			key = "productionLevel",
			name = _("Industry production level"),
			values = numbers(levelCount),
		},
		{
			key = "inputEnabled",
			name = _("Input"),
			values = { _("off"), _("on") },
			defaultIndex = 1,
			tooltip = _("When disabled, the industry will not require any cargo input"),
		},
		{
			key = "autoUpgrade",
			name = _("Auto upgrade"),
			values = { _("off"), _("on") },
			defaultIndex = 1,
			tooltip = _("When disabled, the industry will not up-/downgrade"),
		},
	}
end

local getNumLevels = function(data)
	local count = 0
	while true do
		if data["level" .. (count + 1)] == nil then
			break
		end
		count = count + 1
	end
	return count
end


local lib = {}

lib.addIndustryData = function(name, era, data, constr, stockListConfig)
	local numLevels = getNumLevels(data)
	constr.type = "INDUSTRY"
	constr.params = makeIndustryParams(numLevels)
	constr.updateFn = function(params)
		local currentLevel = (params.productionLevel or 0) + 1
		assert(currentLevel <= numLevels)
		assert(currentLevel >= 1)
	
		local result = {
			models = { },
			groundFaces = { },
		}
		
		constructionutil.addModelsAndGroups(params, data.static, result)
		constructionutil.addModelsAndGroups(params, data["level" .. currentLevel], result)
		if not params.upgrade then addStreets(data, result) end
		
		addGroundFaces(name, era, currentLevel, data, result)

		local inpEnabled = (params.inputEnabled or 1) == 1
		local inputRule = (params.input or (inpEnabled and stockListConfig and stockListConfig.rule.input)) or { {} }
		result.rule = {
			input = inputRule,
			output = params.output or (stockListConfig and stockListConfig.rule.output) or {},
			capacity = (params.capacity or (stockListConfig and stockListConfig.rule.capacity) or 0) * currentLevel,
		}
		addStocks((params.stocks or (inpEnabled and stockListConfig and stockListConfig.stocks)) or {}, result)

		if params.commercialCapacity then
			result.personCapacity = {
				type = "COMMERCIAL",
				capacity = params.commercialCapacity,
			}
		elseif params.industrialCapacity then
			result.personCapacity = {
				type = "INDUSTRIAL",
				capacity = params.industrialCapacity,
			}
		end
	
		return result
	end
end

return lib
