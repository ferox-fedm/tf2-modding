local params = require "params"
local util = require "util"
local vehiclestore = require "mission.vehiclestore"
local arrivaltracker = require "mission.arrivaltracker"
local guidesystem = require "guidesystem"
local guides = require "guides"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"
local vec2 = require "vec2"
local proposalutil = require "mission.proposalutil"

local function getPassengerBusStations(town)
	local function distance(pos0, pos1)
		return vec2.distance(vec2.new(table.unpack(pos0)), vec2.new(table.unpack(pos1)))
	end

	local stations = game.interface.getStations({ town = town, carrier = "ROAD" })
	local passengerstations = {}
	for j = 1, 3 do
		local zone = params["busStationCarsonCityZone" .. j]
		local success = false
		for i = 1, #stations do
			local e = game.interface.getEntity(stations[i])
			if e.cargo == false then
				if distance(e.position, zone.pos) < 2 * zone.radius then
					success = stations[i]
					break
				end
			end
		end
		if success ~= false then
			passengerstations[#passengerstations + 1] = success
		else
			passengerstations[#passengerstations + 1] = -1
		end
	end
	return passengerstations
end

local createBusStationTask = function(taskutil)
	taskutil:new("4b", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_busstop"] = guidesystem.getTime()
			taskutil:setEnabled("menu.construction.roadmenu", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.passenger", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.station/street/modular_terminal.con_0", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.station/bus/small_old.mdl", true)
			taskutil:setZone("green",  { polygon = zoneutil.makeCircleZone(params.busStationCarsonCityZone1.pos, params.busStationCarsonCityZone1.radius), draw = true, drawColor = colors.GREEN })
			taskutil:setZone("blue",   { polygon = zoneutil.makeCircleZone(params.busStationCarsonCityZone2.pos, params.busStationCarsonCityZone2.radius), draw = true, drawColor = colors.BLUE })
			taskutil:setZone("yellow", { polygon = zoneutil.makeCircleZone(params.busStationCarsonCityZone3.pos, params.busStationCarsonCityZone3.radius), draw = true, drawColor = colors.YELLOW })
			taskutil:setProposal("p4b", self.name, "checkProposal")
		end,
		onUpdate = function(self)
			local stations = getPassengerBusStations(params.carsonCity)

			for j = 1, 3 do
				self:setSubtaskCompleted(j, stations[j] >= 0)
			end

			if stations[1] >= 0 and stations[2] >= 0 and stations[3] >= 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_busstop"] = nil
			taskutil:setEnabled("menu.construction.roadmenu", false)
			taskutil:setProposal("p4b")
			taskutil.tasks["4c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_TOWN_STATION_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_TOWN_STATION_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_TOWN_STATION_TASK") % params },
					{ type = "HINT", text = _("MISSION_SILVERCITY_TASK_TOWN_STATION_HINT") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "4",
				subTasks = {
					{ name = _("MISSION_SILVERCITY_TASK_TOWN_STATION_SUB1") % params },
					{ name = _("MISSION_SILVERCITY_TASK_TOWN_STATION_SUB2") % params },
					{ name = _("MISSION_SILVERCITY_TASK_TOWN_STATION_SUB3") % params },
				},
				camera = params.jump_carsonCity,
				voiceOver = "MISSION_SILVERCITY_TASK_TOWN_STATION_TEXT.wav",
			}
		end,
		guiHandlers = {
			checkProposal = function(self, id, name, param, isApply)
				return id == "streetTerminalBuilder"
			end,
		},
	})
end

local createLineTask = function(taskutil)
	taskutil:new("4c", {
		onStart = function(self)
			guides.restart(guidesystem.addGuiGuideCreateLine, "createLine")
			taskutil.userstate.guidesystemkeys["guides_lines"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			local function progresscount(progress)
				local count = 0
				for j = 1, #progress do
					if progress[j] then count = count + 1 end
				end
				return count
			end

			local stations = getPassengerBusStations(params.carsonCity)
			for i = 1, #stations do
				if stations[i] < 0 then return end --last task was skipped
				stations[i] = game.interface.getEntity(stations[i]).stationGroup
			end
			local n = #stations

			local progress = { false, false, false }
			local lines = {}
			for j = 1, n do
				local morelines = game.interface.getLines({ stationGroup = stations[j] })
				for k = 1, #morelines do
					lines[morelines[k]] = 1
				end
			end
			for id, _ in pairs(lines) do
				local l = game.interface.getEntity(id)
				local lprogress = { false, false, false }
				for k = 1, n do
					for j = 1, #l.stops do
						if l.stops[j] == stations[k] then lprogress[k] = true break end
					end
				end
				local count = progresscount(lprogress)
				if count > progresscount(progress) then
					progress = lprogress
				end
			end

			for j = 1, n do
				self:setSubtaskCompleted(j, progress[j])
			end
			if progresscount(progress) == n then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("green")
			taskutil:setZone("yellow")
			taskutil:setZone("blue")
			taskutil.userstate.guidesystemkeys["guides_lines"] = nil
			taskutil.tasks["4d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_TOWN_LINE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_TOWN_LINE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_TOWN_LINE_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "4",
				camera = params.jump_carsonCity,
				voiceOver = "MISSION_SILVERCITY_TASK_TOWN_LINE_TEXT.wav",
				subTasks = {
					{ name = _("MISSION_SILVERCITY_TASK_TOWN_LINE_SUB1") % params },
					{ name = _("MISSION_SILVERCITY_TASK_TOWN_LINE_SUB2") % params },
					{ name = _("MISSION_SILVERCITY_TASK_TOWN_LINE_SUB3") % params },
				},
			}
		end,
	})
end

local buildDepotTask = function(taskutil)
	taskutil:new("4d", {
		onStart = function(self)
			taskutil:setEnabled("menu.construction.roadmenu", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.depot", true)
			taskutil:setProposal("p4d", self.name, "checkProposal")
			guides.restart(guidesystem.addConFileGuideBuildBusDepot, "buildBusDepot")
			taskutil.userstate.guidesystemkeys["guides_depot"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setVisibleAndEnabled("menu.construction.road.depot", false)
			taskutil:setProposal("p4d")
			taskutil.userstate.guidesystemkeys["guides_depot"] = nil
			taskutil.tasks["4e"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_TOWN_DEPOT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_TOWN_DEPOT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_TOWN_DEPOT_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "4",
				camera = params.jump_carsonCity,
				voiceOver = "MISSION_SILVERCITY_TASK_TOWN_DEPOT_TEXT.wav",
			}
		end,
		guiHandlers = {
			checkProposal = function(self, id, name, param, isApply)
				if id ~= "constructionBuilder" then return false end
				local con = param.proposal.toAdd[1]
				if con.fileName ~= "depot/road_depot_era_a.con" then
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_A_ROAD_DEPOT")
				end

				local ccpos = game.interface.getEntity(params.carsonCity).position
				if not proposalutil.closeEnough(param.proposal.toAdd[1].transf, vec2.new(ccpos[1], ccpos[2]), 500) then
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_IN_TOWN_X") % { x = game.interface.getName(params.carsonCity) } 
				end

				local nodes = proposalutil.segments2nodes(param.proposal.proposal.addedSegments, param.proposal.proposal.addedNodes)
				for k, _ in pairs(nodes) do
					if k >= 0 then
						if isApply then taskutil:finish(self.name) end
						return true
					end
				end
				return _("MISSION_PROPOSAL_FEEDBACK_NOT_CONNECTED_TO_STREET")
			end,
		},
	})
end

local buyVehiclesTask = function(taskutil)
	taskutil:new("4e", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount(params.modelNames.busName, nil)
		end,
		onUpdate = function(self)
			local function progresscount(progress)
				local count = 0
				for j = 1, #progress do
					if progress[j] then count = count + 1 end
				end
				return count
			end

			local stations = getPassengerBusStations(params.carsonCity)
			for i = 1, #stations do
				if stations[i] < 0 then return end --tasks were skipped
				stations[i] = game.interface.getEntity(stations[i]).stationGroup
			end
			local n = #stations

			local vehiclecount = 0
			local lines = game.interface.getLines({ stationGroup = stations[1] })
			local vehicles = game.interface.getVehicles({ carrier = "ROAD" })
			for i = 1, #lines do
				local l = game.interface.getEntity(lines[i])
				local lprogress = { }
				for k = 1, n do
					for j = 1, #l.stops do
						if l.stops[j] == stations[k] then lprogress[k] = true break end
					end
				end
				if progresscount(lprogress) == n then
					local vcount = 0
					for v = 1, #vehicles do
						local vehicle = game.interface.getEntity(vehicles[v])
						if vehicle.line == lines[i] and ((vehicle.allCapacities.PASSENGERS or 0) > 0) then
							vcount = vcount + 1
						end
					end
					vehiclecount = math.max(vehiclecount, vcount)
					self:setProgressCount(vehiclecount, params.numberofhorsecarts)
					if vehiclecount >= params.numberofhorsecarts then
						self:finish()
						return
					end
				end
			end

		end,
		onFinish = function(self)
			taskutil.tasks["4f"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_TOWN_BUS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_TOWN_BUS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_TOWN_BUS_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "4",
				camera = params.jump_carsonCity,
				voiceOver = "MISSION_SILVERCITY_TASK_TOWN_BUS_TEXT.wav",
			}
		end,
	})
end

return function(taskutil)
	taskutil:new("4", {
		onStart = function(self)
			taskutil:setMusicTrack("track4")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["4a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_TOWN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_TOWN_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_carsonCity,
				voiceOver = "MISSION_SILVERCITY_TASK_TOWN_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4a", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_landuse"] = guidesystem.getTime()
			taskutil:setEnabled("menu.radialmenu", true);
			taskutil:setEnabled("menu.layersButton", true)
			taskutil:setEnabled("menu.layers.landuseButton", true)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_landuse"] = nil
			taskutil:invokeLater("4b", "start", 8)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_TOWN_LAYER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_TOWN_LAYER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_TOWN_LAYER_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "4",
				camera = params.jump_carsonCity,
				voiceOver = "MISSION_SILVERCITY_TASK_TOWN_LAYER_TEXT.wav",
			}
		end,
		guiHandlers = {
			guiHandleEvent = function(self, id, name, param)
				if id == "menu.layers.landuseButton" and name == "toggleButton.toggle" and param == true then
					if self.finish ~= nil then self:finish() end
				end
			end
		},
	})

	createBusStationTask(taskutil)
	createLineTask      (taskutil)
	buildDepotTask      (taskutil)
	buyVehiclesTask     (taskutil)

	taskutil:new("4f", {
		onStart = function(self)
			arrivaltracker.track("4f", { cargotype = "PASSENGERS", from = params.carsonCity, to = params.carsonCity })
			taskutil:invokeLater(self.name, "showbigfoot", 60)
		end,
		onUpdate = function(self)
			local c = arrivaltracker.get("4f")
			local goal = params.numberofpassengerscarsoncity
			self:setProgressCount(c, goal)

			if c >= goal then
				self:finish()
			end
			self:setProgressCount(c, goal)
		end,
		onFinish = function(self)
			arrivaltracker.track("4f")
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_TOWN_TRANSPORT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_TOWN_TRANSPORT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_TOWN_TRANSPORT_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "4",
				camera = params.jump_carsonCity,
				voiceOver = "MISSION_SILVERCITY_TASK_TOWN_TRANSPORT_TEXT.wav",
			}
		end,
		handlers = {
			showbigfoot = function(self)
				if taskutil.tasks["m3"].start ~= nil then
					taskutil.tasks["m3"]:start()
				end
			end,
		},
	})
end
