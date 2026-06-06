require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local hp = 10
local vp = 5

local contentPadding = 10

local constructionMenuMainColor = ssu.makeColor(5+25, 25+25, 40+25, 200)
local constructionMenuBackColor = ssu.makeColor(5, 25, 40, 210)
local constructionMenuHoverColor = ssu.makeColor(5+10, 25+10, 40+10, 200)

local positiveColor = { .6, .8, 1.0, 1.0 }
local negativeColor = { 1.0, .6, .6, 1.0 }
local warningColor = { 1.0, 1.0, .4, 1.0 }

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("ConstructionContent::Layout", {
		gravity = { -1.0, 1.0 },
	})
	
	a("!color-button Button::Layout, !ui-couch Vehicle::Overview::VehicleButtons Button::Layout", {
		gravity = { 0.5, 0.5 },
	})

	a([[!color-button Button::Icon, 
		!ui-couch Vehicle::Overview::VehicleButtons SimpleButton,
		!ui-couch Vehicle::Overview::VehicleButtons SimpleButton::Icon]], {
	    size = {34, 34},
	})

	a("ConfigureButton, !color-button, !ui-couch Vehicle::Overview::VehicleButtons SimpleButton, !ui-couch !follow-button", {
		backgroundColor = ssu.makeColor(83, 151, 198, 200),
		gravity = { 0.5, 1.0 }
	})

	a("ConfigureButton:hover, !color-button:hover, !ui-couch Vehicle::Overview::VehicleButtons SimpleButton:hover, !ui-couch !follow-button:hover", {
		backgroundColor = ssu.makeColor(106, 192, 251, 200)
	})

	a("ConfigureButton:active, !color-button:active, !ui-couch Vehicle::Overview::VehicleButtons SimpleButton:active, !ui-couch !follow-button:active", {
		backgroundColor = ssu.makeColor(161, 217, 255, 200),
		soundEffect1 = sound.get("buttonClick")
	})

	a("ConfigureButton:disabled, !color-button:disabled, !ui-couch Vehicle::Overview::VehicleButtons SimpleButton:disabled, !ui-couch !follow-button:disabled", {
		backgroundColor = ssu.makeColor(160, 180, 190, 50),
	})

	a("ConfigureButton::Icon:disabled, ConfigureButton::Text:disabled, !color-button:disabled Button::Icon:disabled, !ui-couch Vehicle::Overview::VehicleButtons SimpleButton::Icon:disabled, !ui-couch !follow-button SimpleButton::Icon:disabled", {
		color = ssu.makeColor(0, 0, 0, 150),
	})

	a("ConfigureButton::Text", {
		padding = { vp, hp, vp, hp },
		fontSize = 13,
		textTransform = "UPPERCASE"
	})

	a("!ui-couch ConfigureButton::Text", {
		fontSize = ssu.styles.uicouch_primarybuttons_fontSize,
		textTransform = ssu.styles.uicouch_primarybuttons_textTransform
	})

	a("Window!missing-res-window", {
		gravity = {0.5, 0.5},
		anchorPoint = {0.5, 0.5}
	})

	a("!ui-couch Window!missing-res-window Window::Close!window-button", {
		actionPromptList = {
			{ ia = "ACTION_CLICK", text = _("Close") },
		}
	})

	a("Window!sim-person-extension", {
	    size = {400, 300}
	})
	a("Window!sim-person-extension !person-overview !name-button", {
	    gravity = {-1, 0.5},
	})
	a("Window!sim-person-extension !person-overview TextView", {
	    padding = { vp, 0, vp, 0}
	})

	a("!sim-person-extension !target-town Button::Text", {
		textTransform = "NONE",
	})

	a("Window!animal-extension", {
	    size = {400, 250}
	})

	a("Window!vehicle-view", {
	    size = {400, 350}
	})

	a("Window!line-extension", {
	    size = {400, 500}
	})

	a([[!ui-couch Window!line-extension,
		!ui-couch Window!vehicle-view,
		!ui-couch Window!animal-extension,
		!ui-couch Window!sim-person-extension]], {
		margin = { 0, 10, 0, 0 },
	    size = ssu.sizes.ui_couch_extension_window_size,
		anchorPoint = { 1, 0 }
	})

	a("Window!vehicle-store", {
	    size = {1000, 620},
	    minSize = {300, 200},
	    anchorPoint = { 0.5, 1 },
	    gravity = { 0.5, 1 },
	})
	a("!ui-couch Window!vehicle-store", {
		margin = { 10, 10, 100, 10 },
		gravity = { -1, -1 },
		anchorPoint = { -1, -1 },
	    size = { "100vw", "100vh"},
	    minSize = { "100vw", "100vh"},
	    maxSize = { "100vw", "100vh"},
	})

	a("Window!finances-manager", {
	    size = {800, 600},
	    minSize = {550, 300},
		anchorPoint = { -1, -1 },
	})

	a("!ui-couch Window!finances-manager", {
		margin = { 10, 10, 100, 10 },
		gravity = { -1, -1 },
		anchorPoint = { -1, -1 },
	    size = { "100vw", "100vh"},
	    minSize = { "100vw", "100vh"},
	    maxSize = { "100vw", "100vh"},
	})

	a("Window!fullscreen Window::Content", {
		margin = { 10, 10, 10, 10 },
	})

	a([[!ui-couch Window!line-manager !close-button,
		!ui-couch Window!vehicle-manager !close-button,
		!ui-couch!input-controller Window!finances-manager !close-button,
		!ui-couch Window!statistics !close-button,
		!ui-couch Window!finances-manager ConfigureButton]], {
		visibility = "folded"
	})

	a([[!ui-couch Window SimBuilding::Overview LevelLabel,
		!ui-couch Window SimBuilding::Overview StockRuleLabel,
		!ui-couch Window SimBuilding::Overview StockListBarLabel,
		!ui-couch Window SimBuilding::Overview SimBuilding::StocksLabel,
		!ui-couch Window SimBuilding::Overview Table Label!table-header]], {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a([[!ui-couch FinancesManager Label]], {
		fontSize = ssu.styles.uicouch_body_fontSize
	})


	a("!ui-couch!input-mouse Window!statistics !close-button", {
		visibility = "visible"
	})

	a("Window!statistics", {
		size = {1000, 400},
		minSize = {600, 200},
		maxSize = {1400, 2000},
	    anchorPoint = { 0.5, 1 },
	    gravity = { 0.5, 1 },
	    padding = { 0, 0, 20, 0 },
	})

	a("!ui-couch Window!statistics", {
	    size = {"100vw", "45vh"}
	})

	a("!ui-couch Window!entity-window", {
		margin = { 0, 10, 0, 0 },
		anchorPoint = { 1, 0 },
		size = ssu.sizes.ui_couch_extension_window_size
	})

	a("Window!entity-window:attached", {
		backgroundColor = ssu.makeColor(70, 83, 93, 0),
		shadowNinePatch = { fileName = "ui/design/window/tooltip.tga", horizontal = { 0, 30, 84, 100 }, vertical = { 0, 15, 68, 100 } },
		shadowWidth = { 12, 15, 20, 13 },
		shadowColor = ssu.makeColor(255, 255, 255, 200),
	})

	a("Window!entity-window:attached Window::Title-bar", {
		backgroundColor = ssu.makeColor(0, 0, 0, 0),
		backgroundColor1 = ssu.makeColor(0, 0, 0, 0),
		borderColor = ssu.makeColor(0, 0, 0, 0),
	})

	a([[!ui-couch Vehicle::Overview Button KeybindingHintDisplay!overflowMode,
		!ui-couch Window::Content SimpleButton KeybindingHintDisplay!overflowMode,
		!ui-couch Window::Content !person-overview Button KeybindingHintDisplay!overflowMode,
		!ui-couch ColorChooserButton Button KeybindingHintDisplay!overflowMode,
		!ui-couch ConfigureButton KeybindingHintDisplay!overflowMode,
		!ui-couch StationTerminalPopup Button KeybindingHintDisplay!overflowMode,
		!ui-couch Window::Content Button!missionOption KeybindingHintDisplay!overflowMode,
		!ui-couch Window!missing-res-window Button!simple-button KeybindingHintDisplay!overflowMode]], {
		scaling = ssu.styles.action_keybinding_scale,
		gravity = ssu.styles.action_keybinding_gravity
	})

	a("!signal-view", {
		anchorPoint = { 0, 1 },
		size = {400, 200}
	})

	a("!ui-couch !signal-view", {
		margin = { 0, 10, 0, 0 },
		size = ssu.sizes.ui_couch_extension_window_size
	})

	a("!signal-view CheckBox", {
		margin = { 0, 0, 0 ,hp},
		gravity = { 0, 0 },
	})

	a("Vehicle::Overview::Layout", {
		innerSpacing = { 0, 0 }
	})
	
	a("!ui-classic Vehicle::Overview::VehicleButtons BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	a("!ui-couch Vehicle::Overview::VehicleButtons BoxLayout", {
		innerSpacing = { 5, 0 }
	})

	a("!ui-classic Vehicle::Overview::VehicleButtons, VehicleDebug", {
		backgroundColor = ssu.makeColor(0, 0, 0, 100)
	})

	a("!ui-couch Vehicle::Overview::VehicleButtons", {
		gravity = { 0.5, 0.0 }
	})

	a("!follow-button", {
		backgroundColor = ssu.makeColor(0, 0, 0, 100),
		gravity = { .0, .0 }
	})
	
	a("VehicleStateText!vehicle-warning", {
		backgroundColor = ssu.makeColor(255, 200, 0, 200),
		padding = { vp, hp, vp, hp },
		gravity = { -1.0, .0 }
	})
	
	a("VehicleCargo BoxLayout", {
		innerSpacing = { 20, 5 },
		outerSpacing = { 10, 5 },
		gravity = { .5, .5 }
	})

	a("VehicleContent SlowerLoadingIcon", {
		color = positiveColor,
		margin = { 0, hp, 0, 0 },
		scaling = 2 / 3
	})

	a("Animal::MovementText", {
		padding = { vp, hp, vp, hp }
	})
	
	a("Person::OverviewLayout", {
		outerSpacing = { hp, vp }
	})
	
	a("Line::Settings::Layout", {
		innerSpacing = { hp, vp },
		outerSpacing = { hp, vp }
	})
	
	a("StationGroupDisplayComp::OverloadedIcon", {
		color = positiveColor,
		scaling = 2 / 3,
		margin = { 0, hp, 0, 0 },
		gravity = { 1.0, .5 }
	})
	
	a("StationGroupDisplayComp !via-label", {
		padding = { vp, 0, vp, 2 * hp }
	})
	
	a("StationGroupTerminalsComp::LinesComp BoxLayout", {
		innerSpacing = { 0, 0 }
	})

	a("StationGroupTerminalsComp::LinesComp TextView", {
		padding = { vp, hp, vp, 0 }
	})
	
	a("StationGroupTerminalsComp::OverloadedIcon", {
		color = positiveColor,
		scaling = 2 / 3,
		margin = { 0, hp, 0, 0 },
		gravity = { 1.0, .5 }
	})
	
	a("StationTerminalPopup::Terminal::Icon", {
		padding = { 0, 0, 0, hp }
	})

	a("!ui-couch Window!finances-manager ExpandButton", {
		padding = {0, 0, 0, 20}
	})

	a("!ui-couch Window!finances-manager ExpandButton KeybindingHintDisplay!overflowMode", {
	    gravity = { 0.0, 0.5 },
	    margin = { 0, -5, 0, 0},
	})

	a("!ui-couch Window!finances-manager Window::Title-edit, !ui-couch Window!finances-manager Window::Locate", {
	    visibility = "transparent"
	})
	
	a("FinancesManager::ButtonLayout, HQComp::ButtonsLayout", {
		gravity = { .5, .5 },
		innerSpacing = { hp, vp },
		outerSpacing = { hp, vp },
	})

	a("BuyRevButton::Text", {
		textAlignment = { 1.0, .5 },
	})

	a("#finances.borrow BuyRevButton::Text, #finances.repay BuyButton::Text", {
		minSize = { 100, -1 }
	})

	a("BuyButton KeybindingHintDisplay!overflowMode", {
	    gravity = { 1.0, 0.5 },
	    margin = { 0, 0, 0, 25 },
	})

	a("BuyRevButton KeybindingHintDisplay!overflowMode", {
	    margin = { 0, 25, 0, 0 },
	})

	a("HQComp ConfigureButton#menu.finances.buildHQ KeybindingHintDisplay!overflowMode", {
	    margin = { 0, 10, 0, 0 },
	})

	a("HQComp ConfigureButton#menu.finances.renameCompany KeybindingHintDisplay!overflowMode", {
	    gravity = { 1.0, 0.5 },
	    margin = { 0, 0, 0, 10 },
	})

	a("HQComp ConfigureButton#menu.finances.renameCompany ConfigureButton::Icon", {
	    margin = { 11, 0, 11, 12 },
	})

	a("!ui-couch TextInputField, !ui-couch DoubleSpinBox::Input", {
		actionPromptList = {
			{ia = "IA_TEXT_ACCEPT", text = _("Apply")},
		}
	})
	a("!ui-couch!input-mouse TextInputField, !ui-couch!input-mouse DoubleSpinBox::Input", {
		actionPromptList = {
			{ia = "IA_MENU_BACK", text = _("Cancel")},
		}
	})

	a([[!ui-couch Window!entity-window ComboBox,
		!ui-couch Window!signal-view ComboBox]], {
		padding = { 0, 10, 0, 10 },
	})

	a("!ui-couch!input-controller !entity-window Window::Locate!window-button", {
	    visibility = "folded"
	})

	a("!ui-couch!input-controller !entity-window Window::Title-edit!window-button", {
	    visibility = "folded"
	})

	a("!ui-couch!input-controller !entity-window Window::Close!window-button", {
	    visibility = "transparent"
	})

	a("!ui-couch!input-controller Window::Locate", {
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Locate")},
		}
	})

	a("!ui-couch!input-controller Window::Title-edit", {
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Rename")},
		}
	})

	a("!ui-couch TownEditorComp CargoItem!left-column", {
	    minSize = {20, -1},
		maxSize = {30, -1},
		margin = { 0, 0, 0, 10 },
	})

	a("!ui-couch TownEditorComp LabelValueItemGroup", {
		margin = { -5, 0, -5, -10 },
	})
	
	a("!ui-couch TownEditorComp LabelValueItemGroup > TextView!label", {
		maxSize = {170, -1},
		margin = { 0, 0, 0, 0 },
	})

	a("!ui-couch TownEditorComp  LabelValueItemGroup > CheckBoxWrapper!value", {
		margin = { 0, 0, 0, -20 },
	})

	a("!ui-couch TownEditorComp > LabelValueItemGroup > TextView!label", {
		margin = { 0, 0, 0, 10 },
	})

	a("!ui-couch TownEditorComp > LabelValueItemGroup > CheckBoxWrapper!value", {
		maxSize = {150, -1},
		margin = { 5, 15, 0, 0 },
	})

	a("!input-controller TownEditorComp > LabelValueItemGroup:hover", {
		backgroundColor = ssu.makeColor(70, 150, 255, 70)
	})

	a("!ui-couch TownEditorComp!tab-widget-content !list-item", {
		padding = { 0, 10, 0, 0 },
	})

	a("!ui-couch TownEditorComp!tab-widget-content NavList ComboBox!style-left-right!center-column", {
        margin = { 0, 0, 0, 0 },
		gravity = { -1, -1 }
	})

	a("Window!music-player", {
	    size = {300, 150},
	})

	a([[Window!music-player Slider!slider]], {
		minSize = {150, 5},
	})

	a("!ui-couch Window!music-player", {
		anchorPoint = {-1, -1},
	    size = {300, 150},
	})

	a("!ui-couch Window!music-player MusicPlayer::PlayButtonsLayout", {
		gravity = {0.5, 0.5},
		
	})
	a("!ui-couch Window!music-player MusicPlayer::SliderButtonsLayout", {
		outerSpacing = { 10, 0, 10, 0 },
	})

	a([[!input-controller Window!music-player Button:hover,
		!input-controller Window!music-player !music-player-slider:hover,
		!input-controller Window!music-player !music-player-slider:active]], {
		backgroundColor = ssu.makeColor(70, 150, 255, 70)
	})

	a("!ui-couch Window!music-player MusicPlayer#musicPlayer", {
		gravity = {0.5, 0.5},
		size = {300, 100},
		minSize = {300, 100},
		maxSize = {300, 100}
	})

    a([[!ui-couch!input-controller Window!music-player Window::Close]], {
		visibility = "transparent"
	})

	a("Window!music-player KeybindingHintDisplay", {
		scaling = ssu.styles.action_keybinding_scale,
		gravity = ssu.styles.action_keybinding_gravity
	})

	a("!ui-couch #missionDisplayWindow", {
		margin = { 0, 10, 0, 0 },
	})

	a("!input-controller #missionDisplayWindow Window::Close!window-button", {
	    visibility = "transparent"
	})
	
	a("!ui-couch  DataTable#menu.stats.towns.table  DataTable::HeaderItem!table-header !statistics-table-header", {
		minSize = { -1, 30 },
	})
	
	return result
end
