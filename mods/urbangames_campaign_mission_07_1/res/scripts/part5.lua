local taskutil = require "mission.taskutil"
local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local util = require "util"

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
				name = _("MISSION_MACHINES_TASK_LONDON_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_LONDON_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				camera = { params.pos_london[1], params.pos_london[2], 500 },
				optionsRightAlign = true,
				voiceOver = "MISSION_MACHINES_TASK_LONDON_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
			local config = {
				productionLevel = 0,
				stocks = { },
				input = { { } },
				people = 100,
			}
			game.interface.upgradeConstruction(params.workshop_lemans, "industry/workshop.con", config)
			game.interface.upgradeConstruction(params.workshop_paris, "industry/workshop.con", config)
			game.interface.upgradeConstruction(params.tribune_reims , "industry/tribune.con", {
				productionLevel = 3,
				commercialCapacity = 100,
				capacity = 0,
				autoUpgrade = 0,
				stocks = { },
				input = { { } },
				output = { },
				capacity = 1,
			})
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_LONDON_DECISION_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_LONDON_DECISION_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_LONDON_DECISION_TASK") % params },
				},
				options = { { _("MISSION_MACHINES_TASK_LONDON_DECISION_OPTION1"), "finish1" }, { _("MISSION_MACHINES_TASK_LONDON_DECISION_OPTION2"), "finish2" }, { _("MISSION_MACHINES_TASK_LONDON_DECISION_OPTION3"), "finish3" } },
				camera = { params.pos_paris[1], params.pos_paris[2], 500 },
				parentId = "5",
				voiceOver = "MISSION_MACHINES_TASK_LONDON_DECISION_TEXT.wav",
			}
		end,
		handlers = {
			finishhelper = function(self, city)
				taskutil.userstate.city5 = city
				taskutil:finish(self.name)
			end,
		},
		guiHandlers = {
			finish1 = function(self)
				taskutil:sendScriptFn(self.name, "finishhelper", { "lemans" })
			end,
			finish2 = function(self)
				taskutil:sendScriptFn(self.name, "finishhelper", { "reims" })
			end,
			finish3 = function(self)
				taskutil:sendScriptFn(self.name, "finishhelper", { "paris" })
			end,
		},
	})

	taskutil:new("5b", {
		onStart = function(self)
			if (taskutil.userstate.city5 == "reims") then
				util.activateAirfield(params.airfield_paris)
				util.activateAirfield(params.airfield_lemans)
				util.activateAirfield(params.airfield_reims)
				util.activateAirfield(params.airfield_calais)
				vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", 2)
			elseif (taskutil.userstate.city5 == "paris") then
				game.interface.upgradeConstruction(params.workshop_paris, "industry/workshop.con", {
					productionLevel = 0,
					stocks = {
						{ cargoType = "PLANE_PARTS", type = "RECEIVING", x = 0, y = 0, sizex = 1, sizey = 1 },
					},
					input = { { 1 } },
					people = 50,
					capacity = 200,
				})
				game.interface.upgradeConstruction(params.workshop_player, "industry/workshop.con", {
					productionLevel = 0,
					stocks = {
						{ cargoType = "PLANKS", type = "RECEIVING", x = 0, y = 0, sizex = 1, sizey = 1 },
						{ cargoType = "MACHINES", type = "RECEIVING", x = 1, y = 0, sizex = 1, sizey = 1 },
						{ cargoType = "FUEL", type = "RECEIVING", x = 0, y = 1, sizex = 1, sizey = 1 },
					},
					input = { { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 } },
					output = { PLANE_PARTS = 1 },
					capacity = 400,
				})
			end

			local city = taskutil.userstate.city5
			local workshop = params["workshop_" .. city]
			local specialists = 0
			local stations = workshop == nil and {} or game.interface.getEntities({pos = game.interface.getEntity(workshop).position, radius = 200}, {type = "STATION"})
			for j = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[j]).stationGroup).itemsUnloaded.PASSENGERS or 0
				specialists = specialists + s
			end
			taskutil.userstate.specialists5b = specialists

			taskutil.userstate.persons_5b = game.interface.getEntity(game.interface.getEntity(game.interface.getEntity(params["airfield_" .. city]).stations[1]).stationGroup).itemsLoaded.PASSENGERS or 0
		end,
		onUpdate = function(self)
			local city = taskutil.userstate.city5

			if (taskutil.userstate.city5 == "lemans") then
				local workshop = params["workshop_" .. city]
				local stations = game.interface.getEntities({pos = game.interface.getEntity(workshop).position, radius = 200}, {type = "STATION"})
				local specialists = 0 - taskutil.userstate.specialists5b
				for j = 1, #stations do
					local s = game.interface.getEntity(game.interface.getEntity(stations[j]).stationGroup).itemsUnloaded.PASSENGERS or 0
					specialists = specialists + s
				end

				local goal = params["specialists_lemans"]
				self:setProgressCount(specialists, goal, 1)
				if specialists >= goal then
					self:finish()
				end
			end

			if (taskutil.userstate.city5 == "reims") then
				local persons = (game.interface.getEntity(game.interface.getEntity(game.interface.getEntity(params["airfield_" .. city]).stations[1]).stationGroup).itemsLoaded.PASSENGERS or 0) - taskutil.userstate.persons_5b
				local goal = params["people_lemans"]
				self:setProgressCount(persons, goal, 1)
				if persons >= goal then
					self:finish()
				end
			end

			if (taskutil.userstate.city5 == "paris") then
				local workshop = params["workshop_" .. city]
				local consumed = game.interface.getEntity(game.interface.getEntity(workshop).simBuildings[1]).itemsConsumed
				local p = consumed.PLANE_PARTS or 0

				local goal = params["parts_paris"]
				self:setProgressCount(p, goal, 1)
				if p >= goal then
					self:finish()
				end
			end

		end,
		onFinish = function(self)
			taskutil.tasks["5e"]:start()
		end,
		getInfo = function(self)
			local name
			local text
			local task
			local voiceOver
			local camera
			local subtask
			if (taskutil.userstate.city5 == "lemans") then
				name = _("MISSION_MACHINES_TASK_LONDON_ARMY_NAME")
				text = _("MISSION_MACHINES_TASK_LONDON_ARMY_TEXT")
				task = _("MISSION_MACHINES_TASK_LONDON_ARMY_TASK")
				subtask =  _("MISSION_MACHINES_TASK_LONDON_ARMY_SUB1")
				voiceOver = "MISSION_MACHINES_TASK_LONDON_ARMY_TEXT.wav"
				camera = params.jump_workshop_lemans
			end
			if (taskutil.userstate.city5 == "reims") then
				name = _("MISSION_MACHINES_TASK_LONDON_SCHOOL_NAME")
				text = _("MISSION_MACHINES_TASK_LONDON_SCHOOL_TEXT")
				task = _("MISSION_MACHINES_TASK_LONDON_SCHOOL_TASK")
				subtask = _("MISSION_MACHINES_TASK_LONDON_SCHOOL_SUB1")
				voiceOver = "MISSION_MACHINES_TASK_LONDON_SCHOOL_TEXT.wav"
				camera = params.jump_airfield_reims
			end
			if (taskutil.userstate.city5 == "paris") then
				name = _("MISSION_MACHINES_TASK_LONDON_ACROBATICS_NAME")
				text = _("MISSION_MACHINES_TASK_LONDON_ACROBATICS_TEXT")
				task = _("MISSION_MACHINES_TASK_LONDON_ACROBATICS_TASK")
				subtask = _("MISSION_MACHINES_TASK_LONDON_ACROBATICS_SUB1")
				voiceOver = "MISSION_MACHINES_TASK_LONDON_ACROBATICS_TEXT.wav"
				camera = params.jump_workshop_paris
			end
			return {
				name = name,
				paragraphs = {
					{ text = text % params },
					{ type = "TASK", text = task % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = subtask % params },
				},
				camera = camera,
				parentId = "5",
				voiceOver = voiceOver,
			}
		end,
	})

	taskutil:new("5e", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", 2)
			util.activateAirfield(params.airfield_paris)
			util.activateAirfield(params.airfield_london)
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getVehicles({ carrier = "AIR" })
			local data = taskutil.userstate.planedata
			local stopid1 = game.interface.getEntity(game.interface.getEntity(params.airfield_paris).stations[1]).stationGroup
			local stopid2 = game.interface.getEntity(game.interface.getEntity(params.airfield_london).stations[1]).stationGroup

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
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_LONDON_FLIGHT_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_LONDON_FLIGHT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_LONDON_FLIGHT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = { params.pos_london[1], params.pos_london[2], 500 },
				subTasks = {
					{ name = _("MISSION_MACHINES_TASK_LONDON_FLIGHT_OPTION1") }, --Flugzeug einer Linie zuweisen
					{ name = _("MISSION_MACHINES_TASK_LONDON_FLIGHT_OPTION2") }, --Landen
				},
				parentId = "5",
				voiceOver = "MISSION_MACHINES_TASK_LONDON_FLIGHT_TEXT.wav",
			}
		end,
	})

	taskutil:new("end", {
		onStart = function(self)
			util.activateAirfield(params.airfield_paris)
			util.activateAirfield(params.airfield_lemans)
			util.activateAirfield(params.airfield_reims)
			util.activateAirfield(params.airfield_calais)
			util.activateAirfield(params.airfield_dover)
			util.activateAirfield(params.airfield_london)
			vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", nil)
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
				name = _("MISSION_MACHINES_TASK_FINISH_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_FINISH_TEXT") % params },
				},
				parentId = "5",
				voiceOver = "MISSION_MACHINES_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
