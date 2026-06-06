local taskutil = require "mission.taskutil"
local params = require "params"

return function()
	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_2")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_MEDAL_PLOT_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_MEDAL_PLOT_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m2x") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m2x", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_MEDAL_PLOT_DECISION"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_MEDAL_PLOT_DECISION_TEXT") },
					{ type = "TASK", text = _("MISSION_SWISSMADE_MEDAL_PLOT_DECISION_TASK") },
				},
				options = {
					{ _("MISSION_SWISSMADE_MEDAL_PLOT_DECISION_OPTION1"), "support" },
					{ _("MISSION_SWISSMADE_MEDAL_PLOT_DECISION_OPTION2"), "uncover" },
				},
				parentId = "m2",
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_DECISION_TEXT.wav",
			}
		end,
		handlers = {
			support = function(self) taskutil.userstate.m2decision = "support" taskutil:start("m2a") taskutil:finish(self.name) end,
			uncover = function(self) taskutil.userstate.m2decision = "uncover" taskutil:start("m2a") taskutil:finish(self.name) end,
		},
		guiHandlers = {
			support = function(self) taskutil:sendScriptFn(self.name, "support", { }) end,
			uncover = function(self) taskutil:sendScriptFn(self.name, "uncover", { }) end,
		},
	})


	taskutil:new("m2a", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMarker("secrethouse1", { entity = params.secrethouse1, type = "question" }, self.name, "finish")
		end,
		onFinish = function(self)
			taskutil:setMarker("secrethouse1")
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			local name = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE1A_NAME")
			local text = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE1A_TEXT")
			local task = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE1A_TASK")
			local voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_CLUE1A_TEXT.wav"
			if taskutil.userstate.m2decision == "uncover" then 
				name = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE1B_NAME") 
				text = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE1B_TEXT")
				task = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE1B_TASK")
				voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_CLUE1B_TEXT.wav"
			end
			return {
				name = name % params,
				paragraphs = {
					{ text = text % params },
					{ type = "TASK", text = task % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_stgallen,
				voiceOver = voiceOver,
			}
		end,
	})

	taskutil:new("m2b", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMarker("secrethouse2", { entity = params.secrethouse2, type = "question" }, self.name, "finish")
		end,
		onFinish = function(self)
			taskutil:setMarker("secrethouse2")
			taskutil:startLater("m2c")
		end,
		getInfo = function(self)
			local name = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE2A_NAME")
			local text = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE2A_TEXT")
			local task = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE2A_TASK")
			local voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_CLUE2A_TEXT.wav"
			if taskutil.userstate.m2decision == "uncover" then 
				name = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE2B_NAME") 
				text = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE2B_TEXT")
				task = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE2B_TASK")
				voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_CLUE2B_TEXT.wav"
			end
			return {
				name = name % params,
				paragraphs = {
					{ text = text % params },
					{ type = "TASK", text = task % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_zurich,
				voiceOver = voiceOver,
				}
		end,
	})

	taskutil:new("m2c", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMarker("secrethouse3", { entity = params.secrethouse3, type = "question" }, self.name, "finish")
		end,
		onFinish = function(self)
			taskutil:setMarker("secrethouse3")
			taskutil:startLater("m2d")
		end,
		getInfo = function(self)
			local name = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE3A_NAME")
			local text = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE3A_TEXT")
			local task = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE3A_TASK")
			local voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_CLUE3A_TEXT.wav"
			if taskutil.userstate.m2decision == "uncover" then 
				name = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE3B_NAME") 
				text = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE3B_TEXT")
				task = _("MISSION_SWISSMADE_MEDAL_PLOT_CLUE3B_TASK")
				voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_CLUE3B_TEXT.wav"
			end
			return {
				name = name % params,
				paragraphs = {
					{ text = text % params },
					{ type = "TASK", text = task % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_secrethouse3,
				voiceOver = voiceOver,
				}
		end,
	})

	taskutil:new("m2d", {
		onStart = function(self)
			taskutil.userstate.m2acounter = 3
		end,
		onUpdate = function(self)
			local count = 0
			for i = 1, 3 do
				local stations = game.interface.getEntities({pos = params["pos_secrethouse"..i], radius = 100}, {type = "STATION"})
				local persons = 0
				for i = 1, #stations do
					local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.PASSENGERS or 0
					persons = persons + s
				end
				self:setSubtaskCompleted(i, persons > 0)
				if persons > 0 then count = count + 1 end
			end
			if count == 3 then self:finish() end
		end,
		onFinish = function(self)
			if taskutil.userstate.m2decision == "uncover" then
				taskutil:setMedalCompleted("MEDAL_2")
			end
			taskutil.tasks["m2e"]:start()
		end,
		getInfo = function(self)
			local text = _("MISSION_SWISSMADE_MEDAL_PLOT_PASSENGERSA_TEXT")
			local voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_PASSENGERSA_TEXT.wav"
			if taskutil.userstate.m2decision == "uncover" then 
				text = _("MISSION_SWISSMADE_MEDAL_PLOT_PASSENGERSB_TEXT")
				voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_PASSENGERSB_TEXT.wav"
			end
			return {
				name = _("MISSION_SWISSMADE_MEDAL_PLOT_PASSENGERS_NAME"),
				paragraphs = {
					{ text = text },
					{ type = "TASK", text = _("MISSION_SWISSMADE_MEDAL_PLOT_PASSENGERS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_SWISSMADE_MEDAL_PLOT_PASSENGERSB_SUB1") % params }, --Person nach ${name_secrethouse1} bringen
					{ name = _("MISSION_SWISSMADE_MEDAL_PLOT_PASSENGERSB_SUB2") % params }, --Person nach ${name_secrethouse2} bringen
					{ name = _("MISSION_SWISSMADE_MEDAL_PLOT_PASSENGERSB_SUB3") % params }, --Person nach ${name_secrethouse3} bringen
				},
				parentId = "m2",
				camera = default_camera,
				voiceOver = voiceOver,
			}
		end,
	})

	taskutil:new("m2e", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			local name = _("MISSION_SWISSMADE_MEDAL_PLOT_FINISHA_NAME")
			local text = _("MISSION_SWISSMADE_MEDAL_PLOT_FINISHA_TEXT")
			local voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_FINISHA_TEXT.wav"
			if taskutil.userstate.m2decision == "uncover" then 
				text = _("MISSION_SWISSMADE_MEDAL_PLOT_FINISHB_TEXT") 
				voiceOver = "MISSION_SWISSMADE_MEDAL_PLOT_FINISHB_TEXT.wav"
				name = _("MISSION_SWISSMADE_MEDAL_PLOT_FINISHB_NAME")
			end
			return {
				name = name,
				paragraphs = { { text = text } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = voiceOver,
			}
		end,
	})
end
