local taskutil = require "mission.taskutil"
local params = require "params"

local t = {}

function t.activateAirfield(id)
	game.interface.setPlayer(id, game.interface.getPlayer())
	game.interface.setBulldozeable(id, false)
end

function t.deactivateAirfield(id)
	game.interface.setBulldozeable(id, true)
	game.interface.setPlayer(id, taskutil.userstate.aiplayer)
end

return t
