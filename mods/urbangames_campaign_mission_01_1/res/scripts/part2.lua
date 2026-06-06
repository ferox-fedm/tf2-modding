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
local contexthelper = require "contexthelper"
local nameutil = require "mission.nameutil"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("2", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_SHAFT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_SHAFT_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_forestVirginia,
				voiceOver = "MISSION_SILVERCITY_TASK_SHAFT_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	local angle2a = -0.06
	taskutil:new("2a", {
		onGuiStart = function(self)
			game.gui.setConstructionAngle(angle2a + math.pi)
			--contexthelper:open()
		end,
		onStart = function(self)
			taskutil:setProposal("p2a", self.name, "checkProposal")
			local poly = polygonutil.transform(transf.rotZTransl(angle2a, vec3.new(params.busStationForestZone.pos[1], params.busStationForestZone.pos[2], 0)), outline.busStationOutline())
			taskutil:setZone("blue", { polygon = poly, draw = true, drawColor = colors.BLUE })
			taskutil:setEnabled("menu.construction.roadmenu", true)
			taskutil.userstate.guidesystemkeys["guides_busstation"] = guidesystem.getTime()
		end,
		onFinish = function(self)
			taskutil:setZone("blue")
			taskutil:setProposal("p2a")
			taskutil:setEnabled("menu.construction.roadmenu", false)
			taskutil.userstate.guidesystemkeys["guides_busstation"] = nil
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_SHAFT_TRUCK_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_SHAFT_TRUCK_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_SHAFT_TRUCK_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" }, },
				parentId = "2",
				camera = params.jump_busStationForestZone,
				voiceOver = "MISSION_SILVERCITY_TASK_SHAFT_TRUCK_TEXT.wav",
			}
		end,
		guiHandlers = {
			checkProposal = function(self, id, name, param, isApply)
				if id ~= "constructionBuilder" then return false end
				local con = param.proposal.toAdd[1]
				if con.fileName == "station/street/modular_terminal.con" and util.hasCargoplatform(param.proposal.toAdd[1]) then
					local nodes = proposalutil.segments2nodes(param.proposal.proposal.addedSegments, param.proposal.proposal.addedNodes)
					if nodes[params.snapNode2a] ~= nil and proposalutil.table2size(nodes) == 2 then
						if isApply then
							taskutil.userstate.busStationVirginiaForest = param.result[1]
							taskutil:finish(self.name)
						end
						return true
					else
						local ce = proposalutil.closeEnough(con.transf, vec2.new(params.busStationForestZone.pos[1], params.busStationForestZone.pos[2]), 20)
						if ce then
							return _("MISSION_PROPOSAL_FEEDBACK_NOT_CONNECTED_TO_CROSSING")
						else
							return _("MISSION_PROPOSAL_FEEDBACK_NOT_IN_OUTLINED_AREA")
						end
					end
				else
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_A_CARGO_ROAD_STATION")
				end
			end,
		},
	})

	taskutil:new("2b", {
		onStart = function(self)
			taskutil:setEnabled("menu.lineManager", true)
			taskutil.userstate.guidesystemkeys["guides_lines"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			local line = util.getLineBetweenZones(params.busStationForestZone, params.busStationMineZone)
			if line ~= nil then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_lines"] = nil
			taskutil.tasks["2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_SHAFT_LINE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_SHAFT_LINE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_SHAFT_LINE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_busStationVirginia,
				voiceOver = "MISSION_SILVERCITY_TASK_SHAFT_LINE_TEXT.wav",
			}
		end,
	})

	local angle2c = -0.04
	taskutil:new("2c", {
		onGuiStart = function(self)
			game.gui.setConstructionAngle(angle2c + math.pi)
		end,
		onStart = function(self)
			taskutil:setEnabled("menu.construction.roadmenu", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.depot/road_depot_era_a.con", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.depot", true)
			taskutil:setProposal("p2c", self.name, "checkProposal")
			local poly = polygonutil.transform(transf.rotZTransl(angle2c, vec3.new(params.streetDepotMineZone.pos[1], params.streetDepotMineZone.pos[2], 0)), outline.streetDepotOutline())
			taskutil:setZone("blue", { polygon = poly, draw = true, drawColor = colors.BLUE })
			taskutil.userstate.guidesystemkeys["guides_depot"] = guidesystem.getTime()
		end,
		onFinish = function(self)
			taskutil:setEnabled("menu.construction.roadmenu", false)
			taskutil:setProposal("p2c")
			taskutil:setZone("blue")
			taskutil.userstate.guidesystemkeys["guides_depot"] = nil
			taskutil.tasks["2d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_SHAFT_DEPOT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_SHAFT_DEPOT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_SHAFT_DEPOT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_streetDepotMineZone,
				voiceOver = "MISSION_SILVERCITY_TASK_SHAFT_DEPOT_TEXT.wav",
			}
		end,
		guiHandlers = {
			checkProposal = function(self, id, name, param, isApply)
				if id ~= "constructionBuilder" then return false end
				local con = param.proposal.toAdd[1]
				if con.fileName == "depot/road_depot_era_a.con" then
					local nodes = proposalutil.segments2nodes(param.proposal.proposal.addedSegments, param.proposal.proposal.addedNodes)
					if nodes[params.snapNode2c] ~= nil and proposalutil.table2size(nodes) == 2 then
						if isApply then
							taskutil.userstate.depotStreetVirginia = param.result[1]
							taskutil:finish(self.name)
						end
						return true
					else
						local ce = proposalutil.closeEnough(con.transf, vec2.new(params.streetDepotMineZone.pos[1], params.streetDepotMineZone.pos[2]), 20)
						if ce then
							return _("MISSION_PROPOSAL_FEEDBACK_NOT_CONNECTED_TO_CROSSING")
						else
							return _("MISSION_PROPOSAL_FEEDBACK_NOT_IN_OUTLINED_AREA")
						end
					end
				else
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_A_ROAD_DEPOT")
				end
			end,
		},
	})

	taskutil:new("2d", {
		onStart = function(self)
			taskutil:setEnabled("menu.vehicleManager", true)
			vehiclestore.setAllowedVehicleCount(params.modelNames.truckName, nil)
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getVehicles({ carrier = "ROAD" })

			local foundcargo = false

			for i = 1, #vehicles do
				local vehicle = game.interface.getEntity(vehicles[i])
				if vehicle.allCapacities.LOGS ~= nil then
					if vehicle.allCapacities.LOGS >= 0 then
						self:finish()
						return
					end
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["2e"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_SHAFT_VEHICLE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_SHAFT_VEHICLE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_SHAFT_VEHICLE_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "2",
				camera = params.jump_streetDepotMineZone,
				voiceOver = "MISSION_SILVERCITY_TASK_SHAFT_VEHICLE_TEXT.wav",
			}
		end,
	})

	taskutil:new("2e", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_lines2"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			local line = util.getLineBetweenZones(params.busStationForestZone, params.busStationMineZone)
			if line == nil then
				return --line was removed, lets wait for the player to create it again
			end

			local vehicles = game.interface.getVehicles({ carrier = "ROAD" })

			for v = 1, #vehicles do
				local vehicle = game.interface.getEntity(vehicles[v])
				if vehicle.line == line then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_lines2"] = nil
			taskutil.tasks["2f"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_SHAFT_ASSIGN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_SHAFT_ASSIGN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_SHAFT_ASSIGN_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "2",
				camera = params.jump_streetDepotMineZone,
				voiceOver = "MISSION_SILVERCITY_TASK_SHAFT_ASSIGN_TEXT.wav",
			}
		end,
	})

	taskutil:new("2f", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_gamespeed"] = guidesystem.getTime()
			arrivaltracker.track("2f", { cargotype = "LOGS", to = params.silverMineWoodDeposit })
		end,
		onUpdate = function(self)
			local c = arrivaltracker.get("2f")
			if c > 0 then
				self:finish()
			end
		end,
		onFinish = function(self)
			arrivaltracker.track("2f")
			game.interface.upgradeConstruction(params.silverOreMine, "industry/silver_ore_mine.con", { productionLevel = 0, startProducing = true })
			game.interface.upgradeConstruction(params.silverProcessing, "industry/silver_processing.con", { productionLevel = 0, startConsuming = true })
			nameutil.setName(params.silverOreMine, _("MISSION_SILVERCITY_PARAMS_SILVEROREMINE"))
			taskutil.userstate.guidesystemkeys["guides_gamespeed"] = nil
			game.interface.book(100000000)
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_SHAFT_DELIVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_SHAFT_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_SHAFT_DELIVER_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "2",
				camera = params.jump_busStationVirginia,
				voiceOver = "MISSION_SILVERCITY_TASK_SHAFT_DELIVER_TEXT.wav",
			}
		end,
	})
end
