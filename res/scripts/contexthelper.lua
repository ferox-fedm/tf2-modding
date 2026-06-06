require "gui"

local apputil = require "apputil"

local contexthelper = {}

local welcomeTitle = _("Welcome")
local welcomeText = _("HELP_WELCOME")
local welcomeImage =  "ui/contexthelper/welcome.tga"

local nothingText = _("The context help page for this menu or window is not available.")
local defaultTextGame = _("HELP_START")
local defaultTextGameCouch = _("HELP_START_COUCH")
local defaultTextEditor = _("HELP_START"):gsub("\n\n", "\n"):gsub("\n", "\n\n")
local defaultTextEditorCouch = _("HELP_START_COUCH"):gsub("\n\n", "\n"):gsub("\n", "\n\n")
local defaultImage = "ui/contexthelper/default.tga"
local defaultTitle = _("Context help")

local textwidth = 372

local menuConstruction = "menuConstruction"
local menuLayers = "menuLayers"
local menuStats = "menuStats"
local menuFinances = "menuFinances"
local menuLineManager = "menuLineManager"
local menuVehicleManager = "menuVehicleManager"
local menuBulldozer = "menuBulldozer"
local townWindow = "townWindow"
local industryWindow = "industryWindow"
local stationGroupWindow = "stationGroupWindow"

local getMouseOrGamepad = apputil.getMouseOrGamepad

