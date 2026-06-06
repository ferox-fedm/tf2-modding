require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local hp = 10
local vp = 5

local m = 100

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	result.animations = { }
	
	result.animations.splashScreenPage = {
		[.0] = { color = { .0, .0, .0, .0 } },
		[.05] = { color = { .0, .0, .0, .0 } },
		[.15] = { color = { 1.0, 1.0, 1.0, 1.0 } },
		[.9] = { color = { 1.0, 1.0, 1.0, 1.0 } },
		[1.0] = { color = { .0, .0, .0, .0 } }
	}
	
	a("SplashScreen::LogosLayout", {
		innerSpacing = { 200, 0 }
	})
	a("SplashScreen::Background", {
		ssu.makeColor(0, 0, 0)
	})
	a("SplashScreen::Logo", {
		scaling = .75,
	})
	a("SplashScreen::Logo", {
		animationName = "splashScreenPage",
		animationDuration = 5.0
	})

	a("SplashScreen::ContinueButton", {
		textAutoWrap = true,
		maxSize = {"100vh", -1},
		fontSize = 30
	})
	
	a("MenuUI MainMenu BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	
	a("MenuUI MainMenu", {
		margin = { 0, 0, "7vh", "5vw" },
		maxSize = { -1, "65vh" },
	})

	a("MenuUI MainMenu Button", {
		padding = { 8, 15, 8, 15 },
		gravity = { -1.0, .5 }
	})
	a("!ui-couch MenuUI MainMenu Button", {
		padding = { 4, 8, 4, 8 },
	})

	a("MenuUI MainMenu Button!continue", {
		padding = { 8, 15, 8 + 20, 15 },
		margin = { 0, 0, -20, 0 },
	})
	a("!ui-couch MenuUI MainMenu Button!continue", {
		padding = { 4, 8, 4 + 20, 8 },
		margin = { 0, 0, -20, 0 },
	})

	a("MenuUI::ContinueLabel", {
		fontSize = 14,
		margin = { -5, 10, 10, 10 + 15 }
	})
	a("!ui-couch MenuUI::ContinueLabel", {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})

	a("MenuUI MainMenu Button::Text", {
		fontSize = 24
	})
	a("!ui-couch MenuUI MainMenu Button::Text", {
		fontSize = ssu.styles.uicouch_mainmenu_fontSize,
		textTransform = ssu.styles.uicouch_mainmenu_textTransform
	})

	a("!platform-desktop MenuUI::Logo", {
		size = { -1, "20vh" },
		padding = { "10vh", 0, 0, "15vh" }
	})
	
	a("!platform-console MenuUI::Logo", {
		size = { -1, "25vh" },
		padding = { "10vh", 0, 0, "11vh" }
	})

	a("MenuUI !username-button ImageView, MenuUI !edition-wrap ImageView", {
		gravity = {0, 0},
		size = {20, 20}
	})

	a("MenuUI !username-button ImageView", {
		padding = { 6, 0, 0, hp },
	})

	a("MenuUI !edition-wrap ImageView", {
		padding = { 8, 0, 0, hp },
	})

	
	a("!ui-couch MenuUI !username-button ImageView", {
		padding = { 5, 0, 0, hp },
	})

	a("!ui-couch MenuUI !edition-wrap ImageView", {
		padding = { 5, 0, 0, hp },
	})

	a("MenuUI !username-button TextView, MenuUI !edition-wrap TextView ", {
		fontSize = 20,
	})
	a("!ui-couch MenuUI !username-button TextView, !ui-couch MenuUI !edition-wrap TextView", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})

	a("MenuUI !bottom-right-wrap", {
		margin = { 0, "3vw", "5vh", 0 }
	})

	a("MenuUI !version-label", {
		color = ssu.makeColor(255, 255, 255, 150),
		padding = { vp, hp, vp, hp }
	})
	
	a("IconToggleButtonWithText", {
		borderWidth = { 1, 1, 1, 1 }
	})
	a("IconToggleButtonWithText:hover", {
		borderColor = ssu.makeColor(255, 255, 255, 192 / 2),
		soundEffect1 = sound.get("buttonHover")
	})
	a("IconToggleButtonWithText:active", {
		borderColor = ssu.makeColor(255, 255, 255, 192),
		soundEffect1 = sound.get("menuToggle")
	})
	
	a("IconToggleButtonWithText::Icon", {
		color = { .5, .5, .5, 1.0 }
	})
	a("IconToggleButtonWithText::Icon:hover", {
		color = { .75, .75, .75, 1.0 }
	})
	a("IconToggleButtonWithText::Icon:active", {
		color = { 1.0, 1.0, 1.0, 1.0 }
	})

	a("IconToggleButtonWithText::Text", {
		backgroundColor = ssu.makeColor(0, 0, 0, 128),
		gravity = { 1.0, 1.0 },
		padding = { 2, 4, 2, 4 }
	})
	a("IconToggleButtonWithText::Text:disabled", {
		color = { .5, .5, .5, 1.0 }
	})

	a("!play-scenario-button Button::Layout", {
		innerSpacing = { -10, 5 }
	})
	
	a("TextView!game-storage-size-info", {
		fontSize = 20,
	})

	a("ProgressBar!game-storage-size-info", {
		size = { -1, 25 },
		margin = { 0, 0, 20, 0 },
		minSize = { 250, -1 },
		gravity = { -1.0, .0 },
		color = positiveColor,
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
		backgroundColor1 = negativeColor,
		backgroundColor2 = ssu.makeColor(255, 255, 255, 100),
		shadowColor = negativeColor,
		borderWidth = { 2, 2, 2, 2 }
	})
	
	a("ProgressBar!mod-ram-size-info", {
		size = { 300, 25 },
		margin = { 0, 0, 0, 0 },
		color = ssu.makeColor(255, 255, 255, 255),
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
		backgroundColor1 = negativeColor,
		backgroundColor2 = ssu.makeColor(255, 255, 255, 100),
		shadowColor = negativeColor,
		borderWidth = { 2, 2, 2, 2 }
	})

	a("DialogBox!padded-dialog Button", {
		margin = { 0, 0, 5, 50 }
	})

	a("DialogBox!confirm-cancel-settings DialogBox::Content", {
		padding = { 10, 15, 10, 15 }
	})

	a("DialogBox::Title", {
		fontSize = 18
	})
	a("!ui-couch DialogBox::Title", {
		fontSize = ssu.styles.uicouch_window_title_fontSize,
		textTransform = ssu.styles.uicouch_window_title_textTransform,
	})
	a("DialogBox!padded-dialog DialogBox::Content", {
		size = {380, 200},
		padding = { 10, 15, 10, 15 }
	})
	a("DialogBox!padded-dialog Button::Text", {
		fontSize = 16,
	})
	a("!ui-couch DialogBox!padded-dialog Button::Text", {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})
	a("DialogBox!padded-dialog DialogBox::Overlay, BasicSettingsDialog::Overlay", {
		backgroundColor = ssu.makeColor(0, 0, 0, 200),
	})

	a("ParentSaveGameConfirmDialog MenuWindow", {
		backgroundColor = ssu.makeColor(5+45, 25+45, 40+45),
		shadowNinePatch = { fileName = "ui/l1_window_shadow.tga", horizontal = { 0, 16, 48, 64 }, vertical = { 0, 16, 48, 64 } },
		shadowWidth = { 16, 16, 16, 16 },
		shadowColor = ssu.makeColor(255, 255, 255),
	})

	a("ParentSaveGameConfirmDialog Button!right-button", {
		margin = { 0, 0, 0, 40 }
	})
	a("MenuWindow!save-game-confirm InputTextScrollArea", {
		size = { 300, -1 }
	})
	a("MenuWindow!save-game-confirm InputTextScrollArea > ScrollArea::Content > TextInputField", {
		padding = { 5, 0, 5, 0, }
	})

	a("Window!load-save-preset", {
		margin = { 0, 0, 0, 0 },
		padding = { 10, 15, 10, 15 },
		backgroundColor = ssu.makeColor(5+45, 25+45, 40+45),
		shadowNinePatch = { fileName = "ui/l1_window_shadow.tga", horizontal = { 0, 16, 48, 64 }, vertical = { 0, 16, 48, 64 } },
		shadowWidth = { 16, 16, 16, 16 },
		shadowColor = ssu.makeColor(255, 255, 255),
		size = {600, 500},
		maxSize = {600, 500},
		anchorPoint = {0.5, 0.5}
	})

	a("Window!load-save-preset SavegameDialog BoxLayout", {
		padding = { 10, 10, 0, 10 },
	})

	a("!ui-classic SavegameDialog InputTextScrollArea TextInputField", {
		padding = { 5, 0, 5, 0, }
	})
	a("!ui-classic SavegameDialog InputTextScrollArea ", {
		gravity = {-1, 0},
		size = {-1, -1},
	})


	a("SavegameList Table, SaveGameInfoComp DataTable, CustomGameSettingsComp DataTable, ModUploadMenuComp List", {
		backgroundColor = ssu.makeColor(0, 0, 0, 50)
	})

	a("SavegameInfoDisplay", {
		gravity = { .0, .0 }
	})

	a("!mods-enabled SavegameInfoDisplay::Screenshot", {
		size = { 320, 180 }
	})

	a([[!mods-disabled SavegameInfoDisplay::Screenshot!wide-style,
	    !mods-disabled SavegameInfoDisplay BoxLayout]], {
	    gravity = {-1, -1},
	})

	a("MapPreviewComp::TownMarker", {
		color = ssu.makeColor(255, 255, 255, 200),
		anchorPoint = { .5, .5 }
	})
	
	a("MapPreviewComp::IndustryMarker", {
		color = ssu.makeColor(220, 160, 0, 200),
		anchorPoint = { .5, .5 }
	})
	
	a("MapPreviewComp::TownMarker!existing", {
		color = ssu.makeColor(128, 128, 128)
	})
	
	a("MapPreviewComp::IndustryMarker!existing", {
		color = ssu.makeColor(110, 80, 0)
	})
	
	a("MenuUI::LoadingScreenTip, MenuUI::MissionDescription", {
		fontSize = 20,
		shadowNinePatch = { fileName = "ui/design/main-menu/loading_screen_background.tga", horizontal = { 0, 74, 75, 148 }, vertical = { 0, 70, 71, 140 } },
		shadowWidth = { 60, 60, 60, 60 },
		shadowColor = ssu.makeColor(0, 0, 0, 200)
	})
	a([[!ui-couch MenuUI::LoadingScreenTip,
		!ui-couch MenuUI::MissionDescription]], {
		fontSize = ssu.styles.uicouche_tips_fontSize,
	})
	a("MenuUI::MissionTitle", {
		shadowNinePatch = { fileName = "ui/design/main-menu/loading_screen_background.tga", horizontal = { 0, 74, 75, 148 }, vertical = { 0, 70, 71, 140 } },
		shadowWidth = { 60, 60, 60, 60 },
		shadowColor = ssu.makeColor(0, 0, 0, 100)
	})
	
	a("MenuUI::MissionTitle::Title", {
		fontSize = 24,
		textTransform = "UPPERCASE",
	})
	
	a("MenuUI::MissionTitle::SubTitle, !main-subtitle, !ui-couch !main-subtitle", {
		fontSize = 20
	})
	
	a("MenuUI ProgressBar", {
		color = ssu.makeColor(128, 128, 128),
		backgroundColor = ssu.makeColor(12, 32, 46, 200),
		fontSize = 12,
		shadowNinePatch = { fileName = "ui/l1_loading_bar_shadow.tga", horizontal = { 0, 7, 21, 28 }, vertical = { 0, 7, 21, 28 } },
		shadowWidth = { 7, 7, 7, 7 },
		margin = { 0, 0, 46, 0 }
	})
	
	a("!key-mapping ToggleButton::Text", {
		gravity = { -1.0, .5 },
		textAlignment = { .5, .5 }
	})
	
	a("GameOptionsComp", {
		gravity = { .0, .0 },
		minSize = { 500, -1 }
	})
	
	a("SavegameInfoDisplay", {
		gravity = { -1.0, .0 }
	})
	a("!mods-disabled SavegameInfoDisplay", {
		gravity = { -1.0, -1 },
	})
	a([[SavegameInfoDisplay !no-achievements-label!invisible,
	    SavegameInfoDisplay !not-all-mods-label!invisible]], {
		visibility = "hidden"
	})
	a("!mods-enabled SavegameInfoDisplay !not-all-mods-label!invisible", {
		visibility = "folded"
	})
	a("!platform-console SavegameInfoDisplay experimental-map-size-label!invisible", {
		visibility = "folded"
	})

	a("CustomGameSettingsComp !advanced-settings ScrollArea::Content", {
		maxSize = { 600, -1 },
	})

	a("!input-controller ModsTab!tab-widget-content TextInputField!search-field", {
		visibility = "none"
	})

	a("!ui-couch CustomGameSettingsComp Table !table-item KeybindingHintDisplay!overflowMode", {
		visibility = "none"
	})

	a("!ui-couch CustomGameSettingsComp::ModInfo", {
		visibility = "hidden"
	})

	a("CustomGameSettingsComp::ModInfo", {
		gravity = { -1.0, -1.0 }
	})

	a("CustomGameSettingsComp::ModInfo::Layout", {
		innerSpacing = { vp, hp }
	})

	a("CustomGameSettingsComp::ModInfo::Name", {
		fontSize = 16
	})
	a("!ui-couch CustomGameSettingsComp::ModInfo::Name", {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})
	a("!ui-couch Button!couch-enable-disable-mod-button", {
		minSize = { 90, -1 }
	})

	a("CustomGameSettingsComp::ModInfo::Image", {
		maxSize = { 240, 135 }
	})

	a("CustomGameSettingsComp InputTextScrollArea", {
		size = { 200, -1 }
	})

	
	a("CustomGameSettingsComp InputTextScrollArea TextInputField", {
		padding = {5, 0, 5, 0},
	})

	a("!disclaimer DialogBox::Overlay", {
		blurRadius = 16 * 4
	})

	a("#menuUI ParamsListComp", {
		minSize = { 200, -1 }
	})

	a([[MenuWindow!save-game, MenuWindow!save-map, MenuWindow!load-game]], {
		size = { 1200, 800 }
	})

	a("MenuWindow!advanced-game-settings, MenuWindow!savegame-mod-options", {
	    size = { 1200, 950 },
	})
	a("MenuWindow!settings", {
	    size = { 650, 830 }  -- does not help much, because layout size calc error can become huge
	})
	a("MenuWindow!select-campaign", {
	    size = { 770, 570 }
	})
	a("MenuWindow!select-mission", {
	    minSize = { 500, 200 }
	})
	a("MenuWindow!achievements", {
	    minSize = { 400, 300 },
	    maxSize = { -1, 600 },
	})
	a("MenuWindow!keep-resolution", {
	    minSize = { 500, 200 }
	})
	a([[!ui-couch CustomGameSettingsComp::ModInfo::Left]], {
		gravity = { 0, 0 },
	})
	a([[!ui-couch MenuWindow!mod-details-page !mod-details-property]], {
		padding = {25, 0, 0, 0},
	})

	a([[!ui-couch MenuWindow!mod-details-page CustomGameSettingsComp::ModInfo::Image]], {
		minSize = {340, 192},
		maxSize = {340, 192},
	})

	a([[CustomGameSettingsComp::ModInfo::Desc RichTextView]], {
		padding = { 0, 0, 0, 0 },
	})
	a([[!ui-couch CustomGameSettingsComp::ModInfo::Desc RichTextView]], {
		fontSize = ssu.styles.uicouch_body_fontSize,
		padding = { 0, 0, 0, 10 },
	})

	a([[!ui-couch MenuWindow!settings, !ui-couch MenuWindow!create-new-game, !ui-couch MenuWindow!load-game,
		!ui-couch MenuWindow!mods-page,
		!ui-couch MenuWindow!mod-detail-page,
		!ui-couch MenuWindow!select-campaign, !ui-couch MenuWindow!select-mission, !ui-couch ReleaseNotes,
		!ui-couch MenuWindow!advanced-game-settings, !ui-couch MenuWindow!save-game, !ui-couch MenuWindow!savegame-mod-options,
		!ui-couch MenuWindow!mod-details-page]], {
	    size = { "100vw", "100vh" },
	    minSize = { "100vw", "100vh" },
	    maxSize = { "100vw", "100vh" },
	})
	a("!ui-couch MenuWindow!settings !left-column", {
	    size = { -1, -1},
	    minSize = { -1, 24 },
	})

	a([[!ui-couch MenuWindow!settings !right-column,
		!ui-couch MenuWindow!settings !right-column ComboBox,
		!ui-couch MenuWindow!settings !right-column ComboBox::Button!content-button]], {
	    gravity = { -1, 0.5 },
	})
	a("MenuWindow!settings PresetButtons!right-column BoxLayout", {
	    gravity = { 1, -1 },
	})
	a("MenuWindow!settings PresetButtons!right-column", {
	    maxSize = {550, -1},
	})
	a("!ui-couch MenuWindow!settings PresetButtons KeybindingHintDisplay!overflowMode", {
	    gravity = {0.5, 0},
	})

	a("!ui-couch MenuWindow!settings Button!reset-to-defaults!right-column", {
	    gravity = { 1, 0.5 },
	    margin = { 0, 35 + 15, 0, 0 },
		visibility = "hidden"
	})
	a("!ui-couch MenuWindow!settings !key-mapping!tab-widget-content ScrollArea::Content", {
	    margin = { 0, 35, 0, 0 },
	})
	a("!key-mapping KeybindingHintDisplay!overflowMode", {
		gravity = { 1, 0.5 },
	})

	a("MapPreviewComp", {
	    maxSize = { 480, -1 },
	})
	a("!ui-couch MenuWindow!create-new-game MapPreviewComp", {
		gravity = { 0.5, -1 },
	    maxSize = { "48vw", -1 },
	    minSize = { "48vw", -1 },
	})
	a("!ui-classic MenuWindow!create-new-game", {
	    size = { -1, 790 }   -- avoid vertical size changes when selecting the different climates
	})

	a("!section-title-0", {
		fontSize = 20,
		margin = { 0, 0, 4, 0 },
	})
	a("!ui-couch !section-title-0", {
		fontSize = ssu.styles.uicouch_subtitle_fontSize,
	})

	a("!section-title", {
		fontSize = 20,
		margin = { 15, 0, 4, 0 },
	})
	a("!ui-couch !section-title", {
		margin = { 0, 0, 4, 0 },
		fontSize = ssu.styles.uicouch_subtitle_fontSize,
	})

	a("MenuWindow!create-new-game ToggleButtonGroup", {
		margin = { 0, 0, 0, 10 }
	})
	a("MenuWindow!create-new-game IconToggleButtonWithText::Icon", {
		minSize = { 150, 100 },
	})

	a("MenuWindow!create-new-game TabWidget!game-options", {
		gravity = { -1.0, 0.0 },
	})
	a("MenuWindow!create-new-game TabWidget!game-options", {
		visibility = "folded",
	})

	a("MenuWindow!create-new-game LeftRightItemGroupLayout::Space", {
	    minSize = { 50, -1 },
	})

	a("MenuWindow!create-new-game ToggleButtonGroup KeybindingHintDisplay", {
	    visibility = "none",
	})

	a("MenuWindow!create-new-game #mainMenu.newGame.modInfoLabel", {
		visibility = "none",
		gravity = { 1.0, 0.5 },
		margin = { -32, 0, 0, 0 },
	})

	a("!ui-couch MenuWindow!create-new-game RandomSeedInput!random-seed", {
		padding = { vp, hp, vp, hp },
		size = { 230, -1 },
		margin = { 1, 0, 1, 27 },
		backgroundColor = ssu.makeColor(0, 0, 0, 50),
	})
	a("!ui-couch !start-game-mode #mainMenu.newGame.tabMap RandomSeedInput!random-seed", {
		margin = {0,0,0,0}
	})

	a("!ui-classic MenuWindow!create-new-game Button!random-seed", {
		margin = { 0, 0, 0, 0 },
		padding = { 5, 5, 5, 5 },
	})
	a("!ui-classic MenuWindow!create-new-game TextInputField!random-seed", {
		size = { 180, -1 },
	})

	a("MenuWindow!create-new-game Button!random-seed KeybindingHintDisplay!overflowMode", {
	    gravity = { 1.0, 0.5 },
	})

	a("!ui-couch MenuWindow!load-game EnabledModsLineLayout", {
	    innerSpacing = { 70, 0 },
	})

	a("MenuWindow!create-new-game !list-item ComboBox, MenuWindow!create-new-game !sub-list ComboBox", {
		gravity = { -1, 0.5 },
	})

	a([[!ui-couch MenuWindow!create-new-game !list-item ComboBox,
	    !ui-couch MenuWindow!create-new-game !sub-list ComboBox]], {
		size = {250, -1},
		padding = { 0, 0, 0, 30 },
	})

	a("!ui-classic MenuWindow!create-new-game TabWidget!game-options !tab-widget-content", {
	    minSize = { 620, -1},
	})

	a("KeyMapping!key-mapping!tab-widget-content > NavList!controls-keyboard", {
		size = {-1, 149}
	})

	a("NavList!controls-keyboard CheckBoxWrapper!check-box!right-column", {
		gravity = {0.5, 0.5},
		margin = {0, 10, 0, 0}
	})


	a("LabelValueItemGroup !label, NavList ParamsListComp!horizontal !label", {
		gravity = { 0, 0.5 },
		minSize = { 250, -1 },
	})

	a([[#mainMenu.newGame.tabMap LabelValueItemGroup !label,
	    #mainMenu.newGame.tabMap ParamsListComp!horizontal !label,
	    #mainMenu.newGame.tabDifficulty LabelValueItemGroup !label,
	    #mainMenu.newGame.tabDifficulty ParamsListComp!horizontal !label]], {
		minSize = { 270, -1 },
	})

	a("LabelValueItemGroup !value", {
		gravity = { -1, 0.5 },
	})

	a("LabelValueItemGroup !value TextView, ParamsListComp!sub-list ComboBox TextView", {
		gravity = { -1, 0.5 },
		textAlignment = { 0, 0.5 },
	})

	a("!ui-couch LabelValueItemGroup !value TextView, !ui-couch ParamsListComp!sub-list ComboBox TextView", {
		gravity = { -1, 0.5 },
		textAlignment = { 0.5, 0.5 },
	})
	a([[!ui-couch MenuWindow!create-new-game ParamsListComp!sub-list ComboBox,
		!ui-couch MenuWindow!create-new-game LabelValueItemGroup ComboBox]], {
		gravity = { -1, 0.5 },
		textAlignment = { 0.5, 0.5 },
		minSize = {250, -1},

	})
	a("!ui-couch MenuWindow CustomGameSettingsComp LabelValueItemGroup > ComboBox", {
		gravity = { -1, 0.5 },
		textAlignment = { 0.5, 0.5 },
		size = {220, -1},
		padding = { 0, 50, 0, 0 },
	})

	a([[!ui-couch MenuWindow!create-new-game!start-game-mode ComboBox]], {
		gravity = { -1, 0.5 },
		textAlignment = { 0.5, 0.5 },
		size = {250, -1},
		minSize = {250, -1},
		maxSize = {250, -1},
		padding = { 0, 0, 0, 0 },
	})

	a("MenuWindow!create-new-game LabelValueItemGroup CheckBoxWrapper!custom-settings!label CheckBox", {
		margin = { 0, 0, 0, 10 },
		gravity = { 0, 0.5 },
	})
	a("MenuWindow!create-new-game LabelValueItemGroup Button!custom-settings!value", {
		margin = { 1, 0, 0, 10 },
	})
	a("!ui-couch MenuWindow!create-new-game LabelValueItemGroup Button!custom-settings!value", {
		margin = { 1, 0, 0, 70 },
	})

	a("MenuWindow!create-new-game ScrollArea!right-column", {
		maxSize = { "38vw", -1 },
	})

	a("!ui-couch MenuWindow WindowContentLayout", {
		gravity = { 0.5, -1 },
	})

	a("!ui-couch MenuWindow!create-new-game!map-editor-mode TabWidget::ContentLayout", {
		gravity = { 0.5, -1 },
	    maxSize = { "50vw", -1 },
	    minSize = { "50vw", -1 },
	})

	a("ParamsListComp!sub-list", {
		padding = { 0, 0, 0, hp },
	})

	a("CustomGameSettingsComp !advanced-settings ParamsListComp!sub-list !label", {
		minSize = { 270, -1 },
	})
	a("CustomGameSettingsComp !advanced-settings GameOptionsComp Button!right-column", {
		minSize = { 310, 10 },
	})
	a("CustomGameSettingsComp !advanced-settings GameOptionsComp TextView!main-subtitle", {
		margin = { 0, 0, 4, 0 },
		fontSize = ssu.styles.uicouch_subtitle_fontSize
	})

	a("CustomGameSettingsComp !advanced-settings GameOptionsComp Button!reset-to-defaults", {
		margin = { 18, 0, -32, 290 },
		gravity = {1, 0}
	})

	a([[ParamsListComp!sub-list ParamsListComp::ButtonParam::Layout,
		ParamsListComp!sub-list ParamsListComp::SliderParam::Layout,
		ParamsListComp!sub-list ParamsListComp::ComboBoxParam::Layout,
		ParamsListComp!sub-list ParamsListComp::IconButtonParam::Layout]], {
		innerSpacing = { 5, 5 },  -- so is same as std BoxLayout
	})

	a("ParamsListComp!sub-list Slider", {
		margin = { 0, -8, 0, -12 },
		minSize = { 190, -1 },
	})

	a("ParamsListComp!sub-list ParamsListComp::SliderParam::SliderLabel", {
		padding = { 0, 0, 0, 0 },
		margin = { 0, -10, 0, -20 },
		size = { 80, -1 },
		textAlignment = { 0.5, 0 },
	})

	a("ParamsListComp!sub-list ComboBox", {
		minSize = { 190, -1 },
	})

	a("MenuWindow!create-new-game !cheats-note", {
		margin = { 10, 0, 15, 10 },
	})

	a("!ui-couch #mainMenu.loadGame.basicSettings ParamsListComp::ComboBoxParam!param-row > ComboBox", {
		size = {250, -1},
		minSize = {250, -1},
		maxSize = {250, -1},
	})

	a("!ui-couch #mainMenu.newGame.tabCheats LabelValueItemGroup!list-item CheckBoxWrapper", {
		gravity = {0, 0.5},
		size = {300, -1},
		minSize = {300, -1},
		maxSize = {300, -1},
	})

	a("!ui-couch LabelValueItemGroup ComboBox wrap", {
		gravity = {-1, 0.5},
	})

	a("OrderMoveButtonsComp SimpleButton", {
		gravity = {-1, 0.5},
	})
	a("OrderMoveButtonsComp SimpleButton > Button::Layout", {
		gravity = {0.5, 0.5},
	})

	a("OrderMoveButtonsComp TextInputField!mod-order-index", {
		minSize = {28, -1},
	})
	 

	return result
end
