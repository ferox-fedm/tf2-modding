local taskutil = require "mission.taskutil"
local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local util = require "util"

return function()
	taskutil:new("2", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track2")
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_LEMANS_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_LEMANS_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_airfield_lemans,
				voiceOver = "MISSION_MACHINES_TASK_LEMANS_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.workshop_player, "industry/workshop.con", {
				productionLevel = 0,
				stocks = {
					{ cargoType = "MACHINES", type = "RECEIVING", x = 0, y = 0, sizex = 1, sizey = 1 },
				},
				input = { { 1 } },
				output = { },
				capacity = 200,
			})
		end,
		onUpdate = function(self)
			local consumed = game.interface.getEntity(game.interface.getEntity(params.workshop_player).simBuildings[1]).itemsConsumed.MACHINES or 0
			self:setProgressCount(consumed, params.machines_3a, 1)
			if consumed >= params.machines_3a then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_LEMANS_ENGINE_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_LEMANS_ENGINE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_LEMANS_ENGINE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_MACHINES_TASK_LEMANS_ENGINE_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_workshop_player,
				parentId = "2",
				voiceOver = "MISSION_MACHINES_TASK_LEMANS_ENGINE_TEXT.wav",
			}
		end,
	})

	taskutil:new("2b", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal2", 120)
			game.interface.upgradeConstruction(params.tribune_lemans, "industry/tribune.con", {
				productionLevel = 3,
				commercialCapacity = 100,
				autoUpgrade = 0,
				stocks = { },
				input = { { } },
				output = { },
				capacity = 1,
			})
		end,
		onUpdate = function(self)
			local consumed = game.interface.getEntity(game.interface.getEntity(params.workshop_lemans).simBuildings[1]).itemsConsumed.PLANE_PARTS or 0

			local stations = game.interface.getEntities({pos = game.interface.getEntity(params.workshop_lemans).position, radius = 200}, {type = "STATION"})
			local persons = 0
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.PASSENGERS or 0
				persons = persons + s
			end

			--self:setProgressCount(consumed, params.parts_2b, 1)
			self:setProgressCount(persons, params.persons_2b, 1)
			--if consumed >= params.parts_2b and persons >= params.persons_2b then
			if persons >= params.persons_2b then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_LEMANS_SHOW_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_LEMANS_SHOW_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_LEMANS_SHOW_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_tribune_lemans,
				subTasks = {
					--{ name = _("Bauteile liefern") },
					{ name = _("MISSION_MACHINES_TASK_LEMANS_SHOW_SUB1") },
				},
				parentId = "2",
				voiceOver = "MISSION_MACHINES_TASK_LEMANS_SHOW_TEXT.wav",
			}
		end,
		handlers = {
			showmedal2 = function(self) taskutil:start("m2") end,
		},
	})

	taskutil:new("2c", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", 2)
			util.activateAirfield(params.airfield_lemans)
			util.activateAirfield(params.airfield_paris)
			util.activateAirfield(params.airfield_reims)
			util.activateAirfield(params.airfield_calais)
			taskutil.userstate.progress2c = taskutil.userstate.progress2c or {}
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getVehicles({ carrier = "AIR" })
			local stations = taskutil.userstate.progress2c

			for i = 1, #vehicles do
				local e = game.interface.getEntity(vehicles[i])
				if e.id ~= params.latham_plane and e.line >= 0 then
					local l = game.interface.getEntity(e.line)
					local s = l.stops[e.stopIndex + 1]
					if e.state == "AT_TERMINAL" then
						stations[s] = true
					end
				end
			end
			local count = 0
			for k,v in pairs(stations) do
				if v then count = count + 1 end
			end
			self:setProgressCount(count, params.airport_landings)
			if count >= params.airport_landings then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.progress2c = nil
			vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", 1)
			taskutil.tasks["2d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_LEMANS_FLIGHT_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_LEMANS_FLIGHT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_LEMANS_FLIGHT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_airfield_lemans,
				parentId = "2",
				voiceOver = "MISSION_MACHINES_TASK_LEMANS_FLIGHT_TEXT.wav",
			}
		end,
	})

	taskutil:new("2d", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			if vehiclestore.currentvehicles["vehicle/plane/bleriot_xi.mdl"] == 1 then
				self:finish()
			end
		end,
		onFinish = function(self)
			util.deactivateAirfield(params.airfield_lemans)
			util.deactivateAirfield(params.airfield_paris)
			util.deactivateAirfield(params.airfield_reims)
			util.deactivateAirfield(params.airfield_calais)
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_LEMANS_RETURN_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_LEMANS_RETURN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_LEMANS_RETURN_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_airfield_lemans,
				parentId = "2",
				voiceOver = "MISSION_MACHINES_TASK_LEMANS_RETURN_TEXT.wav",
			}
		end,
	})
end
