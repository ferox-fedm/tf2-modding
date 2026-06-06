local taskutil = require "mission.taskutil"
local params = require "params"

local t = {}

function t.unloaded(city, itemname)
	local stations = game.interface.getEntities({pos = params["pos_"..city], radius = 500}, {type = "STATION"})
	local count = 0
	for i = 1, #stations do
		local s = game.interface.getEntity(stations[i])
		if s.carriers.RAIL then
			count = count + (game.interface.getEntity(s.stationGroup).itemsUnloaded[itemname] or 0)
		end
	end
	return count
end

return t
