local taskutil = require "mission.taskutil"
local params = require "params"

return function()
	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_REICHELT")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_BAT_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_MEDAL_BAT_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				voiceOver = "MISSION_MACHINES_MEDAL_BAT_TEXT.wav",
				camera = params.jump_eiffeltower,
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
			game.interface.upgradeConstruction(params.workshop_reichelt, "industry/workshop.con", {
				productionLevel = 0,
				stocks = {
					{ cargoType = "PLANKS", type = "RECEIVING", x = 0, y = 0, sizex = 1, sizey = 1 },
					{ cargoType = "CHAMPAGNE", type = "RECEIVING", x = 1, y = 0, sizex = 1, sizey = 1 },
				},
				input = { { 1, 0 }, { 0, 1 } },
				capacity = 200,
			})
		end,
		onUpdate = function(self)
			local consumed = game.interface.getEntity(game.interface.getEntity(params.workshop_reichelt).simBuildings[1]).itemsConsumed.PLANKS or 0
			if params.planks_m1a > 1 then self:setProgressCount(consumed, params.planks_m1a) end
			if consumed >= params.planks_m1a then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_BAT_WOOD_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_MEDAL_BAT_WOOD_TEXT") },
					{ type = "TASK", text = _("MISSION_MACHINES_MEDAL_BAT_WOOD_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				voiceOver = "MISSION_MACHINES_MEDAL_BAT_WOOD_TEXT.wav",
				camera = params.jump_workshop_reichelt,
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local consumed = game.interface.getEntity(game.interface.getEntity(params.workshop_reichelt).simBuildings[1]).itemsConsumed.CHAMPAGNE or 0
			if params.champagne_m1b > 1 then self:setProgressCount(consumed, params.champagne_m1b) end
			if consumed >= params.champagne_m1b then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_BAT_CHAMPAGNE_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_MEDAL_BAT_CHAMPAGNE_TEXT") },
					{ type = "TASK", text = _("MISSION_MACHINES_MEDAL_BAT_CHAMPAGNE_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				voiceOver = "MISSION_MACHINES_MEDAL_BAT_CHAMPAGNE_TEXT.wav",
				camera = params.jump_workshop_reichelt,
			}
		end,
	})

	taskutil:new("m1c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local assets = game.interface.getEntities({pos = params.pos_eiffeltower, radius = 40}, {type = "ASSET_GROUP"})
			for i = 1, #assets do
				local a = game.interface.getEntity(assets[i])
				if a.models["asset/hay_pile_2.mdl"] ~= nil then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_REICHELT")
			taskutil.tasks["m1d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_BAT_RESCUE_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_MEDAL_BAT_RESCUE_TEXT") },
					{ type = "TASK", text = _("MISSION_MACHINES_MEDAL_BAT_RESCUE_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				voiceOver = "MISSION_MACHINES_MEDAL_BAT_RESCUE_TEXT.wav",
				camera = params.jump_eiffeltower,
			}
		end,
	})

	taskutil:new("m1d", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_BAT_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_MACHINES_MEDAL_BAT_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_MACHINES_MEDAL_BAT_FINISH_TEXT.wav",
			}
		end,
	})
end
