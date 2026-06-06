local names = require "personnameutil"

local firstNamesMale = names.norway.english.firstNamesMale
local firstNamesFemale = names.norway.english.firstNamesFemale
local lastNames = names.norway.english.lastNames

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