local helperTexts = nil
local function initHelperTexts()
	helperTexts = {
		menuConstruction = {
			["menu.construction.rail"] = {
				function() return _("HELP_CONSTRUCTION_RAIL_TRACKS") end,
				function() return _("HELP_CONSTRUCTION_RAIL_STATIONS") end,
				function() return _("HELP_CONSTRUCTION_RAIL_CONSTRUCTIONS") end,
				function() return _("HELP_CONSTRUCTION_RAIL_SIGNALS") end,
				function() return _("HELP_CONSTRUCTION_RAIL_WAYPOINTS") end,
				function() return _("HELP_CONSTRUCTION_RAIL_TOOLS") end,
			},
			["menu.construction.road"] = {
				function() return getMouseOrGamepad(_("HELP_CONSTRUCTION_ROAD_STREETS"), _("HELP_CONSTRUCTION_ROAD_STREETS_COUCH")) end,
				function() return _("HELP_CONSTRUCTION_ROAD_STATIONS") end,
				function() return _("HELP_CONSTRUCTION_ROAD_CONSTRUCTIONS") end,
				function() return _("HELP_CONSTRUCTION_ROAD_WAYPOINTS") end,
				function() return _("HELP_CONSTRUCTION_ROAD_TOOLS") end,
			},
			["menu.construction.water"] = {
				function() return _("HELP_CONSTRUCTION_WATER_STATIONS") end,
				function() return _("HELP_CONSTRUCTION_WATER_WAYPOINTS") end,
			},
			["menu.construction.air"] = {
				function() return _("HELP_CONSTRUCTION_AIR_STATIONS") end,
			},
			["menu.construction.terrain"] = {
				function() return _("HELP_CONSTRUCTION_TERRAIN_TOOLS") end,
				function() return _("HELP_CONSTRUCTION_TERRAIN_PAINTER") end,
				function() return _("HELP_CONSTRUCTION_TERRAIN_ASSETS") end
			},
			["menu.construction.town"] = {
				function() return _("HELP_CONSTRUCTION_TOWN_TOOLS") end,
			},
			["menu.construction.industry"] = {
				function() return _("HELP_CONSTRUCTION_INDUSTRY_TOOLS") end,
			},
			["menu.construction.heightmap"] = {
				function() return _("HELP_CONSTRUCTION_MAP_GENERATORS") end,
				function() return _("HELP_CONSTRUCTION_MAP_IMPORT") end,
				function() return _("HELP_CONSTRUCTION_MAP_EXPORT") end,
			},
			["menu.construction.generate"] = {
				function() return _("HELP_CONSTRUCTION_GENERATOR_TOWNS") end,
				function() return _("HELP_CONSTRUCTION_GENERATOR_INDUSTRIES") end,
			},
			["menu.construction.generateStreets"] = {
				function() return getMouseOrGamepad(_("HELP_CONSTRUCTION_GENERATOR_STREETS"), _("HELP_CONSTRUCTION_GENERATOR_STREETS_COUCH")) end,
			},
		},
		menuLayers = {
			function() return _("HELP_LAYER_INTRO") end,
			function() return _("HELP_LAYER_LANDUSE") end,
			function() return _("HELP_LAYER_TERRAIN") end,
			function() return _("HELP_LAYER_WATER") end,
			function() return _("HELP_LAYER_SPEEDLIMITS") end,
			function() return _("HELP_LAYER_DESTINATIONS") end,
			function() return _("HELP_LAYER_CARGO") end,
			function() return _("HELP_LAYER_STATIONS") end,
			function() return _("HELP_LAYER_TRAFFIC") end,
			function() return _("HELP LAYER_EMISSIONS") end,
			function() return _("HELP_LAYER_HUD") end,
		},
		menuFinances = {
			["menu.finances.tabFinancesTable"] = function() return _("HELP_COMPANY_FINANCES") end,
			["menu.finances.tabFinancesChart"] = function() return _("HELP_COMPANY_FINANCES") end,
			["menu.finances.tabBalanceChart"] = function() return _("HELP_COMPANY_CHARTS") end,
			["menu.finances.tabTrackChart"] = function() return _("HELP_COMPANY_CHARTS") end,
			["menu.finances.tabTownsChart"] = function() return _("HELP_COMPANY_CHARTS") end,
			["menu.finances.tabHQTable"] = function() return _("HELP_COMPANY_HEADQUARTERS") end,
			["menu.finances.tab3"] = function() return _("HELP_COMPANY_LOGO") end,
		},
		menuStats = {
			["menu.stats.lines"] = function() return getMouseOrGamepad(_("HELP_STATISTICS_LINES"), _("HELP_STATISTICS_LINES_COUCH")) end,
			["menu.stats.vehicles"] = function() return getMouseOrGamepad(_("HELP_STATISTICS_VEHICLES"), _("HELP_STATISTICS_VEHICLES_COUCH")) end,
			["menu.stats.stations"] = function() return _("HELP_STATISTICS_STATIONS") end,
			["menu.stats.towns"] = function() return _("HELP_STATISTICS_TOWNS") end,
			["menu.stats.industries"] = function() return _("HELP_STATISTICS_INDUSTRIES") end,
		},
		menuLineManager = function() return getMouseOrGamepad(_("HELP_MANAGER_LINES"), _("HELP_MANAGER_LINES_COUCH")) end,
		menuVehicleManager = function() return getMouseOrGamepad(_("HELP_MANAGER_VEHICLES"),  _("HELP_MANAGER_VEHICLES_COUCH")) end,
		menuBulldozer = function() return _("HELP_BULLDOZER") end,
		townWindow = function() return _("HELP_WINDOW_TOWN") end,
		industryWindow = function() return _("HELP_WINDOW_INDUSTRY") end,
		stationGroupWindow = function() return _("HELP_WINDOW_STATON") end,
	}
end

local imagePath = "ui/contexthelper/"

