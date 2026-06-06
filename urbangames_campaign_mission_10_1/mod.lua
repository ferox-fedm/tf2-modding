local taskutil = require "mission.taskutil"
local params = require "params"
local story = require "story"
local vehiclestore = require "mission.vehiclestore"
local modifier = require "mission.modifier"
local transf = require "transf"
local vec3 = require "vec3"

function data()
	return {
		info = {
			minorVersion = 0,
			severityAdd = "NONE",
			severityRemove = "NONE",
			name = _("MISSION10"),
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
