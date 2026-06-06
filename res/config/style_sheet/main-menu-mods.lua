require "tableutil"
local ssu = require "stylesheetutil"

local hp = 2*10
local vp = 2*5

local markerColor = ssu.makeColor(255, 255, 255, 200)

local winOuterSpacing = 40
local winInnerSpacing = 25

function data()
	local result = { }

	local a = ssu.makeAdder(result)

	a("MenuWindow!mods-page MenuWindow::Layout, MenuWindow!mod-detail-page MenuWindow::Layout", {
		gravity = {-1, -1},
	})
	
	a("MenuWindow::Title-bar", {
		gravity = {-1, 0},
	})

	a("MenuWindow::TitleText", {
		gravity = {-1, 0},
	})

	-- Window Overrides
	a("MenuWindow!mods-page, MenuWindow!mod-detail-page", {
		size = { 1420, "90vh" },
		gravity = {0.5, 0.5},
	})

	a("MenuWindow!mod-detail-page MenuWindow::Title-bar", {
		visibility = "none",
	})

	a("!mods-page MenuWindow::Content", {
		padding = { 0, winOuterSpacing, 0, winOuterSpacing },
	})
	a("!mod-detail-page MenuWindow::Content", {
		padding = { 0, winOuterSpacing, 0, winOuterSpacing },
	})

	a("MenuWindow!mods-page MenuWindow::Buttons, MenuWindow!mod-detail-page MenuWindow::Buttons", {
		padding = { 0, 0, 25, 0 },
	})

	-- Mod Browser

	a("ModsBrowser", {
	})

	-- Tabs
	a("MenuWindow!mods-page TabWidget > TabWidget::IndicatorLayout", {
		outerSpacing = {243, 0},
	})
	a("!ui-couch MenuWindow!mods-page TabWidget > TabWidget::IndicatorLayout", {
		outerSpacing = {210, 0},
	})

	a("MenuWindow!mods-page !tab-widget-indicator, MenuWindow!mods-page !tab-widget-icon-indicator", {
		shadowColor = ssu.makeColor(0, 0, 0, 0),
		borderWidth = { 0, 0, 0, 0 },
		backgroundImage1 = { fileName = "ui/mod_tab_border.tga", horizontal = { 0, 7, 8, 15 }, vertical= { 0, 7, 8, 10 } },
		backgroundColor1 = ssu.makeColor(255, 255, 255, 50),
		margin = {0, 2, 0, 0},
	})
	a("MenuWindow!mods-page !tab-widget-indicator:hover, MenuWindow!mods-page !tab-widget-icon-indicator:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 0),
		backgroundImage1 = { fileName = "ui/mod_tab_border_active.tga", horizontal = { 0, 7, 8, 15 }, vertical= { 0, 7, 8, 10 } },
		backgroundColor1 = ssu.makeColor(255, 255, 255, 25),
	})
	a("MenuWindow!mods-page !tab-widget-indicator:active, MenuWindow!mods-page !tab-widget-icon-indicator:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 0),
		backgroundImage1 = { fileName = "ui/mod_tab_border_active.tga", horizontal = { 0, 7, 8, 15 }, vertical= { 0, 7, 8, 10 } },
		backgroundColor1 = ssu.makeColor(255, 255, 255, 100),
	})
	
	a("MenuWindow!mods-page !tab-widget-indicator TextView", {
		textTransform = "UPPERCASE",
		padding = { 0, 0, 0, 0 }
	})

	a("MenuWindow!mods-page !tab-widget-indicator", {
		padding = { 0, hp/2, -1, hp/2 },
	})

	-- Sidebar

	a("ModsBrowser !sidebar", {
		size = { 240, -1 },
	})

	a("ModsBrowser !sidebar TextInputField", {
		--margin = { 0, 0, 0, 0 },
		padding = { 5, 0, 5, 0 },
		--backgroundColor = ssu.makeColor(0, 0, 0, 0),
	})

	a("ModsBrowser !sidebar InputTextScrollArea", {
		size = { 184, -1 },
		--padding = { 0, 10, 0, 10 },
		margin = { 10, 5, 10, 5 },
		--backgroundColor = ssu.makeColor(0, 0, 0, 50),
	})

	a("ModsBrowser !search-input-layout", {
		padding = {0, 5, 0, 5},
	})

	a("ModsBrowser !sidebar !filter-menu", {
		margin = { 8, 0, 0, 0 },
		padding = { 4, 0, 0, 10 },
	})

	a("ModsBrowser !sidebar !filters-reset-button", {
		margin = { 8, 0, 0, 0 },
		padding = { 4, 0, 4, 10 },
		size = { 200, -1 }
	})

	a("ModsBrowser !sidebar !filter-menu Button", {
		backgroundColor1 = ssu.makeColor(255, 255, 255),
		size = {204, -1},

	})

	a("!input-mouse ModsBrowser !sidebar !filter-menu Button:hover", {
		backgroundColor = ssu.makeColor(70, 150, 255, 70)
	})
	a("!input-controller ModsBrowser !sidebar !filter-menu Button:hover", {
		backgroundColor = ssu.makeColor(0, 0, 0, 0)
	})


	a("ModsBrowser !sidebar !filter-menu Button::Text", {
		padding = {0, 5, 0, 5 },
	})

	a("ModsBrowser !sidebar !filter-menu Button::Icon", {
		size = { 16, 16 },
	})

	a("ModsBrowser !table-row:hover", {
		backgroundColor1 = ssu.makeColor(0, 0, 0, 0),
		backgroundColor2 = ssu.makeColor(0, 0, 0, 0),
	})

	a("ModsBrowser !sidebar !filter-menu CheckBox:hover", {
		backgroundColor = ssu.makeColor(70, 150, 255, 70)
	})
	a("ModsBrowser !sidebar !filter-menu CheckBox", {
		padding = {1, 2, 1, 20},
		margin = {0, 0, 0, 0},
		size = {182, -1}
	})

	a("ModsBrowser Table", {
		size = {-1, -1},
		gravity = {0.5, -1},
	})

	a("ModsBrowser LoadingSpinner", {
		padding = {0, 0, 0, 0},
		size = { -1, -1 },
		gravity = {0.5, 0.5}
	})

	a("ModsBrowser !message-no-matches", {
		gravity = {0.5, 0.5}
	})

	-- BottomBar
	a("!input-controller ModsBrowser MenuWindow::RightButtons Button", {
		padding = {0, 0, 0, 0},
		margin = {0, 0, 0, 30},
	})
	a("!input-mouse ModsBrowser MenuWindow::RightButtons Button", {
		padding = {0, 0, 0, 0},
		margin = {0, 0, 0, 0},
	})

	a("MenuWindow::RightButtons Button!modio-info", {
		size = { 34, 34 },
		backgroundImage1 = { fileName = "ui/design/buttons/disk_big_behind.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/disk_big_surface.tga" },
		borderImage = { fileName = "ui/design/buttons/disk_big_contour.tga" },
		backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
		backgroundColor2 = ssu.makeColor(15, 35, 50, 200),
		borderColor = ssu.makeColor(255, 255, 255, 128),
	})

	a("MenuWindow::RightButtons Button!modio-info:hover", {
		backgroundColor = ssu.makeColor(0, 0, 0, 0),
		backgroundColor1 = ssu.makeColor(15, 35, 50, 10),
		backgroundColor2 = ssu.makeColor(15, 35, 50, 40),
	})

	a("ModsBrowser AdvancedMenuButton AdvancedMenuButton::Text", {
		textTransform = "UPPERCASE",
	})
	a("ModHubForm!advanced-menu NavList", {
		padding = {0,0,0,0},
	})
	a("ModsBrowser !status-bar-wrap", {
		gravity = {-1, 0.5},
	})


	-- Mod Tile

	a("ModsBrowser ModTile", {
		padding = { 0, 0, 0, 0},
		size = { 256, -1 },
		backgroundColor = ssu.makeColor(0, 0, 0, 50),
		margin = { 5, 5, 5, 5 },
		borderColor = ssu.makeColor(255, 255, 255, 0),
		borderWidth = { 2, 2, 2, 2, }
	})

	a("ModsBrowser ModTile:hover", {
		borderColor = ssu.makeColor(255, 255, 255, 255)
	})

	a("ModsBrowser ModTile ImageView", {
		size = { 256, 144 },
		gravity = {0.5, 0.5},
		-- backgroundColor = ssu.makeColor(0, 0, 0, 255),
	})

	a("ModsBrowser ModTile ImageView!icon", {
		size = { 24, 24 },
		color = ssu.makeColor(255, 255, 255, 255),
		backgroundColor = ssu.makeColor(0, 0, 0, 0),
	})

	a("ModsBrowser ModTile ImageView!icon!invisible", {
		visibility = "none",
	})

	a("ModSubscribeButton!mod-dependency KeybindingHintDisplay", {
		padding = { 0, 3, 0, 5 },
	})

	a("ModSubscribeButton Button::Layout", {
		gravity = { -1, 0.5 },
	})

	a("ModSubscribeButton Button BoxLayout", {
		gravity = { 0.5, 0.5 },
	})

	a("ModSubscribeButton Button !inner", {
		gravity = { 0.5, 0.5 },
	})

	a("ModSubscribeButton Button", {
		backgroundColor = ssu.makeColor(83, 151, 198, 200),
		borderColor = ssu.makeColor(83, 151, 198, 200),
		borderWidth = { 2, 2, 2, 2 },
		padding = { 2, 0, 2,  0},
		gravity = { -1, 1.0 },
	})
	
	a("ImageView!gallery-image", {
		backgroundColor = ssu.makeColor(0, 0, 0, 255),
	})

	a("ModSubscribeButton Button:hover", {
		backgroundColor = ssu.makeColor(106, 192, 251, 200),
		borderColor = ssu.makeColor(106, 192, 251, 200),
	})
	a("ModSubscribeButton Button:active", {
		backgroundColor = ssu.makeColor(161, 217, 255, 200),
		borderColor = ssu.makeColor(161, 217, 255, 200),
	})
	a("ModSubscribeButton Button:disabled", {
		backgroundColor = ssu.makeColor(160, 180, 190, 50),
	})

	a("ModTile ModSubscribeButton Button", {
		backgroundColor = ssu.makeColor(255, 255, 255, 20),
		borderColor = ssu.makeColor(255, 255, 255, 20),
	})
	a("ModTile ModSubscribeButton Button:hover", {
		backgroundColor = ssu.makeColor(106, 192, 251, 100),
		borderColor = ssu.makeColor(106, 192, 251, 100),
	})

	a([[ModSubscribeButton Button::Text:disabled]], {
		color = ssu.makeColor(0, 0, 0, 150),
	})



	a("ModSubscribeButton Button TextView", {
		color = ssu.makeColor(227, 245, 250, 255),
		size = { -1, -1 },
		gravity = { 0.5, 0.5 },
		textAlignment = { 0.5, 0.5 },
		textTransform = "UPPERCASE",
	})

	a("ModSubscribeButton Button ImageView", {
		size = { 12, 12 },
		color = ssu.makeColor(227, 245, 250, 255),
		backgroundColor = ssu.makeColor(0, 0, 0, 0),
		gravity = { 0.5, 0.5 },
	})

	a("ModSubscribeButton Button ImageView!invisible", {
		visibility = "none",
	})

	a([[ModTile ModSubscribeButton Button!subscribed,
		ModSubscribeButton Button!subscribed]], {
		backgroundColor = ssu.makeColor(255, 255, 255, 20),
		borderColor = ssu.makeColor(83, 151, 198, 200),
	})

	a([[ModTile ModSubscribeButton Button:hover!subscribed,
		ModSubscribeButton Button:hover!subscribed]], {
		backgroundColor = ssu.makeColor(106, 192, 251, 100),
		borderColor = ssu.makeColor(106, 192, 251, 100),
	})

	a("ModSubscribeButton!mod-dependency Button::Layout", {
		gravity = { 0.5, 0.5 },
	})

	a("ModSubscribeButton!mod-dependency Button", {
		size = { 18, 18 },
		margin = { 2, 2, 2, 2 },
	})

	a("ModTile ModSubscribeButton Button", {
		margin = { 0, 4, 4, 4 },
		padding = { 2, 2, 2, 2 },
	})

	a("ModTile ModSubscribeButton Button TextView", {
		fontSize = 12,
	})

	-- overwrite default rule that sets KeybindingHintDisplay gravity when inside a table
	a("ModTile ModSubscribeButton Button KeybindingHintDisplay!overflowMode!overflowMode!overflowMode", {
		gravity = {0.05, 0.5},
	})

	a("ModsBrowser ModTile !name-text", {
		padding = {0, 7, 0, 7},
		textAutoWrap = false,
		size = {256, -1},
	})

	a("ModsBrowser ModTile !stat-text", {
		fontSize = 10,
		padding = {0, 4, 0, 4},
		gravity = { 0, 0.5 },
	})


	a("ModsBrowser ModTile !stat-img", {
		size = { 12, 12 },
		backgroundColor = ssu.makeColor(0, 0, 0, 0),
		gravity = { 0, 0.5 },
	})

	a("ModsBrowser ModTile !stat-combo", {
		margin = { 0, 8, 0, 8 },
		gravity = { 0, 0.5 },
	})

	a([[ModsBrowser ModTile !stat-combo-secondary TextView, ModsBrowser ModTile !stat-combo-secondary ImageView]], {
		color = ssu.makeColor(255,255,255,150),
	})

	-- Mod Context Menu

	a("ModTileContextMenu", {
		size = { -1, -1 }
	})

	a("ModTileContextMenu Button", {
		minSize = { 120, -1},
	})

	a("ModTileContextMenu Button TextView", {
		textAlignment = {1.0, .5},
		size = {-1, -1}
	})

	-- Mod Like Button
	a("ModDetailsDialog !button-list !list-item KeybindingHintDisplay!overflowMode", {
		margin = { 0, 3, 0, 3 }
	})
	a([[ModDetailsDialog !button-list ToggleButton > wrap LinearLayout]], {
		gravity = {0.5, 0.5},
		innerSpacing = {0, 0},
	})

	-- minSize/margin to force same vertical position at least for a few digits
	a([[ModDetailsDialog !button-list ToggleButton > wrap TextView]], {
		textAlignment = {1, 0.5},
		minSize = {50, -1},
		padding = {0, 0, 0, 0},
	})
	a([[ModDetailsDialog !button-list ToggleButton > wrap ImageView]], {
		maxSize = {24, 24}
	})

	-- Mod Tile: Unpublished

	a("ModsBrowser ModTile!unpublished", {
		backgroundColor = ssu.makeColor(0, 0, 0, 120),
	})

	-- Mod Tile: Placeholder

	a("ModsBrowser ModTile!placeholder !name-text", {
		backgroundColor = ssu.makeColor(200, 200, 200, 100),
		margin = {0, 7, 0, 7},
	})
	a("ModsBrowser ModTile!placeholder !stat-text", {
		backgroundColor = ssu.makeColor(200, 200, 200, 100),
		size = {40, -1},
	})
	a("ModsBrowser ModTile!placeholder", {
		backgroundColor = ssu.makeColor(0, 0, 0, 50),
	})

	a("ModsBrowser ModTile ImageView!placeholder-throbber", {
		size = { 256, 144 },
		gravity = {0.5, 0.5},
	})

	-- STATUS BAR

	a("ModsBrowser !disk-icon", {
		gravity = {0, 0},
		size = {32, 32}
	})

	a("MenuUI ModsBrowser ProgressBar", {
		backgroundColor = ssu.makeColor(255, 255, 255, 255),
		size = {400, -1},
		margin = {0, 0, 8, 0}
	})

	a("MenuUI ModsBrowser !grid-status-text", {
		fontSize = 12,
		gravity = {-1, 0}
	})

	a("MenuUI ModsPage ComboBox!ordering-combo-box", {
		size = {240, -1},
	})
	a("!ui-couch MenuUI ModsPage ComboBox!ordering-combo-box", {
		size = {200, -1},
	})

	-- Authentication Box

	a("ModHubForm::Overlay,  MenuUI ModsBrowser DialogBox::Overlay", {
		backgroundColor = ssu.makeColor(0, 0, 0, 200),
	})

	a("DialogBox!mod-message-box DialogBox::Overlay, DialogBox!mod-upload DialogBox::Overlay, ModUploadDialog::Overlay", {
		backgroundColor = ssu.makeColor(0, 0, 0, 200),
	})

	a("DialogBox!mod-message-box!modio-info DialogBox::Content", {
		padding = { 24, 24, 24, 24 },
	})

	a("DialogBox!mod-message-box!modio-info DialogBox::Text", {
		size = { 360, -1 },
		padding = { 16, 16, 16, 16, },
		textAutoWrap = true,
	})

	a("ModHubForm::Title", {
		textTransform = "UPPERCASE",
		padding = { vp, hp, vp, hp }
	})


	a("ModHubForm::Content", {
		minSize = {200, -1},
		backgroundColor = ssu.makeColor(5+45, 25+45, 40+45),
		shadowNinePatch = { fileName = "ui/l1_window_shadow.tga", horizontal = { 0, 16, 48, 64 }, vertical = { 0, 16, 48, 64 } },
		shadowWidth = { 16, 16, 16, 16 },
		padding = {10, 10, 10, 10},
		shadowColor = ssu.makeColor(255, 255, 255),
	})

	a("ModHubForm::Content !auth-type-list", {
		gravity = {-1, 0},
		size = {-1, -1},
	})	
	a("ModHubForm::Content !auth-type-list ButtonLineWrap", {
		gravity = {1, 0},
		size = {-1, -1},
		margin = { 5, 0, 0, 0 },
	})
	
	

	a("!ui-couch ModHubForm::Content Button", {
		margin = { 5, 0, 5, 32 },
	})

	a("ModHubForm::InputLabel", {
		padding = { vp, hp, vp, hp },
		minSize = { 100, -1 },
	})
	a("ModHubForm::InputTextScrollArea", {
		padding = { vp, hp, vp, hp },
		size = { 300, -1 },
		backgroundColor = ssu.makeColor(0, 0, 0, 255),
	})
	a("ModHubForm::InputText", {
		padding = { 0,0,0,0 },
		textTransform = "UPPERCASE",
	})
	a("ModHubForm ComboBox", {
		padding = { 4, hp, 4, hp },
		minSize = { 300, -1 },
		backgroundColor = ssu.makeColor(0, 0, 0, 255),
	})
	a("ModHubForm::InputError", {
		color = ssu.makeColor(255, 0, 0, 255),
		padding = { vp, hp, vp, hp }
	})

	a("ModHubForm::TermsOfUse", {
		padding = { vp, hp, vp, hp },
		size = {-1, 200},
	})
	a("ModHubForm::TermsOfUse TextView", {
		size = {500, -1},
		fontSize = ssu.styles.uicouch_body_fontSize,
		textAutoWrap = true,
	})

	a("ModHubForm::Text", {
		padding = { vp * 2, hp, vp * 2, hp }
	})
	a("!ui-couch ModHubForm::Text", {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})
	a("ModHubForm::Layout", {
		gravity = { -1.0, -1.0 },
	})

	a("ModDetailsDialog TextView!title", {
		fontSize = ssu.styles.uicouch_subtitle_fontSize,
	})
	a("ModDetailsDialog TextView!mod-tag, ModUploadComp TextView!mod-tag", {
		fontSize = ssu.styles.uicouche_hints_fontSize,
		backgroundColor1 = ssu.makeColor(0, 0, 0, 50),
		backgroundImage1 = {
			fileName = "ui/design/buttons/disk_mini_surface.tga",
			horizontal = {0, 12, 12, 24},
			vertical = {0, 12, 12, 24}
		},
		padding = { 6, 12, 6, 12 },
	})
	a("ModDetailsDialog TextView!mod-desc", {
		textAutoWrap = true,
		gravity = { -1, -1 },
		maxSize = { -1, -1 },
		--padding = {0,0,0,0},
		--margin = {0,0,0,0},
		--borderWidth={1,1,1,1},
		--borderColor={1,1,1,1},
	})
	a("ModDetailsDialog TextView!mod-dependency", {
		maxSize = { 500, -1 },
	})
	a("ModDetailsDialog TextView!mod-dependency", {
		padding = { 5, 5, 5, 10 },
	})
	a("ModDetailsDialog Button!mod-dependency", {
		gravity = {-1, 0},
	})
	a("ModDetailsDialog ModSubscribeButton!mod-dependency KeybindingHintDisplay!overflowMode", {
		gravity = {0, 0.5},
	})
	a("ModDetailsDialog !left-scroll", {
		gravity = {0, -1},
		margin = {0, 16, 0, 0}
	})
	a("ModDetailsDialog !left-scroll LeftScrollContent", {
		gravity = {-1, 0},
		size = {340, -1},
	})

	a([[!input-mouse ModDetailsDialog !scroll-hint-button, !input-mouse ModDetailsDialog !cycle-hint-button]], {
		visibility = "none"
	})

	a([[ModDetailsDialog !left-scroll !button-list ToggleButton:hover,
		ModDetailsDialog !left-scroll !button-list Button:hover
	]], {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})
	a([[ModDetailsDialog !button-list NavList::ListLayout]], {
		innerSpacing = {0, vp /2 },
	})
	a([[ModDetailsDialog !left-scroll !button-list ToggleButton,
		ModDetailsDialog !left-scroll !button-list > * > * > Button]], {
		backgroundColor = ssu.makeColor(0, 0, 0, 50),
	})

	a([[ModDetailsDialog !left-scroll !button-list !list-item]], {
		size = {-1, 32},
	})
	a([[ModDetailsDialog !left-scroll !button-list ModSubscribeButton Button]], {
		gravity = {-1, -1},
	})
	a("ModDetailsDialog ModSubscribeButton Button", {
		padding = {0, 0, 0, 0},
	})

	a("ModDetailsDialog !left-scroll !button-list ToggleButton:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 75),
	})

	a("ModDetailsDialog !left-scroll !button-list", {
		gravity = {-1, 0},
	})
	a("ModDetailsDialog !left-scroll !button-list !list-item", {
		gravity = {-1, 0},
		margin = { 0, 0, 4, 0 },
		padding = { 0, 0, 0, 0 },
	})
	a("ModDetailsDialog !left-scroll !button-list !list-item > ToggleButton > ToggleButton::Layout", {
		gravity = {-1, 0.5},
	})
	a("ModDetailsDialog !left-scroll !button-list !list-item > ToggleButton", {
		gravity = {-1, -1},
	})
	a("ModDetailsDialog !left-scroll !button-list !list-item > ImageView", {
		maxSize = {24, 24},
	})
	a("ModDetailsDialog !left-scroll !button-list !list-item > Button::Layout", {
		gravity = {-1, 0.5},
	})
	a("ModDetailsDialog !left-scroll !button-list !list-item > Button::Text", {
		textAlignment = {0.5, 0.5},
	})

	a("ModDetailsDialog !right-scroll", {
		gravity = {-1, -1 },
	})
	a("MenuWindow!mod-detail-page !mod-title", {
		fontSize = 28,
		padding = { vp, 40, 5, 0, },
		gravity = {0.5, 0.5},
	})
	a("MenuWindow!mod-detail-page SplitWrapLeft !mod-title", {
		size = {1, -1}, -- make sure it has no width but same height as original text
		visibility = "hidden", -- it is just meant as a vertical spacing
	})
	-- note: gallery-image size is set via C++
	a("ModDetailsDialog !right-scroll ToggleButtonGroup ToggleButton KeybindingHintDisplay", {
		visibility = "none"
	})
	a("ModDetailsDialog !right-scroll ToggleButtonGroup ToggleButton", {
		borderWidth = {4,4,4,4},
	})
	a("ModDetailsDialog !right-scroll ToggleButtonGroup ToggleButton:hover", {
		borderColor = ssu.makeColor(70, 150, 255, 70)
	})
	a("ModDetailsDialog !right-scroll ToggleButtonGroup ToggleButton:active", {
		borderColor = ssu.makeColor(70, 150, 255, 70)
	})

	a("ModDetailsDialog ToggleButtonGroup ImageView", {
		size = {192, 108},
		gravity = {0, -1},
	})

	-- thum
	a("ModDetailsDialog !right-scroll !gallery-thumbnails ToggleButtonGroup::Layout", {
		innerSpacing = {0,0},
		outerSpacing = {0,0},
	})
	a("ModDetailsDialog !right-scroll ReleaseItem !release-version", {
	})
	a("ModDetailsDialog !right-scroll RightScrollContent > ReleaseItem", {
		gravity = {-1, 0},
	})
	a("ModDetailsDialog !right-scroll ReleaseItem !release-version", {
		fontSize = ssu.styles.uicouch_tab_title_fontSize,
	})
	a("ModDetailsDialog !right-scroll !title", {
		padding = { 15, 10, 5, 0, },
	})
	a("ModDetailsDialog !right-scroll ReleaseItem TextView", {
		padding = { 5, 10, 5, 0, },
	})

	a("ModDetailsDialog !right-scroll RightScrollContent > *", {
		gravity = {0.5, 0},
	})
	a("ModDetailsDialog !right-scroll RightScrollContent > TextView", {
		gravity = {0, 0},
	})
	a("ModDetailsDialog !right-scroll RightScrollContent", {
		padding = { 0, hp, 0, 0 },
	})
	a("ModDetailsDialog > BoxLayout", {
		innerSpacing = {hp, 5},
	})
	a("ModDetailsDialog !right-scroll RichTextView", {
		padding = { 0, 10, 5, 0, }
	})
	a([[ModDetailsDialog !right-scroll RightScrollContent > ChildSizeWrap > TextView,
				 ModDetailsDialog !right-scroll RightScrollContent RichTextView,
				 ModDetailsDialog !right-scroll RightScrollContent > ReleaseItem > ChildSizeWrap > *]], {
		gravity = { 0.5, 0 },
	})
	a("ModDetailsDialog !right-scroll RightScrollContent PreviewsWrap ScrollBar", {
		visibility = "none",
	})
	a("ModDetailsDialog !right-scroll RightScrollContent PreviewsWrap", {
		gravity = {-1, 0},
	})
	a("ModDetailsDialog !right-scroll RightScrollContent PreviewsWrap > Button!prev-preview", {
		gravity = {0, 0.5},
	})
	a("ModDetailsDialog !right-scroll RightScrollContent PreviewsWrap > Button!next-preview", {
		gravity = {1, 0.5},
	})
	a("ModDetailsDialog !right-scroll RightScrollContent PreviewsWrap > Button:hover", {
		backgroundColor = {0,0,0,0},
	})
	a("ModDetailsDialog !right-scroll RightScrollContent PreviewsWrap > Button:active", {
		backgroundColor = {0,0,0,0},
	})
	a("ModDetailsDialog !right-scroll RightScrollContent PreviewsWrap > Button Button::Icon", {
		color = ssu.makeColor(255, 255, 255, 220),
	})
	a("ModDetailsDialog !right-scroll RightScrollContent PreviewsWrap > Button Button::Icon:hover", {
		color = ssu.makeColor(255, 255, 255, 255),
	})
	a("ModDetailsDialog !right-scroll RightScrollContent PartiallySupportedWarning", {
		gravity = {-1,0},
	})
	a("ModDetailsDialog !right-scroll RightScrollContent PartiallySupportedWarning > ChildSizeWrap > TextView", {
		textAutoWrap = true,
		color = ssu.makeColor(214 - 2 * 12, 214 - 12, 214)
	})
	a("ModDetailsDialog !right-scroll RightScrollContent PartiallySupportedWarning > WarningIconImage", {
		size = { 12, 12 },
		color = ssu.makeColor(214 - 2 * 12, 214 - 12, 214)
	})
	a("ModDetailsDialog !author-avatar-image", {
		margin = {0, 0, 0, 10},
		size = {32, 32}
	})

	a("ModDetailsDialog !author-name-text", {
		padding = {0, 0, 0, 0}
	})

	a("ModDetailsDialog MenuWindow::Buttons", {
		padding = { 25, 15, 25, 0, }
	})
	a("ModDetailsDialog!invisible", {
		visibility = "hidden",
	})

	a("!input-controller ModsPage !ordering-combo-box !left-button", {
		size = {0,0},
	})
	a("!input-controller ModsPage !ordering-combo-box !right-button", {
		size = {7,0},
	})
	a("ModsBrowser !status-bar-wrap Button!prev-button, ModsBrowser !status-bar-wrap Button!next-button", {
		padding = {9, 0, 9, 0},
	})
	a("ModsBrowser ModsTableScrollContent::RightButtons Button!prev-button, ModsBrowser ModsTableScrollContent::RightButtons Button!next-button", {
		padding = {9, 0, 9, 0},
	})
	a("ModsBrowser !status-bar-wrap", {
		padding = {0, 32, 0, 0},
	})
	a("!input-controller ModsBrowser !status-bar-wrap !login-button", {
		padding = {0, 32, 0, 0},
	})
	a("ModsBrowser !status-bar-wrap Button!next-button KeybindingHintDisplay", {
		gravity = {1, 0.5}
	})

	a("ModsBrowser !status-bar-wrap !page-dots, ModsBrowser ModsTableScrollContent::RightButtons !page-dots", {
		padding = {0, 0, 0, 0},
	})

	a("ModsBrowser !status-bar-wrap Button::Icon", {
		size = {18, 12},
	})

	a("ModsBrowser ModsTableScrollContent::RightButtons Button::Icon", {
		size = {18, 12},
	})

	a("MenuWindow!mods-page MenuWindow::Buttons MenuWindow::LeftButtons", {
		gravity = { 0, 1 },
	})

	a("MenuWindow!mods-page ModsTableScrollContent::RightButtons !right-button", {
		margin = { 0, 16, 0, 0 },
	})

	-- MOD UPLOAD

	a("ModUploadMenuComp::OpenFolder::Icon", {
		padding = { 4, 4, 4, 4 },
		margin = { 2, 2, 2, 2 },
	})

	a("ModUploadMenuComp::OpenFolder::Icon:hover", {
		backgroundImage1 = { fileName = "ui/design/buttons/disk_small_surface_cut.tga" },
		backgroundColor1 = ssu.makeColor(0, 0, 0, 80),
	})

	a("ModUploadComp::PreviewBox", {
		padding = { 12, 12, 12, 12 },
		borderColor = ssu.makeColor(120, 120, 120, 255),
		borderWidth = { 2, 2, 2, 2, }
	})

	a("ModUploadComp ComboBox!language-combobox", {
		size = {200, -1}
	})

	a("ModUploadComp ImageView!image-00", {
		padding = { 0, 0, 0, 0 },
	})

	a("ModUploadComp TextView!image-00-label", {
		padding = { 5, 5, 5, 5 }
	})

	a("ModUploadComp !name-label", {
		fontSize = 20,
		padding = {0, 0, 0, 0}
	});

	a("ModUploadMenuComp RichTextView", {
		padding = {0, 0, 0, 0}
	})

	a("ModUploadComp::Tags", {
		padding = { 6, 0, 6, 0 },
	})

	a("ModUploadComp ScrollArea", {
		gravity = {-1,-1},
	})

	a("ModUploadComp ScrollArea::Content", {
		padding = { 6, 12, 6, 0 },
	})

	a("ModUploadComp ScrollArea ScrollArea", {
		margin = { 4, 0, 4, 0 },
	})

	a("ModUploadComp ScrollArea ScrollArea ScrollArea::Content", {
		padding = { 0, 0, 0, 0 },
	})

	a("ModUploadComp ComboBox", {
		gravity = { -1, -1 },
		size = { 240, -1 },
	})

	a([[ModUploadComp ComboBox wrap,
		ModUploadCompDropEntry!combo-box-list-item!list-item TextView]], {
		gravity = { -1, -1 },
	})

	a("ModUploadCompDropEntry!combo-box-list-item!list-item ImageView", {
		margin = { 8, 26, 8, 0 },
	})

	a([[ModUploadComp ComboBox TextView]], {
		padding = { 6, 12, 6, 12 },
	})

	a([[ModUploadComp ComboBox ImageView]], {
		margin = { 0, 4, 0, 0 },
	})

	a([[ModUploadComp TextView,
		ModUploadComp TextInputField]], {
		gravity = { -1, 0 },
		padding = { 6, 0, 6, 0 },
		textAlignment = { 0, 0.5 },
	})

	a("ModUploadComp TextInputField", {
		padding = { 6, 12, 6, 12 },
	})

	a("ModUploadComp TextView!backend-info", {
		color = ssu.makeColor(255, 168, 54, 255),
	})

	a("ModUploadComp TextView!terms-of-service", {
		color = ssu.makeColor(153, 204, 255, 255),
		maxSize = { 600, -1 },
		textAutoWrap = true,
	})

	a("!platform-console Button!terms-of-service", {
		visibility = "none"
	})

	a("ModUploadComp TextView!terms-of-service!small", {
		maxSize = { 400, -1 },
	})

	a("ModUploadComp TextView!option", {
		padding = { 12, 0, 12, 0 },
	})

	a("ModUploadComp !terms-of-service Button::Text", {
		color = ssu.makeColor(153, 204, 255, 255),
		fontSize = 14,
		padding = { 6, 6, 6, 6 },
		textAlignment = { 0, 0.5 },
		gravity = { 0.5, 0.5 },
	})

	a("ui-couch ModUploadComp !terms-of-service Button::Text", {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})

	a([[ModUploadComp ImageView!preview,
		ModUploadComp ImageView!image-00]], {
		gravity = { -1, -1 },
		size = { 320, 180 },
	})


	a([[ModUploadComp ImageView!preview]], {
		padding = { 36, 0, 36, 0 },
	})

	a("ModUploadComp CheckBox", {
		gravity = { -1, 0 },
		padding = { 12, 0, 12, 0 },
	})

	a("ModUploadComp CheckBox:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})

	a("ModUploadMenuComp BuyButton!right-button", {
		margin = { 12, 0, 0, 0 },
	})

	a("!ui-couch ModUploadMenuComp::FocusModData!table-item KeybindingHintDisplay!overflowMode", {
		gravity = { 0, 0.5 },
	})

	a("!ui-couch ModUploadMenuComp::OpenFolder!table-item KeybindingHintDisplay!overflowMode", {
		gravity = { 0.8, 0.2 },
	})

	a("ModUploadMenuComp BuyButton!right-button KeybindingHintDisplay!overflowMode", {
		gravity = {0, 0.5},
		margin = { 0, 12, 0, 0 },
	})

	a("ModUploadDialog MenuWindow!mod-upload", {
		size = { 720, 580 },
	})

	a("DialogBox!mod-publish DialogBox::Content", {
		padding = { 12, 12, 12, 12 },
	})

	a("DialogBox!mod-publish DialogBox::Text", {
		size = { 420, -1 },
		textAlignment = { 0.0, 0.5 },
	})

	return result
end
