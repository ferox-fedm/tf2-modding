require "gui"

local apputil = require "apputil"
local guidesystem
local guides = {}
local unusedGuiNames = {}
local unusedConFiles = {}
local lastProposal

local function doesComponentExist(id)
	return api.gui ~= nil and api.gui.util.getById(id) ~= nil
end

local isGamepadInputMode = apputil.isGamepadInputMode
local getMouseOrGamepad = apputil.getMouseOrGamepad

local function addNewGuide(p)
	if guides[p.name] ~= nil then
		print("guide system warning: guide " .. p.name .. " is going to be overwritten")
	end
	guidesystem.savedData.completedGuides[p.name] = nil
	guides[p.name] = p
end

local timeUtil = { }
function timeUtil.sec(t) return t end
function timeUtil.min(t) return timeUtil.sec(t) * 60 end
function timeUtil.hr(t) return timeUtil.min(t) * 60 end

local importance = {
	IMMEDIATE = { delayFromStart = 0, delayBetween = 0 },
	VERYHIGH = { delayFromStart = timeUtil.min(3), delayBetween = timeUtil.min(1) },
	HIGH = { delayFromStart = timeUtil.min(5), delayBetween = timeUtil.min(1.5) },
	MEDIUM = { delayFromStart = timeUtil.min(15), delayBetween = timeUtil.min(5) },
	LOW = { delayFromStart = timeUtil.hr(1.5), delayBetween = timeUtil.min(15) },
	RARE = { delayFromStart = timeUtil.hr(4), delayBetween = timeUtil.min(45) },
}

local overridePosition = function(a, b)
	if apputil.isCouchUiMode() then return 0.33, 0.1 end
	return a, b
end

local positions = {
	top_left      = function() return overridePosition(0.05, 0.0) end,
	top_center    = function() return overridePosition(0.5 , 0.1) end,
	top_right     = function() return overridePosition(0.95, 0.0) end,
	center_left   = function() return overridePosition(0.0 , 0.5) end,
	center_right  = function() return overridePosition(1.0 , 0.55) end,
	bottom_left   = function() return overridePosition(0.0 , 0.9) end,
	bottom_center = function() return overridePosition(0.5 , 0.9) end,
	bottom_right  = function() return overridePosition(1.0 , 0.9) end,
}

local textwidth = 378

local initialized = false
guidesystem = {
	guides = guides,
	savedData = {
		time = 0,
		timeLastGuide = -9999,
		timeLastProposal = -9999,
		timeLastMissionWindowVisibilityChange = -999,
		completedGuides = {},
		active = true,
	},
	addNewGuide = addNewGuide,
	addGuiGuide = nil, --see below
	defaultSpawn = nil, --see below
	timeUtil = timeUtil,
	delayOver = nil, --see below
	importance = importance,
	positions = positions,
	getTime = function() return guidesystem.savedData.time end,
}

local window
local currentGuide
local autoCloseAt
local overrideAutoCloseDelay = nil
guidesystem.update = function()
	if game.gui.isGuideSystemActive() == false or guidesystem.savedData.active == false then return end
	if next(guides) == nil then return end

	local d = guidesystem.savedData

	if currentGuide ~= nil then
	    local needClose = autoCloseAt ~= nil and apputil.isGamepadInputMode() and autoCloseAt < guidesystem.savedData.time
	    if guides[currentGuide.name].isCompletedFn() then
		    guidesystem.savedData.completedGuides[currentGuide.name] = true
	        needClose = true
	    end
		if needClose and window ~= nil then
			window:close()
		end
	end

	if currentGuide == nil then
		for name, guide in pairs(guides) do
			if guides[name].isCompletedFn() then
				guidesystem.savedData.completedGuides[name] = true
				guides[name] = nil
			elseif guide.mayBeSpawnedNowFn() then
				if window ~= nil then
					error("guidesystem window is already open")
				end
				currentGuide = { name = name, removeFn = guide.removeFn }
				guide.spawnFn()
				local autoCloseDelayInSeconds = ((overrideAutoCloseDelay ~= nil and overrideAutoCloseDelay) or apputil.isCouchUiMode()) and 120 or 60
				autoCloseAt = guidesystem.savedData.time + autoCloseDelayInSeconds
				break
			end
		end
	end

    if currentGuide ~= nil then
        local mouseOnlyHighlights = guides[currentGuide.name].mouseOnlyHighlights
        if mouseOnlyHighlights ~= nil then
            for k, v in pairs(mouseOnlyHighlights) do
                game.gui.setHighlighted(v, not isGamepadInputMode())
            end
        end
    end
	return false
end

local function concatIdNameParam(id, name, param)
	local p = param or ""
	return id .. name .. tostring(p)
end

function guidesystem.setOverrideAutoCloseDelay(override)
	overrideAutoCloseDelay = override
end

function guidesystem.defaultSpawn(settings)
	local textWithResolvedKeyStrings = settings.text():gsub("<<[%a%d]*>>", function(matchResult) return "<" .. ug.getKeyName(matchResult:sub(3, -3)) .. ">" end)

	local d = guidesystem.savedData
	local tv = gui.textView_create("guidesystem.textView", textWithResolvedKeyStrings, textwidth, true)
	window = gui.window_create("guidesystem.window", _("Tip"), tv)
	local w = api.gui.util.getById("guidesystem.window")
	w:setFocusable(false)
	w:setMovable(not apputil.isCouchUiMode())
	w:setInputActionHandler("IA_ABORT",
		function() window:close() end,
		function() return window ~= nil end
	)
	window:setIcon("ui/icons/windows/tip.tga")
	window:onClose(function()
		currentGuide.removeFn()
		guides[currentGuide.name] = nil
		guidesystem.savedData.completedGuides[currentGuide.name] = true
		currentGuide = nil
		window = nil
		d.timeLastGuide = d.time
	end)
	local x, y
	if settings.positionFn == nil then
		x, y = positions.bottom_center()
	else
		x, y = settings.positionFn()
	end
	local screenSize = game.gui.getContentRect("mainView")
	local size = game.gui.calcMinimumSize(window.id)
	x = x * (screenSize[3] - size[1])
	y = y * (screenSize[4] - size[2])
	game.gui.window_setPosition(window.id, x, y)
end
local defaultSpawn = guidesystem.defaultSpawn

