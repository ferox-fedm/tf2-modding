local t = {}

local state = {
	filterdata = {},
	data = {},
}

local filters = {
	cargo = {},
	person = {},
}

local function townbuilding2town(constructionentity)
	if constructionentity < 0 then return end
	local e = game.interface.getEntity(constructionentity)
	if e.townBuildings == nil then return end
	local tb = e.townBuildings[1]
	if tb == nil then return end
	return game.interface.getEntity(tb).town
end

local function createCargoFilter(filtername)
	local fd = state.filterdata[filtername]
	filters.cargo[filtername] = function(id)
		local e = game.interface.getEntity(id)
		local target = e.targetEntity
		local to = townbuilding2town(target) or target
		if fd.to ~= nil and fd.to ~= to then return end
		if fd.from ~= nil and fd.from ~= e.sourceEntity then return end
		if fd.cargotype ~= nil and fd.cargotype ~= e.cargoType then return end
		state.data[filtername] = state.data[filtername] + 1
	end
end

local function person2goal(e)
	local town = townbuilding2town(e.targetOrAtEntity)
	return town or e.targetOrAtEntity
end

local function person2source(e)
	local target = e.targetOrAtEntity
	local dest = e.destinations
	if target == dest[1] then --person went home
		local source = dest[e.lastNonResType + 1]
		local town = townbuilding2town(source)
		return town or source
	else
		local source = dest[1] --person went to shopping/work
		local town = townbuilding2town(source)
		return town or source
	end
end

local function createPersonFilter(filtername)
	local fd = state.filterdata[filtername]
	filters.person[filtername] = function(id)
		local e = game.interface.getEntity(id)
		if e.lastMoveMode ~= 2 then return end --check move mode == lines
		if fd.to ~= nil and fd.to ~= person2goal(e) then return end
		if fd.from ~= nil and fd.from ~= person2source(e) then return end
		state.data[filtername] = state.data[filtername] + 1
	end
end

function t.track(filtername, options)
	if options == nil then
		state.data[filtername] = nil
		state.filterdata[filtername] = nil
		filters.cargo[filtername] = nil
		filters.person[filtername] = nil
		return
	end
	state.filterdata[filtername] = options
	state.data[filtername] = state.data[filtername] or 0
	if options.cargotype == "PASSENGERS" then
		createPersonFilter(filtername)
	else
		createCargoFilter(filtername)
	end
end

function t.get(filtername)
	return state.data[filtername]
end

t.script = {
	save = function()
		return state
	end,
	load = function(loadedstate)
		state = loadedstate or state
		for filtername, options in pairs(state.filterdata) do
			t.track(filtername, options)
		end
	end,
	handleEvent = function (src, id, name, param)
		if id == "SimPersonSystem" and name == "OnCompletedLineUsage" then
			for _,f in pairs(filters.person) do
				f(param)
			end
		elseif id == "SimCargoSystem" and name == "OnToArriveAtDestination" then
			for _,f in pairs(filters.cargo) do
				f(param)
			end
		end
	end,
}

return t
