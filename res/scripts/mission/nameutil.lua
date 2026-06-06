local t = {}

local tagged = {}

function t.setName(id, name)
	tagged[id] = true
	game.interface.setName(id, name)
	local e = game.interface.getEntity(id)
	for i = 1, #(e.stations or {}) do
		local sid = e.stations[i]
		game.interface.setName(sid, name)
		tagged[sid] = true

		local s = game.interface.getEntity(sid)
		game.interface.setName(s.stationGroup, name)
		tagged[s.stationGroup] = true
	end
	for i = 1, #(e.simBuildings or {}) do
		game.interface.setName(e.simBuildings[i], name)
		tagged[e.simBuildings[i]] = true
	end
	for i = 1, #(e.depots or {}) do
		game.interface.setName(e.depots[i], name)
		tagged[e.depots[i]] = true
	end
end

function t.checkTagged()
	local types = { "CONSTRUCTION", "SIM_BUILDING", "STATION", "STATION_GROUP", "VEHICLE_DEPOT",  "TOWN","VEHICLE", "LINE", }
	local err = 0
	for i = 1, #types do
		local t = types[i]
		local entities = game.interface.getEntities({ radius = 1e100 }, { type = t })
		for j = 1, #entities do
			if not tagged[entities[j]] then
				local e = game.interface.getEntity(entities[j])
				if #(e.townBuildings or {}) == 0 then
					local p = e.position
					err = err + 1
					print(t:lower() .. " entity " .. e.id .. ": '" .. e.name .. "' is not properly renamed (" .. p[1] .. ", " .. p[2] .. ", " .. p[3] ..  ")")
				end
			end
		end
	end
	print("nameutil tag check completed " .. (err == 0 and "successfully" or ("with " .. err .. " errors")))
end

return t
