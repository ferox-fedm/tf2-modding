local names = require "personnameutil"

function data()
return {
	makeName = function (male)
		local countries = { "korea", "russia", "china", "japan" }
		local lastNameLast = { false, true, false, false }
		local idx = math.random(#countries)
		local source = names[countries[idx]].english
	
		if 	lastNameLast[idx] then
			if (male) then
				return source.firstNamesMale[math.random(#source.firstNamesMale)] .. " " .. source.lastNames[math.random(#source.lastNames)]
			else
				return source.firstNamesFemale[math.random(#source.firstNamesFemale)] .. " " .. source.lastNames[math.random(#source.lastNames)]
			end
		else
			if (male) then
				return source.lastNames[math.random(#source.lastNames)] .. " " .. source.firstNamesMale[math.random(#source.firstNamesMale)]
			else
				return source.lastNames[math.random(#source.lastNames)] .. " " .. source.firstNamesFemale[math.random(#source.firstNamesFemale)]
			end
		end
	end
}
end
