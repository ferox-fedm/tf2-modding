require "tableutil"
local ssu = require "stylesheetutil"

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("CameraTool::DebugText", {
        fontSize = 24,
    })
	
	return result
end
