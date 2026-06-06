local params = require "params"
local vehiclestore = require "mission.vehiclestore"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_SULTAN")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_SULTAN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_MEDAL_SULTAN_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_overview,
				voiceOver = "MISSION_BAGDAD_MEDAL_SULTAN_TEXT.wav",
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

	local function sultansWagonIsIn(city)
		local allVehicles = game.interface.getEntities({pos = game.interface.getEntity(city).position, radius = 500 }, { type="VEHICLE" })
		for i = 1, #allVehicles do
			local e = game.interface.getEntity(allVehicles[i])
			for w = 1, #e.vehicles do
				if string.match(e.vehicles[w].fileName, "sultan") then
					return true
				end
			end
		end
		return false
	end

	taskutil:new("m2a", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount("vehicle/waggon/sultan_v2.mdl", nil)
		end,
		onUpdate = function(self)
			if sultansWagonIsIn(params.aleppo) then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_SULTAN_DIVAN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_MEDAL_SULTAN_DIVAN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_MEDAL_SULTAN_DIVAN_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_BAGDAD_MEDAL_SULTAN_DIVAN_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_aleppo,
				voiceOver = "MISSION_BAGDAD_MEDAL_SULTAN_DIVAN_TEXT.wav",
			}
		end,
	})

	taskutil:new("m2b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			if sultansWagonIsIn(params.adana) then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_SULTAN_DISHES_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_MEDAL_SULTAN_DISHES_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_MEDAL_SULTAN_DISHES_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_BAGDAD_MEDAL_SULTAN_DISHES_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_adana,
				voiceOver = "MISSION_BAGDAD_MEDAL_SULTAN_DISHES_TEXT.wav",
			}
		end,
	})

	taskutil:new("m2c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			if sultansWagonIsIn(params.konya) then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_SULTAN")
			taskutil.tasks["m2d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_MEDAL_SULTAN_CARPET_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_MEDAL_SULTAN_CARPET_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_MEDAL_SULTAN_CARPET_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_BAGDAD_MEDAL_SULTAN_CARPET_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_konya,
				voiceOver = "MISSION_BAGDAD_MEDAL_SULTAN_CARPET_TEXT.wav",
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
				name = _("MISSION_BAGDAD_MEDAL_SULTAN_FINISH_NAME") % params,
				paragraphs = { { text = _("MISSION_BAGDAD_MEDAL_SULTAN_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_BAGDAD_MEDAL_SULTAN_FINISH_TEXT.wav",
			}
		end,
	})
end
