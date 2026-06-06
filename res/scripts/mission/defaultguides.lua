local guidesystem = require "guidesystem"

local guides = {}

local reuselist = {
	borrowLoan = 1,
}

function guides.register()
	for k,v in pairs(guidesystem.guides) do
		if reuselist[k] == nil then guidesystem.guides[k] = nil end
	end
end

return guides
