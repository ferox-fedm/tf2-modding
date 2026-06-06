local params = require "params"
local vehiclestore = require "mission.vehiclestore"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m5", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_SUGAR")
			self:setProgressNone()
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_SUGAR_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_SUGAR_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_sugar_farm,
				voiceOver = "MISSION_COLONIALISM_MEDAL_SUGAR_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m5a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m5a", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount(params.modelnames.openwagon, nil)
		end,
		onUpdate = function(self)
			local s = game.interface.getTownCargoSupplyAndLimit(params.surabaya).SUGAR
			if s and s[1] > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_SUGAR")
			taskutil.tasks["m5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_SUGAR_DELIVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_SUGAR_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_MEDAL_SUGAR_DELIVER_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m5",
				camera = params.jump_sugar_farm,
				voiceOver = "MISSION_COLONIALISM_MEDAL_SUGAR_DELIVER_TEXT.wav",
			}
		end,
	})

	taskutil:new("m5b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_SUGAR_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_SUGAR_FINISH_TEXT") % params },
				},
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m5",
				voiceOver = "MISSION_COLONIALISM_MEDAL_SUGAR_FINISH_TEXT.wav",
			}
		end,
	})
end