function guidesystem.delayOver(delay)
	local delay = delay or guidesystem.importance["LOW"]
	local d = guidesystem.savedData
	return (d.time > delay.delayFromStart) and d.time - d.timeLastGuide > delay.delayBetween
end
local delayOver = guidesystem.delayOver

function guidesystem.addGuiGuide(p)
	local key = concatIdNameParam(p.eventId, p.eventName, p.eventParam)
	if unusedGuiNames[key] ~= nil then
		print("guide system warning: guide " .. p.name .. " already exists in guide gui table")
	end

	unusedGuiNames[key] = { goalParam = p.eventParam }

	addNewGuide({
		name = p.name,
		mayBeSpawnedNowFn = p.mayBeSpawnedNowFn or function()
			return delayOver(p.delay)
		end,
		isCompletedFn = function()
			return unusedGuiNames[key] == nil
		end,
		spawnFn = function()
			for k, v in pairs(p.highlight) do
				game.gui.setHighlighted(v, true)
			end
			defaultSpawn(p.settings)
		end,
		removeFn = function()
			for k, v in pairs(p.highlight) do
				game.gui.setHighlighted(v, false)
			end
			unusedGuiNames[key] = nil
		end,
		mouseOnlyHighlights = p.mouseOnlyHighlights,
	})
end
local addGuiGuide = guidesystem.addGuiGuide

function guidesystem.addConFileGuide(p)
	local key = p.conFile
	if unusedConFiles[key] ~= nil then
		print("guide system warning: guide " .. key .. " already exists in guide con file table")
	end
	unusedConFiles[key] = 1

	addNewGuide({
		name = p.name,
		mayBeSpawnedNowFn = p.mayBeSpawnedNowFn or function()
			return delayOver(p.delay)
		end,
		isCompletedFn = function()
			return unusedConFiles[key] == nil
		end,
		spawnFn = function()
			for k, v in pairs(p.highlight) do
				game.gui.setHighlighted(v, true)
			end
			defaultSpawn(p.settings)
		end,
		removeFn = function()
			for k, v in pairs(p.highlight) do
				game.gui.setHighlighted(v, false)
			end
			unusedConFiles[key] = nil
		end,
	})
end
local addConFileGuide = guidesystem.addConFileGuide

function guidesystem.addGuideGameSpeed()
	addNewGuide({
		name = "gameSpeed",
		mayBeSpawnedNowFn = function()
			if game.interface.getGameSpeed() == 0 then return false end
			local d = guidesystem.savedData
			if d.timeFirstVehicle == nil then
				local v = #game.interface.getVehicles()
				if v > 0 then
					d.timeFirstVehicle = d.time
				end
			end
			return d.timeFirstVehicle ~= nil and d.time - d.timeFirstVehicle > timeUtil.sec(60)
		end,
		isCompletedFn = function()
			return game.interface.getGameSpeed() > 1
		end,
		spawnFn = function()
			game.gui.setHighlighted("menu.gameSpeed", true)
			defaultSpawn({ 
				text = function() return getMouseOrGamepad( _("GUIDE_GAME_SPEED"), _("GUIDE_GAME_SPEED_COUCH")) end, 
				positionFn = positions.center_right 
			})
		end,
		removeFn = function()
			game.gui.setHighlighted("menu.gameSpeed", false)
		end,
	})
end

function guidesystem.addGuideUnpause()
	addNewGuide({
		name = "unpause",
		mayBeSpawnedNowFn = function()
			if game.interface.getGameSpeed() ~= 0 then return false end
			local d = guidesystem.savedData
			if d.timeFirstVehicle == nil then
				local v = #game.interface.getVehicles()
				if v > 0 then
					d.timeFirstVehicle = d.time
				end
			end
			return d.timeFirstVehicle ~= nil and d.time - d.timeFirstVehicle > timeUtil.sec(30)
		end,
		isCompletedFn = function()
			return game.interface.getGameSpeed() > 0
		end,
		spawnFn = function()
			game.gui.setHighlighted("menu.gameSpeed", true)
			defaultSpawn({ 
				text = function() return getMouseOrGamepad(_("GUIDE_UNPAUSE"), _("GUIDE_UNPAUSE_COUCH"))  end, 
				positionFn = positions.bottom_right 
			})
		end,
		removeFn = function()
			game.gui.setHighlighted("menu.gameSpeed", false)
		end,
	})
end

function guidesystem.addGuideAddToLine()
	local highlightAddToLine = { "lineChooseButton", "lineListButton", "vehicleButtonsComp" }
	guidesystem.addNewGuide({
		name = "addToLine",
		mayBeSpawnedNowFn = function() return false end,
		isCompletedFn = function() return false end,
		spawnFn = function()
			for k,v in pairs(highlightAddToLine) do
				game.gui.setHighlighted(v, true)
			end
			guidesystem.defaultSpawn({
				text = function() return _("GUIDE_ADD_TO_LINE") end,
				positionFn = guidesystem.positions.bottom_center
			})
		end,
		removeFn = function()
			for k,v in pairs(highlightAddToLine) do
				game.gui.setHighlighted(v, false)
			end
		end,
	})
end

function guidesystem.addGuideBuildBusStop() -- this guide is only meant for edge object bus stop (because it is completed through edge object proposal)
	local highlights = {
		"menu.construction.road",
		"menu.construction.road.road-buildings",
		"menu.construction.road.road-buildings.item.passenger",
		"menu.construction.road.road-buildings.item.station/bus/small_old.mdl",
		"menu.construction.road.road-buildings.item.station/bus/small_new.mdl",
		"menu.construction.road.road-buildings.item.station/bus/small_mid.mdl",
	}
	local name =  "buildBusStop"
	addNewGuide({
		name = name,
		mayBeSpawnedNowFn = function()
			return guidesystem.delayOver(importance.LOW)
		end,
		isCompletedFn = function()
			return guidesystem.savedData.completedGuides[name] ~= nil
		end,
		spawnFn = function()
			for k,v in pairs(highlights) do
				game.gui.setHighlighted(v, true)
			end
			defaultSpawn({ 
				text = function() return _("GUIDE_BUILD_BUS_STOP") end, 
				positionFn = positions.bottom_center 
			})
		end,
		removeFn = function()
			for k,v in pairs(highlights) do
				game.gui.setHighlighted(v, false)
			end
		end,
	})
end

