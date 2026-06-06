local params = require "params"
local modifier = require "mission.modifier"

function data()
	return {
		info = {
			minorVersion = 0,
			severityAdd = "NONE",
			severityRemove = "NONE",
			name = _("MISSION17"),
			description = _("..."),
			visible = false,
			cosmetic = true,
		},
		options = {
		},

		runFn = function (settings)
			game.config.terrainToolMaxSize = 4

			modifier.treevisitor(params.restree)
		end
	}
end
