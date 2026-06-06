local legacyutil = { }

function legacyutil.convertGroundTextureKeys(result)
	if result.groundFaces == nil then return end

	for k, v in pairs(result.groundFaces) do
		if v and v.modes then
			for k1, v1 in pairs(v.modes) do
				local key = v1.key
				local sub = string.sub(key, -4)
				if sub ~= ".lua" then
					print("Legacy warning: ground texture keys should end with '.lua': " .. key)
					result.groundFaces[k].modes[k1].key = v1.key .. ".lua"
				end
			end
		end 
	end
end

return legacyutil