function guidesystem.addGuideOpenTownWindow()
	local highlights = { "townhudicon" }
	local name =  "openTownWindow"
	addNewGuide({
		name = name,
		mayBeSpawnedNowFn = function()
			return guidesystem.delayOver(importance.LOW)
		end,
		isCompletedFn = function()
			return guidesystem.savedData.completedGuides[name] ~= nil
		end,
		spawnFn = function()
			for k,v in pairs(highlights) do
				game.gui.setHighlighted(v, true)
			end
			defaultSpawn({ 
				text = function() return _("GUIDE_OPEN_TOWN_WINDOW") end, 
				positionFn = positions.bottom_center 
			})
		end,
		removeFn = function()
			for k,v in pairs(highlights) do
				game.gui.setHighlighted(v, false)
			end
		end,
	})
end

function guidesystem.addGuideStats()
	local statsbuttons = { "menu.stats.stations", "menu.stats.vehicles", "menu.stats.industries", "menu.stats.towns", "menu.stats.lines", }

	addNewGuide({
		name = "openStats",
		mayBeSpawnedNowFn = function()
			return guidesystem.delayOver(importance.HIGH)
		end,
		isCompletedFn = function()
			for _, v in pairs(statsbuttons) do
				local key = concatIdNameParam(v, "toggleButton.toggle", "true")
				if unusedGuiNames[key] == nil then return true end
			end
			return false
		end,
		spawnFn = function()
			for k,v in pairs(statsbuttons) do
				game.gui.setHighlighted(v, true)
			end
			defaultSpawn({ 
				text = function() return _("GUIDE_STATS") end, 
				positionFn = positions.bottom_right 
			})
		end,
		removeFn = function()
			for k,v in pairs(statsbuttons) do
				game.gui.setHighlighted(v, false)
			end
		end,
	})
end

function guidesystem.addGuideLayers()
	local layerbuttons = {
		"menu.layers.hudFilterButton",
		"menu.layers.emissionLayerButton",
		"menu.layers.trafficLayerButton",
		"menu.layers.speedLimitsButton",
		--"menu.layers.watersButton",
		"menu.layers.contoursButton",
		"menu.layers.landuseButton",
	}

	local highlights = {
		"menu.radialmenu",
		"menu.layersButton",
		"menu.layers.contoursButton",
		"menu.layers.landuseButton",
		"menu.layers.watersButton",
		"menu.layers.speedLimitsButton",
		"menu.layers.destinationButton",
		"menu.layers.cargoButton",
		"menu.layers.stationsButton",
		"menu.layers.emissionLayerButton",
		"menu.layers.trafficLayerButton",
		"menu.layers.hudFilterButton",
	}

	addNewGuide({
		name = "openLayers",
		mayBeSpawnedNowFn = function()
			return guidesystem.delayOver(importance.HIGH)
		end,
		isCompletedFn = function()
			for _, v in pairs(layerbuttons) do
				local key = concatIdNameParam(v, "toggleButton.toggle", "true")
				if unusedGuiNames[key] == nil then return true end
			end
			return false
		end,
		mouseOnlyHighlights = {"menu.layers.hudFilterButton"},
		spawnFn = function()
			for k,v in pairs(highlights) do
				game.gui.setHighlighted(v, true)
			end
			defaultSpawn({ 
				text = function() return _("GUIDE_LAYERS") end, 
				positionFn = positions.top_left 
			})
		end,
		removeFn = function()
			for k,v in pairs(highlights) do
				game.gui.setHighlighted(v, false)
			end
		end,
	})
end

function guidesystem.addGuiGuideMissionWindowClose()
	local text = function() return _("GUIDE_OPEN_CLOSE_WINDOW") end
	addGuiGuide({
		name = "closeMissionWindow",
		eventId = "missionDisplayWindow",
		eventName = "visibilityChange",
		eventParam = true,
		settings = { text = text },
		highlight = {},
		delay = importance.IMMEDIATE,
		mayBeSpawnedNowFn = function()
			return isGamepadInputMode()
		end
	})
end

function guidesystem.addGuiGuideCameraPan()
	local text = function() return getMouseOrGamepad(_("GUIDE_MOUSE_PAN"), _("GUIDE_CONTROLLER_PAN")) end
	local delay = { delayFromStart = timeUtil.sec(30), delayBetween = timeUtil.sec(30) }
	addGuiGuide({
		name = "mousePan",
		eventId = "mainView",
		eventName = "camera.userPan",
		eventParam = true,
		settings = { text = text },
		highlight = {},
		delay = delay
	})
end

function guidesystem.addGuiGuideCameraRotate()
	local text = function() return getMouseOrGamepad(_("GUIDE_MOUSE_ROTATE"), _("GUIDE_CONTROLLER_ROTATE")) end
	local delay = { delayFromStart = timeUtil.sec(60), delayBetween = timeUtil.sec(31) }
	addGuiGuide({
		name = "mouseRotate",
		eventId = "mainView",
		eventName = "camera.userRotateTilt",
		eventParam = true,
		settings = { text = text },
		highlight = {},
		delay = delay
	})
end

function guidesystem.addGuiGuideCameraZoom()
	local text = function() return getMouseOrGamepad(_("GUIDE_MOUSE_WHEEL"), _("GUIDE_CONTROLLER_ZOOM")) end
	local delay = { delayFromStart = timeUtil.sec(80), delayBetween = timeUtil.sec(32) }
	addGuiGuide({
		name = "mouseWheel",
		eventId = "mainView",
		eventName = "camera.userZoom",
		eventParam = nil,
		settings = { text = text },
		highlight = {},
		delay = delay
	})
end

function guidesystem.addGuiGuideCameraKeyScroll()
	local text = function() return _("GUIDE_KEY_SCROLL") end
	addGuiGuide({
		name = "keyScroll",
		eventId = "mainView",
		eventName = "camera.keyScroll",
		eventParam = false,
		settings = { text = text },
		highlight = {},
		delay = importance.RARE,
		mayBeSpawnedNowFn = function() 
			return not isGamepadInputMode() and guidesystem.delayOver(importance.RARE)
		end
	})
end

