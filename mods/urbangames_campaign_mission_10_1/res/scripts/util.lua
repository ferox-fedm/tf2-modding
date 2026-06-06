local taskutil = require "mission.taskutil"

local t = {}

function t.endchapter(chapter)
	for i = 1, 5 do
		local s = chapter .. "a" .. i
		local t = taskutil.tasks[s]
		if t ~= nil and t.start == nil and t.finish ~= nil then
			t:setProgressNone()
			t:finish()
		end
		taskutil:setMarker(s)
	end
end

function t.airfield2pstationgroup(conEntity)
	local stations = game.interface.getEntity(conEntity).stations
	for i = 1, #stations do
		local s = game.interface.getEntity(stations[i])
		if s.cargo == false then return s.stationGroup end
	end
end

function t.line2vehicles(line)
	local vehicles = game.interface.getVehicles()
	local result = {}
	for i = 1, #vehicles do
		if game.interface.getEntity(vehicles[i]).line == line then
			result[#result + 1] = vehicles[i]
		end
	end
	return result
end

return t
