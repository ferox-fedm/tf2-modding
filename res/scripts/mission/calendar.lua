local calendar = {}

local daysperyear = 365.25
local dayspermonth = daysperyear / 12
local chartslockinterval = 2 * daysperyear -- game time seconds

function calendar.syncDate(startyear)
	local millisperday = game.interface.getMillisPerDay()
	if millisperday == 0 then return end
	local dayspersecond = 1000 / millisperday
	local timepassed = game.interface.getGameTime().time
	local remainder = timepassed % chartslockinterval

	--8
	local daystoforward = math.floor(remainder * dayspersecond) - 1

	game.interface.setDate(1, 1, startyear)
	local forwarddate = game.interface.getDateFromNowPlusOffsetDays(daystoforward)
	game.interface.setDate(table.unpack(forwarddate))
end

function calendar.secondsperyear()
	local secondsperday = calendar.secondsperday()
	return secondsperday * daysperyear
end

function calendar.secondspermonth()
	return calendar.secondsperyear() / 12
end

function calendar.secondsperday()
	return calendar.secondsperdayif(game.interface.getMillisPerDay())
end

function calendar.secondsperyearif(millisperday)
	local secondsperday = calendar.secondsperdayif(millisperday)
	return secondsperday * daysperyear
end

function calendar.secondspermonthif(millisperday)
	return calendar.secondsperyearif(millisperday) / 12
end

function calendar.secondsperdayif(millisperday)
	return millisperday / 1000
end

return calendar
