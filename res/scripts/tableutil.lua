function table.copy(obj)
	if type(obj) ~= 'table' then
		return obj
	end

	local res = { }
	for k, v in pairs(obj) do
		res[table.copy(k)] = table.copy(v)
	end
	return res
end

function table.toString(t, lvl)
	if type(t) == "table" then
		if not lvl then lvl = 1 end
		local res = "{\n"
		for k, v in pairs(t) do
			local s = string.rep("    ", lvl) .. "[" .. k .. "]" .. " = "
			if type(v) == "table" then
				res = res .. s .. table.toString(v, lvl+1)
			elseif type(v) == 'boolean' then
				res = res .. s .. tostring(v)
			elseif type(v) == 'function' then
				res = res .. s .. tostring("<function>")
			elseif type(v) == 'userdata' then
				res = res .. s .. tostring("<userdata>")
			else
				res = res .. s .. v
			end
			res = res .. ",\n"
		end
		res = res .. string.rep("    ", lvl-1) .. "}"
		return res
	elseif type(t) == 'boolean' then
		return tostring(t)
	elseif type(t) == 'function' then
		return tostring("<function>")
	elseif type(t) == 'userdata' then
		return tostring("<userdata>")
	else
		return t
	end
end