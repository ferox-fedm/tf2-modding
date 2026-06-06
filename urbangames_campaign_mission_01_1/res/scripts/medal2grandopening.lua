local apputil = require "apputil"
local params = require "params"
local unsavedVariables = require "unsavedVariables"
local guidesystem = require "guidesystem"
local gui = require "gui"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_GRANDOPENING")
			self:setProgressNone()
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_MEDAL_GRANDOPENING_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_MEDAL_GRANDOPENING_TEXT") % params },
				},
				isMedal = true,
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				camera = { 0.5 * (params.jump_railStationMineZone[1] + params.jump_carsonCity[1]), 0.5 * (params.jump_railStationMineZone[2] + params.jump_carsonCity[2]), 1000 },
				voiceOver = "MISSION_SILVERCITY_MEDAL_GRANDOPENING_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m2a") taskutil:finish(self.name) end,
			decline = function(self)
				gui.window_get("missionDisplayWindow"):close()
				taskutil:finish(self.name)
			end,
		},
	})

	local inside = false
	taskutil:new("m2a", {
		onStart = function(self)
			self:setProgressNone()
			taskutil.userstate.cockpitTime = 0
			taskutil.userstate.guidesystemkeys["guides_cockpit"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			if inside then
				taskutil.userstate.cockpitTime = taskutil.userstate.cockpitTime + 1
				if taskutil.userstate.cockpitTime > params.medalCockpitTime * 5 then
					self:finish()
				end
			end
		end,
		onGuiUpdate = function(self)
			game.gui.setVisible("vehicleWindow.enterCockpit", true)
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_GRANDOPENING")
			taskutil.tasks["m2b"]:start()
		end,
		onGuiFinish = function(self)
			if not apputil.isCouchUiMode() then
				game.gui.setVisible("vehicleWindow.enterCockpit", false)
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_MEDAL_GRANDOPENING_ONBOARD_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_MEDAL_GRANDOPENING_ONBOARD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_MEDAL_GRANDOPENING_ONBOARD_TASK") % params },
				},
				parentId = "m2",
				options = { { "Debug: Skip", "finish" } },
				camera = { 0.5 * (params.jump_railStationMineZone[1] + params.jump_carsonCity[1]), 0.5 * (params.jump_railStationMineZone[2] + params.jump_carsonCity[2]), 1000 },
				voiceOver = "MISSION_SILVERCITY_MEDAL_GRANDOPENING_ONBOARD_TEXT.wav",
			}
		end,
		handlers = {
			enter = function(self)
				inside = true
			end,
			leave = function(self)
				inside = false
			end,
		},
	})

	taskutil:new("m2b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_MEDAL_GRANDOPENING_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_MEDAL_GRANDOPENING_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_SILVERCITY_MEDAL_GRANDOPENING_FINISH_TEXT.wav",
			}
		end,
	})
end
