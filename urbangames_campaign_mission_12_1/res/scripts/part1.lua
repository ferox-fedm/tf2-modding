local taskutil = require "mission.taskutil"
local params = require "params"

return function()

	local mainguihandlers = {
		jump_airportpalma = function()
			game.gui.setAutoCamera(params.palma_airport_pos)
		end,
		voiceOverEnded = function(self) taskutil:finish(self.name) end,
	}

	setmetatable(mainguihandlers, { __index = function(self, key)
		local n = #"jump_"
		if key:sub(1, n) == "jump_" then
			game.gui.setAutoCamera(params[key])
		end
	end})

	taskutil:new("1", {
		onStart = function(self)
			--taskutil.tasks["m1"]:start()
			--taskutil.tasks["m2"]:start()
			--taskutil.tasks["m4"]:start()
			taskutil:invokeLater(self.name, "showm1", 120)
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.palma_airport_pos,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_FLIGHT_TEXT.wav",
			}
		end,
		handlers = {
			showm1 = function(self)
				if taskutil.tasks["m1"].start ~= nil then
					taskutil.tasks["m1"]:start()
				end
			end,
		},
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm1", 120)
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.airportdeliverlocation).simBuildings[1]).itemsConsumed
			local x1 = c.STEEL or 0
			local x2 = c.CONSTRUCTION_MATERIALS or 0

			self:setProgressCount(x1, params.steel_airport, 1)
			self:setProgressCount(x2, params.constructionmaterial_airport, 2)

			self:setSubtaskCompleted(1, x1 >= params.steel_airport)
			self:setSubtaskCompleted(2, x2 >= params.constructionmaterial_airport)
			if x1 >= params.steel_airport and x2 >= params.constructionmaterial_airport then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORT_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORT_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORT_SUB1") },
					{ name = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORT_SUB2") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.palma_airport_pos,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORT_TEXT.wav",
			}
		end,
		handlers = {
			showm1 = function(self) 
				if taskutil.tasks["m1"].start ~= nil then
					taskutil.tasks["m1"]:start()
				end
			end,
		},
	})

	taskutil:new("1b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local airportspalma = game.interface.getEntities({ pos = params.palma_airport_pos, radius = 200 }, { type = "CONSTRUCTION" })
			local airportpalma
			for i = 1, #airportspalma do
				if game.interface.getEntity(airportspalma[i]).fileName == "station/air/airport.con" then
					airportpalma = airportspalma[i]
				end
			end
			if not airportpalma then return end

			local goal = {
				{ airportpalma, params.airportfrankfurt },
				{ airportpalma, params.airportwien },
				{ airportpalma, params.airportzurich },
			}
			for g = 1, 3 do
				for h = 1, 2 do
					local e = game.interface.getEntity(goal[g][h])
					goal[g][h] = {}
					for s = 1, #e.stations do
						goal[g][h][e.stations[s]] = 1
					end
				end
			end

			local planes = game.interface.getVehicles({ carrier = "AIR" })
			local lines = {}
			for i = 1, #planes do
				local line = game.interface.getEntity(planes[i]).line
				if line >= 0 then
					lines[line] = 1
				end
			end
			local count = 0
			for g = 1, 3 do
				self:setSubtaskCompleted(g, false)
				for line, _ in pairs(lines) do
					local t = { false, false }
					local l = game.interface.getEntity(line)
					for j = 1, #l.stops do
						local s = game.interface.getEntity(l.stops[j])
						for k = 1, #s.stations do
							for h = 1, 2 do
								local map = goal[g][h]
								if map[s.stations[k]] then
									t[h] = true
								end
							end
						end
					end
					if t[1] and t[2] then
						count = count + 1
						self:setSubtaskCompleted(g)
						break
					end
				end
			end
			if count == 3 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORTS_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORTS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORTS_TASK") % params },
					{ type = "HINT", text = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORTS_HINT") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORTS_SUB1") },
					{ name = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORTS_SUB2") },
					{ name = _("MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORTS_SUB3") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.palma_airport_pos,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_FLIGHT_AIRPORTS_TEXT.wav",
			}
		end,
	})
end
