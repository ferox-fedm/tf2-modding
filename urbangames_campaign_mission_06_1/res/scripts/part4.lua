local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("4", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track4")
		end,
		onFinish = function(self)
			taskutil.tasks["4a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_TASK_SILVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_SILVER_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_overview,
				voiceOver = "MISSION_BAGDAD_TASK_SILVER_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal1", 120)
			arrivaltracker.track("4a1", { cargotype = "SILVER_ORE", to = params.tribe1 })
		end,
		onUpdate = function(self)
			local consumed1 = arrivaltracker.get("4a1")
			local consumed2 = game.interface.getEntity(game.interface.getEntity(params.machine_storage_harbour).simBuildings[1]).itemsConsumed.SILVER_ORE or 0
			self:setProgressCount(consumed2, params.silver_deliver_amount, 1)
			self:setProgressCount(consumed1, params.silver_deliver_amount, 2)
			self:setSubtaskCompleted(1, consumed2 >= params.silver_deliver_amount)
			self:setSubtaskCompleted(2, consumed1 >= params.silver_deliver_amount)
			if consumed1 >= params.silver_deliver_amount and consumed2 >= params.silver_deliver_amount then
				self:finish()
			end
		end,
		onFinish = function(self)
			arrivaltracker.track("4a1")
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_TASK_SILVER_DELIVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_SILVER_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_TASK_SILVER_DELIVER_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				subTasks = {
					{ name = _("MISSION_BAGDAD_TASK_SILVER_DELIVER_SUB2") % params },
					{ name = _("MISSION_BAGDAD_TASK_SILVER_DELIVER_SUB1") % params },
				},
				camera = params.jump_tribe1,
				voiceOver = "MISSION_BAGDAD_TASK_SILVER_DELIVER_TEXT.wav",
			}
		end,
		handlers = {
			showmedal1 = function(self) taskutil:start("m1") end,
		},
	})
end
