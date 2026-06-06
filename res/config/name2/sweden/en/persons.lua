local names = require "personnameutil"

local firstNamesMale = names.sweden.english.firstNamesMale
local firstNamesFemale = names.sweden.english.firstNamesFemale
local lastNames = names.sweden.english.lastNames

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
