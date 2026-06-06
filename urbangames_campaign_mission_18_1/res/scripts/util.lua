local util = {}

local params = require "params"

function util.getStations(carrier)
	local result = {}
	for i = 1, #params.cities do
		local stations = game.interface.getStations({ town = params.cities[i], carrier = carrier })
		for j = 1, #stations do
			result[#result + 1] = stations[j]
		end
	end
	return result
end

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

function util.getConstructionsWithCarrier(carrier)
	local stations = util.getStations(carrier)
	local mapping = {}
	for i = 1, #stations do
		mapping[util.station2construction(stations[i]).id] = 1
	end
	local result = {}
	for k, _ in pairs(mapping) do
		result[#result + 1] = k
	end
	return result
end

function util.getItemsUnloaded(carrier, cargotype)
	local stations = util.getStations(carrier)
	local result = 0
	for j = 1, #stations do
		local s = game.interface.getEntity(stations[j])
		if s.stationGroup >= 0 then
			local s = game.interface.getEntity(s.stationGroup)
			result = result + (s.itemsUnloaded[cargotype] or 0)
		end
	end
	return result
end

return util
