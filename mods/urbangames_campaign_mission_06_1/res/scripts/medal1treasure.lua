local params = require "params"
local vec2 = require "vec2"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_TREASURE")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_TREASURE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_MEDAL_TREASURE_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_overview,
				voiceOver = "MISSION_BAGDAD_MEDAL_TREASURE_TEXT.wav",
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
			taskutil:setMarker("marker1a", { entity = params.stone_m1, type = "question" }, self.name, "finish")
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMarker("marker1a")
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_TREASURE_RUINES_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_MEDAL_TREASURE_RUINES_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_MEDAL_TREASURE_RUINES_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_ruines,
				voiceOver = "MISSION_BAGDAD_MEDAL_TREASURE_RUINES_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			if game.interface.getHeight(taskutil.userstate.stone_m1_pos) < taskutil.userstate.stone_m1_height - 2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_TREASURE")
			taskutil.tasks["m1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_TREASURE_ARTEFACT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_MEDAL_TREASURE_ARTEFACT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_MEDAL_TREASURE_ARTEFACT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_artifacts,
				voiceOver = "MISSION_BAGDAD_MEDAL_TREASURE_ARTEFACT_TEXT.wav",
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
				name = _("MISSION_BAGDAD_MEDAL_TREASURE_FINISH_NAME") % params,
				paragraphs = { { text = _("MISSION_BAGDAD_MEDAL_TREASURE_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_BAGDAD_MEDAL_TREASURE_FINISH_TEXT.wav",
			}
		end,
	})
end
