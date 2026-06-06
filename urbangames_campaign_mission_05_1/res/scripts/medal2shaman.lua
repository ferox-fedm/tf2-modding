local params = require "params"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_SHAMAN")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_MEDAL_SHAMAN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_MEDAL_SHAMAN_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_shaman_hut,
				voiceOver = "MISSION_TRANSSIB_MEDAL_SHAMAN_TEXT.wav",
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
			taskutil:setMarker("markerm2a", { entity = params.shaman_hut, type = "question" }, self.name, "finish")
		end,
		onFinish = function(self)
			taskutil:setMarker("markerm2a")
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			local pos = game.interface.getEntity(params.shaman_hut).position
			return {
				name = _("MISSION_TRANSSIB_MEDAL_SHAMAN_SEARCH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_MEDAL_SHAMAN_SEARCH_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_MEDAL_SHAMAN_SEARCH_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_shaman_hut,
				voiceOver = "MISSION_TRANSSIB_MEDAL_SHAMAN_SEARCH_TEXT.wav",
				parentId = "m2",
			}
		end,
	})

	taskutil:new("m2b", {
		onStart = function(self)
			taskutil:setZone("gem", { polygon = zoneutil.makeCircleZone(params.pos_gem, 30), draw = true, drawColor = colors.RED })
		end,
		onUpdate = function(self)
			local e = game.interface.getEntity(params.gem)
			if not e then
				self:finish()
				return
			end
			if not e.position then
				self:finish()
				return
			end
			if game.interface.getHeight(e.position) < e.position[3] - 2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("gem")
			taskutil.tasks["m2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_MEDAL_SHAMAN_GEMS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_MEDAL_SHAMAN_GEMS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_MEDAL_SHAMAN_GEMS_TASK") % params },
					{ type = "HINT", text = _("MISSION_TRANSSIB_MEDAL_SHAMAN_GEMS_HINT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_gem,
				voiceOver = "MISSION_TRANSSIB_MEDAL_SHAMAN_GEMS_TEXT.wav",
				parentId = "m2",
			}
		end,
	})

	taskutil:new("m2c", {
		onStart = function(self)
			taskutil:setMarker("markerm2c", { entity = params.shaman_hut, type = "question" }, self.name, "finish")
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_SHAMAN")
			taskutil:setMarker("markerm2c")
			taskutil.tasks["m2d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_MEDAL_SHAMAN_RETURN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_MEDAL_SHAMAN_RETURN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_MEDAL_SHAMAN_RETURN_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_shaman_hut,
				voiceOver = "MISSION_TRANSSIB_MEDAL_SHAMAN_RETURN_TEXT.wav",
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
				name = _("MISSION_TRANSSIB_MEDAL_SHAMAN_FINISH_NAME") % params,
				paragraphs = { { text = _("MISSION_TRANSSIB_MEDAL_SHAMAN_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_TRANSSIB_MEDAL_SHAMAN_FINISH_TEXT.wav",
			}
		end,
	})
end