local helperImages = nil
local function initHelperImages()
	helperImages = {
		menuConstruction = {
			["menu.construction.rail"] = {
				function() return imagePath .. "menuConstructionRailTracks.tga" end,
				function() return imagePath .. "menuConstructionRailStation.tga" end,
				function() return imagePath .. "menuConstructionRailConstruction.tga" end,
				function() return imagePath .. "menuConstructionRailSignal.tga" end,
				function() return imagePath .. "menuConstructionRailWaypoint.tga" end,
				function() return imagePath .. "menuConstructionRailTool.tga" end,
			},
			["menu.construction.road"] = {
				function() return imagePath .. "menuConstructionStreets.tga" end,
				function() return imagePath .. "menuConstructionStreetStation.tga" end,
				function() return imagePath .. "menuConstructionStreetConstruction.tga" end,
				function() return imagePath .. "menuConstructionStreetWaypoint.tga" end,
				function() return imagePath .. "menuConstructionStreetTool.tga" end,
			},
			["menu.construction.water"] = {
				function() return imagePath .. "menuConstructionWaterStation.tga" end,
				function() return imagePath .. "menuConstructionWaterWaypoint.tga" end
			},
			["menu.construction.air"] = {
				function() return imagePath .. "menuConstructionAirport.tga" end
			},
			["menu.construction.town"] = {
				function() return imagePath .. "menuConstructionTowns.tga" end
			},
			["menu.construction.terrain"] = {
				function() return imagePath .. "menuConstructionTerrain.tga" end,
				function() return imagePath .. "menuConstructionTerrainPainter.tga" end,
				function() return imagePath .. "menuConstructionAssetBrush.tga" end
			},
			["menu.construction.industry"] = {
				function() return imagePath .. "menuConstructionIndustry.tga" end
			},
			["menu.construction.heightmap"] = {
				function() return imagePath .. "menuConstructionHeightmap.tga" end,
				function() return imagePath .. "menuConstructionHeightmap.tga" end,
				function() return imagePath .. "menuConstructionHeightmap.tga" end,
			},
			["menu.construction.generate"] = {
				function() return imagePath .. "menuConstructionGenerateTowns.tga" end,
				function() return imagePath .. "menuConstructionGenerateIndustries.tga" end,
			},
			["menu.construction.generateStreets"] = {
				function() return imagePath .. "menuConstructionGenerateStreets.tga" end,
			},
		},
		menuLayers = {
			nil,
			function() return imagePath .. "menuLayersLanduse.tga" end,
			function() return imagePath .. "menuLayersContours.tga" end,
			function() return imagePath .. "menuLayersWaters.tga" end,
			function() return imagePath .. "menuLayersSpeedLimits.tga" end,
			function() return imagePath .. "menuLayersDestination.tga" end,
			function() return imagePath .. "menuLayersCargo.tga" end,
			function() return imagePath .. "menuLayersStations.tga" end,
			function() return imagePath .. "menuLayersTraffic.tga" end,
			function() return imagePath .. "menuLayersEmission.tga" end,
			function() return imagePath .. "menuHudIconFilter.tga" end,
		},
		menuFinances = {
			["menu.finances.tabFinancesTable"] = function() return imagePath .. "menuFinances.tga" end,
			["menu.finances.tabFinancesChart"] = function() return imagePath .. "menuFinances.tga" end,
			["menu.finances.tabBalanceChart"] = function() return imagePath .. "menuCharts.tga" end,
			["menu.finances.tabTrackChart"] = function() return imagePath .. "menuCharts.tga" end,
			["menu.finances.tabTownsChart"] = function() return imagePath .. "menuCharts.tga" end,
			["menu.finances.tabHQTable"] = function() return imagePath .. "menuHeadquarter.tga" end,
			["menu.finances.tab3"] = nil,
		},
		menuStats = {
			["menu.stats.lines"] = function() return imagePath .. "menuStatsLines.tga" end,
			["menu.stats.vehicles"] = function() return imagePath .. "menuStatsVehicles.tga" end,
			["menu.stats.stations"] = function() return imagePath .. "menuStatsStations.tga" end,
			["menu.stats.towns"] = function() return imagePath .. "menuStatsTowns.tga" end,
			["menu.stats.industries"] = function() return imagePath .. "menuStatsIndustries.tga" end,
		},
		menuLineManager = function() return imagePath .. "menuLineManager.tga" end,
		menuVehicleManager = function() return imagePath .. "menuVehicleManager.tga" end,
		menuBulldozer = function() return imagePath .. "menuBulldoze.tga" end,
		townWindow = function() return imagePath .. "windowTown.tga" end,
		industryWindow = function() return imagePath .. "windowIndustry.tga" end,
		stationGroupWindow = function() return imagePath .. "windowStationGroup.tga" end,
	}
