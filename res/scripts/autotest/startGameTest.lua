function data()

local state = {
	init = false,
}

return {
	update = function()
		if state.init then return end

		print("Script starting game")
	
		app.startGame()

		state.init = true
	end,
	handleEvent = function(id, name, param)
		print("Event: " .. id .. " " .. name)
	end
}
end