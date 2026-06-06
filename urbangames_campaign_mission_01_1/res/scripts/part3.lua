local proposalutil = require "mission.proposalutil"
local params = require "params"
local polygonutil = require "polygonutil"
local transf = require "transf"
local vec2 = require "vec2"
local vec3 = require "vec3"
local util = require "util"
local colors = require "mission.colors"
local guidesystem = require "guidesystem"
local apputil = require "apputil"
local guides = require "guides"
local arrivaltracker = require "mission.arrivaltracker"
local zoneutil = require "mission.zone"
local vehiclestore = require "mission.vehiclestore"
local outline = require "mission.outline"

local getClassicOrCouch = apputil.getClassicOrCouch
local getMouseOrGamepad = apputil.getMouseOrGamepad

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("3", {
		onStart = function(self)
			taskutil:setMusicTrack("track3")
			self:setProgressNone()
		end,
		onFinish = function()
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_CARGO_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_CARGO_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_silverOreMine,
				voiceOver = "MISSION_SILVERCITY_TASK_CARGO_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3x", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onGuiFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_CARGO_SELLMINE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_CARGO_SELLMINE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_CARGO_SELLMINE_TASK") % params } 
				},
				options = { { _("MISSION_SILVERCITY_TASK_CARGO_SELLMINE_OPTION") % params, "finish" } },
				optionsRightAlign = true,
				parentId = "3",
				camera = params.jump_silverOreMine,
				voiceOver = "MISSION_SILVERCITY_TASK_CARGO_SELLMINE_TEXT.wav",
			}
		end,
	})

	taskutil:new("3a", {
		onStart = function(self)
			taskutil:setProposal("p3a", self.name, "checkProposal")
			local poly = polygonutil.transform(transf.rotZTransl(math.pi, vec3.new(params.railStationMineZone.pos[1], params.railStationMineZone.pos[2], 0)), outline.railStationHeadOutline())
			taskutil:setZone("blue", { polygon = poly, draw = true, drawColor = colors.BLUE })
			taskutil.userstate.guidesystemkeys["guides_railstation"] = guidesystem.getTime()
			taskutil:setEnabled("menu.construction.railmenu", true)
		end,
		onGuiStart = function(self)
			game.gui.setConstructionAngle(math.pi * 0.9)
		end,
		onFinish = function()
			taskutil:setProposal("p3a")
			taskutil:setZone("blue")
			taskutil.userstate.guidesystemkeys["guides_railstation"] = nil
			taskutil:setEnabled("menu.construction.railmenu", false)
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_CARGO_STATION_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_CARGO_STATION_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_CARGO_STATION_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "3",
				camera = params.jump_railStationMineZone,
				voiceOver = "MISSION_SILVERCITY_TASK_CARGO_STATION_TEXT.wav",
			}
		end,
		handlers = {
			finishhelper = function(self, id)
				taskutil.userstate.railStationVirginia = id
				taskutil:finish(self.name)
			end,
		},
		guiHandlers = {
			checkProposal = function(self, id, name, param, isApply)
				if id ~= "constructionBuilder" then return false end
				local con = param.proposal.toAdd[1]
				if con.fileName == "station/rail/modular_station/modular_station.con" and util.hasCargoplatform(param.proposal.toAdd[1]) then
					if param.proposal.toAdd[1].params.length ~= 1 then
						return _("MISSION_PROPOSAL_FEEDBACK_NOT_X_METER_TRACKS") % { x = 120 }
					end

					local nodes = proposalutil.segments2nodes(param.proposal.proposal.addedSegments, param.proposal.proposal.addedNodes)
					if nodes[params.snapNode3a] ~= nil then
						if isApply then
							taskutil:sendScriptFn(self.name, "finishhelper", { param.result[1] })
						end
						return true
					else
						local ce = proposalutil.closeEnough(con.transf, vec2.new(params.railStationMineZone.pos[1], params.railStationMineZone.pos[2]), 75)
						if ce then
							return _("MISSION_PROPOSAL_FEEDBACK_NOT_CONNECTED_TO_TRACK")
						else
							return _("MISSION_PROPOSAL_FEEDBACK_NOT_IN_OUTLINED_AREA")
						end
					end
				else
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_A_CARGO_TRAIN_CARGO_HEAD_STATION")
				end
			end,
		},
	})

	local function jump_trackSnapNode()
		return { 1447, -170, 250 }
	end
	taskutil:new("3b", {
		onStart = function(self)
			taskutil:setProposal("p3b1", self.name, "checkProposal1")
			taskutil:setProposal("p3b2", self.name, "checkProposal2")
			taskutil:setProposal("p3b3", self.name, "checkProposal3")
			taskutil.userstate.tracks3b = 3
			taskutil:setEnabled("menu.construction.railmenu", true)
			taskutil.userstate.guidesystemkeys["guides_track"] = guidesystem.getTime()

			taskutil:setZone("prop1_c1", { polygon = zoneutil.makeCircleZone(params.snapNode3b_prop1_node1pos, 10), draw = true, drawColor = colors.BLUE })
			taskutil:setZone("prop1_c2", { polygon = zoneutil.makeCircleZone(params.snapNode3b_prop1_node2pos, 10), draw = true, drawColor = colors.BLUE })
			taskutil:setZone("prop2_c1", { polygon = zoneutil.makeCircleZone(params.snapNode3b_prop2_node1pos, 10), draw = true, drawColor = colors.GREEN })
			taskutil:setZone("prop2_c2", { polygon = zoneutil.makeCircleZone(params.snapNode3b_prop2_node2pos, 10), draw = true, drawColor = colors.GREEN })
			taskutil:setZone("prop3_c1", { polygon = zoneutil.makeCircleZone(params.snapNode3b_prop3_node1pos, 10), draw = true, drawColor = colors.YELLOW })
			taskutil:setZone("prop3_c2", { polygon = zoneutil.makeCircleZone(params.snapNode3b_prop3_node2pos, 10), draw = true, drawColor = colors.YELLOW })
		end,
		onUpdate = function(self)
			if taskutil.userstate.tracks3b == 0 then
				self:finish()
				taskutil.userstate.tracks3b = nil
			end
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_track"] = nil
			taskutil:setProposal("p3b1")
			taskutil:setProposal("p3b2")
			taskutil:setProposal("p3b3")
			taskutil:setEnabled("menu.construction.railmenu", false)
			taskutil:setZone("prop1_c1")
			taskutil:setZone("prop1_c2")
			taskutil:setZone("prop2_c1")
			taskutil:setZone("prop2_c2")
			taskutil:setZone("prop3_c1")
			taskutil:setZone("prop3_c2")
			taskutil.tasks["3c"]:start()
		end,
		onGuiFinish = function(self)
			game.gui.stopAction()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_CARGO_TRACKS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_CARGO_TRACKS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_CARGO_TRACKS_TASK") % params },
					{ type = "HINT", text = getMouseOrGamepad(_("MISSION_SILVERCITY_TASK_CARGO_TRACKS_HINT1"), _("MISSION_SILVERCITY_TASK_CARGO_TRACKS_HINT1_COUCH")) % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				subTasks = {
					{ name = _("MISSION_SILVERCITY_TASK_CARGO_TRACKS_SUB1") % params },
					{ name = _("MISSION_SILVERCITY_TASK_CARGO_TRACKS_SUB2") % params },
					{ name = _("MISSION_SILVERCITY_TASK_CARGO_TRACKS_SUB3") % params },
				},
				parentId = "3",
				camera = jump_trackSnapNode(),
				voiceOver = "MISSION_SILVERCITY_TASK_CARGO_TRACKS_TEXT.wav",
			}
		end,
		handlers = {
			finishhelper = function(self, id)
				if id == 1 then
					taskutil:setProposal("p3b1")
					taskutil.userstate.tracks3b = taskutil.userstate.tracks3b - 1
					taskutil:setZone("prop1_c1")
					taskutil:setZone("prop1_c2")
					self:setSubtaskCompleted(1)
				elseif id == 2 then
					taskutil:setProposal("p3b2")
					taskutil.userstate.tracks3b = taskutil.userstate.tracks3b - 1
					taskutil:setZone("prop2_c1")
					taskutil:setZone("prop2_c2")
					self:setSubtaskCompleted(2)
				elseif id == 3 then
					taskutil:setProposal("p3b3")
					taskutil.userstate.tracks3b = taskutil.userstate.tracks3b - 1
					taskutil:setZone("prop3_c1")
					taskutil:setZone("prop3_c2")
					self:setSubtaskCompleted(3)
				end
			end
		},
		guiHandlers = {
			checkProposal1 = function(self, id, name, param, isApply)
				if id ~= "trackBuilder" then return false end
				if #param.proposal.proposal.addedSegments == 0 then return true end
				local nodes = proposalutil.segments2nodes(param.proposal.proposal.addedSegments, param.proposal.proposal.addedNodes)
				local goal1 = nodes[params.snapNode3b_prop1[1]] ~= nil
				local goal2 = nodes[params.snapNode3b_prop1[2]] ~= nil
				if goal1 and goal2  then
					if isApply then
						taskutil:sendScriptFn(self.name, "finishhelper", { 1 })
					end
					return true
				elseif goal1 or goal2 then
					return _("MISSION_PROPOSAL_FEEDBACK_CONNECT_TO_OTHER_BLUE_CIRCLE"), 10
				else
					return _("MISSION_PROPOSAL_FEEDBACK_CONNECT_WITH_SAME_COLOR_CIRCLE")
				end
			end,
			checkProposal2 = function(self, id, name, param, isApply)
				if id ~= "trackBuilder" then return false end
				if #param.proposal.proposal.addedSegments == 0 then return true end
				local nodes = proposalutil.segments2nodes(param.proposal.proposal.addedSegments, param.proposal.proposal.addedNodes)
				local goal1 = nodes[params.snapNode3b_prop2[1]] ~= nil
				local goal2 = nodes[params.snapNode3b_prop2[2]] ~= nil
				if goal1 and goal2 then
					if isApply then
						taskutil:sendScriptFn(self.name, "finishhelper", { 2 })
					end
					return true
				elseif goal1 or goal2 then
					return _("MISSION_PROPOSAL_FEEDBACK_CONNECT_TO_OTHER_GREEN_CIRCLE"), 10
				else
					return _("MISSION_PROPOSAL_FEEDBACK_CONNECT_WITH_SAME_COLOR_CIRCLE")
				end
			end,
			checkProposal3 = function(self, id, name, param, isApply)
				if id ~= "trackBuilder" then return false end
				if #param.proposal.proposal.addedSegments == 0 then return true end
				local nodes = proposalutil.segments2nodes(param.proposal.proposal.addedSegments, param.proposal.proposal.addedNodes)
				local goal1 = nodes[params.snapNode3b_prop3[1]] ~= nil
				local goal2 = nodes[params.snapNode3b_prop3[2]] ~= nil
				if goal1 and goal2 then
					if isApply then
						taskutil:sendScriptFn(self.name, "finishhelper", { 3 })
					end
					return true
				elseif goal1 or goal2 then
					return _("MISSION_PROPOSAL_FEEDBACK_CONNECT_TO_OTHER_YELLOW_CIRCLE"), 10
				else
					return _("MISSION_PROPOSAL_FEEDBACK_CONNECT_WITH_SAME_COLOR_CIRCLE")
				end
			end,
		},
	})

	taskutil:new("3c", {
		onStart = function()
			guides.restart(guidesystem.addGuiGuideCreateLine, "createLine")
			taskutil.userstate.guidesystemkeys["guides_lines"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			local line = util.getLineBetweenZones(params.railStationMineZone, params.railStationSilverProcessingZone)
			if line ~= nil then
				self:finish()
			end
		end,
		onFinish = function()
			taskutil.userstate.guidesystemkeys["guides_lines"] = nil
			taskutil.tasks["3d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_CARGO_LINE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_CARGO_LINE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_CARGO_LINE_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "3",
				camera = { 0.5 * (params.jump_railStationMineZone[1] + params.jump_carsonCity[1]), 0.5 * (params.jump_railStationMineZone[2] + params.jump_carsonCity[2]), 1000 },
				voiceOver = "MISSION_SILVERCITY_TASK_CARGO_LINE_TEXT.wav",
			}
		end,
	})

	local goalAngle = -math.pi / 10
	taskutil:new("3d", {
		onStart = function(self)
			local poly = polygonutil.transform(transf.rotZTransl(goalAngle, vec3.new(params.trainDepotMineZone.pos[1], params.trainDepotMineZone.pos[2], 0)), outline.railDepotOutline())
			taskutil:setZone("blue", { polygon = poly, draw = true, drawColor = colors.BLUE })
			taskutil:setProposal("p3d", self.name, "checkProposal")
			taskutil:setEnabled("menu.construction.railmenu", true)
			taskutil.userstate.guidesystemkeys["guides_depot_rail"] = guidesystem.getTime()
		end,
		onUpdate = function(self)

		end,
		onFinish = function()
			taskutil:setZone("blue")
			taskutil:setProposal("p3d")
			taskutil:setEnabled("menu.construction.railmenu", false)
			taskutil.userstate.guidesystemkeys["guides_depot_rail"] = nil
			taskutil.tasks["3e"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_CARGO_DEPOT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_CARGO_DEPOT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_CARGO_DEPOT_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "3",
				camera = params.jump_trainDepotMineZone,
				voiceOver = "MISSION_SILVERCITY_TASK_CARGO_DEPOT_TEXT.wav",
			}
		end,
		handlers = {
			finishhelper = function(self, id)
				taskutil.userstate.depotRailVirginia = id
				taskutil:finish(self.name)
			end,
		},
		guiHandlers = {
			checkProposal = function(self, id, name, param, isApply)
				if id ~= "constructionBuilder" then return false end
				local con = param.proposal.toAdd[1]
				if con == nil then return end
				if con.fileName == "depot/train_depot_era_a.con" then
					if isApply then
						taskutil:sendScriptFn(self.name, "finishhelper", { param.result[1] })
						return true
					end
					local ce = proposalutil.closeEnough(con.transf, vec2.new(params.trainDepotMineZone.pos[1], params.trainDepotMineZone.pos[2]), 10)
					if ce then
						local angle = (math.atan2(con.transf[2], con.transf[1]) + math.pi) % (2 * math.pi)
						local diff = proposalutil.anglediff(angle, goalAngle)
						if diff < math.pi / 12 then
							return true
						elseif diff > 0.9 * math.pi then
							return _("MISSION_PROPOSAL_FEEDBACK_POINT_TO_OTHER_DIRECTION")
						else
							return _("MISSION_PROPOSAL_FEEDBACK_NOT_ALIGNED_TO_OUTLINE")
						end
					else
						return _("MISSION_PROPOSAL_FEEDBACK_NOT_IN_OUTLINED_AREA")
					end
				else
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_A_RAIL_DEPOT")
				end
			end,
		}
	})

	taskutil:new("3e", {
		onStart = function(self)
			taskutil:setEnabled("menu.construction.railmenu", true)
			taskutil:setEnabled("menu.bulldozer", true)
			taskutil:setZone("blue", { polygon = params.buildingArea3e, draw = true, drawColor = colors.BLUE })
			taskutil:setProposal("p3e", self.name, "checkProposal")
			guides.restart(guidesystem.addGuiGuideBuildTracks, "buildTracks")
			taskutil.userstate.guidesystemkeys["guides_track"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			if taskutil.userstate.railStationVirginia == nil or taskutil.userstate.depotRailVirginia == nil then return end --allow debug skipping

			local rsv = game.interface.getEntity(taskutil.userstate.railStationVirginia).stations[1]
			local path0 = game.interface.findPath(taskutil.userstate.depotRailVirginia, rsv)
			local path1 = game.interface.findPath(rsv, params.railStationSilverProcessingZone)

			self:setSubtaskCompleted(1, path0 ~= nil)
			self:setSubtaskCompleted(2, path1 ~= nil)

			if path0 ~= nil and path1 ~= nil then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setProposal("p3e")
			taskutil:setZone("blue")
			taskutil:setEnabled("menu.bulldozer", false)
			taskutil:setEnabled("menu.construction.railmenu", false)
			taskutil.userstate.guidesystemkeys["guides_track"] = nil
			taskutil.tasks["3f"]:start()
		end,
		onGuiFinish = function(self)
			game.gui.stopAction()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_CARGO_CONNECT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_CARGO_CONNECT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_CARGO_CONNECT_TASK") % params },
					{ type = "HINT", text = _("MISSION_SILVERCITY_TASK_CARGO_CONNECT_HINT") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "3",
				subTasks = {
					{ name = _("MISSION_SILVERCITY_TASK_CARGO_CONNECT_SUB1") % params },
					{ name = _("MISSION_SILVERCITY_TASK_CARGO_CONNECT_SUB2") % params },
				},
				camera = params.jump_trainDepotMineZone,
				voiceOver = "MISSION_SILVERCITY_TASK_CARGO_CONNECT_TEXT.wav",
			}
		end,
		guiHandlers = {
			checkProposal = function(self, id, name, param)
				return proposalutil.checkTrackBuildOrBulldozeInArea(params.buildingArea3e)(id, name, param)
			end,
		}
	})

	taskutil:new("3f", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount(params.modelNames.trainName, 1, 1)
			vehiclestore.setAllowedVehicleCount(params.modelNames.cargoWagonName, params.numberofcargowagons, params.numberofcargowagons)
		end,
		onUpdate = function(self)
			local vehicles = vehiclestore.currentvehicles
			if vehicles[params.modelNames.trainName] == 1 and (vehicles[params.modelNames.cargoWagonName] or 0) >= params.numberofcargowagons then
				self:finish()
			end
		end,
		onFinish = function()
			taskutil.tasks["3g"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_CARGO_TRAIN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_CARGO_TRAIN_TEXT") % params },
					{ type = "TASK", text = getClassicOrCouch(_("MISSION_SILVERCITY_TASK_CARGO_TRAIN_TASK"), _("MISSION_SILVERCITY_TASK_CARGO_TRAIN_TASK_COUCH")) % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "3",
				camera = params.jump_trainDepotMineZone,
				voiceOver = "MISSION_SILVERCITY_TASK_CARGO_TRAIN_TEXT.wav",
			}
		end,
	})

	taskutil:new("3g", {
		onUpdate = function(self)
			local line = util.getLineBetweenZones(params.railStationMineZone, params.railStationSilverProcessingZone)
			if line == nil then
				return --line was removed, let's wait for the player to create it again
			end

			local vehicles = game.interface.getVehicles({ carrier = "RAIL" })

			for v = 1, #vehicles do
				local vehicle = game.interface.getEntity(vehicles[v])
				if vehicle.line == line then
					self:finish()
					return
				end
			end
		end,
		onFinish = function()
			taskutil.tasks["3h"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_CARGO_ASSIGN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_CARGO_ASSIGN_TEXT") % params }, 
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_CARGO_ASSIGN_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "3",
				camera = { params.trainDepotMineZone.pos[1], params.trainDepotMineZone.pos[2], 250 },
				voiceOver = "MISSION_SILVERCITY_TASK_CARGO_ASSIGN_TEXT.wav",
			}
		end,
	})

	taskutil:new("3h", {
		onStart = function(self)
			arrivaltracker.track("3h", { cargotype = "SILVER_ORE", to = params.silverProcessing })
		end,
		onUpdate = function(self)
			if taskutil.tasks["m2"].start ~= nil and #game.interface.getEntities(params.medalDriveZone, { type = "VEHICLE"} ) > 0 then
				taskutil.tasks["m2"]:start()
			end

			if arrivaltracker.get("3h") > 0 then
				self:finish()
			end
		end,
		onFinish = function()
			arrivaltracker.track("3h")

			if taskutil.tasks["m2"].start ~= nil then
				taskutil.tasks["m2"]:start()
			end

			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_CARGO_TRANSPORT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_CARGO_TRANSPORT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_CARGO_TRANSPORT_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "3",
				camera = { params.pos_silverProcessing[1], params.pos_silverProcessing[2], 250 },
				voiceOver = "MISSION_SILVERCITY_TASK_CARGO_TRANSPORT_TEXT.wav",
			}
		end,
	})
end
