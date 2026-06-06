local taskutil = require "mission.taskutil"
local params = require "params"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_1")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_MEDAL_CONTROL_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_MEDAL_CONTROL_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_scoutlocator,
				voiceOver = "MISSION_VICECOUNTY_MEDAL_CONTROL_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m1a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m1a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			if taskutil:finished("3d") then
				self:finish()
			end
		end,
		onFinish = function(self)
			if taskutil.userstate.caught then
				taskutil.tasks["m1loss"]:start()
			else
				taskutil.tasks["m1win"]:start()
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_MEDAL_CONTROL_CHASE_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_MEDAL_CONTROL_CHASE_TEXT") },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_MEDAL_CONTROL_CHASE_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_scoutlocator,
				voiceOver = "MISSION_VICECOUNTY_MEDAL_CONTROL_CHASE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1win", {
		onStart = function(self)
			taskutil:setMedalCompleted("MEDAL_1")
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_MEDAL_CONTROL_SUCCESS_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_VICECOUNTY_MEDAL_CONTROL_SUCCESS_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_VICECOUNTY_MEDAL_CONTROL_SUCCESS_FINISH_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1loss", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_MEDAL_CONTROL_FAIL_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_VICECOUNTY_MEDAL_CONTROL_FAIL_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_VICECOUNTY_MEDAL_CONTROL_FAIL_FINISH_TEXT.wav",
			}
		end,
	})
end