end

local helperTitles = nil
local function initHelperTitles()
	helperTitles = {
		menuConstruction = {
			["menu.construction.rail"] = {
				function() return _("Build tracks") end,
				function() return _("Build train stations") end,
				function() return _("Build track constructions") end,
				function() return _("Build track signals") end,
				function() return _("Build track waypoints") end,
				function() return _("Track modification tools")  end
			},
			["menu.construction.road"] = {
				function() return _("Build streets") end,
				function() return _("Build street stations") end,
				function() return _("Build street constructions")  end,
				function() return _("Build street waypoints") end,
				function() return _("Street modification tools")  end
			},
			["menu.construction.water"] = {
				function() return _("Build harbors") end,
				function() return _("Build ship waypoints") end
			},
			["menu.construction.air"] = {
				function() return _("Build airports") end
			},
			["menu.construction.town"] = {
				function() return _("Build towns") end
			},
			["menu.construction.terrain"] = {
				function() return _("Modify terrain") end,
				function() return _("Paint terrain") end,
				function() return _("Place assets") end
			},
			["menu.construction.industry"] = {
				function() return _("Build industries") end
			},
			["menu.construction.heightmap"] = {
				function() return _("Generate heightmap") end,
				function() return _("Import heightmap") end,
				function() return _("Export heightmap") end 
			},
			["menu.construction.generate"] = {
				function() return _("Generate towns") end,
				function() return _("Generate industries") end
			},
			["menu.construction.generateStreets"] = {
				function() return _("Generate streets") end
			}
		},
		menuLayers = {
			nil,
			function() return _("Land use layer") end,
			function() return _("Contour lines layer") end,
			function() return _("Navigable waters layer") end,
			function() return _("Track speed limits layer") end,
			function() return _("Destinations layer") end,
			function() return _("Cargo layer") end,
			function() return _("Stations layer") end,
			function() return _("Street traffic layer") end,
			function() return _("Emissions layer") end,
			function() return _("HUD icon filter") end
		},
		menuFinances = {
			["menu.finances.tabFinancesTable"] = function() return _("Company finances") end,
			["menu.finances.tabFinancesChart"] = function() return _("Company finances") end,
			["menu.finances.tabBalanceChart"] = function() return _("Company charts") end,
			["menu.finances.tabTrackChart"] = function() return _("Company charts") end,
			["menu.finances.tabTownsChart"] = function() return _("Company charts") end,
			["menu.finances.tabHQTable"] = function() return _("Company headquarters") end,
			["menu.finances.tab3"] = function() return _("Company logo") end,
		},
		menuStats = {
			["menu.stats.lines"] =  function() return _("Line statistics") end,
			["menu.stats.vehicles"] = function() return _("Vehicle statistics") end,
			["menu.stats.stations"] = function() return _("Station statistics") end,
			["menu.stats.towns"] = function() return _("Town statistics") end,
			["menu.stats.industries"] = function() return _("Industry statistics") end,
		},
		menuLineManager = function() return _("Line manager") end,
		menuVehicleManager = function() return _("Vehicle manager") end,
		menuBulldozer = function() return _("Bulldoze") end,
		townWindow = function() return _("Towns") end,
		industryWindow = function() return _("Industries") end,
		stationGroupWindow = function() return _("Stations") end,
	}
end

