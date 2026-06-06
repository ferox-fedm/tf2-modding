local taskutil = require "mission.taskutil"
local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local util = require "util"
local vec3 = require "vec3"

return function()
	taskutil:new("4", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track4")
		end,
		onFinish = function(self)
			taskutil.tasks["4a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_REIMS_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_REIMS_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				camera = params.jump_airfield_reims,
				optionsRightAlign = true,
				voiceOver = "MISSION_MACHINES_TASK_REIMS_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal1", 120)
			game.interface.upgradeConstruction(params.workshop_player, "industry/workshop.con", {
				productionLevel = 0,
				stocks = {
					{ cargoType = "PLANKS", type = "RECEIVING", x = 0, y = 0, sizex = 1, sizey = 1 },
					{ cargoType = "MACHINES", type = "RECEIVING", x = 1, y = 0, sizex = 1, sizey = 1 },
					{ cargoType = "FUEL", type = "RECEIVING", x = 0, y = 1, sizex = 1, sizey = 1 },
				},
				input = { { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 } },
				output = { },
				capacity = 400,
			})
		end,
		onUpdate = function(self)
			local consumed = game.interface.getEntity(game.interface.getEntity(params.workshop_player).simBuildings[1]).itemsConsumed.FUEL or 0
			self:setProgressCount(consumed, params.fuel_4a)
			if consumed >= params.fuel_4a then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["4b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_REIMS_FUEL_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_REIMS_FUEL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_REIMS_FUEL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_workshop_player,
				parentId = "4",
				voiceOver = "MISSION_MACHINES_TASK_REIMS_FUEL_TEXT.wav",
			}
		end,
		handlers = {
			showmedal1 = function(self) taskutil:start("m1") end,
		},
	})

	taskutil:new("4b", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.tribune_reims, "industry/tribune.con", {
				stocks = { "PLANKS", "CHAMPAGNE" },
				input = { { 1, 0 }, { 0, 1 } },
				capacity = 200,
				commercialCapacity = 50,
				productionLevel = 3,
				autoUpgrade = 0,
			})
		end,
		onUpdate = function(self)
			local consumed = game.interface.getEntity(game.interface.getEntity(params.tribune_reims).simBuildings[1]).itemsConsumed
			local c = consumed.CHAMPAGNE or 0
			local p = consumed.PLANKS or 0

			local stations = game.interface.getEntities({pos = game.interface.getEntity(params.tribune_reims).position, radius = 200}, {type = "STATION"})
			local persons = 0
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.PASSENGERS or 0
				persons = persons + s
			end

			self:setProgressCount(c, params.champagne_4b, 1)
			self:setProgressCount(p, params.planks_4b, 2)

			if c >= params.champagne_4b then self:setSubtaskCompleted(1) end
			if p >= params.planks_4b then self:setSubtaskCompleted(2) end

			if c >= params.champagne_4b and p >= params.planks_4b then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["4c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_REIMS_SHOW_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_REIMS_SHOW_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_REIMS_SHOW_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_tribune_reims,
				subTasks = {
					{ name = _("MISSION_MACHINES_TASK_REIMS_SHOW_SUB1") },
					{ name = _("MISSION_MACHINES_TASK_REIMS_SHOW_SUB2") },
					--{ name = _("MISSION_MACHINES_TASK_REIMS_SHOW_SUB3") },
				},
				parentId = "4",
				voiceOver = "MISSION_MACHINES_TASK_REIMS_SHOW_TEXT.wav",
			}
		end,
	})

	taskutil:new("4c", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", 2)
			util.activateAirfield(params.airfield_lemans)
			util.activateAirfield(params.airfield_paris)
			util.activateAirfield(params.airfield_reims)
			util.activateAirfield(params.airfield_calais)
			taskutil.userstate.progress4c = taskutil.userstate.progress4c or {}
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getVehicles({ carrier = "AIR" })
			local planepositions = taskutil.userstate.progress4c
			planepositions[0] = planepositions[0] or 0

			for i = 1, #vehicles do
				if vehicles[i] ~= params.latham_plane then
					local e = game.interface.getEntity(vehicles[i])
					local planepos = e.position
					if planepositions[e.id] ~= nil then
						local z = game.interface.getHeight({planepos[1], planepos[2]})
						if planepos[3] - z > 35 then
							local x = vec3.new(table.unpack(planepos))
							local y = vec3.new(table.unpack(planepositions[e.id]))
							planepositions[0] = planepositions[0] + vec3.distance(x, y)
						end
					end
					planepositions[e.id] = planepos
				end
			end
			self:setProgressCount(planepositions[0], params.flight_distance, 1)
			if planepositions[0] >= params.flight_distance then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.progress4c = nil
			vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", 1)
			taskutil.tasks["4d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_REIMS_FLIGHT_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_REIMS_FLIGHT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_REIMS_FLIGHT_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_MACHINES_TASK_REIMS_FLIGHT_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_airfield_reims,
				parentId = "4",
				voiceOver = "MISSION_MACHINES_TASK_REIMS_FLIGHT_TEXT.wav",
			}
		end,
	})

	taskutil:new("4d", {
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
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_REIMS_RETURN_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_REIMS_RETURN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_REIMS_RETURN_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_airfield_reims,
				parentId = "4",
				voiceOver = "MISSION_MACHINES_TASK_REIMS_RETURN_TEXT.wav",
			}
		end,
	})
end
