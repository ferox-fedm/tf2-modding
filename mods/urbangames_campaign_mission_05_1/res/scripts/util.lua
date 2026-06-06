local params = require "params"
local taskutil = require "mission.taskutil"
local transf = require "transf"
local vec3 = require "vec3"

local t = {}

function t.mode2capacity(mode)
	if mode == 1 then return 200 end
	if mode == 2 then return 400 end
end --params.construction_site_capacity_1 * mode end

function t.mode2count(mode) 
	if mode == 1 then return 40 end
	if mode == 2 then return 60 end
end --t.mode2capacity(mode) * 5 end

local function key(siteIdx)
	return "construction_site_" .. siteIdx
end

function t.activate(siteIdx)
	game.interface.upgradeConstruction(params[key(siteIdx)], "industry/construction_site.con", { productionLevel = 0, idx = siteIdx, capacity = t.mode2capacity(taskutil.userstate.mode)})
end

function t.updateSite(task, siteIdx)
	local tot = t.mode2count(taskutil.userstate.mode)
	local steel
	local stone
	local persons

	local function getSiteData(siteIdx)
		local id = params[key(siteIdx)]
		local pos = game.interface.getEntity(id).position
		local stations = game.interface.getEntities({pos = pos, radius = 200}, {type = "STATION"})
		local persons = 0
		for i = 1, #stations do
			local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.PASSENGERS or 0
			persons = persons + s
		end
		local consumed = game.interface.getEntity(game.interface.getEntity(id).simBuildings[1]).itemsConsumed
		local steel = consumed.STEEL or 0
		local stone = consumed.STONE or 0
		return { steel, stone, persons }
	end

	local data = getSiteData(siteIdx)
	steel = data[1]
	stone = data[2]
	persons = data[3]

	local progress
	if siteIdx == 1 then
		progress = steel
		task:setProgressCount(steel, tot, 1)
	elseif siteIdx == 2 then
		progress = stone
		task:setProgressCount(stone, tot, 1)
	elseif siteIdx == 3 then
		progress = math.min(steel, stone)
		task:setProgressCount(steel, tot, 1)
		task:setProgressCount(stone, tot, 2)
		if steel > tot then task:setSubtaskCompleted(1) end
		if stone > tot then task:setSubtaskCompleted(2) end
	end
	--task:setProgressPercent(progress / tot)

	return progress / tot
end

function t.deactivate(siteIdx)
	game.interface.upgradeConstruction(params[key(siteIdx)], "industry/construction_site.con", { productionLevel = 0, capacity = 0})
end

local function getprogresslevels(tracklist)
	local n = #tracklist
	local d = 1 / n
	local result = {}
	for i = 1, n do
		result[#result + 1] = i * d
	end
	result[#result] = 1 -- avoid rounding issues at 100%

	return result
end

local function gettracksbyprogress(tracklist, n)
	local result = {}

	for i = 1, n do
		result[i] = tracklist[i]
	end

	return result
end

local function gettracklists(pos)
	local entities = game.interface.getEntities({pos = {0, 0, 0}, radius = 1e100}, { type = "CONSTRUCTION" })
	for i = 1, #entities do
		local id = entities[i]
		local e = game.interface.getEntity(id)
		if e.fileName == "industry/track_list.con" then
			if vec3.distance(vec3.new(e.transf[13], e.transf[14], e.transf[15]), vec3.new(table.unpack(pos))) < 1 then
				print("recovered tracklist", id)
				return id
			end
		end
	end
end

local function build(tracklistname)
	taskutil.userstate[tracklistname .. "progress"] = 0
	local tracklist = params[tracklistname]
	local id = gettracklists(tracklist[1].node0pos)
	if id == nil then
		id = game.interface.buildConstruction("industry/track_list.con", { productionLevel = 0, tracklist = gettracksbyprogress(tracklist, 0) },
				transf.rotZTransl(0.0, vec3.new(table.unpack(tracklist[1].node0pos))))
	end
	return id
end

function t.upgrade(tracklistname, progress)
	local tracklist = params[tracklistname]
	local savedprogress = taskutil.userstate[tracklistname .. "progress"]
	local progresslevels = getprogresslevels(tracklist)
	local n = nil
	for i = 1, #progresslevels do
		if progress >= progresslevels[i] then
			n = i
		else
			break
		end
	end
	if n == savedprogress then return end
	taskutil.userstate[tracklistname .. "progress"] = n
	local id = taskutil.userstate[tracklistname]
	if id == nil then
		id = build(tracklistname)
		taskutil.userstate[tracklistname] = id
	end
	local tracklist = gettracksbyprogress(tracklist, n)
	local complete = n == #progresslevels
	game.interface.upgradeConstruction(id, "industry/track_list.con", { productionLevel = 0, tracklist = tracklist, complete = complete })
end

return t
