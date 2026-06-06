local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
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
				name = _("MISSION_FUTURECITY_TASK_4_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_4_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_TASK_4_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm2", 120)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["4b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_TASK_4_DECIDE_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_4_DECIDE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_TASK_4_DECIDE_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_TASK_4_DECIDE_TEXT.wav",
				options = { { _("MISSION_FUTURECITY_TASK_4_DECIDE_OPTION1"), "option1" },
				            { _("MISSION_FUTURECITY_TASK_4_DECIDE_OPTION2"), "option2" } },
				parentId = "4",
			}
		end,
		handlers = {
			option1 = function(self)
				taskutil.userstate.choice4a = 1
				taskutil:finish(self.name)
			end,
			option2 = function(self)
				taskutil.userstate.choice4a = 2
				taskutil:finish(self.name)
			end,
			showm2 = function(self)
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
				end
			end,
		},
		guiHandlers = {
			option1 = function(self)
				taskutil:sendScriptFn(self.name, "option1")
			end,
			option2 = function(self)
				taskutil:sendScriptFn(self.name, "option2")
			end,
		},
	})

	taskutil:new("4b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			if taskutil.userstate.choice4a == 1 then
				local res = 0
				for i = 1, #params.cities do
					local c = game.interface.getTownCapacities(params.cities[i])
					res = res + c[1]
				end

				local goals = params["choice4_" .. taskutil.userstate.choice4a]
				self:setProgressCount(res, goals.residential, 1)

				local done = res >= goals.residential

				self:setSubtaskCompleted(1, done)

				if done then self:finish() end
			else
				local com = 0
				local ind = 0
				for i = 1, #params.cities do
					local c = game.interface.getTownCapacities(params.cities[i])
					com = com + c[2]
					ind = ind + c[3]
				end

				local goals = params["choice4_" .. taskutil.userstate.choice4a]
				local goal = goals.industrial + goals.commercial

				local tot = com + ind
				self:setProgressCount(tot, goal, 1)

				local done = tot >= goal

				self:setSubtaskCompleted(1, done)

				if done then self:finish() end
			end
		end,
		onFinish = function(self)
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			local sub
			if taskutil.userstate.choice4a == 1 then
				sub = _("MISSION_FUTURECITY_TASK_4_IMPLEMENT_SUB1") % params
			else
				sub = _("MISSION_FUTURECITY_TASK_4_IMPLEMENT_SUB2") % params
			end
			return {
				name = _("MISSION_FUTURECITY_TASK_4_IMPLEMENT_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_4_IMPLEMENT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_TASK_4_IMPLEMENT_TASK") % params },
				},
				subTasks = {
					{ name = sub },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_TASK_4_IMPLEMENT_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
			}
		end,
	})
end