local contextHelperGui = { }
local guiState = {
	fn = nil,
	counter = 0,
	access = {},
	menuConstruction = {
	}
}
setmetatable(guiState, {
	__index = {
		open = function(self, name)
			self:setMostRecentlyUsed(name)
			if self.fn then self.fn() end
		end,
		close = function(self, name)
			self.access[name] = nil
			if self.fn then self.fn() end
		end,
		isOpen = function(self, name)
			return self.access[name] ~= nil
		end,
		toggle = function(self, name, param)
			if param ~= nil then
				if param then
					self:open(name)
				else
					self:close(name)
				end
			else
				if self:isOpen(name) then
					self:close(name)
				else
					self:open(name)
				end
			end
		end,
		setMostRecentlyUsed = function(self, name)
			self.access[name] = self.counter
			self.counter = self.counter + 1
		end,
		mostRecentlyUsed = function(self)
			local mru = nil
			local mruCounter = nil
			for k, v in pairs(self.access) do
				if mruCounter == nil or v > mruCounter then
					mru = k
					mruCounter = v
				end
			end
			return mru
		end,
		menuConstructionTab = function(self, tab)
			if tab == nil then
				self.menuConstruction["tab"] = nil
			else
				self.menuConstruction["tab"] = tab
			end
			self:setMostRecentlyUsed(menuConstruction)
			if self.fn then self.fn() end
		end,
		menuConstructionSubTab = function(self, tab, subtab)
			self.menuConstruction[tab] = subtab
			self:setMostRecentlyUsed(menuConstruction)
			if self.fn then self.fn() end
		end,
		menuLayersCurrent = function(self, idx, param)
			if param then
				self.menuLayers = idx
				self:setMostRecentlyUsed(menuLayers)
			elseif self.menuLayers == idx then
				self.menuLayers = nil
			end
			if self.fn then self.fn() end
		end,
		menuStatsCurrent = function(self, idx, param)
			if param then
				self.menuStats = idx
				self:setMostRecentlyUsed(menuStats)
			elseif self.menuStats == idx then
				self:close(menuStats)
				self.menuStats = nil
			end
			if self.fn then self.fn() end
		end,
		menuFinancesTab = function(self, idx)
			if idx == nil then
				self.menuFinances = nil
			else
				self.menuFinances = idx
			end
			self:setMostRecentlyUsed(menuFinances)
			if self.fn then self.fn() end
		end,
		townWindow = function(self)
			self:setMostRecentlyUsed(townWindow)
			if self.fn then self.fn() end
		end,
		industryWindow = function(self)
			self:setMostRecentlyUsed(industryWindow)
			if self.fn then self.fn() end
		end,
		stationGroupWindow = function(self)
			self:setMostRecentlyUsed(stationGroupWindow)
			if self.fn then self.fn() end
		end,
		debugPrint = function(self)
			for k, v in pairs(self.access) do
				print(k .. " is open with priority " .. v)
			end
			for k, v in pairs(self.menuConstruction) do
				print("menu.construction." .. k .. " = " .. v)
			end
			if self.menuLayers then print("menu.layers.current = " .. self.menuLayers) end
			if self.menuStats then print("menu.stats.current = " .. self.menuStats) end
			if self.menuFinances then print("menu.finances.tab = " .. self.menuFinances) end
		end,
		reset = function(self)
			self.counter = 0
			self.access = {}
			self.menuConstruction = {}
		end,
	}
})

local function get(source, nothing, default)
	local mostRecentlyUsed = guiState:mostRecentlyUsed()

	if mostRecentlyUsed == nil then
		return default
	elseif mostRecentlyUsed == menuConstruction then
		local tab = guiState.menuConstruction["tab"]
		if tab == nil then return default end
		local subtab = guiState.menuConstruction[tab] or 1
		if source[menuConstruction][tab] == nil then return nothing end
		if source[menuConstruction][tab][subtab] == nil then return nothing end
		return source[menuConstruction][tab][subtab]() or nothing
	elseif mostRecentlyUsed == menuLayers then
		if source[mostRecentlyUsed][guiState.menuLayers or 1] == nil then return nothing end
		return source[mostRecentlyUsed][guiState.menuLayers or 1]() or nothing
	elseif mostRecentlyUsed == menuStats then
		if source[mostRecentlyUsed][guiState.menuStats or "menu.stats.vehicles"] == nil then return nothing end
		return source[mostRecentlyUsed][guiState.menuStats or "menu.stats.vehicles"]() or nothing
	elseif mostRecentlyUsed == menuFinances then
		if source[mostRecentlyUsed][guiState.menuFinances or "menu.finances.tabFinancesTable"] == nil then return nothing end 
		return source[mostRecentlyUsed][guiState.menuFinances or "menu.finances.tabFinancesTable"]() or nothing
	else
		if source[mostRecentlyUsed] == nil then return nothing end
		return source[mostRecentlyUsed]() or nothing
	end
