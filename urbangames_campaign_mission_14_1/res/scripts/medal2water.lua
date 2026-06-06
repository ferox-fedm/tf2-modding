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
				name = _("MISSION_LEADER_MEDAL_WATER_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_MEDAL_WATER_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_harborkonstanza,
				voiceOver = "MISSION_LEADER_MEDAL_WATER_TEXT.wav",
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
			taskutil.userstate.transportedship = 0
		end,
		onUpdate = function(self)
			self:setProgressCount(taskutil.userstate.transportedship, params.ship_unload_amount)
			if taskutil.userstate.transportedship >= params.ship_unload_amount then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_2")
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_MEDAL_WATER_CARGO_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_MEDAL_WATER_CARGO_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_MEDAL_WATER_CARGO_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_harborkonstanza,
				voiceOver = "MISSION_LEADER_MEDAL_WATER_CARGO_TEXT.wav",
			}
		end,
		handlers = {
			handleEvent = function(self, id, name, param)
				if id == "__missionCallback__" and name == "JOURNAL_ENTRY" then
					if game.interface.getEntity(param.params.entity).carrier == "WATER" and param.params.cargoUnloaded ~= nil then
						for cargoType, amount in pairs(param.params.cargoUnloaded) do
							if cargoType ~= "PASSENGERS" then taskutil.userstate.transportedship = taskutil.userstate.transportedship + amount end
						end
					end
				end
			end,
		},
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
				name = _("MISSION_LEADER_MEDAL_WATER_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_LEADER_MEDAL_WATER_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_LEADER_MEDAL_WATER_FINISH_TEXT.wav",
			}
		end,
	})
end
