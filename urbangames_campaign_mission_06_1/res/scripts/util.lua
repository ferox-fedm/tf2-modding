local params = require "params"

local t = {}

function t.getHq()
	local entities = game.interface.getEntities({ pos = game.interface.getEntity(params.adana).position, radius = 500 }, { type = "CONSTRUCTION" })
	for i = 1, #entities do
		local e = game.interface.getEntity(entities[i])
		if e.fileName == "asset/headquarter.con" then
			return e
		end
	end
end

return t
