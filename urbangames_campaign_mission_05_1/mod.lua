local params = require "params"
local modifier = require "mission.modifier"

function data()
	return {
		info = {
			minorVersion = 0,
			severityAdd = "NONE",
			severityRemove = "NONE",
			name = _("MISSION05"),
			description = _("..."),
			visible = false,
			cosmetic = true,
		},
		options = {
		},

		runFn = function (settings)
			modifier.treevisitor(params.restree)
		end
	}
end
