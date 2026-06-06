local params = require "params"
local modifier = require "mission.modifier"

function data()
	return {
		info = {
			minorVersion = 0,
			severityAdd = "NONE",
			severityRemove = "NONE",
			name = _("MISSION01"),
			description = _("..."),
			visible = false,
			cosmetic = true,
		},
		options = {
		},

		runFn = function (settings)
			game.config.environment = "mission_1.lua"

			modifier.treevisitor(params.restree)
		end
	}
end
