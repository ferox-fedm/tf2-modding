local proposalutil = require "mission.proposalutil"
local params = require "params"
local polygonutil = require "polygonutil"
local transf = require "transf"
local vec2 = require "vec2"
local vec3 = require "vec3"
local util = require "util"
local colors = require "mission.colors"
local guidesystem = require "guidesystem"
local vehiclestore = require "mission.vehiclestore"
local arrivaltracker = require "mission.arrivaltracker"
local outline = require "mission.outline"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("5", {
		onStart = function(self)
			taskutil:setMusicTrack("track5")
			self:setProgressNone()
		end,
		onFinish = function()
			taskutil.tasks["5a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_OUTSIDE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_OUTSIDE_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_carsonCity,
				voiceOver = "MISSION_SILVERCITY_TASK_OUTSIDE_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	local angle5a = math.pi * 0.15
	taskutil:new("5a", {
		onStart = function(self)
			local poly = polygonutil.transform(transf.rotZTransl(angle5a, vec3.new(params.railStationCarsonCityZone.pos[1], params.railStationCarsonCityZone.pos[2], 0)), outline.railStationHeadOutline())
			taskutil:setZone("green", { polygon = poly, draw = true, drawColor = colors.GREEN })

			taskutil:setZone("blue", { polygon = params.buildingArea5a, draw = true, drawColor = colors.BLUE })

			taskutil:setProposal("p5b1", self.name, "checkProposal1")
			taskutil:setProposal("p5b2", self.name, "checkProposal2")

			taskutil:setEnabled("menu.bulldozer", true)

			taskutil:setEnabled("menu.construction.railmenu", true)
			taskutil:setVisibleAndEnabled("menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_1", true)
			
			taskutil.userstate.guidesystemkeys["guides_camera"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			local stationsC = game.interface.getEntities(params.railStationCarsonCityZone, {type = "STATION"})
			local stationsR = game.interface.getEntities(params.railStationRenoZone, {type = "STATION"})

			for c = 1, #stationsC do
				local sc = game.interface.getEntity(stationsC[c])
				if sc.cargo == false and sc.carriers["RAIL"] then
					for r = 1, #stationsR do
						local sr = game.interface.getEntity(stationsR[r])
						if sr.cargo == false and sr.carriers["RAIL"] and game.interface.findPath(stationsC[c], stationsR[r], { TRAIN = true }) then
							self:finish()
						end
					end
				end
			end
		end,
		onFinish = function()
			taskutil:setZone("green")
			taskutil:setZone("blue")
			taskutil:setProposal("p5b1")
			taskutil:setProposal("p5b2")
			taskutil.tasks["5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_OUTSIDE_CONNECT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_OUTSIDE_CONNECT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_OUTSIDE_CONNECT_TASK") % params },
					{ type = "HINT", text = _("MISSION_SILVERCITY_TASK_OUTSIDE_CONNECT_HINT") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "5",
				camera = { 0.5 * (params.jump_railStationCarsonCityZone[1] + params.jump_reno[1]),
				           0.5 * (params.jump_railStationCarsonCityZone[2] + params.jump_reno[2]), 2000 },
				voiceOver = "MISSION_SILVERCITY_TASK_OUTSIDE_CONNECT_TEXT.wav",
			}
		end,
		handlers = {
			removezone = function(self)
				taskutil:setZone("green")
				taskutil:setProposal("p5b1")
			end,
		},
		guiHandlers = {
			checkProposal1 = function(self, id, name, param, isApply)
				if id == "bulldozer" then --allow carson city street depot to be razed if it's interfering with rail station
					local removed = param.proposal.toRemove
					if #removed ~= 1 then return false end
					local e = game.interface.getEntity(removed[1])
					if e == nil then return false end
					if #(e.depots or {}) ~= 1 then return false end
					if e.transf == nil then return false end
					local p = params.railStationCarsonCityZone.pos
					if not proposalutil.closeEnough(e.transf, vec2.new(p[1], p[2]), 300) then return false end
					return true
				end
				if id ~= "constructionBuilder" then return false end
				local con = param.proposal.toAdd[1]

				local function closeEnough(dist)
					return proposalutil.closeEnough(con.transf, vec2.new(params.railStationCarsonCityZone.pos[1], params.railStationCarsonCityZone.pos[2]), dist)
				end

				if con.fileName ~= "station/rail/modular_station/modular_station.con" or util.hasCargoplatform(param.proposal.toAdd[1]) then
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_A_CARGO_TRAIN_PASSENGER_HEAD_STATION")
				end

				if not closeEnough(250) then
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_IN_OUTLINED_AREA")
				end

				if con.params.length ~= 1 then
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_X_METER_TRACKS") % { x = 120 }
				end

				local goalAngle = angle5a
				local angle = math.atan2(con.transf[2], con.transf[1])
				local diff = proposalutil.anglediff(angle, goalAngle)
				if diff > 0.9 * math.pi then
					return _("MISSION_PROPOSAL_FEEDBACK_POINT_TO_OTHER_DIRECTION")
				elseif diff > math.pi / 18 then
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_ALIGNED_TO_OUTLINE")
				end
				if not closeEnough(25) then
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_IN_OUTLINED_AREA")
				end

				local personEdges = param.data.tpNetLinkProposal.toAdd
				for i = 1,#personEdges do
					local link = personEdges[i].link
					if link.to.edgeId.entity >= 0 then
						if isApply then
							taskutil:sendScriptFn(self.name, "removezone")
						end
						return true
					end
				end
				return _("MISSION_PROPOSAL_FEEDBACK_NOT_CONNECTED_TO_STREET")
			end,
			checkProposal2 = function(self, id, name, param)
				return proposalutil.checkTrackBuildOrBulldozeInArea(params.buildingArea5a)(id, name, param)
			end,
		}
	})

	local getVehicle5b = function()
		local vehicles = game.interface.getVehicles({ carrier = "RAIL" })

		local result = {}
		for i = 1, #vehicles do
			local count = {}
			local vehicle = game.interface.getEntity(vehicles[i])
			for j = 1, #vehicle.vehicles do
				local wagon = vehicle.vehicles[j]
				count[wagon.fileName] = 1 + (count[wagon.fileName] or 0)
			end
			local t = params.modelNames.trainName
			local tc = count[t] or 0
			local w = params.modelNames.passengerWagonName
			local wc = count[w] or 0
			if tc > 0 and wc >= params.numberofpassengerwagons then
				result[#result +1] = vehicle
			end
		end
		return result
	end

	taskutil:new("5b", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount(params.modelNames.trainName, nil)
			vehiclestore.setAllowedVehicleCount(params.modelNames.passengerWagonName, nil)
			vehiclestore.setAllowedVehicleCount(params.modelNames.cargoWagonName, nil)

			taskutil:setEnabled("menu.construction.roadmenu", true)
			taskutil:setEnabled("menu.construction.road.streets", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.upgradeButton", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.depot/road_depot_era_a.con", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.station/bus/small_old.mdl", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.station/road/small_cargo.mdl", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.station/street/modular_terminal.con_0", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.depot", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.passenger", true)
			taskutil:disableProposalCheck()
		end,
		onUpdate = function(self)
			if getVehicle5b()[1] ~= nil then self:finish() end
		end,
		onFinish = function()
			taskutil.tasks["5c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_OUTSIDE_TRAIN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_OUTSIDE_TRAIN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_OUTSIDE_TRAIN_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "5",
				camera = { 0.5 * (params.jump_railStationCarsonCityZone[1] + params.jump_reno[1]),
				           0.5 * (params.jump_railStationCarsonCityZone[2] + params.jump_reno[2]), 2000 },
				voiceOver = "MISSION_SILVERCITY_TASK_OUTSIDE_TRAIN_TEXT.wav",
			}
		end,
	})

	taskutil:new("5c", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showponderosa", 60)
		end,
		onUpdate = function(self)
			local lines = util.getAllLineBetweenZones(params.railStationCarsonCityZone, params.railStationRenoZone)
			local vehicles = getVehicle5b()
			for i = 1, #vehicles do
				for j = 1, #lines do
					if vehicles[i].line == lines[j] then
						self:finish()
						return
					end
				end
			end
		end,
		onFinish = function()
			taskutil.tasks["5d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_OUTSIDE_LINE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_OUTSIDE_LINE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_OUTSIDE_LINE_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "5",
				camera = { 0.5 * (params.jump_railStationCarsonCityZone[1] + params.jump_reno[1]),
				           0.5 * (params.jump_railStationCarsonCityZone[2] + params.jump_reno[2]), 2000 },
				voiceOver = "MISSION_SILVERCITY_TASK_OUTSIDE_LINE_TEXT.wav",
			}
		end,
		handlers = {
			showponderosa = function(self)
				if taskutil.tasks["m1"].start ~= nil then
					taskutil.tasks["m1"]:start()
				end
			end,
		},
	})

	taskutil:new("5d", {
		onStart = function(self)
			self:setProgressCount(0, params.numberofpassengers, 1)
			self:setProgressCount(0, params.numberofpassengers, 2)
			arrivaltracker.track("5d1", { cargotype = "PASSENGERS", to   = params.carsonCity, from = params.reno })
			arrivaltracker.track("5d2", { cargotype = "PASSENGERS", from = params.carsonCity,   to = params.reno })
		end,
		onUpdate = function(self)
			local c1 = arrivaltracker.get("5d1")
			local c2 = arrivaltracker.get("5d2")

			local done1 = c1 >= params.numberofpassengers
			local done2 = c2 >= params.numberofpassengers

			if done1 then self:setSubtaskCompleted(1) end
			if done2 then self:setSubtaskCompleted(2) end

			self:setProgressCount(c1, params.numberofpassengers, 1)
			self:setProgressCount(c2, params.numberofpassengers, 2)

			if done1 and done2 then
				self:finish()
			end
		end,
		onFinish = function()
			arrivaltracker.track("5d1")
			arrivaltracker.track("5d2")
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_OUTSIDE_TRANSPORT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_OUTSIDE_TRANSPORT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_OUTSIDE_TRANSPORT_TASK") % params, },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				subTasks = {
					{ name = _("MISSION_SILVERCITY_TASK_OUTSIDE_TRANSPORT_SUB1") % params },
					{ name = _("MISSION_SILVERCITY_TASK_OUTSIDE_TRANSPORT_SUB2") % params },
				},
				parentId = "5",
				camera = { 0.5 * (params.jump_railStationCarsonCityZone[1] + params.jump_reno[1]),
				           0.5 * (params.jump_railStationCarsonCityZone[2] + params.jump_reno[2]), 2000 },
				voiceOver = "MISSION_SILVERCITY_TASK_OUTSIDE_TRANSPORT_TEXT.wav",
			}
		end,
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
				name = _("MISSION_SILVERCITY_TASK_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_FINISH_TEXT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				voiceOver = "MISSION_SILVERCITY_TASK_FINISH_TEXT.wav",
			}
		end,
	})

end
