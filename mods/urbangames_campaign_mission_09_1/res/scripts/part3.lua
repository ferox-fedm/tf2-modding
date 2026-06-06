local taskutil = require "mission.taskutil"
local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local util = require "util"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	local function countbuses()
		local vehicles = vehiclestore.currentvehicles
		local count = (vehicles["vehicle/bus/aboag_v2.mdl"] or 0)
		            + (vehicles["vehicle/bus/et13_v2.mdl"] or 0)
		            + (vehicles["vehicle/bus/saurer_tuescher_v2.mdl"] or 0)
		            + (vehicles["vehicle/bus/landauer_v2.mdl"] or 0)

		return count
	end

	taskutil:new("3", {
		onStart = function(self)
			taskutil:setMusicTrack("track3")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_REDUIT_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_REDUIT_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_REDUIT_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal3", 120)
			game.interface.upgradeConstruction(params.storage_north, "industry/custom.con", {
				productionLevel = 0,
				stocks = {
				},
				input = { { } },
				output = { GRAIN = 1 },
				capacity = 200,
			})
			game.interface.upgradeConstruction(params.storage_south, "industry/custom.con", {
				productionLevel = 0,
				stocks = {
				},
				input = { { } },
				output = { GRAIN = 1 },
				capacity = 200,
			})

		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			if countbuses() > params.buses_3b then
				taskutil.tasks["3b"]:start()
			else
				taskutil.tasks["3c"]:start()
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_REDUIT_GOTTHARD_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_REDUIT_GOTTHARD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SWISSMADE_TASK_REDUIT_GOTTHARD_TASK") % params },
				},
				options = { { _("MISSION_SWISSMADE_TASK_REDUIT_GOTTHARD_OPTION1"), "blowup" }, { _("MISSION_SWISSMADE_TASK_REDUIT_GOTTHARD_OPTION2"), "finish" } },
				optionsRightAlign = true,
				parentId = "3",
				camera = params.gotthard_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_REDUIT_GOTTHARD_TEXT.wav",
			}
		end,
		handlers = {
			blowup = function(self)
				game.interface.upgradeConstruction(params.tracktunnel, "industry/tracklist.con", { productionLevel = 0 })
				taskutil.userstate.gotthardblowup = true
				taskutil:finish(self.name)
			end,
			showmedal3 = function(self) taskutil:start("m3") end,
		},
		guiHandlers = {
			blowup = function(self) taskutil:sendScriptFn(self.name, "blowup") end,
		},
	})

	taskutil:new("3b", {
		onStart = function(self)
			taskutil.userstate.countbuses3a = countbuses()
		end,
		onUpdate = function(self)
			if taskutil.userstate.countbuses3a - countbuses() >= params.buses_3b_sell then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["3c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_REDUIT_BUGS_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_REDUIT_BUGS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SWISSMADE_TASK_REDUIT_BUGS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_REDUIT_BUGS_TEXT.wav",
			}
		end,
	})

	taskutil:new("3c", {
		onStart = function(self)
			arrivaltracker.track("3cnorth", { cargotype = "GRAIN", from = params.storage_north })
			arrivaltracker.track("3csouth", { cargotype = "GRAIN", from = params.storage_south })
		end,
		onUpdate = function(self)
			local supply = 0
			local demand = 0
			for i = 1, #params.cities do
				local f = game.interface.getTownCargoSupplyAndLimit(params[params.cities[i]]).FOOD
				if f then
					supply = supply + f[1]
					demand = demand + f[2]
				end
			end
			local coverage = supply / demand * 100

			local consumed = arrivaltracker.get("3cnorth") + arrivaltracker.get("3csouth")

			self:setProgressCount(coverage, params.coverage_3b, 1)
			self:setProgressCount(consumed, params.grain_3b, 2)

			local done1 = coverage >= params.coverage_3b
			local done2 = consumed >= params.grain_3b
			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then
				self:finish()
			end

		end,
		onFinish = function(self)
			arrivaltracker.track("3cnorth")
			arrivaltracker.track("3csouth")
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_REDUIT_RESERVES_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_REDUIT_RESERVES_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SWISSMADE_TASK_REDUIT_RESERVES_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_SWISSMADE_TASK_REDUIT_RESERVES_SUB1") % params },
					{ name = _("MISSION_SWISSMADE_TASK_REDUIT_RESERVES_SUB2") % params },
				},
				parentId = "3",
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_REDUIT_RESERVES_TEXT.wav",
			}
		end,
	})
end
