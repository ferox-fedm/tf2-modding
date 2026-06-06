local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
	taskutil:new("5", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track5")
		end,
		onFinish = function(self)
			taskutil.tasks["5a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_TOURISM_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_TOURISM_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_scoutlocator,
				voiceOver = "MISSION_VICECOUNTY_TASK_TOURISM_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
			taskutil:setMarker("5a1", { entity = params.miami, type = "question" }, self.name, "start5b")
			taskutil:setMarker("5a2", { entity = params.everglades, type = "question" }, self.name, "start5c")
			taskutil:setMarker("5a3", { entity = params.keywest, type = "question" }, self.name, "start5d")
			taskutil:invokeLater(self.name, "showm3", 120)
		end,
		onUpdate = function(self)
			local done = 0
			if taskutil.tasks["5b"].start == nil and taskutil.tasks["5b"].finish == nil then 
				done = done + 1
			end
			if taskutil.tasks["5c"].start == nil and taskutil.tasks["5c"].finish == nil then 
				done = done + 1
			end
			if taskutil.tasks["5d"].start == nil and taskutil.tasks["5d"].finish == nil then 
				done = done + 1
			end
			self:setProgressCount(done, 3)
			if done >= 3 then self:finish() end
		end,
		onFinish = function(self)
			if taskutil.tasks["5b"].start then taskutil.tasks["5b"]:start() end
			if taskutil.tasks["5c"].start then taskutil.tasks["5c"]:start() end
			if taskutil.tasks["5d"].start then taskutil.tasks["5d"]:start() end

			taskutil:setMarker("5a1")
			taskutil:setMarker("5a2")
			taskutil:setMarker("5a3")
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_TOURISM_MEASURE_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_TOURISM_MEASURE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_TOURISM_MEASURE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				optionsRightAlign = true,
				parentId = "5",
				camera = params.jump_scoutlocator,
				voiceOver = "MISSION_VICECOUNTY_TASK_TOURISM_MEASURE_TEXT.wav",
			}
		end,
		handlers = {
			start5b = function(self)
				taskutil:setMarker("5a1")
				taskutil:start("5b")
			end,
			start5c = function(self)
				taskutil:setMarker("5a2")
				taskutil:start("5c")
			end,
			start5d = function(self)
				taskutil:setMarker("5a3")
				taskutil:start("5d")
			end,
			showm3 = function(self)
				if taskutil.tasks["m3"].start ~= nil then
					taskutil.tasks["m3"]:start()
				end
			end,
		},
		guiHandlers = {
			start5b = function(self)
				taskutil:sendScriptFn(self.name, "start5b")
			end,
			start5c = function(self)
				taskutil:sendScriptFn(self.name, "start5c")
			end,
			start5d = function(self)
				taskutil:sendScriptFn(self.name, "start5d")
			end,
		},
	})

	taskutil:new("5b", {
		onStart = function(self)
			arrivaltracker.track("5b1", { cargotype = "PASSENGERS", from = params.westpalmbeach, to = params.miami })
			arrivaltracker.track("5b2", { cargotype = "FOOD", to = params.miami })
		end,
		onUpdate = function(self)
			local c1 = arrivaltracker.get("5b1")
			local c2 = arrivaltracker.get("5b2")

			local n1 = params.people_amount_westpalmbeach
			local n2 = params.food_amount_westpalmbeach

			local done1 = c1 >= n1
			local done2 = c2 >= n2

			self:setProgressCount(c1, n1, 1)
			self:setProgressCount(c2, n2, 2)

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("5b1")
			arrivaltracker.track("5b2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_TOURISM_MILLENIALS_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_TOURISM_MILLENIALS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_TOURISM_MILLENIALS_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_TASK_TOURISM_MILLENIALS_SUB1") % params },
					{ name = _("MISSION_VICECOUNTY_TASK_TOURISM_MILLENIALS_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				optionsRightAlign = true,
				parentId = "5",
				camera = params.jump_miami,
				voiceOver = "MISSION_VICECOUNTY_TASK_TOURISM_MILLENIALS_TEXT.wav",
			}
		end,
	})

	taskutil:new("5c", {
		onStart = function(self)
			arrivaltracker.track("5c", { cargotype = "PASSENGERS", from = params.miami, to = params.everglades })
			taskutil.userstate.income5c = 0
		end,
		onUpdate = function(self)
			local c1 = arrivaltracker.get("5c")
			local c2 = taskutil.userstate.income5c

			local n1 = params.people_amount_everglades
			local n2 = params.money_amount_everglades

			local done1 = c1 >= n1
			local done2 = c2 >= n2

			self:setProgressCount(c1, n1, 1)
			self:setProgressCount(c2, n2, 2)

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.income5c = nil
			arrivaltracker.track("5c")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_TOURISM_FAMILIES_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_TOURISM_FAMILIES_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_TOURISM_FAMILIES_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_TASK_TOURISM_FAMILIES_SUB1") % params },
					{ name = _("MISSION_VICECOUNTY_TASK_TOURISM_FAMILIES_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				optionsRightAlign = true,
				parentId = "5",
				camera = params.jump_everglades,
				voiceOver = "MISSION_VICECOUNTY_TASK_TOURISM_FAMILIES_TEXT.wav",
			}
		end,
		handlers = {
			handleEvent = function(self, id, name, param)
				if id == "__missionCallback__" then
					local id = param.params.entity
					if param.type == "VEHICLE_INCOME" then
						local e = game.interface.getEntity(id)
						if e.vehicles[1].fileName == "vehicle/ship/srn6_v2.mdl" then
							taskutil.userstate.income5c = taskutil.userstate.income5c + param.amount
						end
					end
				end
			end
		},
	})

	taskutil:new("5d", {
		onStart = function(self)
			taskutil.userstate.passengers5d = 0
		end,
		onUpdate = function(self)
			local entities = game.interface.getEntities({ pos = params.pos_keywest, radius = params.keywest_radius }, { type = "STATION" })
			local done1 = #entities > 0
			self:setSubtaskCompleted(1, done1)

			local done2 = taskutil.userstate.passengers5d >= params.people_amount_keys
			self:setSubtaskCompleted(2, done2)

			self:setProgressCount(taskutil.userstate.passengers5d, params.people_amount_keys, 2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.passengers5d = nil
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_TOURISM_CULTURE_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_TOURISM_CULTURE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_TOURISM_CULTURE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_TASK_TOURISM_CULTURE_SUB1") % params },
					{ name = _("MISSION_VICECOUNTY_TASK_TOURISM_CULTURE_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				optionsRightAlign = true,
				parentId = "5",
				camera = params.jump_keywest,
				voiceOver = "MISSION_VICECOUNTY_TASK_TOURISM_CULTURE_TEXT.wav",
			}
		end,
		handlers = {
			handleEvent = function(self, id, name, param)
				if id == "__missionCallback__" then
					local id = param.params.entity
					if param.type == "VEHICLE_INCOME" then
						local e = game.interface.getEntity(id)
						if e.carrier == "TRAM" then
							local polygon = zoneutil.makeCircleZone(params.pos_keywest, params.keywest_radius)
							if polygonutil.contains(polygon, e.position) then
								local count = param.params.cargoUnloaded.PASSENGERS or 0
								taskutil.userstate.passengers5d = taskutil.userstate.passengers5d + count
							end
						end
					end
				end
			end
		},
	})

	taskutil:new("end", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setCompleted()
			taskutil:invokeLater(self.name, "finish", 0.6)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_FINISH_TEXT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				voiceOver = "MISSION_VICECOUNTY_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
