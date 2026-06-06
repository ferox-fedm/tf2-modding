local params = require "params"
local transf = require "transf"
local vec3 = require "vec3"
local polygonutil = require "polygonutil"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"
local vehiclestore = require "mission.vehiclestore"
local proposalutil = require "mission.proposalutil"
local guidesystem = require "guidesystem"

return function(taskutil)
	local tasks = taskutil.tasks

	local mainguihandlers = {
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
			self:setProgressNone()
			for k, v in pairs(params.modelnames) do
				vehiclestore.setAllowedVehicleCount(v, 0)
			end

			taskutil:setEnabled("menu.construction.watermenu", false)
			taskutil:setEnabled("menu.construction.roadmenu", false)

			taskutil:setEnabled("menu.layers.watersButton", false)
			taskutil:setEnabled("menu.layers.speedLimitsButton", false)
			taskutil:setEnabled("menu.layers.stationsButton", false)
			taskutil:setEnabled("menu.layers.destinationButton", false)
			taskutil:setEnabled("menu.layers.cargoButton", false)
			taskutil:setEnabled("menu.layers.trafficLayerButton", false)
			taskutil:setEnabled("menu.layers.emissionLayerButton", false)

			taskutil:enableProposalCheck()
			taskutil:setProposalCheckWhitelist()
		end,
		onFinish = function(self)
			taskutil.tasks["1x"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_COFFEE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_COFFEE_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_coffee_processing,
				voiceOver = "MISSION_COLONIALISM_TASK_COFFEE_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1x", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_contours"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_contours"] = nil
			taskutil:invokeLater("1a", "start", 8)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_COFFEE_LAYER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_COFFEE_LAYER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_COFFEE_LAYER_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = { params.jump_buildingarea_processing_center[1], params.jump_buildingarea_processing_center[2], 500},
				voiceOver = "MISSION_COLONIALISM_TASK_COFFEE_LAYER_TEXT.wav",
			}
		end,
		guiHandlers = {
			guiHandleEvent = function(self, id, name, param)
				if id == "menu.layers.contoursButton" and name == "toggleButton.toggle" and param == true then
					if self.finish ~= nil then self:finish() end
				end
			end,
		},
	})

	taskutil:new("1a", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_railstation"] = guidesystem.getTime()
			taskutil.userstate.guidesystemkeys["guides_track"] = guidesystem.getTime()
			taskutil:setZone("blue2", { polygon = params.buildingArea1a_processing, draw = true, drawColor = colors.BLUE })
			taskutil:setProposal("p1a1_tracks", self.name, "checkProposalTracks")
			taskutil:setProposal("p1a2_depots", self.name, "checkProposalDepots")
			taskutil:setProposal("p1a3_streetconnectivity", self.name, "checkProposalStreetConnectivity")
			taskutil:setProposal("p1a4_streetbulldoze", self.name, "checkProposalStreetBulldoze")
		end,
		onUpdate = function(self)
			local pos1 = params.pos_coffee_farm
			local stations1 = game.interface.getEntities({pos = pos1, radius = 500}, {type = "STATION"})

			local pos2 = params.pos_coffee_processing
			local stations2 = game.interface.getEntities({pos = pos2, radius = 500}, {type = "STATION"})
			for i = 1, #stations1 do
				if game.interface.getEntity(stations1[i]).cargo then
					for j = 1, #stations2 do
						if game.interface.getEntity(stations2[j]).cargo then
							local path = game.interface.findPath(stations1[i], stations2[j], { TRAIN = true })
							if path ~= nil then
								self:finish()
								return
							end
						end
					end
				end
			end
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_railstation"] = nil
			taskutil.userstate.guidesystemkeys["guides_track"] = nil
			taskutil:setEnabled("menu.construction.rail.stations.passenger", true)
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_COFFEE_FARMS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_COFFEE_FARMS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_COFFEE_FARMS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = { params.jump_buildingarea_processing_center[1], params.jump_buildingarea_processing_center[2], 500},
				voiceOver = "MISSION_COLONIALISM_TASK_COFFEE_FARMS_TEXT.wav",
			}
		end,
		guiHandlers = {
			checkProposalTracks = function(self, id, name, param)
				return proposalutil.checkTrackBuildOrBulldozeInArea(params.buildingArea1a_processing)(id, name, param)
			end,
			checkProposalDepots = function(self, id, name, param, isApply)
				if id == "constructionBuilder" then
					if param.proposal.toAdd[1].fileName == "depot/train_depot_era_a.con"  then
						local trf = param.proposal.toAdd[1].transf
						if polygonutil.contains(params.buildingArea1a_processing, { trf[13], trf[14] }) then
							return true
						end
						return _("MISSION_PROPOSAL_FEEDBACK_NOT_IN_OUTLINED_AREA")
					end
				end
			end,
			checkProposalStreetConnectivity = function(self, id, name, param, isApply)
				if id == "constructionBuilder" then
					local filename = param.proposal.toAdd[1].fileName

					local con = param.proposal.toAdd[1]
					if con and con.fileName == "station/rail/modular_station/modular_station.con" and not con.hasCargoPlatform then
						return _("MISSION_PROPOSAL_FEEDBACK_NOT_A_CARGO_TRAIN_CARGO_HEAD_STATION")
					end

					if filename ~= "depot/train_depot_era_a.con"  then
						--check street connectivity
						local nodes = proposalutil.segments2nodes(param.proposal.proposal.addedSegments, param.proposal.proposal.addedNodes)
						if next(nodes) ~= nil then
							for k, _ in pairs(nodes) do
								if k >= 0 then
									return true
								end
							end
						end

						if filename:match("station/street") == nil and filename:match("depot/road") == nil then
							local streetcon = false
							local personEdges = param.data.tpNetLinkProposal.toAdd
							for i = 1, #personEdges do
								local link = personEdges[i].link
								if link.to.edgeId.entity >= 0 then
									return true
								end
							end
						end
						return _("MISSION_PROPOSAL_FEEDBACK_NOT_CONNECTED_TO_STREET")
					end
				end
			end,
			checkProposalStreetBulldoze = function(self, id, name, param, isApply)
				if id ~= "bulldozer" then return false end

				if #param.proposal.toRemove == 0 then
					--skip track bulldozing
					local rs = param.proposal.proposal.removedSegments
					for i = 1, #rs do
						if rs[i].type == 1 then return false end
					end
				end

				return true
			end,
		},
	})

	taskutil:new("1b", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_depot_rail"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			local cons = game.interface.getEntities({ radius = 1e100 }, { type = "CONSTRUCTION" })
			local depots = {} --needs construction entity (for pathfinding)
			for i = 1, #cons do
				if #(game.interface.getEntity(cons[i]).depots or {}) > 0 then depots[#depots + 1] = cons[i] end
			end

			local pos1 = params.pos_coffee_farm
			local stations1 = game.interface.getEntities({pos = pos1, radius = 500}, {type = "STATION"})
			local pos2 = params.pos_coffee_processing
			local stations2 = game.interface.getEntities({pos = pos2, radius = 500}, {type = "STATION"})

			for k = 1, #depots do
				for i = 1, #stations1 do
					if game.interface.getEntity(stations1[i]).cargo then
						for j = 1, #stations2 do
							if game.interface.getEntity(stations2[j]).cargo then
								local path = game.interface.findPath(stations1[i], stations2[j], { TRAIN = true })
								if path ~= nil then
									local path2 = game.interface.findPath(depots[k], stations1[i], { TRAIN = true })
									local path3 = game.interface.findPath(depots[k], stations2[j], { TRAIN = true })
									if path2 or path3 then
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
			taskutil.userstate.guidesystemkeys["guides_depot_rail"] = nil
			taskutil:setZone("blue")
			taskutil:setZone("blue2")
			taskutil.tasks["1c"]:start()
		end,
		onGuiFinish = function(self)
			game.gui.stopAction()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_COFFEE_DEPOT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_COFFEE_DEPOT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_COFFEE_DEPOT_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = { params.jump_buildingarea_processing_center[1], params.jump_buildingarea_processing_center[2], 500},
				voiceOver = "MISSION_COLONIALISM_TASK_COFFEE_DEPOT_TEXT.wav",
			}
		end,
	})

	taskutil:new("1c", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount(params.modelnames.train1, 1)
			vehiclestore.setAllowedVehicleCount(params.modelnames.train2, 1)
			vehiclestore.setAllowedVehicleCount(params.modelnames.train3, 1)
			vehiclestore.setAllowedVehicleCount(params.modelnames.goodswagon, params.num_wagons)
			vehiclestore.setAllowedVehicleCount(params.modelnames.passengerwagon, 0)
		end,
		onUpdate = function(self)
			local v = vehiclestore.currentvehicles
			if (v[params.modelnames.train1] or 0) + (v[params.modelnames.train2] or 0) + (v[params.modelnames.train3] or 0) > 0
					and (v[params.modelnames.goodswagon] or 0) >= params.num_wagons then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["1d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_COFFEE_TRAIN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_COFFEE_TRAIN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_COFFEE_TRAIN_TASK") %  params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_buildingarea_processing_center,
				voiceOver = "MISSION_COLONIALISM_TASK_COFFEE_TRAIN_TEXT.wav",
			}
		end,
	})

	taskutil:new("1d", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_lines"] = guidesystem.getTime()
			taskutil.userstate.guidesystemkeys["guides_gamespeed"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			local e = game.interface.getEntity(game.interface.getEntity(params.coffee_processing).simBuildings[1])

			local processed = e.itemsConsumed.COFFEE or 0
			if processed >= params.coffee_amount_1c then
				self:finish()
			end

		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_lines"] = nil
			taskutil.userstate.guidesystemkeys["guides_gamespeed"] = nil
			vehiclestore.setAllowedVehicleCount(params.modelnames.train1, nil)
			vehiclestore.setAllowedVehicleCount(params.modelnames.train2, nil)
			vehiclestore.setAllowedVehicleCount(params.modelnames.train3, nil)
			vehiclestore.setAllowedVehicleCount(params.modelnames.goodswagon, nil)
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_COFFEE_DELIVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_COFFEE_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_COFFEE_DELIVER_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = { params.jump_buildingarea_processing_center[1], params.jump_buildingarea_processing_center[2], 500},
				voiceOver = "MISSION_COLONIALISM_TASK_COFFEE_DELIVER_TEXT.wav",
			}
		end,
	})
end
