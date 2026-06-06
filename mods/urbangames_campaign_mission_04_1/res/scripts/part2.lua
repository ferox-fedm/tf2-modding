local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("2", {
		onStart = function(self)
			taskutil:setMusicTrack("track2")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_INFRASTRUCTURE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_INFRASTRUCTURE_TEXT") % params },
				},
				optionsRightAlign = true,
				options = { { "Continue", "finish" } },
				camera = params.jump_topolobampo,
				voiceOver = "MISSION_PARADISO_TASK_INFRASTRUCTURE_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			taskutil:setMarker("hotel", { entity = params.hotel, type = "question" }, self.name, "hotel")
			taskutil:setMarker("hospital", { entity = params.hospital, type = "question" }, self.name, "hospital")
			taskutil:invokeLater(self.name, "showm1", 240)
		end,
		onFinish = function(self)
			taskutil:setMarker("hotel")
			taskutil:setMarker("hospital")
			taskutil:startLater("3")
		end,
		onUpdate = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_INFRASTRUCTURE_MATERIAL_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_INFRASTRUCTURE_MATERIAL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_INFRASTRUCTURE_MATERIAL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_topolobampo,
				voiceOver = "MISSION_PARADISO_TASK_INFRASTRUCTURE_MATERIAL_TEXT.wav",
			}
		end,
		handlers = {
			hotel = function(self) taskutil:setMarker("hotel") taskutil:start("2ab") end,
			hospital = function(self) taskutil:setMarker("hospital") taskutil:start("2ac") end,
			showm1 = function(self) taskutil:start("m1") end,
		},
	})

	taskutil:new("2ab", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.hotel, "industry/hotel.con", { productionLevel = 0, cargo = "consume", cap = 100 })
			taskutil:setMarker("hotel")
			arrivaltracker.track("2ab", { cargotype = "SPOON", to = params.hotel })
		end,
		onUpdate = function(self)
			local s = arrivaltracker.get("2ab")
			self:setProgressCount(s, params.spoon_2)
			if s >= params.spoon_2 then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["2ac"]:setProgressNone()
			if (taskutil.tasks["2ac"].finish ~= nil) then taskutil.tasks["2ac"]:finish() end
			if (taskutil.tasks["2a"].finish ~= nil) then taskutil.tasks["2a"]:finish() end
			arrivaltracker.track("2ab")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_INFRASTRUCTURE_HOTEL_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_INFRASTRUCTURE_HOTEL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_INFRASTRUCTURE_HOTEL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_hotel,
				voiceOver = "MISSION_PARADISO_TASK_INFRASTRUCTURE_HOTEL_TEXT.wav",
			}
		end,
	})

	taskutil:new("2ac", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.hospital, "industry/hospital.con", { productionLevel = 0, cargo = "consume", cap = 100 })
			taskutil:setMarker("hospital")
			arrivaltracker.track("2ac", { cargotype = "ALCOHOL", to = params.hospital })
		end,
		onUpdate = function(self)
			local a = arrivaltracker.get("2ac")
			self:setProgressCount(a, params.alcohol_2)
			if a >= params.alcohol_2 then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["2ab"]:setProgressNone()
			if (taskutil.tasks["2ab"].finish ~= nil) then taskutil.tasks["2ab"]:finish() end
			if (taskutil.tasks["2a"].finish ~= nil) then taskutil.tasks["2a"]:finish() end
			arrivaltracker.track("2ac")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_INFRASTRUCTURE_HOSPITAL_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_INFRASTRUCTURE_HOSPITAL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_INFRASTRUCTURE_HOSPITAL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_hospital,
				voiceOver = "MISSION_PARADISO_TASK_INFRASTRUCTURE_HOSPITAL_TEXT.wav",
			}
		end,
	})

end
