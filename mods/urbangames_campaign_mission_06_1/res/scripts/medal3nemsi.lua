local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_NEMSI")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_KARABEN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_MEDAL_KARABEN_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_overview,
				voiceOver = "MISSION_BAGDAD_MEDAL_KARABEN_TEXT.wav",
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
		end,
		onUpdate = function(self)
			local assets = game.interface.getEntities({pos = params.bushes.pos, radius = 600}, {type = "ASSET_GROUP"})
			local count = 0
			for i = 1, #assets do
				local a = game.interface.getEntity(assets[i])
				local z = a.position[3]
				if 220 <= z and z <= 230 then
					local c = a.models["tree/usa/broom_snakeweed.mdl"]
					if a.models["tree/usa/broom_snakeweed.mdl"] ~= nil then
						count = count + c
					end
				end
			end
			if taskutil.userstate.bushesfound == nil or taskutil.userstate.bushesfound < count then
				taskutil.userstate.bushesfound = count
			end

			local diff = taskutil.userstate.bushesfound - count
			self:setProgressCount(diff, params.numbushes, 1)
			if diff >= params.numbushes then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_KARABEN_NOSE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_MEDAL_KARABEN_NOSE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_MEDAL_KARABEN_NOSE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_BAGDAD_MEDAL_KARABEN_NOSE_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_bushes,
				voiceOver = "MISSION_BAGDAD_MEDAL_KARABEN_NOSE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3b", {
		onStart = function(self)
			local entities = game.interface.getEntities({ pos = game.interface.getEntity(params.ergeli).position, radius = 200 }, { type = "CONSTRUCTION" })
			if #entities > 0 then
			    game.interface.setBulldozeable(entities[1], false)
				taskutil:setMarker("nemsi", { entity = entities[1], type = "question" }, self.name, "finish")
			else
				self:finish()
			end
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMarker("nemsi")
			taskutil.tasks["m3c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_KARABEN_WEAPONS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_MEDAL_KARABEN_WEAPONS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_MEDAL_KARABEN_WEAPONS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_ergeli,
				voiceOver = "MISSION_BAGDAD_MEDAL_KARABEN_WEAPONS_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3c", {
		onStart = function(self)
			arrivaltracker.track("m3c", { cargotype = "FOOD", to = params.tribe1 })
		end,
		onUpdate = function(self)
			local consumed = arrivaltracker.get("m3c")
			self:setProgressCount(consumed, params.food_m3c, 1)
			if consumed >= params.food_m3c then
				self:finish()
			end
		end,
		onFinish = function(self)
			arrivaltracker.track("m3c")
			taskutil:setMedalCompleted("MEDAL_NEMSI")
			taskutil.tasks["m3d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_KARABEN_TRANSLATOR_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_MEDAL_KARABEN_TRANSLATOR_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_MEDAL_KARABEN_TRANSLATOR_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_BAGDAD_MEDAL_KARABEN_TRANSLATOR_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_tribe1,
				voiceOver = "MISSION_BAGDAD_MEDAL_KARABEN_TRANSLATOR_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3d", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_KARABEN_FINISH_NAME") % params,
				paragraphs = { { text = _("MISSION_BAGDAD_MEDAL_KARABEN_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_BAGDAD_MEDAL_KARABEN_FINISH_TEXT.wav",
			}
		end,
	})
end
