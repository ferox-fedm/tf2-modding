local taskutil = require "mission.taskutil"
local params = require "params"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local util = require "util"

return function()
	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_2")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_MEDAL_TREES_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_MEDAL_TREES_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_OILSANDS_MEDAL_TREES_TEXT.wav",
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m2a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m2a", {
		onStart = function(self)
			taskutil.userstate.treecachecount = 0
		end,
		onUpdate = function(self)
			local treestoplant = taskutil.userstate.treesatstart - util.counttrees()
			self:setProgressText(tostring(treestoplant))
			if treestoplant <= 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m2b"]:start()
			taskutil:setMedalCompleted("MEDAL_2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_MEDAL_TREES_PLANT_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_MEDAL_TREES_PLANT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_MEDAL_TREES_PLANT_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_OILSANDS_MEDAL_TREES_PLANT_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
			}
		end,
	})

	taskutil:new("m2b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_MEDAL_TREES_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_OILSANDS_MEDAL_TREES_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_OILSANDS_MEDAL_TREES_FINISH_TEXT.wav",
			}
		end,
	})
end
