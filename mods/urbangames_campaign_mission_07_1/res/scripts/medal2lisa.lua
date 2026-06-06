local taskutil = require "mission.taskutil"
local params = require "params"

return function()
	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_LISA")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_MONALISA_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_MEDAL_MONALISA_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				voiceOver = "MISSION_MACHINES_MEDAL_MONALISA_TEXT.wav",
				camera = params.jump_paris,
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

	local function getTownBuilding(town)
		local entities = game.interface.getEntities({ pos = params["pos_" .. town], radius = 250 }, { type = "CONSTRUCTION" })
		if #entities > 0 then
			return entities[1]
		else
			return params.workshop_player
		end
	end

	taskutil:new("m2a", {
		onStart = function(self)
		    local building = getTownBuilding("reims")
		    game.interface.setBulldozeable(building, false)
			taskutil:setMarker("lisa1", { entity = building, type = "question" }, self.name, "finish")
			taskutil:setStreetSegmentsForConstructionsTownBuildingsBulldozable(building, false);
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMarker("lisa1")
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_MONALISA_CLUE1_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_MEDAL_MONALISA_CLUE1_TEXT") },
					{ type = "TASK", text = _("MISSION_MACHINES_MEDAL_MONALISA_CLUE1_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				voiceOver = "MISSION_MACHINES_MEDAL_MONALISA_CLUE1_TEXT.wav",
				camera = params.jump_reims,
			}
		end,
	})

	taskutil:new("m2b", {
        onStart = function(self)
			local building = getTownBuilding("dover")
			game.interface.setBulldozeable(building, false)
			taskutil:setMarker("lisa2", { entity = building, type = "question" }, self.name, "finish")
			taskutil:setStreetSegmentsForConstructionsTownBuildingsBulldozable(building, false);
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMarker("lisa2")
			taskutil.tasks["m2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_MONALISA_CLUE2_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_MEDAL_MONALISA_CLUE2_TEXT") },
					{ type = "TASK", text = _("MISSION_MACHINES_MEDAL_MONALISA_CLUE2_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				voiceOver = "MISSION_MACHINES_MEDAL_MONALISA_CLUE2_TEXT.wav",
				camera = params.jump_dover,
			}
		end,
	})

	taskutil:new("m2c", {
		onStart = function(self)
		    local building = getTownBuilding("lemans")
		    game.interface.setBulldozeable(building, false)
			taskutil:setMarker("lisa3", { entity = building, type = "question" }, self.name, "finish")
			taskutil:setStreetSegmentsForConstructionsTownBuildingsBulldozable(building, false);

		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMarker("lisa3")
			taskutil:setMedalCompleted("MEDAL_LISA")
			taskutil.tasks["m2d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_MONALISA_CLUE3_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_MEDAL_MONALISA_CLUE3_TEXT") },
					{ type = "TASK", text = _("MISSION_MACHINES_MEDAL_MONALISA_CLUE3_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				voiceOver = "MISSION_MACHINES_MEDAL_MONALISA_CLUE3_TEXT.wav",
				camera = params.jump_lemans,
			}
		end,
	})

	taskutil:new("m2d", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_MONALISA_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_MACHINES_MEDAL_MONALISA_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_MACHINES_MEDAL_MONALISA_FINISH_TEXT.wav",
			}
		end,
	})
end
