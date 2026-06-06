local params = require "params"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("5", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track5")
		end,
		onFinish = function(self)
			taskutil.tasks["5a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_UTILIZATION_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_UTILIZATION_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_overviewpos,
				voiceOver = "MISSION_TRANSSIB_TASK_UTILIZATION_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			--local g = game.interface.getEntity(game.interface.getEntity(params.goods_consumer).simBuildings[1]).itemsConsumed.GOODS or 0
			--local done1 = g >= params.goods_5a
			--self:setProgressCount(g, params.goods_5a, 1)

			local w = game.interface.getEntity(game.interface.getEntity(params.war_material_consumer).simBuildings[1]).itemsConsumed.WAR_MATERIAL or 0
			local done2 = w >= params.war_material_5a
			self:setProgressCount(w, params.war_material_5a)

			if done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_UTILIZATION_SITE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_UTILIZATION_SITE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_TASK_UTILIZATION_SITE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				--subTasks = {
					--{ name = _("MISSION_TRANSSIB_TASK_UTILIZATION_SITE_SUB1") % params },
					--{ name = _("MISSION_TRANSSIB_TASK_UTILIZATION_SITE_SUB2") % params },
				--},
				parentId = "5",
				camera = params.jump_war_material_consumer,
				voiceOver = "MISSION_TRANSSIB_TASK_UTILIZATION_SITE_TEXT.wav",
			}
		end,
	})

	taskutil:new("end", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setCompleted()
			taskutil:invokeLater(self.name, "finish", 0.6)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_FINISH_TEXT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				voiceOver = "MISSION_TRANSSIB_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