function guidesystem.addGuiGuideLanduseButton()
	local text = function() return _("GUIDE_LANDUSE_BUTTON") end
	addGuiGuide({
		name = "landuseButton",
		eventId = "menu.layers.landuseButton",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = positions.top_left },
		highlight = { "menu.layers.landuseButton", "menu.layersButton", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideContoursButton()
	local text = function() return _("GUIDE_CONTOURS_BUTTON") end
	addGuiGuide({
		name = "contoursButton",
		eventId = "menu.layers.contoursButton",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = positions.top_left },
		highlight = { "menu.layers.contoursButton", "menu.layersButton", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideWatersButton()
	local text = function() return _("GUIDE_WATERS_BUTTON") end -- unused - why?
	addGuiGuide({
		name = "watersButton",
		eventId = "menu.layers.watersButton",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = positions.top_left },
		highlight = { "menu.layers.watersButton", "menu.layersButton", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideSpeedLimitsButton()
	local text = function() return _("GUIDE_SPEED_LIMITS_BUTTON") end
	addGuiGuide({
		name = "speedLimitsButton",
		eventId = "menu.layers.speedLimitsButton",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = positions.top_left },
		highlight = { "menu.layers.speedLimitsButton", "menu.layersButton", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideTrafficLayerButton()
	local text = function() return _("GUIDE_TRAFFIC_LAYER_BUTTON") end
	addGuiGuide({
		name = "trafficLayerButton",
		eventId = "menu.layers.trafficLayerButton",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = positions.top_left },
		highlight = { "menu.layers.trafficLayerButton", "menu.layersButton", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideEmissionLayerButton()
	local text = function() return _("GUIDE_EMISSION_LAYER_BUTTON") end
	addGuiGuide({
		name = "emissionLayerButton",
		eventId = "menu.layers.emissionLayerButton",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = positions.top_left },
		highlight = { "menu.layers.emissionLayerButton", "menu.layersButton", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideHudIcons()
	local text = function() return _("GUIDE_HUD_ICONS") end
	addGuiGuide({
		name = "hudIcons",
		eventId = "menu.layers.hudFilterButton",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = positions.top_left },
		highlight = { "menu.layers.hudFilterButton", "menu.layers.hudFilterButton.radial", "menu.radialmenu" },
	})
end

function guidesystem.addGuiGuideBorrowLoan()
	local text = function() return _("GUIDE_BORROW_LOAN") end
	addGuiGuide({
		name = "borrowLoan",
		eventId = "finances.borrow",
		eventName = "button.click",
		eventParam = nil,
		settings = { text = text, positionFn = positions.bottom_left },
		highlight = { "menu.financesButton", "menu.financesButton.radial", "menu.finances.tabFinancesTable", "finances.borrow", "menu.radialmenu" },
		mouseOnlyHighlights = { "menu.financesButton"},
		mayBeSpawnedNowFn = function()
			if api.res.getBaseConfig().noCosts then return false end
			if not doesComponentExist("menu.construction.rail.rail-buildings") then return false end -- HACK: implies editor mode
			if lastProposal == nil then return false end
			local d = guidesystem.savedData
			if d.time - d.timeLastProposal < timeUtil.sec(3) then return end
			local balance = game.interface.getEntity(game.interface.getPlayer()).balance
			local cost = lastProposal.param.data.costs
			return cost > balance
		end
	})
end

function guidesystem.addGuiGuideRepayLoan()
	local text = function() return _("GUIDE_REPAY_LOAN") end
	addGuiGuide({
		name = "repayLoan",
		eventId = "finances.repay",
		eventName = "button.click",
		eventParam = nil,
		settings = { text = text, positionFn = positions.bottom_left },
		highlight = { "menu.financesButton", "menu.financesButton.radial", "menu.finances.tabFinancesTable", "finances.repay", "menu.radialmenu" },
		mouseOnlyHighlights = { "menu.financesButton"},
		mayBeSpawnedNowFn = function()
			if not delayOver(importance.LOW) then return false end
			local player = game.interface.getEntity(game.interface.getPlayer())
			local v = 500000
			return player.loan > v and player.balance > v
		end
	})
end

function guidesystem.addGuiGuideStatsVehiclesButton()
	local text = function() return _("GUIDE_STATS_VEHICLES_BUTTON") end
	addGuiGuide({
		name = "statsVehiclesButton",
		eventId = "menu.stats.vehicles.table",
		eventName = "visibilityChange",
		eventParam = true,
		settings = { text = text, positionFn = positions.bottom_right },
		highlight = { "menu.statsButton", "menu.stats.vehicles", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideStatsStationsButton()
	local text = function() return _("GUIDE_STATS_STATIONS_BUTTON") end
	addGuiGuide({
		name = "statsStationsButton",
		eventId = "menu.stats.stations.table",
		eventName = "visibilityChange",
		eventParam = true,
		settings = { text = text, positionFn = positions.bottom_right },
		highlight = { "menu.statsButton", "menu.stats.stations", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideStatsLinesButton()
	local text = function() return _("GUIDE_STATS_LINES_BUTTON") end
	addGuiGuide({
		name = "statsLinesButton",
		eventId = "menu.stats.lines.table",
		eventName = "visibilityChange",
		eventParam = true,
		settings = { text = text, positionFn = positions.bottom_right },
		highlight = { "menu.statsButton", "menu.stats.lines", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideStatsTownsButton()
	local text = function() return _("GUIDE_STATS_TOWNS_BUTTON") end
	addGuiGuide({
		name = "statsTownsButton",
		eventId = "menu.stats.towns.table",
		eventName = "visibilityChange",
		eventParam = true,
		settings = { text = text, positionFn = positions.bottom_right },
		highlight = { "menu.statsButton", "menu.stats.towns", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideStatsIndustriesButton()
	local text = function() return _("GUIDE_STATS_INDUSTRIES_BUTTON") end
	addGuiGuide({
		name = "statsIndustriesButton",
		eventId = "menu.stats.industries.table",
		eventName = "visibilityChange",
		eventParam = true,
		settings = { text = text, positionFn = positions.bottom_right },
		highlight = { "menu.statsButton", "menu.stats.industries", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideSaveGameButton()
	local text = function() return _("GUIDE_SAVE_GAME_BUTTON") end
	addGuiGuide({
		name = "saveGameButton",
		eventId = "ingameMenu.saveGameButton",
		eventName = "button.click",
		eventParam = nil,
		settings = { text = text, positionFn = positions.top_right },
		highlight = { "menu.fileMenuButton", "ingameMenu.saveGameButton" },
		delay = importance.LOW
	})
end

function guidesystem.addGuiGuideMusicPlayerButton()
	local text = function() return _("GUIDE_MUSIC_PLAYER_BUTTON") end
	addGuiGuide({
		name = "musicPlayerButton",
		eventId = "menu.musicPlayerButton",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = positions.bottom_right },
		highlight = { "menu.musicPlayerButton", "menu.radialmenu" },
		delay = importance.LOW
	})
end

function guidesystem.addGuiGuideCameraButton()
	local text = function() return _("GUIDE_CAMERA_BUTTON") end
	addGuiGuide({
		name = "cameraButton",
		eventId = "menu.cameraToolButton",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = positions.bottom_right },
		highlight = { "menu.cameraToolButton", "menu.radialmenu" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideSettingsButton()
	local text = function() return _("GUIDE_SETTINGS_BUTTON") end
	addGuiGuide({
		name = "settingsButton",
		eventId = "ingameMenu.settingsButton",
		eventName = "button.click",
		eventParam = nil,
		settings = { text = text, positionFn = positions.top_right },
		highlight = { "menu.fileMenuButton", "ingameMenu.settingsButton" },
		delay = importance.LOW,
		mayBeSpawnedNowFn = function() 
			return not apputil.isCouchUiMode() and guidesystem.delayOver(importance.LOW)
		end
	})
end

function guidesystem.addGuiGuideBulldozer()
	local text = function() return _("GUIDE_BULLDOZER") end
	addGuiGuide({
		name = "bulldozer",
		eventId = "menu.bulldozer",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = positions.bottom_right },
		highlight = { "menu.bulldozer" },
		delay = importance.MEDIUM
	})
end

function guidesystem.addGuiGuideWarnings() --unused
	local text = function() return getMouseOrGamepad(_("GUIDE_WARNINGS"), "This is a warning text that shows up only when using the gamepad.") end

	addGuiGuide({
		name = "warnings",
		eventId = "menu.messagePanel.problem",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = positions.top_center },
		highlight = { "menu.messagePanel.problem" },
		delay = importance.IMMEDIATE
	})
end

function guidesystem.addGuiGuideBuildStreets()
	local text = function() return _("GUIDE_BUILD_STREETS") end
	addGuiGuide({
		name = "buildStreets",
		eventId = "streetBuilder",
		eventName = "builder.apply",
		eventParam = nil,
		settings = { text = text, positionFn = positions.bottom_center },
		highlight = { "menu.construction.road", "menu.construction.road.streets",
			"menu.construction.road.streets.item.standard/town_medium_new.lua",
			"menu.construction.road.streets.item.standard/town_medium_old.lua",
		},
		delay = importance.LOW
	})
end

function guidesystem.addGuiGuideBuildTracks()
	local text = function() return _("GUIDE_BUILD_TRACKS") end
	addGuiGuide({
		name = "buildTracks",
		eventId = "trackBuilder",
		eventName = "builder.apply",
		eventParam = nil,
		settings = { text = text, positionFn = positions.bottom_center },
		highlight = { "menu.construction.rail", "menu.construction.rail.tracks", "menu.construction.rail.tracks.item.standard.lua" },
		delay = importance.LOW
	})
end

function guidesystem.addGuiGuideBuildStations()
	local text = function() return _("GUIDE_BUILD_STATIONS") end
	addGuiGuide({
		name = "buildStations",
		eventId = "constructionBuilder",
		eventName = "builder.apply",
		eventParam = nil,
		settings = { text = text, positionFn = positions.bottom_center },
		highlight = { "menu.construction.rail",          "menu.construction.road",          "menu.construction.water",          "menu.construction.air",
		              "menu.construction.rail.rail-buildings", "menu.construction.road.road-buildings", "menu.construction.water.water-buildings", "menu.construction.air.air-buildings",
			"menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_0",
			"menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_1",
			"menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_2",
			"menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_3",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_0",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_1",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_2",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_3",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_4",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_5",
			"menu.construction.water.water-buildings.item.station/water/harbor_modular.con_0",
			"menu.construction.water.water-buildings.item.station/water/harbor_modular.con_1",
			"menu.construction.air.air-buildings.item.station/air/airfield.con_0",
			"menu.construction.air.air-buildings.item.station/air/airport.con_0",
			"menu.construction.air.air-buildings.item.station/air/airfield.con_1",
			"menu.construction.air.air-buildings.item.station/air/airport.con_0",
		},
		delay = importance.VERYHIGH,
		mayBeSpawnedNowFn = function()
			return doesComponentExist("menu.construction.rail.rail-buildings") and guidesystem.delayOver(importance.VERYHIGH)
		end
	})
end

function guidesystem.addGuiGuideRotateProposal()
	local text = function() return _("GUIDE_ROTATE_CONSTRUCTIONS") end
	addGuiGuide({
		name = "rotateConstructions",
		eventId = "constructionBuilder",
		eventName = "builder.rotate",
		eventParam = nil,
		settings = { text = text, positionFn = positions.top_center },
		highlight = { },
		mayBeSpawnedNowFn = function()
			if lastProposal == nil then return false end
			local d = guidesystem.savedData
			if d.time - d.timeLastProposal ~= timeUtil.sec(4) then return false end
			return lastProposal.id == "constructionBuilder" and lastProposal.name == "builder.proposalCreate"
		end
	})
end

function guidesystem.addGuiGuideTrackModifier()
	local text = function() return _("GUIDE_TRACK_MODIFIER") end
	addGuiGuide({
		name = "trackModifier",
		eventId = "streetTrackModifier",
		eventName = "builder.apply",
		eventParam = nil,
		settings = { text = text, positionFn = positions.bottom_center },
		highlight = { "menu.construction.road", "menu.construction.road.upgrades", "menu.construction.road.upgrades.item.tram_1950", "menu.construction.road.upgrades.item.tram_0" },
		delay = importance.LOW
	})
end

function guidesystem.addGuiGuideCompanyFinances()
	local text = function() return _("GUIDE_COMPANY_FINANCES") end
	addGuiGuide({
		name = "companyFinances",
		eventId = "menu.finances.category",
		eventName = "visibilityChange",
		eventParam = true,
		settings = { text = text, positionFn = positions.bottom_left },
 		highlight = { "menu.financesButton", "menu.financesButton.radial", "menu.radialmenu" },
		mouseOnlyHighlights = { "menu.financesButton"},
		delay = importance.MEDIUM
	})
end

function guidesystem.addGuiGuideCompanyGrowth()
	local text = function() return _("GUIDE_COMPANY_GROWTH") end
	addGuiGuide({
		name = "companyGrowth",
		eventId = "menu.finances.tabBalanceChart.content",
		eventName = "visibilityChange",
		eventParam = true,
		settings = { text = text, positionFn = positions.bottom_left },
		highlight = { "menu.financesButton", "menu.financesButton.radial", "menu.finances.tabBalanceChart", "menu.radialmenu" },
        mouseOnlyHighlights = { "menu.financesButton"},
		delay = importance.LOW
	})
end

function guidesystem.addGuiGuideCompanyLogo()
	local text = function() return _("GUIDE_COMPANY_LOGO") end
	addGuiGuide({
		name = "companyLogo",
		eventId = "menu.finances.category",
		eventName = "tabWidget.currentChanged",
		eventParam = 2,
		settings = { text = text, positionFn = positions.bottom_left },
		highlight = { "menu.financesButton", "menu.financesButton.radial", "menu.finances.tab3", "menu.radialmenu" },
		mouseOnlyHighlights = { "menu.financesButton"},
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideCompanyHeadQuarter()
	local text = function() return _("GUIDE_COMPANY_HEAD_QUARTER") end
	addGuiGuide({
		name = "companyHeadQuarter",
		eventId = "menu.finances.buildHQ",
		eventName = "button.click",
		eventParam = nil,
		settings = { text = text, positionFn = positions.bottom_left },
		highlight = { "menu.financesButton", "menu.financesButton.radial", "menu.finances.tabHQTable", "menu.finances.buildHQ", "menu.radialmenu" },
		mouseOnlyHighlights = { "menu.financesButton"},
		delay = importance.LOW
	})
end

function guidesystem.addGuiGuideLocateButton()
	local text = function() return _("GUIDE_LOCATE_BUTTON") end
	addGuiGuide({
		name = "locateButton",
		eventId = "window.locateButton",
		eventName = "button.click",
		eventParam = nil,
		settings = { text = text, positionFn = guidesystem.positions.bottom_center },
		highlight = { "window.locateButton" },
		delay = importance.RARE,
		mayBeSpawnedNowFn = function() 
			return not apputil.isGamepadInputMode() and guidesystem.delayOver(importance.RARE)
		end		
	})
end

function guidesystem.addGuiGuideCockpitView()
	local text = function() return _("GUIDE_COCKPIT_VIEW") end
	guidesystem.addGuiGuide({
		name = "cockpitView",
		eventId = "vehicleWindow.enterCockpit",
		eventName = "button.click",
		eventParam = nil,
		settings = { text = text, positionFn = guidesystem.positions.bottom_center },
		highlight = { "vehicleWindow.enterCockpit" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideCreateLine()
	local text = function() return _("GUIDE_CREATE_LINE") end
	guidesystem.addGuiGuide({
		name = "createLine",
		eventId = "lineManager.newLine",
		eventName = "button.click",
		eventParam = nil,
		settings = { text = text, positionFn = guidesystem.positions.bottom_center },
		highlight = { "menu.lineManager", "lineManager.newLine" },
		delay = importance.RARE
	})
end

function guidesystem.addGuiGuideBuildSignals()
	local text = function() return _("GUIDE_BUILD_SIGNALS") end
	guidesystem.addGuiGuide({
		name = "buildSignals",
		eventId = "menu.construction.rail.signals.item.railroad/signal_old_block.mdl",
		eventName = "visibilityChange",
		eventParam = true,
		settings = { text = text, positionFn = guidesystem.positions.bottom_center },
		highlight = { "menu.construction.rail", "menu.construction.rail.signals", "menu.construction.rail.signals.item.railroad/signal_path_a.mdl" },
		delay = importance.RARE
	})
end

function guidesystem.addConFileGuideBuildBusStationPassenger()
	local text = function() return _("GUIDE_BUILD_BUS_STATION_PASSENGER") end
	addConFileGuide({
		name = "buildBusStationPassenger",
		conFile = "station/street/modular_terminal.con", --warning: same conFile as guide buildBusStationCargo (they overwrite one another)
		settings = { text = text, positionFn = guidesystem.positions.bottom_center }, -- unused
		highlight = {
			"menu.construction.road",
			"menu.construction.road.road-buildings",
			"menu.construction.road.road-buildings.item.passenger",
			"menu.construction.road.road-buildings.item.station/bus/small_old.mdl",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_0",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_1",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_2",
		},
		delay = importance.RARE
	})
end

function guidesystem.addConFileGuideBuildBusStationCargo()
	local text = function() return _("GUIDE_BUILD_BUS_STATION_CARGO") end
	addConFileGuide({
		name = "buildBusStationCargo",
		conFile = "station/street/modular_terminal.con", --warning: same conFile as guide buildBusStationPassenger (they overwrite one another)
		settings = { text = text, positionFn = guidesystem.positions.bottom_center }, -- unused
		highlight = {
			"menu.construction.road",
			"menu.construction.road.road-buildings",
			"menu.construction.road.road-buildings.item.passenger",
			"menu.construction.road.road-buildings.item.station/bus/small_new.mdl",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_3",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_4",
			"menu.construction.road.road-buildings.item.station/street/modular_terminal.con_5",
		},
		delay = importance.RARE
	})
end

function guidesystem.addConFileGuideBuildTrainStationPassenger()
	local text = function() return _("GUIDE_BUILD_TRAIN_STATION_PASSENGER") end
	addConFileGuide({
		name = "buildTrainStationPassenger",
		conFile = "station/rail/modular_station/modular_station.con", --warning: same conFile as guide buildTrainStationCargo (they overwrite one another)
		settings = { text = text, positionFn = guidesystem.positions.bottom_center }, -- unused
		highlight = {
			"menu.construction.rail",
			"menu.construction.rail.rail-buildings",
			"menu.construction.rail.rail-buildings.item.passenger",
			"menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_0",
			"menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_1",
		},
		delay = importance.RARE
	})
end

function guidesystem.addConFileGuideBuildTrainStationCargo()
	local text = function() return _("GUIDE_BUILD_TRAIN_STATION_CARGO") end
	addConFileGuide({
		name = "buildTrainStationCargo",
		conFile = "station/rail/modular_station/modular_station.con", --warning: same conFile as guide buildTrainStationPassenger (they overwrite one another)
		settings = { text = text, positionFn = guidesystem.positions.bottom_center }, -- unused
		highlight = {
			"menu.construction.rail",
			"menu.construction.rail.rail-buildings",
			"menu.construction.rail.rail-buildings.rail-building.item.cargo",
			"menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_6",
			"menu.construction.rail.rail-buildings.item.station/rail/modular_station/modular_station.con_7",
		},
		delay = importance.RARE
	})
end

function guidesystem.addConFileGuideBuildBusDepot()
	local text = function() return _("GUIDE_BUILD_BUS_DEPOT") end
	addConFileGuide({
		name = "buildBusDepot",
		conFile = "depot/road_depot_era_a.con",
		settings = { text = text, positionFn = guidesystem.positions.bottom_center },
		highlight = {
			"menu.construction.road",
			"menu.construction.road.road-buildings",
			"menu.construction.road.road-buildings.item.depot",
			"menu.construction.road.road-buildings.item.depot/road_depot_era_a.con",
		},
		delay = importance.RARE
	})
end

function guidesystem.addConFileGuideBuildTrainDepot()
	local text = function() return _("GUIDE_BUILD_TRAIN_DEPOT") end
	addConFileGuide({
		name = "buildTrainDepot",
		conFile = "depot/train_depot_era_a.con",
		settings = { text = text, positionFn = guidesystem.positions.bottom_center },
		highlight = {
			"menu.construction.rail",
			"menu.construction.rail.rail-buildings",
			"menu.construction.rail.rail-buildings.item.depot",
			"menu.construction.rail.rail-buildings.item.depot/train_depot_era_a.con",
		},
		delay = importance.RARE
	})
end

function guidesystem.addConFileGuideBuildHarbor()
	local text = function() return _("GUIDE_BUILD_HARBOR") end
	addConFileGuide({
		name = "buildHarbor",
		conFile = "station/water/harbor_modular.con",
		settings = { text = text, positionFn = guidesystem.positions.bottom_center },
		highlight = { "menu.construction.water", "menu.construction.water.water-buildings",
		"menu.construction.water.water-buildings.item.station/water/harbor_modular.con_0",
		"menu.construction.water.water-buildings.item.station/water/harbor_modular.con_1",
		},
		delay = importance.RARE
	})
end

function guidesystem.addConFileGuideBuildDock()
	local text = function() return _("GUIDE_BUILD_DOCK") end
	addConFileGuide({
		name = "buildDock",
		conFile = "depot/shipyard_old.con",
		settings = { text = text, positionFn = guidesystem.positions.bottom_center },
		highlight = { "menu.construction.water", "menu.construction.water.water-buildings", "menu.construction.water.water-buildings.item.depot/shipyard_era_a.con" },
		delay = importance.RARE
	})
end

local vehicleExhaustedGuideSpawn = false
local vehicleExhaustedGuideCompleted = false

function guidesystem.addVehicleExhaustedGuide()
	addNewGuide({
		name = "exhausted",
		mayBeSpawnedNowFn = function()
			return vehicleExhaustedGuideSpawn
		end,
		isCompletedFn = function()
			return vehicleExhaustedGuideCompleted
		end,
		spawnFn = function()
			game.gui.setHighlighted("menu.vehicleManager", true)
			game.gui.setHighlighted("menu.vehicleManager.maintenanceButton", true)
			game.gui.setHighlighted("menu.vehicleManager.replaceButton", true)
			
			defaultSpawn({ 
				text = function() return _("GUIDE_VEHICLE_EXHAUSTED") end, 
				positionFn = positions.bottom_center 
			})
			
			vehicleExhaustedGuideSpawn = false
		end,
		removeFn = function()
			game.gui.setHighlighted("menu.vehicleManager", false)
			game.gui.setHighlighted("menu.vehicleManager.maintenanceButton", false)
			game.gui.setHighlighted("menu.vehicleManager.replaceButton", false)
			
			vehicleExhaustedGuideCompleted = true
		end,
	})
end

function guidesystem.addGuideStationQuality()
	local nextId = 0
	local stationQualitySpawn = true
	local key = concatIdNameParam("menu.layers.stationsButton", "toggleButton.toggle", true)
	unusedGuiNames[key] = { goalParam = true }
	addNewGuide({
		name = "stationQuality",
		mayBeSpawnedNowFn = function()
			nextId = nextId + 1
			
			if not (guidesystem.delayOver(importance.HIGH) and stationQualitySpawn) then return false end
	
			local stations = game.interface.getStations()
			if #stations == 0 then return false end
			if nextId > #stations then nextId = 1 end
			
			local stationId = stations[nextId]
			
			local samples = game.interface.getStationTransportSamples(stationId)
			local ratio = 1.0
			if samples[2] > 0 then ratio = samples[1] / samples[2] end

			return ratio < .8 
		end,
		
		isCompletedFn = function()
			local completed = unusedGuiNames[key] == nil;
			return completed;
		end,
		spawnFn = function()
			stationQualitySpawn = false
			defaultSpawn({ 
				text = function() return _("GUIDE_STATION_QUALITY") end, 
				positionFn = positions.bottom_center 
			})
			game.gui.setHighlighted("menu.layersButton", true)
			game.gui.setHighlighted("menu.layers.stationsButton", true)
			game.gui.setHighlighted("menu.radialmenu", true)
			
		end,
		removeFn = function()
			game.gui.setHighlighted("menu.layersButton", false)
			game.gui.setHighlighted("menu.layers.stationsButton", false)
			game.gui.setHighlighted("menu.radialmenu", false)
		end,
	})
end

function guidesystem.addGuiGuideInspector()
	local text = function() return _("GUIDE_INSPECTOR") end
	addGuiGuide({
		name = "inspectorButton",
		eventId = "menu.inspector",
		eventName = "toggleButton.toggle",
		eventParam = true,
		settings = { text = text, positionFn = guidesystem.positions.bottom_center },
		highlight = { "menu.inspector" },
		delay = importance.HIGH,
		mayBeSpawnedNowFn = function() 
			return isGamepadInputMode() and guidesystem.delayOver(importance.HIGH)
		end
	})
end

function guidesystem.addGuiGuideCloseAll()
	local text = function() return _("GUIDE_CLOSE_ALL") end
	addGuiGuide({
		name = "closeAllButton",
		eventId = "menu.closeAll",
		eventName = "button.click",
		eventParam = true,
		settings = { text = text, positionFn = guidesystem.positions.bottom_center },
		highlight = { "menu.closeAll" },
		delay = importance.RARE,
		mayBeSpawnedNowFn = function() 
			return isGamepadInputMode() and guidesystem.delayOver(importance.RARE)
		end
	})
end

guidesystem.addGuideGameSpeed()
guidesystem.addGuideUnpause()
--guidesystem.addGuideAddToLine()
guidesystem.addGuideBuildBusStop()
guidesystem.addGuideOpenTownWindow()

guidesystem.addGuiGuideCameraPan()
guidesystem.addGuiGuideCameraZoom()
guidesystem.addGuiGuideCameraRotate()
guidesystem.addGuiGuideCameraKeyScroll()
guidesystem.addGuideLayers()
guidesystem.addGuiGuideLanduseButton()
guidesystem.addGuiGuideContoursButton()
--guidesystem.addGuiGuideWatersButton()
guidesystem.addGuiGuideSpeedLimitsButton()
guidesystem.addGuiGuideTrafficLayerButton()
guidesystem.addGuiGuideEmissionLayerButton()
guidesystem.addGuiGuideHudIcons()
guidesystem.addGuiGuideBorrowLoan()
guidesystem.addGuiGuideRepayLoan()
guidesystem.addGuideStats()
guidesystem.addGuiGuideStatsVehiclesButton()
guidesystem.addGuiGuideStatsStationsButton()
guidesystem.addGuiGuideStatsLinesButton()
guidesystem.addGuiGuideStatsTownsButton()
guidesystem.addGuiGuideStatsIndustriesButton()
guidesystem.addGuiGuideSaveGameButton()
guidesystem.addGuiGuideMusicPlayerButton()
--guidesystem.addGuiGuideCameraButton()
guidesystem.addGuiGuideSettingsButton()
guidesystem.addGuiGuideBulldozer()
-- guidesystem.addGuiGuideWarnings()
guidesystem.addGuiGuideBuildStreets()
guidesystem.addGuiGuideBuildTracks()
guidesystem.addGuiGuideBuildStations()
guidesystem.addGuiGuideRotateProposal()
guidesystem.addGuiGuideTrackModifier()
guidesystem.addGuiGuideCompanyFinances()
guidesystem.addGuiGuideCompanyGrowth()
--guidesystem.addGuiGuideCompanyLogo()
guidesystem.addGuiGuideCompanyHeadQuarter()
--guidesystem.addGuiGuideLocateButton()
--guidesystem.addGuiGuideCockpitView()
--guidesystem.addGuiGuideCreateLine()
--guidesystem.addGuiGuideBuildSignals()

--guidesystem.addConFileGuideBuildBusStationPassenger()
--guidesystem.addConFileGuideBuildBusStationCargo()
--guidesystem.addConFileGuideBuildBusDepot()
--guidesystem.addConFileGuideBuildTrainStationPassenger()
--guidesystem.addConFileGuideBuildTrainStationCargo()
--guidesystem.addConFileGuideBuildTrainDepot()
--guidesystem.addConFileGuideBuildHarbor()
--guidesystem.addConFileGuideBuildDock()
guidesystem.addVehicleExhaustedGuide()
guidesystem.addGuideStationQuality()

guidesystem.addGuiGuideInspector()
-- guidesystem.addGuiGuideCloseAll()

guidesystem.script = {
	save = function ()
		return guidesystem.savedData
	end,
	load = function (state, reset)
		if state == nil or next(state) == nil or reset then return end
		guidesystem.savedData.time = state.time
		if initialized then return end
		guidesystem.savedData = state
		for k,v in pairs(guidesystem.savedData.completedGuides) do
			guides[k] = nil
		end
		if guidesystem.savedData.timeLastMissionWindowVisibilityChange == nil then
			guidesystem.savedData.timeLastMissionWindowVisibilityChange = -999
		end

		initialized = true
	end,
	guiUpdate = function ()
		guidesystem.update()
		game.interface.sendScriptEvent("saveevent", "", guidesystem.savedData)
	end,
	update = function ()
		local gamespeed = game.interface.getGameSpeed()
		local dt = 0.2
		if gamespeed > 1 then dt = dt / gamespeed end
		guidesystem.savedData.time = guidesystem.savedData.time + dt
	end,
	handleEvent = function (src, id, name, param)
		if id == "saveevent" then
			local t = guidesystem.savedData.time
			guidesystem.savedData = param
			guidesystem.savedData.time = t
		end
	end,
	guiHandleEvent = function (id, name, param)
		--print("guiHandleEvent " .. id .. " " .. name .. " " .. tostring(param))
		if name == "builder.proposalCreate" then
			lastProposal = {
				id = id,
				name = name,
				param = {
					data = {
						costs = param.data.costs,
					},
				}
			}
			guidesystem.savedData.timeLastProposal = guidesystem.savedData.time

			local toAdd = param.proposal.toAdd
			if toAdd and #toAdd > 0 then
				for i = 1, #toAdd do
					local con = toAdd[i]
					unusedConFiles[con.fileName] = nil
				end
			end

			local eo = param.proposal.proposal.edgeObjectsToAdd
			for i = 1, #eo do
				if eo[i].category == 0 then -- 0 corresponds to a stop
					guidesystem.savedData.completedGuides["buildBusStop"] = true
				end
			end
		end

		if id == "mainView" and name == "select" then
			local e = game.interface.getEntity(param)
			if e and e.type == "TOWN" then
				guidesystem.savedData.completedGuides["openTownWindow"] = true
			end
		end

		if id == "missionDisplayWindow" and name == "visibilityChange" then
			local isFirstVisibilityChange = guidesystem.savedData.timeLastMissionWindowVisibilityChange < 0
			guidesystem.savedData.timeLastMissionWindowVisibilityChange = guidesystem.savedData.time
			if isFirstVisibilityChange then return end
		end

		local entityStart, entityEnd = id:find(".entity%d+.")
		if entityStart ~= nil then
			local idold = id
			id = id:sub(1, entityStart - 1) .. id:sub(entityEnd, #id)
		end

		local key = concatIdNameParam(id, name, param)
		local t = unusedGuiNames[key]
		if t == nil then
			key = concatIdNameParam(id, name, "")
			t = unusedGuiNames[key]
		end
		if t ~= nil and (t.goalParam == nil or t.goalParam == param) then
			unusedGuiNames[key] = nil
		end
		
		local vehicleExhaustedPrefix = "popup.vehicle"
		if id:sub(1, #vehicleExhaustedPrefix) == vehicleExhaustedPrefix and not vehicleExhaustedGuideCompleted then
			vehicleExhaustedGuideSpawn = true
		end
	end
}

return guidesystem
