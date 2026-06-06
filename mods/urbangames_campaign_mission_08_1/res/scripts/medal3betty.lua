local taskutil = require "mission.taskutil"
local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_3")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_MEDAL_BETTY_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_MEDAL_BETTY_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = jump_foodprocessing,
				voiceOver = "MISSION_TWENTIES_MEDAL_BETTY_TEXT.wav",
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
			arrivaltracker.track("m3a1", { from = params.farm1, cargotype = "GRAIN", to = params.foodprocessing })
			arrivaltracker.track("m3a2", { from = params.farm2, cargotype = "GRAIN", to = params.foodprocessing })
		end,
		onUpdate = function(self)
			local count = 0
			if arrivaltracker.get("m3a1") > 0 then count = count + 1 end
			if arrivaltracker.get("m3a2") > 0 then count = count + 1 end

			if count == 2 then self:finish() end
			self:setProgressCount(count, 2)
			vehiclestore.setAllowedVehicleCount("vehicle/truck/usa/mack_ac_stake_v2.mdl", nil)
		end,
		onFinish = function(self)
			arrivaltracker.track("m3a1")
			arrivaltracker.track("m3a2")
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_MEDAL_BETTY_GRAIN_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_MEDAL_BETTY_GRAIN_TEXT") },
					{ type = "TASK", text = _("MISSION_TWENTIES_MEDAL_BETTY_GRAIN_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = jump_foodprocessing,
				voiceOver = "MISSION_TWENTIES_MEDAL_BETTY_GRAIN_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local bought = #taskutil.userstate.boughtlicenses
			self:setProgressCount(bought, 5)
			if bought >= 5 then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_3")
			taskutil.tasks["m3c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_MEDAL_BETTY_LICENCE_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_MEDAL_BETTY_LICENCE_TEXT") },
					{ type = "TASK", text = _("MISSION_TWENTIES_MEDAL_BETTY_LICENCE_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = jump_foodprocessing,
				voiceOver = "MISSION_TWENTIES_MEDAL_BETTY_LICENCE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_MEDAL_BETTY_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_TWENTIES_MEDAL_BETTY_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				camera = jump_foodprocessing,
				voiceOver = "MISSION_TWENTIES_MEDAL_BETTY_FINISH_TEXT.wav",
			}
		end,
	})
end
