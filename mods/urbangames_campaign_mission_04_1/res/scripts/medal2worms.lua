local params = require "params"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_WORMS")
			self:setProgressNone()
			taskutil.userstate.worm1height = game.interface.getHeight(params.worm1.pos)
			taskutil.userstate.worm2height = game.interface.getHeight(params.worm2.pos)
			taskutil.userstate.worm3height = game.interface.getHeight(params.worm3.pos)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_MEDAL_WORMS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_WORMS_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = { 0, 0, 5000 },
				voiceOver = "MISSION_PARADISO_MEDAL_WORMS_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self)
				taskutil:start("m2a")
				taskutil:finish(self.name)
			end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m2a", {
		onStart = function(self)
			taskutil:setZone("worms", { polygon = zoneutil.makeCircleZone(params.worm1.pos, 25), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			if game.interface.getHeight(params.worm1.pos) < taskutil.userstate.worm1height - 2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("worms")
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_MEDAL_WORMS_HINT1_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_WORMS_HINT1_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_MEDAL_WORMS_HINT1_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_worm1,
				voiceOver = "MISSION_PARADISO_MEDAL_WORMS_HINT1_TEXT.wav",
				parentId = "m2",
			}
		end,
	})

	taskutil:new("m2b", {
		onStart = function(self)
			taskutil:setZone("worms", { polygon = zoneutil.makeCircleZone(params.worm2.pos, 25), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			if game.interface.getHeight(params.worm2.pos) < taskutil.userstate.worm2height - 2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("worms")
			taskutil.tasks["m2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_MEDAL_WORMS_HINT2_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_WORMS_HINT2_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_MEDAL_WORMS_HINT2_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_worm2,
				voiceOver = "MISSION_PARADISO_MEDAL_WORMS_HINT2_TEXT.wav",
				parentId = "m2",
			}
		end,
	})

	taskutil:new("m2c", {
		onStart = function(self)
			taskutil:setZone("worms", { polygon = zoneutil.makeCircleZone(params.worm3.pos, 25), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			if game.interface.getHeight(params.worm3.pos) < taskutil.userstate.worm3height - 2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("worms")
			taskutil:setMedalCompleted("MEDAL_WORMS")
			taskutil.tasks["m2d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_MEDAL_WORMS_HINT3_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_WORMS_HINT3_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_MEDAL_WORMS_HINT3_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_worm3,
				voiceOver = "MISSION_PARADISO_MEDAL_WORMS_HINT3_TEXT.wav",
				parentId = "m2",
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
				name = _("MISSION_PARADISO_MEDAL_WORMS_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_WORMS_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_PARADISO_MEDAL_WORMS_FINISH_TEXT.wav",
			}
		end,
	})
end
