local params = require "params"
local guidesystem = require "guidesystem"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_MONUMENTS")
			self:setProgressNone()
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_HQ_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_HQ_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_surabaya,
				voiceOver = "MISSION_COLONIALISM_MEDAL_HQ_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m3x") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m3x", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_hq"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			local entities = game.interface.getEntities({ radius = 10e100 }, { type = "CONSTRUCTION" })
			for i = 1, #entities do
				local e = game.interface.getEntity(entities[i])
				if e.fileName == "asset/headquarter.con" then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_HQ_BUILD_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_HQ_BUILD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_MEDAL_HQ_BUILD_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_surabaya,
				voiceOver = "MISSION_COLONIALISM_MEDAL_HQ_BUILD_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3a", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_hq"] = guidesystem.getTime()
			local entities = game.interface.getEntities({ pos = game.interface.getEntity(params.surabaya).position, radius = 200 }, { type = "CONSTRUCTION" })
			if #entities > 0 then
			    game.interface.setBulldozeable(entities[1], false)
				taskutil:setMarker("monuments", { entity = entities[1], type = "question" }, self.name, "finish")
				taskutil:setStreetSegmentsForConstructionsTownBuildingsBulldozable(entities[1], false);
			else
				error("no target for medal found")
			end
		end,
		onFinish = function(self)
			taskutil:setMarker("monuments")
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_HQ_HINT1_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_HQ_HINT1_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_MEDAL_HQ_HINT1_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_surabaya,
				voiceOver = "MISSION_COLONIALISM_MEDAL_HQ_HINT1_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3b", {
		onStart = function(self)
			local entities = game.interface.getEntities({ pos = game.interface.getEntity(params.semarang).position, radius = 200 }, { type = "CONSTRUCTION" })
			if #entities > 0 then
			    game.interface.setBulldozeable(entities[1], false)
				taskutil:setMarker("monuments", { entity = entities[1], type = "question" }, self.name, "finish")
				taskutil:setStreetSegmentsForConstructionsTownBuildingsBulldozable(entities[1], false);
			else
				error("no target for medal C found")
			end
		end,
		onFinish = function(self)
			taskutil:setMarker("monuments")
			taskutil.tasks["m3c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_HQ_HINT2_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_HQ_HINT2_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_MEDAL_HQ_HINT2_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_semarang,
				voiceOver = "MISSION_COLONIALISM_MEDAL_HQ_HINT2_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3c", {
		onStart = function(self)
			taskutil:setMarker("temple1", { entity = params.temple1, type = "question" }, self.name, "temple1")
			taskutil:setMarker("temple2", { entity = params.temple2, type = "question" }, self.name, "temple2")
			taskutil:setMarker("temple3", { entity = params.temple3, type = "question" }, self.name, "temple3")
			taskutil:setMarker("temple4", { entity = params.temple4, type = "question" }, self.name, "temple4")
		end,
		onFinish = function(self)
			taskutil:setMarker("temple1")
			taskutil:setMarker("temple2")
			taskutil:setMarker("temple3")
			taskutil:setMarker("temple4")
			taskutil.tasks["m3d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_HQ_HINT3_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_HQ_HINT3_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_MEDAL_HQ_HINT3_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_temple1,
				voiceOver = "MISSION_COLONIALISM_MEDAL_HQ_HINT3_TEXT.wav",
			}
		end,
		handlers = {
			temple1 = function(self)
				taskutil:setMarker("temple1")
				if self.finish ~= nil then self:finish() end
			end,
			temple2 = function(self) taskutil:setMarker("temple2") end,
			temple3 = function(self) taskutil:setMarker("temple3") end,
			temple4 = function(self) taskutil:setMarker("temple4") end,
		},
	})

	taskutil:new("m3d", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.temple1, "industry/temple.con", { productionLevel = 0, running = true })
		end,
		onUpdate = function(self)
			local e = game.interface.getEntity(game.interface.getEntity(params.temple1).simBuildings[1])

			if e.itemsConsumed.COFFEEBEANS ~= nil then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_MONUMENTS")
			taskutil.tasks["m3e"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_HQ_SACRIFICE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_HQ_SACRIFICE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_MEDAL_HQ_SACRIFICE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_temple1,
				voiceOver = "MISSION_COLONIALISM_MEDAL_HQ_SACRIFICE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3e", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_HQ_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_HQ_FINISH_TEXT") % params },
				},
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_COLONIALISM_MEDAL_HQ_FINISH_TEXT.wav",
			}
		end,
	})
end
