local t = {}

local exceptions = { }

function t.except(id)
	exceptions[id] = true
end

function t.upgrade()
	local entities = game.interface.getEntities({ radius = 1e100 }, { type = "CONSTRUCTION" })
	for j = 1, #entities do
		local id = entities[j]
		local e = game.interface.getEntity(id)
		local conparams = e.params
		conparams.seed = nil
		if not exceptions[id] and #(e.townBuildings or {}) == 0 then
			print("upgrading " .. e.name ..  " (" .. id .. ") with " .. e.fileName)
			game.interface.upgradeConstruction(id, e.fileName, conparams)
		end
	end
end

return t
