local taskutil = require "mission.taskutil"
local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local modifier = require "mission.modifier"

function data()
	return {
		info = {
			minorVersion = 0,
			severityAdd = "NONE",
			severityRemove = "NONE",
			name = _("MISSION08"),
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
