local gui = require "gui"

local script = {
	guiHandleEvent = function (id, name, param)
		if name == "button.click" then
			local fn = gui.buttoncallbacks[id]
			if fn then fn() end
		elseif name == "destroy" then
			local fn = gui.windowcallbacks[id]
			if fn then fn() end
		end
	end
}

function data()
	return script
end
