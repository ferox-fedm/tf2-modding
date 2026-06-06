local function isModPath(fileName)
	if string.starts(fileName, "res/") then return false end

	return true
end

local filefilterutil = {
	util = {
		always = function (fileName, data)
				return true
			end,

		combineOr = function (filters)
				return function(fileName, data)
						for i, fn in ipairs(filters) do
							if fn(fileName, data) then
								return true
							end
						end
						return false
					end
			end,

		combineAnd = function (filters)
				return function(fileName, data)
						for i, fn in ipairs(filters) do
							if not fn(fileName, data) then
								return false
							end
						end
						return true
					end
			end
	},

	package = {
		base = function (fileName, data)
				return not isModPath(fileName)
			end,

		mod = function (fileName, data)
				return isModPath(fileName)
			end,
	},

	model = {
		vehicle = function (fileName, data)
			return data.metadata.transportVehicle ~= nil
		end,
			
		person = function (fileName, data)
			return data.metadata.person ~= nil
		end,
		
		car = function (fileName, data)
			return data.metadata.car ~= nil
		end,

		rock = function (fileName, data)
			return data.metadata.rock ~= nil
		end,
			
		tree = function (fileName, data)
			return data.metadata.tree ~= nil
		end,

		signal = function (fileName, data)
			return data.metadata.signal ~= nil
		end,

		animal = function (fileName, data)
			return data.metadata.animal ~= nil
		end,

		other = function (fileName, data)
			return not data.metadata.transportVehicle 
				and not data.metadata.person
				and not data.metadata.car 
				and not data.metadata.rock 
				and not data.metadata.tree 
				and not data.metadata.signal 
				and not data.metadata.animal 
		end
	}
}

return filefilterutil
