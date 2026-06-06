local util = {}

local taskutil = require "mission.taskutil"
local params = require "params"
local polygonutil = require "polygonutil"

function util.station2construction(station, radius)
	if radius == nil then radius = 30 end
	if radius > 120 then return end
	local e = game.interface.getEntity(station)
	local pos = e.position
	local cons = game.interface.getEntities({ pos = pos, radius = radius }, { type = "CONSTRUCTION" })
	for i = 1, #cons do
		local c = game.interface.getEntity(cons[i])
		for j = 1, #c.stations do
			if c.stations[j] == station then
				return c
			end
		end
	end
	return util.station2construction(station, radius + radius)
end

function util.collecttowns(zone)
	local towns = {}
	for i = 1, #params.call do
		local townid = params.call[i]
		local town = game.interface.getEntity(townid)
		if polygonutil.contains(zone, town.position) then
			towns[#towns + 1] = townid
		end
	end
	return towns
end

function util.collecttownsfromregionaltrains(callback)
	local trains = game.interface.getVehicles({ carrier = "RAIL" })
	for i = 1, #trains do
		local v = game.interface.getEntity(trains[i])
		local hasice = false
		for j = 1, #v.vehicles do
			if v.vehicles[j].fileName == params.icetrain then
				hasice = true
				break
			end
		end
		if not hasice then
			if v.state == "AT_TERMINAL" then
				local line = game.interface.getEntity(v.line)
				local stop = game.interface.getEntity(line.stops[v.stopIndex + 1])
				local station = game.interface.getEntity(stop.stations[1])
				local town = station.town
				callback(town)
			end
		end
	end
end

function util.foralltrainstations(towns, fn)
	for i = 1, #towns do
		local town = towns[i]
		local stations = game.interface.getStations({ town = town, carrier = "RAIL" })
		for j = 1, #stations do
			local con = util.station2construction(stations[j])
			fn(con)
		end
	end
end

return util
