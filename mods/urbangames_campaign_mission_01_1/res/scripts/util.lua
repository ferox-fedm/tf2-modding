local vec2 = require "vec2"
local p = require "params"

local t = {}

function t.hasCargoplatform(toAdd)
	return toAdd.hasCargoPlatform
end

function t.getAllLineBetweenZones(zone1, zone2)
	local stations1 = game.interface.getEntities(zone1, { type = "STATION" })
	local stations2 = game.interface.getEntities(zone2, { type = "STATION" })

	local result = {}

	for s1Idx = 1, #stations1 do
		local s1Entity = game.interface.getEntity(stations1[s1Idx])
		local s1Lines = game.interface.getLines({ stationGroup = s1Entity.stationGroup})

		for s2Idx = 1, #stations2 do
			local s2Entity = game.interface.getEntity(stations2[s2Idx])
			local s2Lines = game.interface.getLines({ stationGroup = s2Entity.stationGroup})

			for line1Idx = 1, #s1Lines do
				for line2Idx = 1, #s2Lines do

					if s1Lines[line1Idx] == s2Lines[line2Idx] then
						result[#result + 1] = s1Lines[line1Idx]
					end
				end
			end
		end
	end
	return result
end

function t.getLineBetweenZones(zone1, zone2)
	return t.getAllLineBetweenZones(zone1, zone2)[1]
end

function t.getStationNameInZone(zone)
	local stationgroups = game.interface.getEntities(zone, {type = "STATION_GROUP"})
	if #stationgroups > 0 then
		return stationgroups[1]
	else
		return p.silverProcessing --fallback to avoid crash
	end
end

function t.pullmanWagonIsInZone(zone)
	local allVehicles = game.interface.getEntities(zone, { type="VEHICLE" })
	for i = 1, #allVehicles do
		local e = game.interface.getEntity(allVehicles[i])
		for w = 1, #e.vehicles do
			if string.match(e.vehicles[w].fileName, "pullman") then
				return true
			end
		end
	end
	return false
end

return t