end

local function getText()
    local defaultText = (game.gui.isEditor() and getMouseOrGamepad(defaultTextEditor, defaultTextEditorCouch) or getMouseOrGamepad(defaultTextGame, defaultTextGameCouch))
	local text = get(helperTexts, nothingText, defaultText)
	
	text = text:gsub("<<[%a%d]*>>", function(matchResult) return "<" .. ug.getKeyName(matchResult:sub(3, -3)) .. ">" end)
			text = text:gsub("\n\n", "\n")
			text = text:gsub("\n", "\n\n")

	return text
end

local function getImage()
	return get(helperImages, defaultImage, defaultImage)
end

local function getTitle()
	return get(helperTitles, defaultTitle, defaultTitle)
end

local function getOrigin(self)
	local contentRect = game.gui.getContentRect(self.window.id)
	local origin = { contentRect[1], contentRect[2] + contentRect[4] }
	return origin
end

setmetatable(contextHelperGui, {
	__index = {
		open = function(self)
			if self.window ~= nil then
				error("context helper opened twice")
			end
			self.imageView = gui.imageView_create("contexthelper.imageView", getImage())
			self.textView = gui.textView_create("contexthelper.textView", getText(), textwidth, true)
			self.boxLayout = gui.boxLayout_create("contexthelper.boxLayout", "VERTICAL")
			self.boxLayout:addItem(self.imageView)
			self.boxLayout:addItem(self.textView)
			self.window = gui.window_create("contexthelper.window", getTitle(), self.boxLayout)
			--self.window:setIcon("ui/design/window-content/context-help.tga")
			local w = api.gui.util.getById("contexthelper.window")
			w:setFocusable(false)
			w:getCore():addHighPriorityProcessingComponent(w)
			self.window:onClose(function ()
				w:getCore():removeHighPriorityProcessingComponent(w)
				self.window = nil
				self.textView = nil
				self.imageView = nil
				self.boxLayout = nil
			end)
			
			w:setInputActionForward("IA_CONTEXT_HELP", w, "IA_MENU_BACK");

			local isCouchMode = apputil.isCouchUiMode()

			if isCouchMode then
			    w:setInputActionBubbleUpAcceptFilter({ "IA_CLOSE", "IA_MENU", "IA_CLOSE_ALL_LONGPRESS", "uiCloseAll", "IA_BULLDOZER" }, false)
			end

			local mainView = game.gui.getContentRect("mainView")
			local mainMenuHeight = game.gui.getContentRect("mainMenuTopBar")[4] + game.gui.getContentRect("mainMenuBottomBar")[4]

			local y = mainView[4] - mainMenuHeight
			local x = 0

			if isCouchMode then
				x = mainView[3] / 2
				y = mainView[4] / 2
			end

			game.gui.window_setPosition(self.window.id, x, y)
		end,
		close = function(self)
			if self.window == nil then
				error("context helper closed twice")
			end
			self.window:close()
		end,
		setContent = function(self, image, text, title)
			local origin = nil
			if self.window then
				origin = getOrigin(self)
			end
			
			if self.imageView then self.imageView:setImage(image) end
			if self.textView then self.textView:setText(text, textwidth) end
			if self.window then self.window:setTitle(title) end
		end,
		refresh = function(self)
			self:setContent(getImage(), getText(), getTitle())
		end
	}
})
guiState.fn = function() contextHelperGui:refresh() end

