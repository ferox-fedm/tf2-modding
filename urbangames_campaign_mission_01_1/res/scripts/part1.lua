local params = require "params"
local util = require "util"
local guidesystem = require "guidesystem"
local vehiclestore = require "mission.vehiclestore"
local apputil = require "apputil"

local getClassicOrCouch = apputil.getClassicOrCouch
local getMouseOrGamepad = apputil.getMouseOrGamepad

return function(taskutil)
	local tasks = taskutil.tasks

	local mainguihandlers = {
		voiceOverEnded = function(self) taskutil:finish(self.name) end,
		jump_trackSnapNode1 = function()
			game.gui.setAutoCamera({ 1447, -170, 250 })
		end,
		jump_trackSnapNode2 = function()
			game.gui.setAutoCamera({ 1692, -247, 250 })
		end,
		jump_trackSnapNode3 = function()
			game.gui.setAutoCamera({ 1578, -394, 250 })
		end,
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
			for k, v in pairs(params.modelNames) do
				vehiclestore.setAllowedVehicleCount(v, 0)
			end

			taskutil:setEnabled("menu.construction.roadmenu", false)
			taskutil:setEnabled("menu.construction.road.streets", false)
			taskutil:setEnabled("menu.construction.road.waypoints", false)
			taskutil:setEnabled("menu.construction.road.upgrades", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.upgradeButton", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.depot/road_depot_era_a.con", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.station/bus/small_old.mdl", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.station/road/small_cargo.mdl", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.station/street/modular_terminal.con_0", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.depot", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.passenger", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.depot/tram_depot_era_a.con", false)

			taskutil:setEnabled("menu.construction.railmenu", false)
			taskutil:setEnabled("menu.construction.rail.signals", false)
			taskutil:setEnabled("menu.construction.rail.waypoints", false)
			taskutil:setEnabled("menu.construction.rail.upgrade", false)
			taskutil:setEnabled("menu.construction.rail.track-constructions", false)
			taskutil:setVisibleAndEnabled("menu.construction.rail.tracks.upgradeButton", false)
			taskutil:setVisibleAndEnabled("menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_0", false)
			taskutil:setVisibleAndEnabled("menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_1", false)
			taskutil:setVisibleAndEnabled("menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_6", false)

			taskutil:setEnabled("menu.construction.watermenu", false)
			taskutil:setEnabled("menu.construction.airmenu", false)
			taskutil:setEnabled("menu.construction.terrainmenu", false)

			taskutil:setEnabled("menu.lineManager", false)
			taskutil:setEnabled("menu.vehicleManager", false)
			taskutil:setEnabled("menu.bulldozer", false)
			taskutil:setEnabled("menu.moduleBulldozer", false)

			taskutil:setEnabled("menu.layersButton", false)
			taskutil:setEnabled("menu.layers.landuseButton", false)
			taskutil:setEnabled("menu.layers.contoursButton", false)
			taskutil:setEnabled("menu.layers.stationsButton", false)
			taskutil:setEnabled("menu.layers.destinationButton", false)
			taskutil:setEnabled("menu.layers.cargoButton", false)
			taskutil:setEnabled("menu.layers.watersButton", false)
			taskutil:setEnabled("menu.layers.speedLimitsButton", false)
			taskutil:setEnabled("menu.layers.trafficLayerButton", false)
			taskutil:setEnabled("menu.layers.emissionLayerButton", false)

			taskutil:setEnabled("menu.statsButton", false);
			taskutil:setEnabled("menu.stats.stations", false);
			taskutil:setEnabled("menu.stats.towns", false);
			taskutil:setEnabled("menu.stats.industries", false);
			taskutil:setEnabled("menu.stats.lines", false);
			taskutil:setEnabled("menu.stats.vehicles", false);

			taskutil:setEnabled("menu.radialmenu", false);
			taskutil:setEnabled("menu.inspector", false);

		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			local e = game.interface.getEntity(params.silverOreMine)
			return {
				name = _("MISSION_SILVERCITY_TASK_MINE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_MINE_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_silverOreMine,
				voiceOver = "MISSION_SILVERCITY_TASK_MINE_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	--what player needs to to:
	local move = 500
	local zoom = 2000
	local turn = 180
	local tilt = 1.5

	--what player has achieved:
	local moveprogress = 0
	local zoomprogress = 0
	local turnprogress = 0
	local tiltprogress = 0

	local lastcam
	taskutil:new("1a", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_camera"] = guidesystem.getTime()
		end,
		onGuiUpdate = function(self)
			local camera = game.gui.getCamera()
			taskutil:sendScriptFn(self.name, "cameraChanged", { camera })
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_camera"] = nil
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_MINE_MOVECAM_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_MINE_MOVECAM_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_TASK_MINE_MOVECAM_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = { params.jump_virginiaCity[1], params.jump_virginiaCity[2], 500 },
				voiceOver = "MISSION_SILVERCITY_TASK_MINE_MOVECAM_TEXT.wav",
				subTasks = {
					{ name = _("MISSION_SILVERCITY_TASK_MINE_MOVECAM_SUB1") % params },
					{ name = _("MISSION_SILVERCITY_TASK_MINE_MOVECAM_SUB2") % params },
					{ name = _("MISSION_SILVERCITY_TASK_MINE_MOVECAM_SUB3") % params },
					{ name = _("MISSION_SILVERCITY_TASK_MINE_MOVECAM_SUB4") % params },
				}
			}
		end,
		handlers = {
			cameraChanged = function(self, param)
				local camera = param
				if lastcam == nil then lastcam = camera end
				local x0, y0, z0, turn0, tilt0 = table.unpack(lastcam)
				local x1, y1, z1, turn1, tilt1 = table.unpack(camera)

				moveprogress =  moveprogress + math.sqrt((x1 - x0)*(x1 - x0) + (y1 - y0)*(y1 - y0))
				self:setProgressText(math.floor(moveprogress) .. "/" .. move .. " " .. _("meters"), 1)
				if moveprogress >= move then self:setSubtaskCompleted(1) end

				zoomprogress = zoomprogress + math.abs(z1 - z0)
				self:setProgressText(math.floor(zoomprogress) .. "/" .. zoom .. " " .. _("meters"), 2)
				if zoomprogress >= zoom then self:setSubtaskCompleted(2) end

				turnprogress = turnprogress + (180 * math.abs(turn1 - turn0) / math.pi)
				self:setProgressText(math.floor(turnprogress) .. "/" .. turn .. " " .. _("degree"), 3)
				if turnprogress >= turn then self:setSubtaskCompleted(3) end

				tiltprogress = tiltprogress + math.abs(tilt1 - tilt0)
				self:setProgressPercent(tiltprogress / tilt, 4)
				if tiltprogress >= tilt then self:setSubtaskCompleted(4) end

				if moveprogress >= move and zoomprogress >= zoom and turnprogress >= turn and tiltprogress >= tilt then
					if self.finish ~= nil then self:finish() end
				end

				lastcam = camera
			end,
		},
	})

	taskutil:new("1b", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_closeMissionWindow"] = guidesystem.getTime()

			taskutil:setEnabled("menu.inspector", true);
			taskutil:setMarker("marker1b", { entity = params.silverOreMine, type = "question" }, self.name, "finish")
			taskutil.userstate.guidesystemkeys[apputil.isCouchUiMode() and "guides_inspectorbutton" or "guides_locatebutton"] = guidesystem.getTime()
		end,
		onFinish = function(self)
			taskutil:setMarker("marker1b")
			taskutil:startLater("2")
			taskutil.userstate.guidesystemkeys[apputil.isCouchUiMode() and "guides_inspectorbutton" or "guides_locatebutton"] = nil
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_TASK_MINE_LOCATE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_TASK_MINE_LOCATE_TEXT") % params },
					{ type = "TASK", text = getMouseOrGamepad(_("MISSION_SILVERCITY_TASK_MINE_LOCATE_TASK"), _("MISSION_SILVERCITY_TASK_MINE_LOCATE_TASK_COUCH")) % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_silverOreMine,
				voiceOver = "MISSION_SILVERCITY_TASK_MINE_LOCATE_TEXT.wav",
			}
		end,
		guiHandlers = {
			guiHandleEvent = function(self, id, name, param)
				if id == "mainView" and name == "select" then
					if param == params.silverOreMine or param == game.interface.getEntity(params.silverOreMine).simBuildings[1] then
						taskutil:finish(self.name)
					end
				end
			end
		},
	})
end
