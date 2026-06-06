local names = require "personnameutil"

local firstNamesMale = names.russia.english.firstNamesMale
local firstNamesFemale = names.russia.english.firstNamesFemale
local lastNames = names.russia.english.lastNames

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
