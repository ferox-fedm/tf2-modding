local getMaximumLoan = function()
	local year = game.interface.getGameTime().date.year
	if year < 1900 then return 10000000 end
	if year < 1950 then return 30000000 end
	return 100000000
end

local setMaximumLoan = function()
	local factor = game.config.advancedOptions.maximumLoanScale
	game.interface.setMaximumLoan(game.interface.getPlayer(), getMaximumLoan() * factor)
end

function data()
return {
	init = function()
		setMaximumLoan()
	end,
	update = function()
		setMaximumLoan()
	end,
}
end
