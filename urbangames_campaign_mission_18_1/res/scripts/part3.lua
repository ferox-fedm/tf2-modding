local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
	taskutil:new("3", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track3")
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_TASK_3_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_3_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_TASK_3_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm1", 120)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_TASK_3_DECIDE_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_3_DECIDE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_TASK_3_DECIDE_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_TASK_3_DECIDE_TEXT.wav",
				options = { { _("MISSION_FUTURECITY_TASK_3_DECIDE_OPTION1"), "option1" },
				            { _("MISSION_FUTURECITY_TASK_3_DECIDE_OPTION2"), "option2" } },
				parentId = "3",
			}
		end,
		handlers = {
			option1 = function(self)
				taskutil.userstate.choice3a = 1
				taskutil:finish(self.name)
			end,
			option2 = function(self)
				taskutil.userstate.choice3a = 2
				taskutil:finish(self.name)
			end,
			showm1 = function(self)
				if taskutil.tasks["m1"].start ~= nil then
					taskutil.tasks["m1"]:start()
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

	taskutil:new("3b", {
		onStart = function(self)
			arrivaltracker.track("3b1", { cargotype = "MACHINES" })
			arrivaltracker.track("3b2", { cargotype = "CONSTRUCTION_MATERIALS" })
			arrivaltracker.track("3b3", { cargotype = "FUEL" })
			arrivaltracker.track("3b4", { cargotype = "FOOD" })
			arrivaltracker.track("3b5", { cargotype = "TOOLS" })
			arrivaltracker.track("3b6", { cargotype = "GOODS" })
		end,
		onUpdate = function(self)
			local done1, done2, done3
			if taskutil.userstate.choice3a == 1 then
				local c1 = arrivaltracker.get("3b1")
				local c2 = arrivaltracker.get("3b2")
				local c3 = arrivaltracker.get("3b3")

				local goals = params["choice3_" .. taskutil.userstate.choice3a]
				self:setProgressCount(c1, goals.machines, 1)
				self:setProgressCount(c2, goals.conmat, 2)
				self:setProgressCount(c3, goals.fuel, 3)

				done1 = c1 >= goals.machines
				done2 = c2 >= goals.conmat
				done3 = c3 >= goals.fuel

				self:setSubtaskCompleted(1, done1)
				self:setSubtaskCompleted(2, done2)
				self:setSubtaskCompleted(3, done3)
			else
				local c4 = arrivaltracker.get("3b4")
				local c5 = arrivaltracker.get("3b5")
				local c6 = arrivaltracker.get("3b6")

				local goals = params["choice3_" .. taskutil.userstate.choice3a]
				self:setProgressCount(c4, goals.food, 1)
				self:setProgressCount(c5, goals.tools, 2)
				self:setProgressCount(c6, goals.goods, 3)

				done1 = c4 >= goals.food
				done2 = c5 >= goals.tools
				done3 = c6 >= goals.goods

				self:setSubtaskCompleted(1, done1)
				self:setSubtaskCompleted(2, done2)
				self:setSubtaskCompleted(3, done3)
			end

			if done1 and done2 and done3 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("3b1")
			arrivaltracker.track("3b2")
			arrivaltracker.track("3b3")
			arrivaltracker.track("3b4")
			arrivaltracker.track("3b5")
			arrivaltracker.track("3b6")
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			local sub1, sub2, sub3
			if taskutil.userstate.choice3a == 1 then
				sub1 = _("MISSION_FUTURECITY_TASK_3_IMPLEMENT_SUB1")
				sub2 = _("MISSION_FUTURECITY_TASK_3_IMPLEMENT_SUB2")
				sub3 = _("MISSION_FUTURECITY_TASK_3_IMPLEMENT_SUB3")
			else
				sub1 = _("MISSION_FUTURECITY_TASK_3_IMPLEMENT_SUB4")
				sub2 = _("MISSION_FUTURECITY_TASK_3_IMPLEMENT_SUB5")
				sub3 = _("MISSION_FUTURECITY_TASK_3_IMPLEMENT_SUB6")
			end
			return {
				name = _("MISSION_FUTURECITY_TASK_3_IMPLEMENT_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_3_IMPLEMENT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_TASK_3_IMPLEMENT_TASK") % params },
				},
				subTasks = {
					{ name = sub1 },
					{ name = sub2 },
					{ name = sub3 },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_TASK_3_IMPLEMENT_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
			}
		end,
	})
end
