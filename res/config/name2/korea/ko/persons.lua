local names = require "personnameutil"

local firstNamesMale = names.korea.korean.firstNamesMale
local firstNamesFemale = names.korea.korean.firstNamesFemale
local lastNames = names.korea.korean.lastNames

function data()
return {
	makeName = function (male)
		if (male) then
			return lastNames[math.random(#lastNames)] .. firstNamesMale[math.random(#firstNamesMale)]
		else
			return lastNames[math.random(#lastNames)] .. firstNamesFemale[math.random(#firstNamesFemale)]
		end
	end
}
end
