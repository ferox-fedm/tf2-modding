local paramsutil = { }

local function makeNumTracksValues(stationConfig)
	local result = { }

	if stationConfig ~= nil then
		for i = 1, #stationConfig.tracksConfig do
			result[#result + 1] = _("${value}") % { value = stationConfig.tracksConfig[i].num }
		end
	else
		result = { _("1"), _("2"), _("3"), _("4"), _("5") }
	end
			
	return result
end

local function makeSizeIndexValues(stationConfig, platformConfig)
	local result = { }
	
	if stationConfig ~= nil and platformConfig ~= nil then
		for i = 1, #platformConfig do
			result[#result + 1] = _("${value} m") % { value = #platformConfig[i].firstPlatformParts * stationConfig.segmentLength }
		end
	else
		result = { _("1 m"), _("2 m"), _("3 m") }
	end
	
	return result
end

function paramsutil.makeTrackTypeParam()
	return {
		key = "trackType",
		name = _("Track type"),
		values = { _("Standard"), _("High-speed") },
		yearFrom = 1925,
		yearTo = 0
	}
end

function paramsutil.makeTrackCatenaryParam()
	return {
		key = "catenary",
		name = _("Catenary"),
		values = { _("No"), _("Yes") },
		defaultIndex = 1,
		yearFrom = 1910,
		yearTo = 0
	}
end

local tramCatenaryYearFrom = 1875

function paramsutil.makeTramTrackParam1()
	return {
		key = "tramTrack",
		name = _("Tram track"),
		values = { _("No"), _("Yes") },
		yearFrom = 0,
		yearTo = tramCatenaryYearFrom
	}
end

function paramsutil.makeTramTrackParam2()
	return {
		key = "tramTrack",
		name = _("Tram track"),
		values = { _("No"), _("Yes"), _("Electric") },
		yearFrom = tramCatenaryYearFrom,
		yearTo = 0
	}
end

function paramsutil.makeTramCatenaryParam()
	return {
		key = "tramCatenary",
		name = _("Catenary"),
		values = { _("No"), _("Yes") },
		defaultIndex = 1,
		yearFrom = tramCatenaryYearFrom,
		yearTo = 0
	}
end

function paramsutil.makeTrainStationParams(stationConfig, platformConfig)
	return {
		{
			key = "numTracksIndex",
			name = _("Number of tracks"),
			values = makeNumTracksValues(stationConfig)	
		},
		{
			key = "sizeIndex",
			name = _("Platform length"),
			values = makeSizeIndexValues(stationConfig, platformConfig),
			defaultIndex = 1
		},
		paramsutil.makeTrackTypeParam(),
		paramsutil.makeTrackCatenaryParam(),
		--[[
		{
			key = "streetConnectionType",
			name = _("Street orientation"),
			values = { _("Horizontal"), _("Vertical") }
		},
		--]]
		{
			key = "streetSecondConnection",
			name = _("Second street connection"),
			values = { _("No"), _("Yes") } --_("Horizontal"), _("Vertical") }
		},
	}
end

function paramsutil.makeTerminalStationParams()
	return {
		{
			key = "numTerminalsIndex",
			name = _("Number of terminals"),
			values = { _("1"), _("2"), _("3") }
		},
	}
end

local numbers = function(num)
	local res = {}
	for i=1, num do
		table.insert(res, tostring(i))
	end
	return res
end

function paramsutil.makeIndustryParams(levelCount)
	if levelCount == nil then levelCount = 5 end
	return {
		{
			key = "productionLevel",
			name = _("Industry production level"),
			values = numbers(levelCount)
		},
	}
end

return paramsutil
