local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_1")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_MONSTER_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_MEDAL_MONSTER_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_fishery,
				voiceOver = "MISSION_SHINKANSEN_MEDAL_MONSTER_TEXT.wav",
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
			local productionLevel = game.interface.getEntity(params.hq).params.productionLevel
			game.interface.upgradeConstruction(params.hq, "industry/hq.con", {
				stocks = { "CONSTRUCTION_MATERIALS", "STEEL", "FOOD", "FISH", },
				input = { { 1, 0, 0, 0 }, { 0, 1, 0, 0 }, { 0, 0, 1, 0 }, { 0, 0, 0, 1 } },
				output = { },
				capacity = 100,
				commercialCapacity = 50,
				productionLevel = productionLevel,
			})
			arrivaltracker.track("m1a", { cargotype = "FISH", to = params.hq })
		end,
		onUpdate = function(self)
			local x = arrivaltracker.get("m1a")
			self:setProgressCount(x, 10000)
			if x > 50 then taskutil:start("m1b") end
			if x > 100 then taskutil:start("m1c") end
			if x > 150 then taskutil:start("m1d") end
			if x > 200 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("m1a")
			taskutil.tasks["m1e"]:start() -- end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_MONSTER_FISH_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_MEDAL_MONSTER_FISH_TEXT") },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_MEDAL_MONSTER_FISH_TASK") % { x = 10000 } },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_fishery,
				voiceOver = "MISSION_SHINKANSEN_MEDAL_MONSTER_FISH_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_MONSTER_QUAKE1_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_MEDAL_MONSTER_QUAKE1_TEXT") },
				},
				options = { { "Ok!", "finish" } },
				parentId = "m1",
				camera = params.jump_fishery,
				voiceOver = "MISSION_SHINKANSEN_MEDAL_MONSTER_QUAKE1_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_MONSTER_QUAKE2_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_MEDAL_MONSTER_QUAKE2_TEXT") },
				},
				options = { { "Ok!", "finish" } },
				parentId = "m1",
				camera = params.jump_fishery,
				voiceOver = "MISSION_SHINKANSEN_MEDAL_MONSTER_QUAKE2_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1d", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_MONSTER_QUAKE3_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_MEDAL_MONSTER_QUAKE3_TEXT") },
				},
				options = { { "Ok!", "finish" } },
				parentId = "m1",
				camera = params.jump_fishery,
				voiceOver = "MISSION_SHINKANSEN_MEDAL_MONSTER_QUAKE3_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1e", {
		onStart = function(self)
			taskutil:setMarker("underwater", { pos = params.underwaterpos_questionsmark.pos, type = "question" }, self.name, "finish")
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_1")
			taskutil:setMarker("underwater")
			taskutil.tasks["m1f"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_MONSTER_LOCATE_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_MEDAL_MONSTER_LOCATE_TEXT") },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_MEDAL_MONSTER_LOCATE_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_underwaterpos,
				voiceOver = "MISSION_SHINKANSEN_MEDAL_MONSTER_LOCATE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1f", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_MONSTER_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_SHINKANSEN_MEDAL_MONSTER_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_SHINKANSEN_MEDAL_MONSTER_FINISH_TEXT.wav",
			}
		end,
	})
end
