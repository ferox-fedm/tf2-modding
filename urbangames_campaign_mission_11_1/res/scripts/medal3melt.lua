local taskutil = require "mission.taskutil"
local params = require "params"

return function()
	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_3")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_MEDAL_SMELT_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_MEDAL_SMELT_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_MEDAL_SMELT_TEXT.wav",
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
			local steelfarmparams = {
				stocks = { "MACHINES" },
				input = { { 1 } },
				output = { STEEL = 1 },
				capacity = 100 
			}

			local o = taskutil.userstate.options
			for i = 1, #o do
				if o[i][2] == "steel_farm.con" then
					o[i][3] = steelfarmparams
				end
			end

			for i = 1, params.numconsites do
				local e = game.interface.getEntity(params["constructionsite" .. i])
				if e.fileName == "industry/steel_farm.con" then
					game.interface.upgradeConstruction(params["constructionsite" .. i], e.fileName, steelfarmparams)
				end
			end
		end,
		onUpdate = function(self)
			local c = 0
			for i = 1, params.numconsites do
				local e = game.interface.getEntity(params["constructionsite" .. i])
				if e.fileName == "industry/steel_farm.con" then
					c = c + (game.interface.getEntity(e.simBuildings[1]).itemsConsumed.MACHINES or 0)
				end
			end
			self:setProgressCount(c, params.amount_machines_to_farm)
			if c >= params.amount_machines_to_farm then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_3")
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_MEDAL_SMELT_MACHINES_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_MEDAL_SMELT_MACHINES_TEXT") },
					{ type = "TASK", text = _("MISSION_REDSTAR_MEDAL_SMELT_MACHINES_TASK") },
					{ type = "HINT", text = _("MISSION_REDSTAR_MEDAL_SMELT_MACHINES_HINT") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_MEDAL_SMELT_MACHINES_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_MEDAL_SMELT_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_REDSTAR_MEDAL_SMELT_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_REDSTAR_MEDAL_SMELT_FINISH_TEXT.wav",
			}
		end,
	})
end
