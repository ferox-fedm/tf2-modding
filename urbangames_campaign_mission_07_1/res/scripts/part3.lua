local taskutil = require "mission.taskutil"
local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local util = require "util"

return function()
	taskutil:new("3", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track3")
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_CHANNEL_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_CHANNEL_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				camera = params.jump_airfield_calais,
				optionsRightAlign = true,
				voiceOver = "MISSION_MACHINES_TASK_CHANNEL_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal3", 60)
			game.interface.upgradeConstruction(params.workshop_player, "industry/workshop.con", {
				productionLevel = 0,
				stocks = {
					{ cargoType = "PLANKS", type = "RECEIVING", x = 0, y = 0, sizex = 1, sizey = 1 },
					{ cargoType = "MACHINES", type = "RECEIVING", x = 1, y = 0, sizex = 1, sizey = 1 },
				},
				input = { { 1, 0 }, { 0, 1 } },
				output = { },
				capacity = 200,
			})
		end,
		onUpdate = function(self)
			local consumed = game.interface.getEntity(game.interface.getEntity(params.workshop_player).simBuildings[1]).itemsConsumed.PLANKS or 0
			self:setProgressCount(consumed, params.planks_2a, 1)
			if consumed >= params.planks_2a then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_CHANNEL_HULL_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_CHANNEL_HULL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_CHANNEL_HULL_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_MACHINES_TASK_CHANNEL_HULL_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_workshop_player,
				parentId = "3",
				voiceOver = "MISSION_MACHINES_TASK_CHANNEL_HULL_TEXT.wav",
			}
		end,
		handlers = {
			showmedal3 = function(self) taskutil:start("m3") end,
		},
	})

	taskutil:new("3b", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.tribune_calais, "industry/tribune.con", {
				stocks = { "FUEL" },
				input = { { 1 } },
				capacity = 50,
				productionLevel = 3,
				autoUpgrade = 0,
			})
		end,
		onUpdate = function(self)
			local consumed = game.interface.getEntity(game.interface.getEntity(params.tribune_calais).simBuildings[1]).itemsConsumed
			--local p = consumed.PLANE_PARTS or 0
			local f = consumed.FUEL or 0
			--self:setProgressCount(p, params.parts_3b, 1)
			self:setProgressCount(f, params.fuel_3b, 1)
			--if p >= params.parts_3b and f >= params.fuel_3b then
			if f >= params.fuel_3b then
				self:finish()
			end
		end,
		onFinish = function(self)
			if taskutil.tasks["m3"].finish ~= nil then
				taskutil.tasks["m3"]:finish()
				taskutil.userstate.lathamrunning = 0
			end
			if taskutil.tasks["m3a"].finish ~= nil then taskutil.tasks["m3a"]:finish() end
			--game.interface.setPlayer(game.interface.getEntity(params.latham_plane).line, game.interface.getPlayer())
			taskutil.tasks["3c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_CHANNEL_SHOW_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_CHANNEL_SHOW_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_CHANNEL_SHOW_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_tribune_calais,
				subTasks = {
					--{ name = _("Bauteile liefern") },
					{ name = _("MISSION_MACHINES_TASK_CHANNEL_SHOW_SUB1") }, --Treibstoff liefern
				},
				parentId = "3",
				voiceOver = "MISSION_MACHINES_TASK_CHANNEL_SHOW_TEXT.wav",
			}
		end,
	})

	taskutil:new("3c", {
		onStart = function(self)
			util.activateAirfield(params.airfield_calais)
			util.activateAirfield(params.airfield_dover)
			vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", 2)
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getVehicles({ carrier = "AIR" })
			local data = taskutil.userstate.planedata
			local stopid1 = game.interface.getEntity(game.interface.getEntity(params.airfield_calais).stations[1]).stationGroup
			local stopid2 = game.interface.getEntity(game.interface.getEntity(params.airfield_dover).stations[1]).stationGroup

			local done1 = false
			local done2 = false
			for i = 1, #vehicles do
				local e = game.interface.getEntity(vehicles[i])
				if e.line >= 0 then
					local l = game.interface.getEntity(e.line)
					local lineok = #l.stops == 2
					if lineok then
						local variant1 = l.stops[1] == stopid1 and l.stops[2] == stopid2
						local variant2 = l.stops[1] == stopid2 and l.stops[2] == stopid1
						if not (variant1 or variant2) then
							lineok = false
						end
					end
					if lineok then
						done1 = true
						if data[vehicles[i]] ~= nil and e.state == "AT_TERMINAL" and l.stops[e.stopIndex + 1] ~= data[vehicles[i]] then
							done2 = true
							data[vehicles[i]] = nil
						elseif e.state == "AT_TERMINAL" then
							data[vehicles[i]] = l.stops[e.stopIndex + 1]
						end
					else
						data[vehicles[i]] = nil
					end
				end
			end
			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)
			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", 1)
			taskutil.tasks["3d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_CHANNEL_FLIGHT_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_CHANNEL_FLIGHT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_CHANNEL_FLIGHT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_airfield_calais,
				subTasks = {
					{ name = _("MISSION_MACHINES_TASK_CHANNEL_FLIGHT_OPTION1") }, --Flugzeug einer Linie zuweisen
					{ name = _("MISSION_MACHINES_TASK_CHANNEL_FLIGHT_OPTION2") }, --Landen
				},
				parentId = "3",
				voiceOver = "MISSION_MACHINES_TASK_CHANNEL_FLIGHT_TEXT.wav",
			}
		end,
	})

	taskutil:new("3d", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			if vehiclestore.currentvehicles["vehicle/plane/bleriot_xi.mdl"] == 1 then
				self:finish()
			end
		end,
		onFinish = function(self)
			util.deactivateAirfield(params.airfield_calais)
			util.deactivateAirfield(params.airfield_dover)
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_CHANNEL_RETURN_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_CHANNEL_RETURN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_CHANNEL_RETURN_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_airfield_calais,
				parentId = "3",
				voiceOver = "MISSION_MACHINES_TASK_CHANNEL_RETURN_TEXT.wav",
			}
		end,
	})
end
