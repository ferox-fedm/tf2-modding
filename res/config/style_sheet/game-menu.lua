require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local hp = 10
local vp = 5
local defaultMargin = hp

local constructionMenuMainColor = ssu.makeColor(5+25, 25+25, 40+25, 200)
local constructionMenuBackColor = ssu.makeColor(5, 25, 40, 210)
local constructionMenuHoverColor = ssu.makeColor(5+10, 25+10, 40+10, 200)

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	result.animations = { }

	a("#menuLayout, #menuMainLayout", {
		innerSpacing = { 0, 0 }
	})
	
	a("#mainMenuLeftLayout, #mainMenuRightLayout, #mainButtonsLayout", {
		gravity = { -1.0, 1.0 }
	})
	
	a("#mainMenuTopBar", {
		size = { -1, 35 },
		gravity = { -1.0, 1.0 },
		backgroundImage1 = { fileName = "ui/design/game-menu/top_bar.tga" },
		backgroundImage2 = { fileName = "ui/design/game-menu/top_lines.tga" },
		backgroundColor1 = ssu.makeColor(255, 255, 255),
		backgroundColor2 = ssu.makeColor(255, 255, 255),
		shadowNinePatch = { fileName = "ui/design/game-menu/top_bar_shadow.tga", horizontal = { 0, 5, 5, 10 }, vertical = { 0, 5, 5, 10 } },
		shadowWidth = { 5, 0, 0, 0 },
		shadowColor = ssu.makeColor(0, 0, 0, 100),
		blurRadius = 6 * 4
	})
	
	a("MainMenuBottomBar", {
		size = { -1, 30 },
		backgroundImage1 = { fileName = "ui/design/game-menu/bottom_bar.tga" },
		backgroundColor1 = ssu.makeColor(255, 255, 255),
		blurRadius = 16 * 4
	})
	
	a("MainMenuBottomBar::LeftSpace", {
		size = { 200, 5 }
	})
	
	a("MainMenuBottomBar::Layout", {
		innerSpacing = { 10, 0 }
	})
	
	a("#menu.finances", {
		size = { 194, 85 },
		backgroundImage1 = { fileName = "ui/design/game-menu/finances_corner_behind.tga" },
		backgroundImage2 = { fileName = "ui/design/game-menu/finances_corner_surface.tga" },
        borderImage = { fileName = "ui/design/game-menu/finances_corner_contour.tga" },
		backgroundColor1 = ssu.makeColor(15, 35, 50, 180),
		backgroundColor2 = ssu.makeColor(255, 255, 255),
		borderColor = ssu.makeColor(255, 255, 255, 128)
	})
	a("#menu.finances!finances-button-hover", {
		backgroundColor1 = ssu.makeColor(183, 188, 193, 128),
		borderColor = ssu.makeColor(255, 255, 255)
	})
	a("#menu.finances!finances-button-active", {
		backgroundColor1 = ssu.makeColor(150, 155, 160, 150),
		backgroundColor2 = ssu.makeColor(255, 255, 255),
		borderColor = ssu.makeColor(255, 255, 255)
	})
	
	a("Finances::Layout", {
		outerSpacing = { 10, 10 },
		gravity = { .0, -1.0 }
	})
	
	a("FinancesButton", {
		gravity = { .0, 1.0 }
	})
	
	a("#menu.financesButton.prefix", {
		fontSize = 42,
		padding = { 0, 5, 0, 0 }
	})
	
	a("#menu.financesButton.label", {
		padding = { 0, 0, 0, 0 },
		fontSize = 9,
		textTransform = "UPPERCASE"
	})
	a("!ui-couch #menu.financesButton.label", {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})

	a("#menu.financesButton.number", {
		padding = { 0, 0, 0, 0 },
		fontSize = 18,
		maxSize = {194 * 0.5, -1},
		textAutoScale = true,
	})
	a("!ui-couch #menu.financesButton.number", {
		fontSize = ssu.styles.uicouch_subtitle_fontSize
	})

	a("MoneyDisplay:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
		--borderColor = ssu.makeColor(255, 255, 255, 50)
	})
	a("MoneyDisplay:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 100),
		--borderColor = ssu.makeColor(255, 255, 255, 150)
	})
	
	a("#menu.financesButton BoxLayout", {
		innerSpacing = { 0, 0 },
		gravity = { .0, .65 }
	})
	
	a("!ui-classic #menu.contexthelper", {
		padding = { 0, 0, 0, 194 }
	})
	
	a("#menu.construction", {
		gravity = { .5, 1.0 }
	})

	a("#menu.closeAll", {
		visibility = "folded",
	})

	a("#menu.inspector", {
		visibility = "folded"
	})
	a("!input-controller #menu.inspector", {
		actionPromptList = {
			{ia = "IA_SELECT", text = _("Inspector")},
		}
	})
	
	a("#menu.construction TabWidget::IndicatorLayout", {
		innerSpacing = { 15, 0 }
	})
	
	a("ConstructionMenuIndicator", {
		color = ssu.makeColor(255, 255, 255)
	})

	a("BulldozerButton::Icon", {
		color = ssu.makeColor(255, 255, 0)
	})

	a("ConstructionMenuIndicator, LineManagerButton, VehicleManagerButton, BulldozerButton", {
		backgroundImage1 = { fileName = "ui/design/buttons/disk_big_behind.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/disk_big_surface.tga" },
		borderImage = { fileName = "ui/design/buttons/disk_big_contour.tga" },
		backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
		backgroundColor2 = ssu.makeColor(15, 35, 50),
		borderColor = ssu.makeColor(255, 255, 255, 128)
	})

	a([[ConstructionMenuIndicator KeybindingHintDisplay!overflowMode,
		LineManagerButton KeybindingHintDisplay!overflowMode,
		VehicleManagerButton KeybindingHintDisplay!overflowMode,
		BulldozerButton KeybindingHintDisplay!overflowMode, 
		ContextHelperButton KeybindingHintDisplay!overflowMode,
		RadialMenuButton KeybindingHintDisplay!overflowMode]], {
		gravity = {0.88, 0.12},
	})
	
	a("ContextHelperButton", {
		gravity = {0.88, 0.12},
		visibility = "hidden"
	})

	a("#menu.contexthelper", {
		visibility = "visible"
	})

	a("ContextHelperButton!context-helper-button-couch", {
		gravity = {0.5, 0.5},
		scaling = 0.65,
	})
	a("!ui-classic ContextHelperButton!context-helper-button-couch", {
		visibility = "none"
	})

	a("!ui-couch ContextHelperButton KeybindingHintDisplay!overflowMode", {
		gravity = {0.95, 0.25},
	})

	a("ConstructionMenuIndicator:hover, LineManagerButton:hover, VehicleManagerButton:hover, BulldozerButton:hover", {
		backgroundColor1 = ssu.makeColor(183, 188, 193, 128),
		borderColor = ssu.makeColor(255, 255, 255)
	})
	a("ConstructionMenuIndicator:active, LineManagerButton:active, VehicleManagerButton:active, BulldozerButton:active", {
		backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
		backgroundColor2 = ssu.makeColor(110, 122, 132)
	})
	a("ConstructionMenuIndicator ImageView:disabled, LineManagerButton::Icon:disabled, VehicleManagerButton::Icon:disabled, BulldozerButton::Icon:disabled", {
		color = ssu.makeColor(128, 128, 128)
	})

	a("!ui-couch ConstructionMenu ConstructionMenuTab ConstructionList", {
		size = { -1, 110 },
	})
	a("!ui-couch ConstructionMenu::Content!content TabWidget::ContentLayout", {
		gravity = {-1, 0}
	})
	
	a("StatisticsButton::Icon, ContextHelperButton::Icon, RadialMenuButton::Icon, #menu.fileMenuButton.bottom MenuButton::Icon", {
		color = ssu.makeColor(255, 255, 255),
		backgroundImage1 = { fileName = "ui/design/buttons/disk_small_behind.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/disk_small_surface.tga" },
		borderImage = { fileName = "ui/design/buttons/disk_small_contour.tga" },
		backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
		backgroundColor2 = ssu.makeColor(15, 35, 50),
		borderColor = ssu.makeColor(255, 255, 255, 128)
	})
	a("StatisticsButton::Icon:hover, ContextHelperButton::Icon:hover, !radial-button-icon:hover, #menu.fileMenuButton.bottom MenuButton::Icon:hover", {
		backgroundColor1 = ssu.makeColor(183, 188, 193, 128),
		borderColor = ssu.makeColor(255, 255, 255)
	})
	a("StatisticsButton::Icon:active, ContextHelperButton::Icon:active, !radial-button-icon:active, #menu.fileMenuButton.bottom MenuButton::Icon:active", {
		backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
		backgroundColor2 = ssu.makeColor(110, 122, 132)
	})
	a("StatisticsButton::Icon:disabled, ContextHelperButton::Icon:disabled, !radial-button-icon:disabled, #menu.fileMenuButton.bottom MenuButton::Icon:disabled", {
		color = ssu.makeColor(128, 128, 128)
	})
	a("MenuButton#menu.fileMenuButton.bottom MenuButton::Icon", {
		size = { 42, 42 },
	})
	a("!ui-classic RadialMenuButton", {
		visibility = "none"
	})
	
	a("BulldozerBar", {
		backgroundImage1 = { fileName = "ui/design/game-menu/bulldozer_bar.tga" },
		backgroundColor1 = ssu.makeColor(255, 255, 255),
		minSize = { 0, 15 }
	})
	
	a("#menu.layers", {
		margin = { defaultMargin, 0, 0, defaultMargin }
	})

	a("!ui-couch LayerToggleButton KeybindingHintDisplay!overflowMode", {
		visibility = "hidden",
	})
	
	a("!ui-couch Clock::SpeedButton KeybindingHintDisplay", {
		scaling = 0.65,
		gravity = { 0.95, 0.19 },
	})

	a("!ui-couch Clock::SpeedButton!hide-keybinding-hint-display KeybindingHintDisplay", {
		visibility = "hidden",
	})

	a("LayersButton::Icon", {
		color = ssu.makeColor(255, 255, 255),
		shadowNinePatch = { fileName = "ui/design/buttons/disk_small_contour_shadow.tga", horizontal = { 0, 22, 23, 44 }, vertical = { 0, 22, 23, 44 } },
		shadowWidth = { 4, 4, 4, 4 },
		shadowColor = ssu.makeColor(0, 0, 0, 128),
		backgroundImage1 = { fileName = "ui/design/buttons/disk_small_surface_cut.tga", horizontal = { 0, 18, 19, 36 }, vertical = { 0, 18, 18, 18 } },
		backgroundImage2 = { fileName = "ui/design/buttons/disk_small_contour_cut.tga" },
		backgroundColor1 = ssu.makeColor(0, 0, 0, 0),
		backgroundColor2 = ssu.makeColor(255, 255, 255, 150)
	})
	a("LayersButton::Icon:hover", {
		backgroundColor2 = ssu.makeColor(255, 255, 255)
	})
	a("LayersButton::Icon:active", {
		backgroundColor1 = ssu.makeColor(15, 35, 50, 190)
	})
	a("LayersButton::Icon:disabled", {
		color = ssu.makeColor(128, 128, 128)
	})

	a("LayerToggleButton::Icon", {
		color = ssu.makeColor(255, 255, 255),
		padding = { 2, 2, 2, 2 },
		backgroundImage1 = { fileName = "ui/design/buttons/disk_small_surface_cut.tga", horizontal = { 0, 18, 19, 36 }, vertical = { 18, 18, 18, 18 } },
		backgroundImage2 = { fileName = "ui/design/buttons/disk_small_contour_cut.tga" },
		backgroundColor1 = ssu.makeColor(15, 35, 50, 190),
		backgroundColor2 = ssu.makeColor(255, 255, 255, 0)
	})
	a("LayerToggleButton::Icon:hover", {
		backgroundColor2 = ssu.makeColor(255, 255, 255)
	})
	a("LayerToggleButton::Icon:active", {
		backgroundColor2 = ssu.makeColor(255, 255, 255)
	})
	a("LayerToggleButton::Icon:disabled", {
		color = ssu.makeColor(128, 128, 128)
	})

	a([[!ui-couch #menu.layers MinimizeButton]], {
		actionPromptList = {
			{ ia = "ACTION_CLICK", text = _("Minimize") }
		},
	})
	a("#menu.layers MinimizeButton", {
		visibility = "folded"
	})
	
	a("HudIconButton", {
		borderWidth = { 2, 0, 0, 0 },
		borderColor = ssu.makeColor(15+20, 35+20, 50+20, 190)
	})
	
	a("!ui-couch HudFilterComp KeybindingHintDisplay!overflowMode", {
		margin = { 0, 0, 0, 35 },
		scaling = 0.65,
		gravity = { 0.55, 0.19 },
	})

	a("!ui-couch!input-controller HudIconButton#menu.layers.hudFilterButton", {
		visibility = "transparent",
	})

	a("HudIconButton::Icon", {
		color = ssu.makeColor(255, 255, 255),
		padding = { 2, 2, 2, 2 },
		backgroundImage1 = { fileName = "ui/design/buttons/disk_small_surface_cut.tga", horizontal = { 0, 18, 19, 36 }, vertical = { 18, 18, 19, 36 } },
		backgroundImage2 = { fileName = "ui/design/buttons/disk_small_contour_cut.tga" },
		backgroundColor1 = ssu.makeColor(15, 35, 50, 190),
		backgroundColor2 = ssu.makeColor(255, 255, 255, 0)
	})
	a("HudIconButton::Icon:hover", {
		backgroundColor2 = ssu.makeColor(255, 255, 255)
	})
	a("HudIconButton::Icon:active", {
		backgroundColor2 = ssu.makeColor(255, 255, 255)
	})
	a("HudIconButton::Icon:disabled", {
		color = ssu.makeColor(128, 128, 128)
	})
	
	a("#menu.layers BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	
	a("#menu.warningsButton", {
		margin = { defaultMargin, 0, 0, 0 }
	})
	
	a("WarningsButton::Icon", {
		color = ssu.makeColor(255, 255, 255),
		backgroundImage1 = { fileName = "ui/design/buttons/disk_small_surface_cut.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/disk_small_contour_cut.tga" },
		backgroundColor1 = ssu.makeColor(0, 0, 0, 0),
		backgroundColor2 = ssu.makeColor(255, 255, 255, 150),
		shadowNinePatch = { fileName = "ui/design/buttons/disk_small_contour_shadow.tga", horizontal = { 0, 22, 23, 44 }, vertical = { 0, 22, 23, 44 } },
		shadowWidth = { 4, 4, 4, 4 },
		shadowColor = ssu.makeColor(0, 0, 0, 128)
	})
	a("WarningsButton::Icon:hover", {
		backgroundColor2 = ssu.makeColor(255, 255, 255)
	})
	a("WarningsButton::Icon:active", {
		backgroundColor1 = ssu.makeColor(15, 35, 50, 190)
	})
	a("WarningsButton::Icon:disabled", {
		color = ssu.makeColor(128, 128, 128)
	})
	
	a("#menu.warnings", {
		minSize = { 800, 50 },
		maxSize = { 800, 300 }
	})

	a("#menu.fileMenuButton", {
		gravity = { 1.0, .0 },
		margin = { defaultMargin, defaultMargin, 0, 0 }
	})
	a("!ui-couch #menu.fileMenuButton", {
		visibility = "none"
	})

	a("#menu.fileMenuButton.bottom", {
		padding = { defaultMargin, defaultMargin + 6, 10, 0 }
	})
	a("!input-controller #menu.fileMenuButton.bottom", {
		visibility = "hidden"
	})

	a("MenuButton::Icon", {
		color = ssu.makeColor(255, 255, 255),
		backgroundImage1 = { fileName = "ui/design/buttons/disk_small_surface_cut.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/disk_small_contour_cut.tga" },
		backgroundColor1 = ssu.makeColor(0, 0, 0, 0),
		backgroundColor2 = ssu.makeColor(255, 255, 255, 150),
		shadowNinePatch = { fileName = "ui/design/buttons/disk_small_contour_shadow.tga", horizontal = { 0, 22, 23, 44 }, vertical = { 0, 22, 23, 44 } },
		shadowWidth = { 4, 4, 4, 4 },
		shadowColor = ssu.makeColor(0, 0, 0, 128)
	})
	a("MenuButton::Icon:hover", {
		backgroundColor2 = ssu.makeColor(255, 255, 255)
	})
	a("MenuButton::Icon:active", {
		backgroundColor1 = ssu.makeColor(255, 255, 255, 50),
		backgroundColor2 = ssu.makeColor(255, 255, 255)
	})
	a("MenuButton::Icon:disabled", {
		color = ssu.makeColor(128, 128, 128)
	})
	
	a("Clock::Date", {
		padding = { vp, hp, vp, hp },
		minSize = { 85, -1 },
		textAlignment = { 1.0, .5 }
	})
	
	a("Clock::SpeedButton::Icon", {
		color = ssu.makeColor(255, 255, 255),
		backgroundImage1 = { fileName = "ui/design/buttons/disk_mini_surface.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/disk_mini_contour.tga" },
		backgroundColor1 = ssu.makeColor(0, 0, 0, 0),
		backgroundColor2 = ssu.makeColor(0, 0, 0, 0)
	})
	a("Clock::SpeedButton::Icon:hover", {
		backgroundColor2 = ssu.makeColor(255, 255, 255)
	})
	a("Clock::SpeedButton::Icon:active", {
		color = ssu.makeColor(10, 12, 15),
		backgroundColor1 = ssu.makeColor(255, 255, 255),
		backgroundColor2 = ssu.makeColor(255, 255, 255, 0)
	})
	a("Clock::SpeedButton::Icon:disabled", {
		color = ssu.makeColor(128, 128, 128)
	})

	a("DateWindow", {
		size = {350, 220}
	})
	a("DateWindow!edit-speed-layout", {
		size = {350, 100}
	})
	a("!date-window", {
		anchorPoint = {0.5, 0.5},
	})

	a([[DatePopup BoxLayout, 
		DateWindow BoxLayout]], {
		innerSpacing = { 5, 10 }
	})
	a("DateWindow BoxLayout", {
		innerSpacing = { 0, 2 }
	})
	a("DatePopup Slider", {
		size = { 100, -1 }
	})
	a("DateWindow Slider", {
		size = { 200, -1 }
	})

	a("DateWindow DoubleSpinBox", {
		size = { 200, -1 }
	})

	a([[DatePopup SliderSpeedLayout:hover, DateWindow SliderSpeedLayout:hover,
		DatePopup DayLayout:hover, DateWindow DayLayout:hover,
		DatePopup MonthLayout:hover, DateWindow MonthLayout:hover,
		DatePopup YearLayout:hover, DateWindow YearLayout:hover]], {
		backgroundColor = ssu.makeColor(255, 255, 255, 50)
	})

	a("!input-controller !date-window Window::Close!window-button", {
	    visibility = "folded"
	})

	a("!input-controller DateWindow ComboBox:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 0),
	})
	a("!input-controller DateWindow ComboBox:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 0),
	})
	a("DatePopup::DateSpeedValueLabel", {
		padding = { vp, hp, vp, hp },
		minSize = { 75, -1 },
		textAlignment = { 1.0, .5 }
	})
	a("DateWindow::DateSpeedValueLabel", {
		padding = { vp, hp, vp, hp },
		minSize = { 75, -1 },
		textAlignment = { .5, .5 }
	})

	a([[DatePopup ComboBox !left-button!hide-left-right-buttons,
		DatePopup ComboBox !right-button!hide-left-right-buttons]], {
		visibility = "hidden"
	})
	a([[!input-controller DateWindow DoubleSpinBox !left-button!hide-left-right-buttons,
		!input-controller DateWindow DoubleSpinBox !right-button!hide-left-right-buttons]], {
		visibility = "hidden"
	})
	a([[!input-mouse DateWindow DoubleSpinBox !left-button!hide-left-right-buttons,
		!input-mouse DateWindow DoubleSpinBox !right-button!hide-left-right-buttons]], {
		visibility = "visible"
	})

	a("HudFilterComp BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	
	a("HudFilterComp::FilterButton", {
		padding = { 0, 5, 0, 5 }
	})
	
	a("HudFilterComp CheckBox", {
		margin = { 0, hp, 0, hp }
	})
	
	a("!ui-couch HudFilterComp CheckBox", {
		gravity = {0, -1}
	})

	a("!carrier-filter BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	a("!carrier-filter", {
		gravity = {-1, 1}
	})
	
	a("CarrierFilterButton::Icon, VisibilityFilterButton::Icon", {
		padding = { 10, hp, 10, hp }
	})
	
	a("VisibilityFilterButton", {
		margin = { 0, 0, 0, hp } -- HACK assumes always right to carrier filters
	})

	a([[!filter-button-icon,
		HudFilterComp::FilterButton::Icon,
		CarrierFilterButton::Icon,
		VisibilityFilterButton::Icon]], {
		color = ssu.makeColor(140, 160, 180, 200)
	})
	a([[!filter-button-icon:hover,
		HudFilterComp::FilterButton::Icon:hover,
		CarrierFilterButton::Icon:hover,
		VisibilityFilterButton::Icon:hover]], {
		color = ssu.makeColor(180, 200, 220)
	})
	a([[!filter-button-icon:active,
		HudFilterComp::FilterButton::Icon:active,
		CarrierFilterButton::Icon:active,
		VisibilityFilterButton::Icon:active]], {
		color = ssu.makeColor(255, 255, 255)
	})
	a([[!filter-button-icon:disabled,
		HudFilterComp::FilterButton::Icon:disabled,
		CarrierFilterButton::Icon:disabled,
		VisibilityFilterButton::Icon:disabled]], {
		color = ssu.makeColor(150, 150, 150)
	})

