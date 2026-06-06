local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_3")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_MEDAL_BLOCK_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_MEDAL_BLOCK_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_foodprocessing,
				voiceOver = "MISSION_VICECOUNTY_MEDAL_BLOCK_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m3a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m3a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local transported = game.interface.getIndustryTransportRating(params.foodprocessing)
			self:setProgressPercent(transported, 1)
			if transported < params.block_percent then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_3")
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_MEDAL_BLOCK_BREAD_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_MEDAL_BLOCK_BREAD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_MEDAL_BLOCK_BREAD_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_MEDAL_BLOCK_BREAD_SUB1") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_foodprocessing,
				voiceOver = "MISSION_VICECOUNTY_MEDAL_BLOCK_BREAD_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_MEDAL_BLOCK_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_VICECOUNTY_MEDAL_BLOCK_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_VICECOUNTY_MEDAL_BLOCK_FINISH_TEXT.wav",
			}
		end,
	})
end
