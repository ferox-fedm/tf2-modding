local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
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
				name = _("MISSION_FUTURECITY_TASK_5_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_5_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_TASK_5_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
			taskutil.userstate.time5a = game.interface.getGameTime().time
			taskutil:invokeLater(self.name, "showm3", 120)
		end,
		onUpdate = function(self)
			local time = game.interface.getGameTime().time
			local income = game.interface.getPlayerJournal(taskutil.userstate.time5a * 1000, time * 1000).income._sum

			local companyscore = game.interface.getCompanyScore(game.interface.getPlayer())

			self:setProgressCount(income, params.earnings, 1)
			self:setProgressCount(companyscore, params.companyscore, 2)

			local done1 = income >= params.earnings
			local done2 = companyscore >= params.companyscore

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_TASK_5_IMPLEMENT_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_5_IMPLEMENT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_TASK_5_IMPLEMENT_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_FUTURECITY_TASK_5_IMPLEMENT_SUB1") % params },
					{ name = _("MISSION_FUTURECITY_TASK_5_IMPLEMENT_SUB2") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_TASK_5_IMPLEMENT_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				optionsRightAlign = true,
				parentId = "5",
			}
		end,
		handlers = {
			showm3 = function(self)
				if taskutil.tasks["m3"].start ~= nil then
					taskutil.tasks["m3"]:start()
				end
			end,
		},
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
				name = _("MISSION_FUTURECITY_TASK_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_FINISH_TEXT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				voiceOver = "MISSION_FUTURECITY_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