-- 	default selector tooltip (mouseover)
	a("#toolTipContainer.toolTip", {
		backgroundColor = ssu.makeColor(15, 35, 50, 100),
		margin = { 15, 0, 0, 30 },
		gravity = { .0, .0 },
		blurRadius = 4 * 4
	})

-- 	selector tooltip when called from inspector tool
	a("!input-controller #toolTipContainer.toolTip", {
		margin = { 20, 1, 1, 1 }, -- 20px below cursor (at least 1px margin required to prevent flickering)
		gravity = { 0.5, 0.0 },
	})
	
	a("AutoSave", {
		gravity = { 1.0, .0 },
		minSize = { 200, -1 },
		maxSize = { 400, -1 },
		backgroundColor = ssu.makeColor(5, 25, 40, 230),
	})
	a("AutoSave::Label", {
		padding = { vp, hp, vp, hp },
		fontSize = 22,
		minSize = { 200, -1 },
		textAlignment = { .5, .5 }
	})

	a("!ui-couch AutoSave::Label", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})

	a("AutoSave::Progress", {
		gravity = { -1.0, .0 },
		size = { -1, 5 }
	})
	
	a("MusicPlayer::Layout", {
		innerSpacing = { hp, vp },
		outerSpacing = { hp, vp }
	})

	a([[FinancesButton:active,
		ConstructionMenuIndicator:active,
		LineManagerButton:active,
		VehicleManagerButton:active,
		BulldozerButton:active,
		StatisticsButton:active,
		ContextHelperButton:active,
		RadialMenuButton:active,
		LayersButton:active,
		LayerToggleButton:active,
		HudIconButton:active,
		WarningsButton:active,
		MenuButton:active,
		Clock::SpeedButton:active,
		CarrierFilterButton:active]], {
		soundEffect1 = sound.get("buttonClick")
	})
	
	a([[VisibilityFilterButton:active]], {
		soundEffect1 = sound.get("toggleOn"),
		soundEffect2 = sound.get("toggleOff")
	})
	
	result.animations.attention = {
		[.0] = {
			color = { 1.0, 1.0, 1.0, 1.0 },
			backgroundColor1 = { 1.0, .0, .0, .0 },
			backgroundColor2 = { 1.0, 1.0, 1.0, 1.0 },
		},
		[.5] = {
			color = { 1.0, .0, .0, 1.0 },
			backgroundColor1 = { 1.0, .0, .0, .5 },
			backgroundColor2 = { 1.0, .0, .0, 1.0 },
		},
		[1.0] = {
			color = { 1.0, 1.0, 1.0, 1.0 },
			backgroundColor1 = { 1.0, .0, .0, .25 },
			backgroundColor2 = { 1.0, .5, .5, 1.0 },
		}
	}
	
	a("CGameUI !attention", {
		backgroundColor1 = { 1.0, 1.0, 1.0, .5 },
		backgroundColor2 = { 1.0, 1.0, 1.0, 1.0 },
		animationName = "attention",
		animationDuration = 1.0
	})

	a("#menu.stats.select", {
		margin = { 0, 75, 0, -75 },
	})
	a("!ui-couch!input-controller #menu.cameraToolButton", {
	    visibility = "hidden"
	})
	a("!input-controller #menu.stats.select", {
		visibility = "hidden",
	})
	a("!ui-couch #menu VerticalLine, !ui-couch mainMenuRightLayout-space", {
	    visibility = "none"
	})

	a("Window!statistics-select-window", {
	    anchorPoint = { 0.5, 0.5 },
	    gravity = { 0.5, 0.5 },
	})
	a("!statistics-select-window Window::Content", {
		padding = { 20, 20, 20, 20 },
	})
	a("!statistics-select-window !statistics-button", {
		padding = { 15, 15, 15, 15 },
		borderColor = { 1.0, 1.0, 1.0, 0.5 },
		borderWidth = { 2, 2, 2, 2 },
	})
	a("!statistics-select-window !statistics-button !icon", {
		gravity = { 0.5, 0.5 },
	})
	a("!statistics-select-window !statistics-button !label", {
		minSize = { 120, 0 },
		textAlignment = { 0.5, 0.5 },
	})

	a("!statistics-select-window !statistics-button:hover", {
		borderColor = ssu.makeColor(70, 150, 255, 255),
		backgroundColor = ssu.makeColor(70, 150, 255, 70),
	})

	a("!input-controller #menu.layersButton!invisible", { -- add to have higher priority than !controller-visible
		visibility = "hidden"
	})

	a("!ui-couch!input-controller #menu.musicPlayerButton", {
		visibility = "folded"
	})

	a("!ui-couch CGameUI RadialMenuFakeButton", {
		actionPromptList = {
			{ia = "IA_RADIAL_MENU", text = _("Radial menu")},
		}
	})

	a("!ui-couch!input-controller BulldozerButton", {
		visibility = "transparent",
		actionPromptList = {
			{ia = "IA_SELECT", text = _("Bulldozer")},
		}
	})

	a("!ui-couch BulldozerButton#menu.moduleBulldozer!module-bulldozer-invisible", {
		visibility = "hidden",
	})

	a("!ui-couch !action-none, !ui-couch !action-inspector", {
		actionPromptList = {
			{ia = "IA_MENU_BACK", text = _("Back")},
		}
	})

	a("!ui-couch !action-constructionbuilder", {
		actionPromptList = {
			{ia = "constructRaise", text = _("Change height")},
			{ia = "constructLower", text = _("Change height")},
			{ia = "constructOpt2", text = _("Rotate")},
			{ia = "constructOpt1", text = _("Rotate")},
			{ia = "IA_OPTION2", text = _("Settings")},
			{ia = "IA_PRECISION_MODE", text = _("(Hold) Precision mode")},
		}
	})
	
	a("!ui-couch!input-controller !action-proposal", {
		actionPromptList = {
			{ia = "IA_PRECISION_MODE", text = _("(Hold) Force paint")},
		}
	})

	a("!ui-couch!input-controller !action-constructionbuilder", {
		actionPromptList = {
			{ia = "IA_APPLY", text = _("Build")},
		}
	})

	a("!ui-couch !action-streetbuilder", {
		actionPromptList = {
			{ia = "constructRaise", text = _("Change height")},
			{ia = "constructLower", text = _("Change height")},
			{ia = "IA_CHANGE_BUILD_MODE", text = _("Change build mode")},
			{ia = "IA_CONSTRUCTION_CYCLE_NEXT", text = _("Next section")},
			{ia = "IA_OPTION2", text = _("Settings")},
			{ia = "IA_PRECISION_MODE", text = _("(Hold) Precision mode")},
		}
	})
	a("!ui-couch!input-controller !action-streetbuilder", {
		actionPromptList = {
			{ia = "IA_APPLY", text = _("Set Start Point")},
		}
	})

	a("!ui-couch !action-streetbuilder !build-control-dragging", {
		actionPromptList = {
			{ia = "constructOpt1", text = _("Bend")},
			{ia = "constructOpt2", text = _("Bend")},
			{ia = "IA_PRECISION_MODE", text = _("(Hold) Precision mode")},
		}
	})
	a("!ui-couch!input-controller !action-streetbuilder !build-control-dragging", {
		actionPromptList = {
			{ia = "IA_APPLY", text = _("Set End Point")},
		}
	})

	a("!ui-couch !action-proposal", {
		actionPromptList = {
			{ia = "IA_OPTION2", text = _("Settings")},
		}
	})
	a("!ui-couch!input-mouse !action-proposal", {
		actionPromptList = {
			{ia = "IA_MENU_BACK", text = _("Back")},
		}
	})
	a("!ui-couch!input-controller !action-proposal", {
		actionPromptList = {
			{ia = "IA_APPLY", text = _("Apply tool")},
		}
	})

	a("!ui-couch BuildControlComp::SectionTypeButton", {
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Change type")},
		}
	})

	a("!ui-couch!input-controller BuildControlComp::BuildButton", {
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Build")},
		}
	})
	a("!ui-couch BuildControlComp::CancelButton", {
		actionPromptList = {
			{ia = "IA_OPTION2", text = _("Settings")},
			{ia = "IA_MENU_BACK", text = _("Back")},
		}
	})
	a("!ui-couch!input-mouse !action-add-station", {
		actionPromptList = {
			{ia = "IA_MENU_BACK", text = _("Back")},
		}
	})
	a("!ui-couch!input-mouse !action-streetbuilder, !ui-couch!input-mouse !action-constructionbuilder", {
		actionPromptList = {
			{ia = "IA_MENU_BACK", text = _("Back")},
		}
	})
	a("!ui-couch!input-controller BuildControlComp::CancelButton", {
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Cancel")},
		}
	})
	
	a("!ui-couch !action-trackmodifier", {
		actionPromptList = {
			{ia = "IA_OPTION2", text = _("Settings")},
			{ia = "IA_PRECISION_MODE", text = _("(Hold) Precision mode")},
		}
	})
	a("!ui-couch!input-controller !action-trackmodifier", {
		actionPromptList = {
			{ia = "IA_APPLY", text = _("Apply tool")},
		}
	})

	a("!ui-couch !action-streetterminalbuilder", {
		actionPromptList = {
			{ia = "IA_OPTION2", text = _("Settings")},
		}
	})
	a("!ui-couch!input-controller !action-streetterminalbuilder", {
		actionPromptList = {
			{ia = "IA_APPLY", text = _("Build")},
		}
	})

	a("!ui-couch!input-controller !action-townbuilder", {
		actionPromptList = {
			{ia = "IA_APPLY", text = _("Build")},
		}
	})
	a("!ui-couch !action-townbuilder", {
		actionPromptList = {
			{ia = "IA_OPTION2", text = _("Settings")},
		}
	})

	a("!ui-couch!input-controller Selector::ActionTargetComponent", {
		actionPromptList = {
			{ ia = "IA_SELECT", text = _("Select") },
		}
	})

	a("!ui-couch!input-controller !action-add-station Selector::ActionTargetComponent", {
		actionPromptList = {
			{ ia = "IA_SELECT", text = _("Add station") },
		}
	})

	a([[!ui-couch!input-controller !action-bulldozer Selector::ActionTargetComponent,
	    !ui-couch!input-controller !action-module-bulldozer Selector::ActionTargetComponent]], {
		actionPromptList = {
			{ ia = "IA_SELECT", text = _("Bulldoze") },
		}
	})
	a("!ui-couch!input-controller !action-bulldozer", {
		actionPromptList = {
			{ ia = "IA_MENU_BACK", text = _("Cancel") },
		}
	})
	a("!ui-couch!input-controller !action-module-bulldozer", {
		actionPromptList = {
			{ ia = "IA_MENU_BACK", text = _("Back") },
		}
	})

	a("!ui-couch !bulldozer-confirm BuildControlComp::BuildButton", {
		actionPromptList = {
			{ ia = "ACTION_CLICK", text = _("Confirm destruction") }, 
		}
	})

	a("!ui-couch !bulldozer-confirm BuildControlComp::CancelButton", {
		actionPromptList = {
			{ ia = "ACTION_CLICK", text = _("Cancel") }, 
		}
	})

	a("!ui-couch BuildControlComp!action-modulebuilder", {
		actionPromptList = {
			{ ia = "IA_OPTION2", text = _("Settings") },
		}
	})
	a("!ui-couch!input-mouse !action-modulebuilder", {
		actionPromptList = {
			{ ia = "IA_MENU_BACK", text = _("Back") },
		}
	})
	a("!ui-couch!input-controller !action-modulebuilder", {
		actionPromptList = {
			{ ia = "IA_APPLY", text = _("Build") },
		}
	})

	a("!ui-couch AddModuleComp!construct-menu List", {
		actionPromptList = {
			{ ia = "IA_BACK", text = _("Back") },
			{ ia = "IA_OPTION2", text = _("Settings") },
			{ ia = "selectBulldozer", text = _("Bulldozer") },
		}
	})

	a("BuildControlComp::BuildButton KeybindingHintDisplay!overflowMode", {
		visibility = "none",
	})

	a("!ui-couch hackCamera, !ui-couch cameraActionComp", {
	    actionPromptList = {
			{ ia = "cockpitCameraHorn", text = _("Trigger horn") }, 
			{ ia = "cockpitCameraPosNext", text = _("Change camera") }, 
			{ ia = "cockpitCameraPosPrevious", text = _("Change camera") },
		}
	})
	a("!ui-couch!input-controller hackCamera, !ui-couch!input-controller cameraActionComp", {
	    actionPromptList = {
			{ ia = "IA_OPTION4", text = _("(Hold) Precision mode") },
		}
	})

	a("!ui-couch!input-mouse #menu.radialmenu", {
	    visibility = "none"
	})

	a("!ui-couch !action-follow", {
	    actionPromptList = {
			{ ia = "IA_MENU_BACK", text = _("Exit") },
		}
	})

	a("!ui-couch Window!finances-manager #finances.borrow", {
		actionPromptList = {
			{ia = "ACTION_CLICK"},
		}
	})
	a("!ui-couch Window!finances-manager #finances.repay", {
		actionPromptList = {
			{ia = "ACTION_CLICK"},
		}
	})
	a("!ui-couch!input-controller Chart::TimeScale Slider", {
		actionPromptList = {
			{ia = "IA_LEFT", text = _("Time scale")},
			{ia = "IA_RIGHT", text = _("Time scale")},
		}
	})
	a("!ui-couch!input-controller Chart!bar-chart", {
		actionPromptList = {
			{ia = "IA_RECURSIVE_PREV", text = _("Select bar")},
			{ia = "IA_RECURSIVE_NEXT", text = _("Select bar")},
		}
	})
	a("!ui-couch!input-controller Chart!line-chart", {
		actionPromptList = {
			{ia = "IA_LEFT", text = _("Move cursor")},
			{ia = "IA_RIGHT", text = _("Move cursor")},
			{ia = "IA_DOWN", text = _("Select graph")},
			{ia = "IA_UP", text = _("Select graph")},
		}
		
	})

	a("!ui-couch!input-controller #menu.financesButton MoneyDisplay", {
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Modify balance")},
		}
	})
	a("!ui-couch #menu.financesButton MoneyDisplay KeybindingHintDisplay!overflowMode", {
	    visibility = "none"
	})

	a("!ui-couch Window!finances-manager #menu.finances.buildHQ", {
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Build headquarter")}, 
		}
	})
	a("!ui-couch Window!finances-manager #menu.finances.relocateHQ", {
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Relocate headquarter")}, 
		}
	})
	a("!ui-couch Window!finances-manager #menu.finances.renameCompany", {
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Rename company")}, 
		}
	})
	a([[!input-controller StatisticsWindow!construct-menu-window EntityLink,
		!input-controller Table Table::Content NameEntry]], {
		actionPromptList = {
			{ ia = "IA_OPTION1", text = _("Locate") }
		},
	})

	a("!ui-couch StatisticsWindow!construct-menu-window InputTextScrollArea", {
		visibility = "none"
	})

	-- hide keybinding of buttons since they are used as source for the parents
	a([[!ui-couch EntityLink Button!name-button KeybindingHintDisplay!overflowMode,
		!ui-couch Table Table::Content NameEntry Button KeybindingHintDisplay!overflowMode,
		!ui-couch Table Table::Content LineFilterItem::LineComp Button KeybindingHintDisplay!overflowMode,
		!ui-couch StationGroupTerminalsComp::LinesComp Button KeybindingHintDisplay!overflowMode]], {
		visibility = "none"
	})

	a("!input-controller StatisticsWindow!construct-menu-window Button!locate-button", {
		visibility = "none"
	})

	-- hide so that hints are shown correctly when using controller (vehicle table)
	a([[!input-controller LineFilterItem::RowComp !edit-button-space,
		!input-controller LineFilterItem::RowComp BoxLayout::Space]], {
		visibility = "none"
	})


	a([[!ui-couch ConstructionMenu FilterViewParent RightFilterView ImageView]], {
		size = { 15, 15 },
    })
	a([[!ui-couch FilterViewParent]], {
		maxSize = { -1, 40 },
		gravity = { -1.0, 0.5 },
	})
	a([[!ui-couch FilterViewParent BoxLayout]], {
		gravity = { 1.0, 0.5 },
	})
	a([[!ui-couch LeftFilterView]], {
		size = { 180, -1 },
	})
	a([[!ui-couch LeftFilterView BoxLayout]], {
		gravity = { 1.0, -1.0 },
	})
	a([[!ui-couch RightFilterView]], {
		gravity = { -1.0, -1.0 },
		minSize = { 80, -1.0 },
	})
	a([[!ui-couch RightFilterView BoxLayout]], {
		gravity = { 1.0, -1.0 },
	})
	a([[!ui-couch RightFilterView Icon]], {
		minSize = { 20, -1.0 },
		margin = { 0, 4, 0, 4 }
	})

	return result
end
