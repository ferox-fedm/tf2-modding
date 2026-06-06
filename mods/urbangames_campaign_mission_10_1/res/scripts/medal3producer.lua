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
				name = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_filmset4,
				voiceOver = "MISSION_STARFLIGHT_MEDAL_PRODUCER_TEXT.wav",
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
			taskutil:setMarker("m3", { entity = params.filmset4, type = "question" }, self.name, "finish")
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMarker("m3")
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_STRIKE_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_STRIKE_TEXT") },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_STRIKE_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_filmset4,
				voiceOver = "MISSION_STARFLIGHT_MEDAL_PRODUCER_STRIKE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3b", {
		onStart = function(self)
			local entities = game.interface.getEntities({ pos = params.pos_losangeles, radius = 500 }, { type = "CONSTRUCTION" })
			local e
			for i = 1, #entities do
				e = game.interface.getEntity(entities[i])
				if e.fileName:match("/ind_") then
					e = entities[i]
					break
				end
			end

			if e ~= nil then
				taskutil:setMarker("m3", { entity = e, type = "question" }, self.name, "finish")
			end
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMarker("m3")
			taskutil.tasks["m3c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_HINT1_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_HINT1_TEXT") },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_HINT1_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_losangeles,
				voiceOver = "MISSION_STARFLIGHT_MEDAL_PRODUCER_HINT1_TEXT.wav",
			}
		end,
	})

	local function fin(self)
		taskutil.userstate.progress_m3b = (taskutil.userstate.progress_m3b or 0) + 1
		if taskutil.userstate.progress_m3b == 2 then
			taskutil.userstate.progress_m3b = nil
			taskutil:finish(self.name)
		end
	end

	taskutil:new("m3c", {
		onStart = function(self)

			local entities = game.interface.getEntities({ pos = params.pos_bakersfield, radius = 500 }, { type = "CONSTRUCTION" })
			local e
			for i = 1, #entities do
				e = game.interface.getEntity(entities[i])
				if e.fileName:match("/res_") then
					e = entities[i]
					break
				end
			end

			if e ~= nil then
				taskutil:setMarker("m3_2", { entity = e, type = "question" }, self.name, "finishhelper2")
			end

			local entities = game.interface.getEntities({ pos = params.pos_santabarbara, radius = 500 }, { type = "CONSTRUCTION" })
			local e
			for i = 1, #entities do
				e = game.interface.getEntity(entities[i])
				if e.fileName:match("/res_") then
					e = entities[i]
					break
				end
			end

			if e ~= nil then
				taskutil:setMarker("m3_1", { entity = e, type = "question" }, self.name, "finishhelper1")
			end

		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMarker("m3_1")
			taskutil:setMarker("m3_2")
			taskutil.tasks["m3d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_HINT2_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_HINT2_TEXT") },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_HINT2_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = { -200, -2700, 1500 },
				voiceOver = "MISSION_STARFLIGHT_MEDAL_PRODUCER_HINT2_TEXT.wav",
			}
		end,
		handlers = {
			finishhelper1 = function(self)
				taskutil:setMarker("m3_1")
				fin(self)
			end,
			finishhelper2 = function(self)
				taskutil:setMarker("m3_2")
				fin(self)
			end,
		},
	})

	taskutil:new("m3d", {
		onStart = function(self)
			taskutil.userstate.progress_m3c = #game.interface.getVehicles({ carrier = "AIR" })
		end,
		onUpdate = function(self)
			if taskutil.userstate.progress_m3c > #game.interface.getVehicles({ carrier = "AIR" }) then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m3e"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_HEARING_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_HEARING_TEXT") },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_HEARING_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = { -200, -2700, 1500 },
				voiceOver = "MISSION_STARFLIGHT_MEDAL_PRODUCER_HEARING_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3e", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_3")
			taskutil.tasks["m3f"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_STUDIO_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_STUDIO_TEXT") },
				},
				options = { { _("MISSION_STARFLIGHT_MEDAL_PRODUCER_STUDIO_OPTION") % params, "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				camera = params.jump_filmset4,
				voiceOver = "MISSION_STARFLIGHT_MEDAL_PRODUCER_STUDIO_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3f", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_STARFLIGHT_MEDAL_PRODUCER_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_STARFLIGHT_MEDAL_PRODUCER_FINISH_TEXT.wav",
			}
		end,
	})
end
