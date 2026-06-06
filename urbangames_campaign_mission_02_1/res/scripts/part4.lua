local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local guidesystem = require "guidesystem"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("4", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track4")
			taskutil:disableProposalCheck()
		end,
		onFinish = function(self)
			taskutil.tasks["4b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_PASSENGERS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_PASSENGERS_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				--camera = { -2263, -1012, 1033 },
				camera = params.jump_surabaya_semarang_mid,
				voiceOver = "MISSION_COLONIALISM_TASK_PASSENGERS_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4b", {
		onStart = function(self)
			taskutil:setEnabled("menu.construction.road.passenger", true)
			vehiclestore.setAllowedVehicleCount(params.modelnames.passengerwagon, nil)
		end,
		onUpdate = function(self)
			local pos = {}
			pos[#pos + 1] = game.interface.getEntity(params.semarang).position
			pos[#pos + 1] = game.interface.getEntity(params.surabaya).position
			--pos[#pos + 1] = game.interface.getEntity(params.malang).position
			--pos[#pos + 1] = game.interface.getEntity(params.yogyakarta).position
			local n = #pos

			for i = 1, n do
				for j = i + 1, n do
					local stations1 = game.interface.getEntities({pos = pos[i], radius = 500}, {type = "STATION"})
					local stations2 = game.interface.getEntities({pos = pos[j], radius = 500}, {type = "STATION"})

					for k = 1, #stations1 do
						local s1 = stations1[k]
						if not game.interface.getEntity(s1).cargo then
							for l = 1, #stations2 do
								local s2 = stations2[l]
								if not game.interface.getEntity(s2).cargo then
									local path = game.interface.findPath(s1, s2, { TRAIN = true })
									if path ~= nil then
										self:finish()
										return
									end
								end
							end
						end
					end
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["4c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_PASSENGERS_LINE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_PASSENGERS_LINE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_PASSENGERS_LINE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_surabaya_semarang_mid,
				voiceOver = "MISSION_COLONIALISM_TASK_PASSENGERS_LINE_TEXT.wav",
			}
		end,
	})

	taskutil:new("4c", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm3", 30)
		end,
		onUpdate = function(self)
			local pos = {}
			pos[#pos + 1] = game.interface.getEntity(params.semarang).position
			pos[#pos + 1] = game.interface.getEntity(params.surabaya).position
			--pos[#pos + 1] = game.interface.getEntity(params.malang).position
			--pos[#pos + 1] = game.interface.getEntity(params.yogyakarta).position
			local n = #pos

			local function transported(station)
				local e = game.interface.getEntity(game.interface.getEntity(station).stationGroup)
				if e.itemsUnloaded == nil then return 0 end
				return e.itemsUnloaded.PASSENGERS or 0
			end

			local total = 0
			for i = 1, n do
				local stations = game.interface.getEntities({pos = pos[i], radius = 500}, {type = "STATION"})

				for k = 1, #stations do
					local s = game.interface.getEntity(stations[k])
					if s.carriers["RAIL"] then
						total = total + transported(stations[k])
					end
				end
			end
			if total >= params.passenger_amount_4c then self:finish() end
			self:setProgressCount(total, params.passenger_amount_4c)
		end,
		onFinish = function(self)
			taskutil:startLater("5")
		end,
		handlers = {
			showm3 = function(self) 
				if taskutil.tasks["m3"].start ~= nil then
					taskutil.tasks["m3"]:start()
				end
			end,
		},
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_PASSENGERS_TRANSPORT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_PASSENGERS_TRANSPORT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_PASSENGERS_TRANSPORT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_surabaya_semarang_mid,
				voiceOver = "MISSION_COLONIALISM_TASK_PASSENGERS_TRANSPORT_TEXT.wav",
			}
		end,
	})

end
