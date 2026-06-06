require "tableutil"
local ssu = require "stylesheetutil"

local hp = 2*10
local vp = 2*5

local winOuterSpacing = 25
local winInnerSpacing = 25

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("MenuWindow", {
		blurRadius = 16 * 4
	})
	
	a("MenuWindow::Layout", {
		innerSpacing = { 0, 0 },
	})
	
	a("MenuWindow::TitleLayout", {
		innerSpacing = { 0, 0 },
		outerSpacing = { winOuterSpacing, vp }
	})

	a("MenuWindow::TitleText", {
		fontSize = 18,
	})
	a("!ui-couch MenuWindow::TitleText", {
		fontSize = ssu.styles.uicouch_window_title_fontSize,
		textTransform = ssu.styles.uicouch_window_title_textTransform,
	})
	
	a("MenuWindow::Content", {
		padding = { winInnerSpacing-12, winOuterSpacing, 0, winOuterSpacing }
	})
		
	a("!ui-couch MenuWindow!settings MenuWindow::Content", {
		margin = { 0, "10vw", 0, "10vw" },
		gravity = { 0.5, -1 },
	})

	a([[!ui-couch MenuWindow!settings !right-column ComboBox,
		!ui-couch MenuWindow!settings !right-column ComboBox::Button!content-button]], {
		gravity = { -1, 0.5 },
	})

    local settingsMenuColumnWidthLeft = 400
    local settingsMenuColumnWidthRight = 266
	a([[!ui-couch MenuWindow!settings !right-column,
		!ui-couch MenuWindow!settings !right-column ComboBox,
		!ui-couch MenuWindow!settings !right-column ComboBox::Button!content-button]], {
		size = { settingsMenuColumnWidthRight, -1},
	})
	a([[!ui-couch MenuWindow!settings !list-item,
	    !ui-couch NavList#mainMenu.newGame.tabMap]], {
		size = { settingsMenuColumnWidthLeft + settingsMenuColumnWidthRight + (10+10), -1}, -- 10+10: padding of TextView
	})
	a([[!ui-couch NavList#mainMenu.newGame.tabDifficulty]], {
		size = { 750, -1},
	})
	a("!ui-couch MenuWindow!settings !left-column", {
        maxSize = { settingsMenuColumnWidthLeft, -1 },
		gravity = { 0, 0.5 },
	})
	a("!ui-couch MenuWindow!settings !right-column", {
		gravity = { 1, 0.5 },
	})

    a("!ui-couch MenuWindow!settings NavList, !ui-couch MenuWindow!settings KeyMapping Table", {
	    padding = {0, 0, 0, 15}, -- fix symmetry, scrollbar on the right side has a width of 15
    })
    a("!ui-couch MenuWindow!settings !controls-keyboard", {
	    padding = {0, 15, 0, 15}, -- fix symmetry (but here there is no scrollbar on either side)
    })

	a("!ui-couch MenuWindow!settings !tab-widget-indicator, !ui-couch MenuWindow!settings !tab-widget-icon-indicator", {
		padding = { 0, hp, -1, hp },
		borderWidth = { 0, 0, 2, 0 },
		minSize = { 60, 33 },
	})
	a("!ui-couch MenuWindow!settings !tab-widget-indicator-scrollview", {
		gravity = {0.5, 0}
	})
	a("!ui-couch MenuWindow!settings TabWidgetIndicatorHintWrap", {
		gravity = {0.5, 0},
	})

	a("!ui-couch MenuWindow!settings !tab-widget-content", {
		margin = {0, 100, 0, 100},
		gravity = { -1, -1},
	    size = { -1, -1},
    })
	
	a("!ui-couch Window!load-save-preset Button!left-button KeybindingHintDisplay", {
		gravity = { 1, 0.5},
    })
	a("!ui-couch Window!load-save-preset Button!right-button", {
		margin = { 0, 0, 0, 40 },
    })

	a("WindowContentLayout, MenuWindow LinearLayout", {
		innerSpacing = { winInnerSpacing, winInnerSpacing }
	})
	
	a("MenuWindow::Buttons", {
		padding = { winInnerSpacing, winOuterSpacing - 10, winInnerSpacing, winOuterSpacing - 10 },
	})

	a("MenuWindow::Buttons", {
		gravity = {-1, 0.5}
	})
	a("MenuWindow::Buttons MenuWindow::LeftButtons", {
		gravity = {0, 0.5}
	})
	a("MenuWindow::Buttons MenuWindow::RightButtons", {
		gravity = {1, 0.5}
	})
	a("MenuWindow::Buttons MenuWindow::RightButtons Button", {
		margin = {0, 0, 0, 32},
	})
	
	a("MenuWindow::Buttons !left-button Button::Text", {
		fontSize = 16
	})
	a("!ui-couch MenuWindow::Buttons !left-button Button::Text", {
		fontSize = ssu.styles.uicouch_primarybuttons_fontSize,
		textTransform = ssu.styles.uicouch_primarybuttons_textTransform,
	})
	
	a("MenuWindow::Buttons !right-button Button::Text", {
		fontSize = 16
	})
	a("!ui-couch MenuWindow::Buttons !right-button Button::Text", {
		fontSize = ssu.styles.uicouch_primarybuttons_fontSize,
		textTransform = ssu.styles.uicouch_primarybuttons_textTransform,
	})

	a("MenuWindow::Buttons !left-button KeybindingHintDisplay!overflowMode", {
		gravity = {1.0, 0.5},
	})

	a("MenuWindow::Buttons !right-button", {
		margin = { 0, 0, 0, 50 }
	})

	a("MenuWindow::Buttons !right-button KeybindingHintDisplay!overflowMode", {
		--gravity = {0.0, 0.5},
	})
	
	return result
end
