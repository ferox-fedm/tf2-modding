require "tableutil"
local ssu = require "stylesheetutil"

local contentPadding = 10
local hp = 10
local vp = 5

local constructionMenuMainColor = ssu.makeColor(5+25, 25+25, 40+25, 200)
local constructionMenuBackColor = ssu.makeColor(5, 25, 40, 210)
local constructionMenuHoverColor = ssu.makeColor(5+10, 25+10, 40+10, 200)

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("Window::Layout, Window::TitleLayout", {
		innerSpacing = { 0, 0 }
	})

	a("Window, Window!window-extension-view", {
		anchorPoint = { 0, 0 },
	    maxSize = {10000, 10000},  -- generally allow nearly limitless manual size increases
		gravity = { .0, .0 },
		blurRadius = 16 * 4
	})

	a("!ui-couch Window!window-extension-view", {
		margin = { 0, 10, 0, 0 },
		anchorPoint = { 1, 0 },
		size = ssu.sizes.ui_couch_extension_window_size,
		gravity = { .0, .0 },
		blurRadius = 16 * 4
	})

	a("Window, MenuWindow", {
		backgroundColor = ssu.makeColor(5, 25, 40, 175),
		--borderWidth = { 1, 1, 1, 1},
		--borderColor = ssu.makeColor(10, 27, 41, 100),
		shadowNinePatch = { fileName = "ui/l1_window_shadow.tga", horizontal = { 0, 16, 48, 64 }, vertical = { 0, 16, 48, 64 } },
		shadowWidth = { 16, 16, 16, 16 },
		shadowColor = ssu.makeColor(255, 255, 255),
	})

	a([[MenuWindow!savegame-basic-settings,
	MenuWindow!mod-upload]], {
		backgroundColor = ssu.makeColor(5+45, 25+45, 40+45),
	})

	a("Window!construct-settings", {
		anchorPoint = { 1.0, 1.0 },
		gravity = { 1.0, 1.0 },
		backgroundColor = ssu.makeColor(70, 83, 93, 150),
		--borderWidth = { 1, 1, 1, 1},
		--borderColor = ssu.makeColor(10, 27, 41, 100),
		maxSize = { 405, 430 },
	})
	a("!ui-couch Window!construct-settings", {
		minSize = { 400, -1 },
		anchorPoint = { 1.0, 0.0 },
		gravity = { 1.0, 0.0 },
		margin = { 50, 10, 0, 0 }
	})
	a("!ui-couch !top-gamebar-visible Window!construct-settings", {
		margin = { 50, 10, 203, 0 },
	})

	a("!ui-couch Window!construct-settings Window::Content", {
		padding = { 0, 0, 0, 0 },
	})

	a("Window::Title", {
		fontSize = 16,
		textTransform = "UPPERCASE",
		padding = { 0, contentPadding, 0, contentPadding }
	})
	a("!ui-couch Window::Title", {
		fontSize = ssu.styles.uicouch_window_title_fontSize,
		textTransform = ssu.styles.uicouch_window_title_textTransform,
	})
	a("Window::Title!title-editable", {
		textTransform = "NONE",
	})
	
	a("Window::Icon", {
		padding = { 0, 0, 0, contentPadding }
	})
	
	a("Window::TitleComp TextInputField", {
		fontSize = 16,
	})
	a("!ui-couch Window::TitleComp TextInputField", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	
	a("Window::Content", {
		padding = { 1, 1, 1, 1 }
	})
	
	local windowTitleBarBaseStyle = {
		--backgroundColor = ssu.makeColor(5, 25, 40, 128),
		--backgroundImage1 = { fileName = "ui/design/game-menu/shadow_window_top.tga" },
		--backgroundColor1 = ssu.makeColor(100, 100, 255, 25), --ssu.makeColor(5, 25, 40),
		--borderWidth = { 0, 0, 1, 0},
		--borderColor = ssu.makeColor(5, 25, 40),
		minSize = { 32, 32 }
	}
	
	a("Window::Title-bar, MenuWindow::Title-bar, !construct-settings Window::Title-bar", windowTitleBarBaseStyle)


	a([[!input-controller !construct-menu !close-button,
		!input-controller !construct-editor-menu !close-button]], {
		visibility = "transparent"
	})

	a([[!input-controller #menu.layers.hudFilterWindow !close-button,
		!input-controller #contexthelper.window !close-button,
		!input-controller Window::Close!close-button]], {
		visibility = "folded"
	})

	a("!input-controller Window!layers-window !close-button", {
		visibility = "none"
	})

	a("!input-controller Window!layers-window !reduce-button", {
		visibility = "folded"
	})

	a("!ui-couch Window!layers-window !reduce-button", {
		actionPromptList = {
			{ ia = "ACTION_CLICK", text = _("Minimize") }
		},
	})

    -- a("!input-controller #guidesystem.window Window::Close KeybindingHintDisplay!overflowMode", {
	-- 	gravity = {0.0, 0.5}
	-- })

	a("Window !window-button, !construct-menu !close-button, !construct-editor-menu !close-button, !vehicle-manager !close-button, !line-manager !close-button", {
		minSize = { -1, 33 },
	})
	a("Window !window-button!close-button:hover, !construct-menu !close-button:hover, !construct-editor-menu !close-button:hover, !vehicle-manager !close-button:hover, !line-manager !close-button:hover", {
		backgroundColor = ssu.makeColor(200, 0, 0, 200)
	})
	a("Window !window-button!close-button:active, !construct-menu !close-button:active, !construct-editor-menu !close-button:active, !vehicle-manager !close-button:active, !line-manager !close-button:active", {
		backgroundColor = ssu.makeColor(255, 75, 75, 100)
	})
	a("Window !window-button!close-button:disabled, !construct-menu !close-button:disabled, !construct-editor-menu !close-button:disabled, !vehicle-manager !close-button:disabled, !line-manager !close-button:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})

	a("Window::Title-edit ImageView", {
		padding = { vp + 6, hp, vp + 5, hp }
	})

	a("Window !window-button:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 25)
	})
	a("Window !window-button:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50)
	})
	a("Window !window-button:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})

	a("Window!camera-manager", {
	    size = {800, 600},
	    minSize = {700, 200},
	})
	a("Window!load-save-camera-config", {
	    size = {800, 300},
	})	
	
	a("!platform-console RendererCompWithOverlay!sim-person-rc", {
	    size = {-1, 405},
	})

	a("!platform-console !vehicle-rc", {
	    size = {-1, 316},
	})

	-- a("!ui-classic RendererCompWithOverlay!sim-person-rc", {
	    -- size = {-1, 183},
	-- })

	-- a("!ui-classic !vehicle-rc", {
	    -- size = {-1, 145},
	-- })

	-- a("!ui-classic Window!animal-rc", {
	    -- size = {-1, 183},
	-- })

	-- a("!ui-couch RendererCompWithOverlay!sim-person-rc", {
	--     size = {-1, 405},
	-- })

	-- a("!ui-couch !vehicle-rc", {
	--     size = {-1, 316},
	-- })

	-- a("!ui-couch Window!animal-rc", {
	    -- size = {-1, 183},
	-- })

	return result
end
