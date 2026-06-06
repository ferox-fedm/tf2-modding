local names = require "personnameutil"

local firstNamesMale = names.russia.russian.firstNamesMale
local firstNamesFemale = names.russia.russian.firstNamesFemale
local lastNames = names.russia.russian.lastNames

function data()
return {
	makeName = function (male)
		if (male) then
			return firstNamesMale[math.random(#firstNamesMale)] .. " " .. lastNames[math.random(#lastNames)]
		else
			return firstNamesFemale[math.random(#firstNamesFemale)] .. " " .. lastNames[math.random(#lastNames)]
		end
	end
}
end
