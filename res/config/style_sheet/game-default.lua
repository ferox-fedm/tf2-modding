require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local hp = 10
local vp = 5

local positiveColor = { .6, .8, 1.0, 1.0 }

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("CGameUI *:hover", {
		soundEffect1 = { },
		soundEffect2 = { }
	})

	a([[!ui-couch StatisticsWindow DataTable#menu.stats.lines.table,
		!ui-couch StatisticsWindow DataTable#menu.stats.vehicles.table]], {
		actionPromptList = { 
			{ ia = "IA_OPTION2", text = _("Filter/Sort") },
		},
	})

	a([[!ui-couch StatisticsWindow DataTable#menu.stats.stations.table,
		!ui-couch StatisticsWindow DataTable#menu.stats.towns.table,
		!ui-couch StatisticsWindow DataTable#menu.stats.industries.table]], {
		actionPromptList = { 
			{ ia = "IA_OPTION2", text = _("Sort") },
		},
	})

	a("!ui-couch LineManager!manager-win", {
		actionPromptList = { 
			{ ia = "IA_OPTION2", text = _("Filter") },
		},
	})
	a("!ui-couch!input-controller LineManager!manager-win RowWrap", {
		actionPromptList = {
			{ ia = "IA_TABRIGHT", text = _("Delete Line") },
		},
	})
	a("!ui-couch!input-controller LineManager!manager-win RowWrap Button!rename", {
		actionPromptList = {
			{ ia = "ACTION_CLICK", text = _("Rename") },
		},
	})
	a("!ui-couch LineManager!manager-win #lineManager.newLine", {
		actionPromptList = { 
			{ ia = "ACTION_CLICK", text = _("New Line") },
		},
	})

	a("!ui-couch!input-controller LineManager::LineEditorComp Button!delete-station-button", {
		actionPromptList = { 
			{ ia = "ACTION_CLICK", text = _("Delete Station") },
		},
	})
	a("!ui-couch!input-controller LineManager LineEditor LineFilterItem::RowComp!table-item Button!rename", {
		actionPromptList = { 
			{ ia = "ACTION_CLICK", text = _("Rename") },
		},
	})
	a("!ui-couch!input-controller VehicleManager LineFilterItem::RowComp!table-item Button!rename", {
		actionPromptList = { 
			{ ia = "ACTION_CLICK", text = _("Rename") },
		},
	})
	a("!ui-couch!input-controller VehicleManager LineDepotFilter LineFilterItem::ButtonComp Button!rename", {
		actionPromptList = { 
			{ ia = "ACTION_CLICK", text = _("Rename") },
		},
	})
	a("!ui-couch LineManager::LineEditorComp #lineEditor.addStation", {
		actionPromptList = { 
			{ ia = "IA_SELECT", text = _("Add Station") },
		},
	})

	a("ColorChooser::Color", {
		size = { 20, 20 }
	})
	a("ColorChooser Button", {
		borderColor = { 0, 0, 0, 0 },
		borderWidth = { 1, 1, 1, 1 },
	})
	a("!ui-couch ColorChooser Button", {
		borderWidth = { 2, 2, 2, 2 },
	})
	a("ColorChooser Button:hover", {
		borderColor = ssu.makeColor(255, 255, 255),
	})
	
	a("ColorChooser::Color::Icon", {
		margin = { 1, 1, 1, 1 },
		backgroundColor = ssu.makeColor(130, 130, 130, 130),
	})
	
	a("ColorChooser::Layout", {
		outerSpacing = { hp, vp },
	})
	
	a("LineColorComp", {
		size = { 14, 14 },
		margin = { 0, 0, 0, hp },
		backgroundImage1 = { fileName = "ui/design/buttons/line_surface.tga" },
	})

	a([[CGameUI WindowContainer,
		BulldozerBar]], {
		margin = { 0, 0, 65, 0 }
	})

	a([[!ui-couch CGameUI WindowContainer,
		!ui-couch!input-controller BulldozerBar]], {
		margin = { 0, 0, 30, 0 }
	})

	a([[!ui-couch !top-gamebar-visible Window!vehicle-manager,
		!ui-couch !top-gamebar-visible Window!line-manager]], {
		margin = { 0, 0, 25, 0 }
	})

	a("Button!start-game-button:active", {
		soundEffect1 = sound.get("startGame")
	})
	a("Button!start-game-button", {
		margin = { 0, 0, 0, 50 }
	})
	
	a("!neutral-message", {
		backgroundColor = ssu.makeColor(0, 0, 0, 0)
	})
	
	a("!info-message", {
		backgroundColor = ssu.makeColor(83, 151, 198, 200)--ssu.makeColor(125, 175, 235, 200)
	})
	
	a("!warning-message", {
		backgroundColor = ssu.makeColor(255, 200, 0, 200),
	})

	a("MissingResources::Layout", {
		gravity = {-1.0, 0.0}
	})
	a("MissingResources::CompLayout", {
		minSize = {-1, 55}
	})
	a("MissingResources::ButtonLayout", {
		gravity = {1.0, 0}
	})

	a("MissingResources::VehicleUpdateButton", {
		margin = { 0, 10, 0, 0 }
	})

	a("BuyButton, BuyToggleButton, MissingResources::VehicleUpdateButton", {
		backgroundColor1 = ssu.makeColor(83, 151, 198, 200),
		backgroundImage1 = { fileName = "ui/design/buttons/button_guide.tga", horizontal = { 0, 21, 21, 34 }, vertical = { 0, 17, 18, 34 } },
		padding = { 0, 15, 0, 0 },
		minSize = { 0, 34 }
	})
	a("BuyRevButton", {
		backgroundColor1 = ssu.makeColor(83, 151, 198, 200),
		backgroundImage1 = { fileName = "ui/design/buttons/button_guide_left.tga", horizontal = { 0, 21, 21, 34 }, vertical = { 0, 17, 18, 34 } },
		padding = { 0, 0, 0, 15 },
		minSize = { 0, 34 }
	})
	a("!ui-couch Window!finances-manager BuyButton, !ui-couch BuyRevButton", {
		visibility = "folded"
	})
	a("BuyButton:hover, BuyToggleButton:hover, BuyRevButton:hover, MissingResources::VehicleUpdateButton:hover", {
		backgroundColor1 = ssu.makeColor(106, 192, 251, 200),
	})
	a("BuyButton:active, BuyToggleButton:active, BuyRevButton:active, MissingResources::VehicleUpdateButton:active", {
		backgroundColor1 = ssu.makeColor(161, 217, 255, 200),
	})
	a("BuyButton:disabled, BuyToggleButton:disabled, BuyRevButton:disabled, MissingResources::VehicleUpdateButton:disabled", {
		backgroundColor1 = ssu.makeColor(160, 180, 190, 50),
	})
	a([[BuyButton::Icon:disabled, BuyButton::Text:disabled, MissingResources::Button::Icon:disabled,
		BuyToggleButton::Icon:disabled, BuyToggleButton::Text:disabled,
		BuyRevButton::Icon:disabled, BuyRevButton::Text:disabled]], {
		color = ssu.makeColor(0, 0, 0, 150),
	})
	
	a("BuyButton::Text, BuyToggleButton::Text, BuyRevButton::Text", {
		padding = { vp, hp, vp, hp },
		fontSize = 13,
		textTransform = "UPPERCASE"
	})
	a([[!ui-couch BuyButton::Text,
		!ui-couch BuyToggleButton::Text,
		!ui-couch BuyRevButton::Text,
		!ui-couch TownGrowthComp::Label,
		!ui-couch TownGrowthComp::TargetLabel,
		!ui-couch TownGrowthComp::Value,
		!ui-couch TownGrowthComp::InitSizeValue,
		!ui-couch TownGrowthComp::TargetSizeValue,
		!ui-couch TownGrowthComp::Score!negative,
		!ui-couch TownGrowthComp::Score!positive,
		!ui-couch TownGrowthComp::RatingSumValue!negative,
		!ui-couch TownGrowthComp::RatingSumValue!positive,
		!ui-couch MissingResources::VehicleUpdateButton::Text]], {
		fontSize = ssu.styles.uicouch_body_fontSize
	})

	a("DepotButton::Icon", {
		margin = { 0, 0, 0, hp }
	})

	a("LineButton::Text, DepotButton::Text", {
		padding = { vp, hp, vp, hp }
	})
	a("LineButton::Text:disabled, DepotButton::Text:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})

	a("CargoItem", {
		padding = { vp, hp/4, vp, hp/4 }
	})
	a("CargoItemAggregate", {
		padding = { vp, 0, vp, hp/4 }
	})
	a("CargoItem::Layout", {
		innerSpacing = { 5, 0 }
	})
	a("CargoItem::Icon, CargoItem::Refittable", {
		scaling = 2.0 / 3.0
	})
	
	a("CargoItem::Icon!passengers", {
		padding = { 0, 6, 0, 7 }
	})
	
	a("EntityLink Button::Text, !ui-couch EntityLink Button::Text", {
		textTransform = "NONE"
	})

	a("EntityLink::OverloadedIcon", {
		padding = { vp, hp, vp, hp },
		color = positiveColor,
		scaling = 2 / 3,
		margin = { 0, 0, 0, hp },
		gravity = { 1.0, .5 }
	})

	a([[BuyButton:active,
		BuyRevButton:active,
		BuyToggleButton:active,
		DepotButton:active,
		LineButton:active]], {
		soundEffect1 = sound.get("buttonClick")
	})
	
	a("InGameConsole", {
		backgroundColor = { 0, 0, 0, 0.3 },
		blurRadius = 16 * 4
	})
	
	a("InGameConsole::TextInput", {
		backgroundColor = { 1, 1, 1, 0.05 },
		fontFamily = "Noto/NotoSansMono-Regular.ttf"
	})

	a("InGameConsole::TextInput!selected-text", {
		color = { 1, 1, 1, 0.25 },
	})

	a("InGameConsole::ScrollArea::TextView", {
		fontFamily = "Noto/NotoSansMono-Regular.ttf"
	})

	a("InGameConsole::Button", {
		padding = {4,4,4,4}
	})

	a("InGameConsole::Button *:hover", {
		backgroundColor = { 1, 1, 1, 0.65 },
	})

	a("!town-editor-tab Space", {
	    margin = {20, 0, 0, 0},
	})
	a("!town-editor-line ComboBox!center-column", {
	    margin = {0, 30, 0, 10},
	})
	a("!town-editor-line !left-column", {
	    minSize = {100, 0},
	})
	a("town-editor-line !right-column", {
	    minSize = {30, 0},
	})

	return result
end
