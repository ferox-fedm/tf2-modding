local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("4", {
		onStart = function(self)
			taskutil:setMusicTrack("track4")
			self:setProgressNone()
		end,
		onFinish = function(self)
			if taskutil.userstate.gotthardblowup then
				taskutil.tasks["4c"]:start()
			else
				taskutil.tasks["4b"]:start()
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_HARDTIMES_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_HARDTIMES_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_HARDTIMES_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	--[[
	unused	4a
	]]--

	taskutil:new("4b", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal2", 120)
		end,
		onUpdate = function(self)
			arrivaltracker.track("4b1", { cargotype = "COAL", from = params.coalmine, to = params.como })
			arrivaltracker.track("4b2", { cargotype = "IRON_ORE", from = params.ironoremine, to = params.friedrichshafen })

			local tot_coal = arrivaltracker.get("4b1")
			local tot_iron = arrivaltracker.get("4b2")

			self:setProgressCount(tot_coal, params.coal_4, 1)
			self:setProgressCount(tot_iron, params.iron_4, 2)

			self:setSubtaskCompleted(1, tot_coal >= params.coal_4)
			self:setSubtaskCompleted(2, tot_iron >= params.iron_4)

			if tot_iron >= params.iron_4 and tot_coal >= params.coal_4 then self:finish() end

		end,
		onFinish = function(self)
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_MOBILE_TRANSIT_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_HARDTIMES_TRANSIT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SWISSMADE_TASK_MOBILE_TRANSIT_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_SWISSMADE_TASK_MOBILE_TRANSIT_SUB1") },
					{ name = _("MISSION_SWISSMADE_TASK_MOBILE_TRANSIT_SUB2") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_HARDTIMES_TRANSIT_TEXT.wav",
			}
		end,
		handlers = {
			showmedal2 = function(self) taskutil:start("m2") end,
		},
	})

	taskutil:new("4c", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal2", 120)
		end,
		onUpdate = function(self)

			arrivaltracker.track("4c1", { cargotype = "MACHINES", from = params.machinefactory, to = params.friedrichshafen })
			arrivaltracker.track("4c2", { cargotype = "GRAIN", from = params.farm_south_west, to = params.como })
			arrivaltracker.track("4c3", { cargotype = "GRAIN", from = params.farm_south_east, to = params.como })
			arrivaltracker.track("4c4", { cargotype = "GRAIN", from = params.storage_south, to = params.como })

			local tot_machines = arrivaltracker.get("4c1")
			local tot_grain = arrivaltracker.get("4c2") + arrivaltracker.get("4c3") + arrivaltracker.get("4c4")

			self:setProgressCount(tot_machines, params.machines_4, 1)
			self:setProgressCount(tot_grain, params.grain_4, 2)

			self:setSubtaskCompleted(1, tot_machines >= params.machines_4)
			self:setSubtaskCompleted(2, tot_grain >= params.grain_4)
			
			if tot_machines >= params.machines_4 and tot_grain >= params.grain_4 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_MOBILE_INDUSTRY_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_HARDTIMES_INDUSTRY_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SWISSMADE_TASK_MOBILE_INDUSTRY_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_SWISSMADE_TASK_MOBILE_INDUSTRY_SUB1") },
					{ name = _("MISSION_SWISSMADE_TASK_MOBILE_INDUSTRY_SUB2") },
				},
				parentId = "4",
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_HARDTIMES_INDUSTRY_TEXT.wav",
			}
		end,
		handlers = {
			showmedal2 = function(self) taskutil:start("m2") end,
		},
	})
end
