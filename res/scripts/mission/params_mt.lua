local mt = {
	__index = function(self, key)
		local n = #"pos_"
		if key:sub(1, n) == "pos_" then
			return game.interface.getEntity(self[key:sub(n + 1)]).position
		end
		local m = #"name_"
		if key:sub(1, m) == "name_" then
			return game.interface.getName(self[key:sub(m + 1)])
		end
		local o = #"jump_"
		if key:sub(1, o) == "jump_" then
			local entry = self[key:sub(o + 1)]
			local default = { 0, 0, 500 }
			if entry == nil then return default
			elseif type(entry) == "number" then
				local e = game.interface.getEntity(self[key:sub(o + 1)])
				if e == nil or e.position == nil then return default end
				local p = e.position
				return { p[1], p[2], 250 }
			elseif type(entry) == "table" then
				return { entry.pos[1], entry.pos[2], entry.pos[3] or 250 }
			end
		end
	end,
}

return mt
