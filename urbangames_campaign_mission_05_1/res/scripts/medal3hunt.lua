local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_HUNT")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_MEDAL_HUNT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_MEDAL_HUNT_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_irkutsk,
				voiceOver = "MISSION_TRANSSIB_MEDAL_HUNT_TEXT.wav",
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

	local commercialCapacity = 50
	taskutil:new("m3a", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.circus, "industry/circus.con", {
				commercialCapacity = commercialCapacity,
			})
		end,
		onUpdate = function(self)
			local pos = game.interface.getEntity(params.circus).position
			local stations = game.interface.getEntities({pos = pos, radius = 200}, {type = "STATION"})
			local persons = 0
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.PASSENGERS or 0
				if s > 0 then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			local pos = game.interface.getEntity(params.circus)
			return {
				name = _("MISSION_TRANSSIB_MEDAL_HUNT_AUDIENCE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_MEDAL_HUNT_AUDIENCE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_MEDAL_HUNT_AUDIENCE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_circus,
				voiceOver = "MISSION_TRANSSIB_MEDAL_HUNT_AUDIENCE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3b", {
		onStart = function(self)
			arrivaltracker.track("m3b", { cargotype = "LOGS", to = params.circus })
			game.interface.upgradeConstruction(params.circus, "industry/circus.con", {
				stocks = { "LOGS" },
				input = { { 1 } },
				capacity = 15,
				commercialCapacity = commercialCapacity,
			})
		end,
		onUpdate = function(self)
			local l = arrivaltracker.get("m3b")
			self:setProgressCount(l, params.logs_m3b)

			if l >= params.logs_m3b then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("m3b")
			taskutil:setMedalCompleted("MEDAL_HUNT")
			taskutil.tasks["m3d"]:start()
		end,
		getInfo = function(self)
			local pos = game.interface.getEntity(params.circus)
			return {
				name = _("MISSION_TRANSSIB_MEDAL_HUNT_WOOD_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_MEDAL_HUNT_WOOD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_MEDAL_HUNT_WOOD_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_circus,
				voiceOver = "MISSION_TRANSSIB_MEDAL_HUNT_WOOD_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3d", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_MEDAL_HUNT_FINISH_NAME") % params,
				paragraphs = { { text = _("MISSION_TRANSSIB_MEDAL_HUNT_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_TRANSSIB_MEDAL_HUNT_FINISH_TEXT.wav",
			}
		end,
	})
end
