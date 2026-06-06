require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local hp = 10
local vp = 5

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("Window!vehicle-manager", {
	    anchorPoint = { 0.5, 1 },
	    gravity = { 0.5, 1 },
	    size = {1000, 350},
		padding = { 0, 0, 25, 0} --HACK avoid overlap
	})
	a("!ui-couch Window!vehicle-manager", {
	    size = {"100vw", 250},
	})

	a("!ui-couch Window!vehicle-manager Window::Title-bar", {
	    visibility = "folded",
	})

	a([[!ui-couch VehicleManager InputTextScrollArea,
		!ui-couch VehicleStore::VehicleAndCargoFilter InputTextScrollArea]], {
		visibility = "none"
	})

	a("VehiclesTable#menu.stats.vehicles.table LineFilterItem::ButtonComp", {
		visibility = "none"
	})

	a("VehicleManager LinearLayout", {
		innerSpacing = { hp, vp }
	})
	
	a("VehicleManager::VehicleButtons", {
		backgroundColor = ssu.makeColor(83, 151, 198, 200),
	})

	a("VehicleManager Button!locate-button", {
		visibility = "none"
	})

	a("VehicleManager::VehicleButtons Button", {
		padding = { vp, vp, vp, vp }
	})
	a("VehicleManager::VehicleButtons::Space", {
		--backgroundColor = ssu.makeColor(255, 0, 0, 100),
		size = { 15, vp }
	})
	
	a("VehicleMaintenanceSettings", {
		minSize = { 200, 125 }
	})
	
	a("VehicleMaintenanceSettings::Layout", {
		innerSpacing = { hp, vp },
	})
	
	a("VehicleMaintenanceSettings::Label, VehicleMaintenanceSettings::Costs", {
		padding = { vp, hp, vp, hp }
	})
	
	a("VehicleMaintenanceSettings::SliderLayout", {
		innerSpacing = { hp, vp },
		outerSpacing = { hp, vp }
	})
	
	a("VehicleMaintenanceSettings::SliderLabel", {
		minSize = { 75, 0 },
	})
	
	a("VehicleMaintenanceSettings Slider", {
		gravity = { -1.0, .5 }
	})
	
	a("VehicleMaintenanceSettings Button", {
		gravity = { 1.0, 1.0 }
	})

	a("VehicleManager LineDepotFilter::Header", {
		padding = { vp + 7, hp, 0, hp },
		fontSize = ssu.styles.uicouch_body_fontSize,
		gravity = { -1, 0.5 },
		size = { -1, 23 },
	})

	a("!ui-couch!input-controller VehicleManager LineDepotFilter LineFilterItem::ButtonComp !rename", {
		visibility = "folded"
	})
	a("!ui-couch VehicleManager #menu.vehicleManager.editButton", {
		visibility = "none"
	})

	a("!ui-couch VehicleManager Button!table-item-selectable:active", {
		soundEffect1 = sound.get("toggleOn")
	})

	a("!ui-couch BuyButton#vehicleManager.buyVehicles", {
		visibility = "folded"
	})

	a("!ui-couch VehicleManager!manager-win VehicleManager::Filter BuyButton#vehicleManager.buyVehicles", {
		actionPromptList = {
			{ ia = "ACTION_CLICK", text = _("Buy vehicles") },
		},
	})

	a("!ui-couch VehicleManager!manager-win wrap", {
		actionPromptList = { 
			{ ia = "IA_OPTION2", text = _("Filter/Sort") },
		},
	})

	a("!ui-couch!input-controller VehicleManager!manager-win VehicleManager::Vehicles", {
		actionPromptList = { 
			{ ia = "IA_BACK", text = _("Back") },
		},
	})

	a("!ui-couch!input-mouse !vehicle-manager VehicleManager VehicleManager::Close", {
		gravity = {0, 0},
		visibility = "visible"
	})

	a("!ui-couch VehicleManager::Fake", {
		actionPromptList = { 
			{ ia = "IA_OPTION4", text = _("Actions") }, 
		},
	})

	a("!ui-couch Popup LineList", {
		minSize = { 300, 100 }
	})

	a("!input-controller VehicleManager::Filter LineDepotFilter:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 15),
	})

	a("!input-controller VehicleManager::Vehicles Table:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 15),
	})

	a("!ui-classic VehicleManager LineDepotFilter::Header", {
		visibility = "none"
	})
	
	-- special cases where keybinding hint in table items should be centered
	a([[!ui-couch VehicleManager LineDepotFilter !table-item-selectable KeybindingHintDisplay!overflowMode]], {
		scaling = 0.65,
		gravity = { 0.9, 0.5 },
	})
	
	a("VehicleManager LineDepotFilter Button::Text", {
		gravity = { -1, 0.5 },
	})

	a("VehicleManager LineDepotFilter Button!fake-active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 100),
	})

	return result
end
