local params = require "params"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_FERRY")
			self:setProgressNone()
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_open_sea_zone,
				voiceOver = "MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_TEXT.wav",
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
			local ships = game.interface.getVehicles()
			for i = 1, #ships do
				local s = game.interface.getEntity(ships[i])
				if s.carrier == "WATER" then
				    game.interface.setBulldozeable(s.id, false)
					taskutil:setMarker("drunk", { entity = s.id, type = "question" }, self.name, "finish")
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil:setMarker("drunk")
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_LOCATE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_LOCATE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_LOCATE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_open_sea_zone,
				voiceOver = "MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_LOCATE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.glasgow_pub, "industry/pub.con", { productionLevel = 0, running = true, cap = params.amount_m1b })
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.glasgow_pub).simBuildings[1]).itemsConsumed
			if (c.WHISKEY or 0) > 0 then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_FERRY")
			taskutil.tasks["m1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_PUB_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_PUB_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_PUB_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_glasgow_pub,
				voiceOver = "MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_PUB_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_FINISH_NAME") % params,
				paragraphs = { { text = _("MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_HIGHLANDS_MEDAL_WHISKYSHIP_FINISH_TEXT.wav",
			}
		end,
	})
end
