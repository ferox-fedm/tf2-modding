local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("2", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track2")
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_PRODUCTION_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_PRODUCTION_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_steelmill,
				voiceOver = "MISSION_LEADER_TASK_PRODUCTION_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			arrivaltracker.track("2a1", { cargotype = "IRON_ORE", to = params.steelmill })
			arrivaltracker.track("2a2", { cargotype = "PASSENGERS", to = params.steelmill })
		end,
		onUpdate = function(self)
			local c1 = arrivaltracker.get("2a1")
			local c2 = arrivaltracker.get("2a2")

			self:setProgressCount(c1, params.people_amount, 1)
			self:setProgressCount(c2, params.iron_amount, 2)

			local done1 = c1 >= params.people_amount
			local done2 = c2 >= params.iron_amount

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("2a1")
			arrivaltracker.track("2a2")
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_PRODUCTION_STEEL_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_PRODUCTION_STEEL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_PRODUCTION_STEEL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_LEADER_TASK_PRODUCTION_STEEL_SUB1") },
					{ name = _("MISSION_LEADER_TASK_PRODUCTION_STEEL_SUB2") },
				},
				parentId = "2",
				camera = params.jump_steelmill,
				voiceOver = "MISSION_LEADER_TASK_PRODUCTION_STEEL_TEXT.wav",
			}
		end,
	})
end