local initDone = false
local openAtStart = false
contexthelper.script = {
	init = function ()
		openAtStart = true
	end,
	guiInit = function ()
		if (apputil.isGamepadInputMode()) then
			welcomeText = _("HELP_WELCOME_COUCH")
		end
		initHelperTexts()
		initHelperImages()
		initHelperTitles()
	end,
	save = function ()
		return { openAtStart = openAtStart }
	end,
	load = function (state)
		if state == nil then return end
		openAtStart = state.openAtStart or false
	end,
	update = function ()
		openAtStart = false
	end,
	guiUpdate = function ()
		if initDone == false then
			guiState:reset()
			if game.gui.isGuideSystemActive() and openAtStart then
				contextHelperGui:open()
				
				if game.gui.isEditor() then
					contextHelperGui:setContent(defaultImage, getMouseOrGamepad(defaultTextEditor, defaultTextEditorCouch), defaultTitle)
				else
					welcomeText = welcomeText:gsub("\n\n", "\n")
					welcomeText = welcomeText:gsub("\n", "\n\n")
				
					contextHelperGui:setContent(welcomeImage, welcomeText, welcomeTitle)
				end
			end
			initDone = true
		end
	end,
	guiHandleEvent = function (id, name, param)
		--print("guiHandleEvent " .. id .. " " .. name .. " " .. tostring(param))

		if (helperTexts == nil or helperImages == nil or helperTitles == nil) then
			return
		end

		if id == "menu.contexthelper" and name == "button.click" then
			if contextHelperGui.window == nil then
				contextHelperGui:open()
			else
				contextHelperGui:close()
			end
		elseif id == "menu.construction" and name == "tabWidget.currentChanged" then
			if param.index < 0 then
				guiState:menuConstructionTab(nil)
				guiState:close(menuConstruction)
			else
				guiState:menuConstructionTab(param.id)
				guiState:open(menuConstruction)
			end
		elseif id == "menu.construction.rail.tabs" and name == "tabWidget.currentChanged" then
			guiState:menuConstructionSubTab("menu.construction.rail", param.index + 1)
		elseif id == "menu.construction.road.tabs" and name == "tabWidget.currentChanged" then
			guiState:menuConstructionSubTab("menu.construction.road", param.index + 1)
		elseif id == "menu.construction.water.tabs" and name == "tabWidget.currentChanged" then
			guiState:menuConstructionSubTab("menu.construction.water", param.index + 1)
		elseif id == "menu.construction.air.tabs" and name == "tabWidget.currentChanged" then
			guiState:menuConstructionSubTab("menu.construction.air", param.index + 1)
		elseif id == "menu.construction.terrain.tabs" and name == "tabWidget.currentChanged" then
			guiState:menuConstructionSubTab("menu.construction.terrain", param.index + 1)
		elseif id == "menu.construction.town.tabs" and name == "tabWidget.currentChanged" then
			guiState:menuConstructionSubTab("menu.construction.town", param.index + 1)
		elseif id == "menu.construction.industry.tabs" and name == "tabWidget.currentChanged" then
			guiState:menuConstructionSubTab("menu.construction.industry", param.index + 1)
		elseif id == "menu.construction.heightmapmenu" and name == "tabWidget.currentChanged" then
			guiState:menuConstructionSubTab("menu.construction.heightmap", param.index + 1)
		elseif id == "menu.construction.generatemenu" and name == "tabWidget.currentChanged" then
			guiState:menuConstructionSubTab("menu.construction.generate", param.index + 1)

		elseif id == "menu.layersButton" and name == "toggleButton.toggle" then
			guiState:toggle(menuLayers, param)

		elseif id == "menu.layers.landuseButton" and name == "toggleButton.toggle" then
			guiState:menuLayersCurrent(2, param)
		elseif id == "menu.layers.contoursButton" and name == "toggleButton.toggle" then
			guiState:menuLayersCurrent(3, param)
		elseif id == "menu.layers.watersButton" and name == "toggleButton.toggle" then
			guiState:menuLayersCurrent(4, param)
		elseif id == "menu.layers.speedLimitsButton" and name == "toggleButton.toggle" then
			guiState:menuLayersCurrent(5, param)
		elseif id == "menu.layers.destinationButton" and name == "toggleButton.toggle" then
			guiState:menuLayersCurrent(6, param)
		elseif id == "menu.layers.cargoButton" and name == "toggleButton.toggle" then
			guiState:menuLayersCurrent(7, param)
		elseif id == "menu.layers.stationsButton" and name == "toggleButton.toggle" then
			guiState:menuLayersCurrent(8, param)
		elseif id == "menu.layers.trafficLayerButton" and name == "toggleButton.toggle" then
			guiState:menuLayersCurrent(9, param)
		elseif id == "menu.layers.emissionLayerButton" and name == "toggleButton.toggle" then
			guiState:menuLayersCurrent(10, param)
		elseif id == "menu.layers.hudFilterButton" and name == "toggleButton.toggle" then
			guiState:menuLayersCurrent(11, param)
		elseif id == "menu.finances.category" and name == "visibilityChange" then
			guiState:toggle(menuFinances, param)
		elseif id == "menu.finances.category" and name == "tabWidget.currentChanged" then
			guiState:menuFinancesTab(param.id)

		elseif id == "menu.stats.lines" and name == "toggleButton.toggle" then
			guiState:menuStatsCurrent("menu.stats.lines", param)
		elseif id == "menu.stats.lines.table" and name == "visibilityChange" then
			guiState:menuStatsCurrent("menu.stats.lines", param)

		elseif id == "menu.stats.vehicles" and name == "toggleButton.toggle" then
			guiState:menuStatsCurrent("menu.stats.vehicles", param)
		elseif id == "menu.stats.vehicles.table" and name == "visibilityChange" then
			guiState:menuStatsCurrent("menu.stats.vehicles", param)

		elseif id == "menu.stats.stations" and name == "toggleButton.toggle" then
			guiState:menuStatsCurrent("menu.stats.stations", param)
		elseif id == "menu.stats.stations.table" and name == "visibilityChange" then
			guiState:menuStatsCurrent("menu.stats.stations", param)

		elseif id == "menu.stats.towns" and name == "toggleButton.toggle" then
			guiState:menuStatsCurrent("menu.stats.towns", param)
		elseif id == "menu.stats.towns.table" and name == "visibilityChange" then
			guiState:menuStatsCurrent("menu.stats.towns", param)

		elseif id == "menu.stats.industries" and name == "toggleButton.toggle" then
			guiState:menuStatsCurrent("menu.stats.industries", param)
		elseif id == "menu.stats.industries.table" and name == "visibilityChange" then
			guiState:menuStatsCurrent("menu.stats.industries", param)

		elseif id == "menu.lineManager" and name == "toggleButton.toggle" then
			guiState:toggle(menuLineManager, param)
		elseif id == "menu.vehicleManager" and name == "toggleButton.toggle" then
			guiState:toggle(menuVehicleManager, param)
		elseif id == "menu.bulldozer" and name == "toggleButton.toggle" then
			guiState:toggle(menuBulldozer, param)
		elseif id == "mainView" and name == "select" then
			local e = game.interface.getEntity(param)
			if e then
				if e.type == "TOWN" then
					guiState:townWindow(e)
				elseif e.type == "SIM_BUILDING" or (e.type == "CONSTRUCTION" and e.simBuildings[1] ~= nil) then
					guiState:industryWindow(e)
				elseif e.type == "STATION_GROUP" then
					guiState:stationGroupWindow(e)
				end
			end
		elseif id == "window.locateButton" and name == "destroy" then
			--reset most recently used flag for townwindow and industry window whenever any window is closed (otherwise nothing resets them)
			guiState.access[townWindow] = nil
			guiState.access[industryWindow] = nil
			guiState.access[stationGroupWindow] = nil
		end
		--guiState:debugPrint()
	end
}

contexthelper.open = function()
	contextHelperGui:open()
end

contexthelper.close = function()
	contextHelperGui:close()
end

return contexthelper
