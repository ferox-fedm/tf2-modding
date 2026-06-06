require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local hp = 10
local vp = 5

local contentPadding = 10

local constructionMenuMainColor = ssu.makeColor(5+25, 25+25, 40+25, 200)
local constructionMenuBackColor = ssu.makeColor(5, 25, 40, 210)
local constructionMenuHoverColor = ssu.makeColor(5+10, 25+10, 40+10, 200)

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)

	a([[!construct-menu !title-bar, 
		!construct-menu !content, 
		!construct-menu !info-popup,
		!construct-editor-menu !title-bar, 
		!construct-editor-menu !content, 
		!construct-editor-menu !info-popup]], {
		blurRadius = 8 * 4
	})

	a([[!construct-menu !title-bar, 
		!construct-menu !close-button,
		!construct-editor-menu !title-bar,
		!construct-editor-menu !close-button]], {
		backgroundColor = constructionMenuBackColor,
		backgroundImage1 = { fileName = "ui/design/game-menu/shadow_window.tga" },
		backgroundColor1 = ssu.makeColor(5-10, 25-10, 40-10),
		size = { -1, 33 }
	})

	a([[!ui-couch !construct-menu!active-action,
		!ui-couch !construct-editor-menu!active-action]], {
		visibility = "transparent",
	})

	a("ConstructionMenu !tab-indicator ImageView, StatisticsWindow !tab-indicator ImageView", {
		margin = { 0, -11, -1, 0 },
		minSize = { 27, 27 },
		maxSize = { 40, 34 },
	})
	a("AddModuleComp !tab-indicator ImageView", {
		margin = { 0, -3, -1, 7 },
		size = { 17, 17 },
	})

	a([[!construct-menu !tab-indicator TextView,
		!construct-menu TextView!tab-indicator,
		!construct-editor-menu !tab-indicator TextView,
		!construct-editor-menu TextView!tab-indicator]], {
		color = ssu.makeColor(255, 255, 255),
		fontSize = 14,
		textTransform = "UPPERCASE",
		padding = { 0, hp, 0, hp },
	})
	a([[!ui-couch !construct-menu !tab-indicator TextView,
		!ui-couch !construct-menu TextView!tab-indicator,
		!ui-couch !construct-editor-menu !tab-indicator TextView,
		!ui-couch !construct-editor-menu TextView!tab-indicator]], {
		fontSize = ssu.styles.uicouch_body_fontSize
	})

	a([[!construct-menu !tab-indicator,
		!construct-editor-menu !tab-indicator]], {
		-- backgroundColor = constructionMenuBackColor,
		backgroundImage1 = { fileName = "ui/design/game-menu/shadow_window.tga" },
		--backgroundColor1 = ssu.makeColor(5-5, 25-10, 40-10),
		borderColor = ssu.makeColor(5, 25, 40),
		borderWidth = { 0, 1, 0, 0 },
		minSize = { 130, 33 },
	})
	a([[!construct-menu !tab-indicator:hover,
		!construct-editor-menu !tab-indicator:hover]], {
		backgroundColor = constructionMenuHoverColor
	})
	a([[!construct-menu !tab-indicator:active,
		!construct-editor-menu !tab-indicator:active]], {
		backgroundColor = ssu.makeColor(5+35, 25+35, 40+35, 240), --constructionMenuMainColor,
		--backgroundColor1 = ssu.makeColor(0, 0, 0, 110),
		soundEffect1 = sound.get("tabClick")
	})
	
	a([[!construct-menu !tab-indicator:disabled,
		!construct-editor-menu !tab-indicator:disabled]], {
		color = ssu.makeColor(150, 150, 150),
	})
	
	a([[!construct-menu !tab-indicator TextView:disabled,
		!construct-menu !tab-indicator ImageView:disabled,
		!construct-editor-menu !tab-indicator TextView:disabled,
		!construct-editor-menu !tab-indicator ImageView:disabled]], {
		color = ssu.makeColor(150, 150, 150),
	})

	--a("!construct-menu TabWidget", {
		--gravity = { -1, 0.5 },  -- "spread out" effect where tabs use whole size always
	--})

	a("!construct-menu BoxLayout, !construct-editor-menu BoxLayout", {
		innerSpacing = { 0, 0 }
	})

	a("!construct-menu MapPreviewComp", {
		minSize = { 600, 600 },
		maxSize = { 600, 600 },
	})
	
	a("!construct-menu !content", {
		backgroundColor = constructionMenuMainColor,
		padding = { 0, 0, 30, 0 },
		size = { -1, -1 },
	})

	a("!ui-couch !construct-menu !content", {
		backgroundColor = constructionMenuMainColor,
		padding = { 0, 0, 30, 0 },
		size = { -1, 160 },
	})

	a("!ui-couch StatisticsWindow!construct-menu-window LinesTable#menu.stats.vehicles.table DataTable LineFilterItem::LineComp Button::Icon", {
		padding = { 0, 0, 0, 0 }
	})
	a("!ui-couch StatisticsWindow!construct-menu-window !construct-menu !content", {
		size = { -1, 250 },
	})
	a("!ui-couch StatisticsWindow!construct-menu-window CGameUI::Content!content TabWidget::ContentLayout", {
		gravity = { -1, 0 },
	})
	a([[!ui-couch!input-mouse StatisticsWindow!construct-menu-window LinesTable#menu.stats.lines.table DataTable,
		!ui-couch!input-mouse StatisticsWindow!construct-menu-window LinesTable#menu.stats.vehicles.table DataTable]], {
		size = { -1, 200 },
	})
	a([[!ui-couch!input-controller StatisticsWindow!construct-menu-window LinesTable#menu.stats.lines.table DataTable,
		!ui-couch!input-controller StatisticsWindow!construct-menu-window LinesTable#menu.stats.vehicles.table DataTable]], {
		size = { -1, 220 },
	})

	a([[!ui-couch !construct-editor-menu GenerateStreetsComp Button!default-button]], {
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Default")},
		}
	})

	a([[!ui-couch !construct-editor-menu GenerateStreetsComp Button!clear-button]], {
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Clear")},
		}
	})

	a([[!ui-couch !construct-editor-menu GenerateStreetsComp::Settings]], {
		visibility = "folded"
	})

	a([[!construct-editor-menu GenerateHeightmapComp::Settings,
		!construct-editor-menu GenerateIndustriesComp::Settings,
		!construct-editor-menu GenerateTownsComp::Settings,
		!construct-editor-menu GenerateStreetsComp::Settings]], {
		gravity = {1, 0},
	})

	a([[!construct-menu GenerateHeightmapComp::Settings ScrollArea]], {
		maxSize = {-1, 375},
	})

	a([[!construct-editor-menu GenerateHeightmapComp::Settings ScrollArea]], {
		maxSize = {-1, 175},
	})

	a([[!construct-editor-menu GenerateHeightmapComp::Settings,
		!construct-editor-menu GenerateTownsComp::Settings,
		!construct-editor-menu GenerateIndustriesComp::Settings]], {
		size = {500, -1},
		minSize = {500, -1},
		maxSize = {500, -1},
	})

	a([[!construct-editor-menu GenerateHeightmapComp::Settings LabelValueItemGroup,
		!construct-editor-menu GenerateTownsComp::Settings LabelValueItemGroup,
		!construct-editor-menu GenerateIndustriesComp::Settings LabelValueItemGroup]], {
		margin = {0, 0, -5, 0},
	})
	a([[!construct-editor-menu GenerateHeightmapComp::Settings TextInputField]], {
		gravity = {0.5, 0.5},
		minSize = {250, -1},
		maxSize = {250, -1},
	})
	a([[!construct-editor-menu GenerateTownsComp::Settings TextInputField,
		!construct-editor-menu GenerateIndustriesComp::Settings TextInputField]], {
		gravity = {0.5, 0.5},
		minSize = {200, -1},
		maxSize = {200, -1},
	})

	a([[!construct-editor-menu GenerateHeightmapComp::Settings ParamsListComp::SliderParam::Label!label,
		!construct-editor-menu GenerateHeightmapComp::Settings TextView!label]], {
		minSize = {150, -1},
		maxSize = {150, -1},
		textAutoWrap = true,
	})
	a([[!construct-editor-menu GenerateTownsComp::Settings TextView!label,
		!construct-editor-menu GenerateIndustriesComp::Settings TextView!label]], {
		minSize = {200, -1},
		maxSize = {200, -1},
		textAutoWrap = true,
	})
	a([[!construct-editor-menu GenerateHeightmapComp::Settings ParamsListComp::SliderParam::SliderLabel]], {
		minSize = {100, -1},
		maxSize = {100, -1},
	})
	a([[!construct-editor-menu GenerateTownsComp::Settings LabelValueItemGroup !check-box,
		!construct-editor-menu GenerateIndustriesComp::Settings LabelValueItemGroup !check-box]], {
		minSize = {200, -1},
		maxSize = {200, -1},
	})

	a("!construct-editor-menu MapPreviewComp", {
		gravity = {0.5, 0},
		minSize = { 350, 350 },
		maxSize = { 350, 350 },
	})

	a("!construct-editor-menu GenerateStreetsComp MapPreviewComp", {
		gravity = {0, 0},
		padding = { 0, 60, 0, 0 },
	})

	a("!construct-editor-menu !content", {
		backgroundColor = constructionMenuMainColor,
		size = { "100vw", "50vh" },
		maxSize = { "100vw", "50vh" },
		minSize = { "100vw", "50vh" },
		padding = { 0, 0, 0, 0 },
	})
	a("!ui-couch!input-mouse !construct-editor-menu !content", {
		padding = { 0, 0, 35, 0 },
	})

	a([[!ui-couch !construct-editor-menu GenerateHeightmapComp Button!seed-button,
		!ui-couch !construct-editor-menu GenerateTownsComp Button!seed-button,
		!ui-couch !construct-editor-menu GenerateIndustriesComp Button!seed-button
		]], {
		visibility = "folded",
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Random Seed")},
		}
	})
	a([[!ui-couch !construct-editor-menu GenerateHeightmapComp Button!generate-button,
		!ui-couch !construct-editor-menu GenerateTownsComp Button!generate-button,
		!ui-couch !construct-editor-menu GenerateIndustriesComp Button!generate-button,
		!ui-couch !construct-editor-menu GenerateStreetsComp Button!generate-button]], {
		visibility = "transparent",
		actionPromptList = {
			{ia = "ACTION_CLICK", text = _("Generate")},
		}
	})
	a([[!ui-couch !construct-editor-menu GenerateHeightmapComp TextInputField!game-menu,
		!ui-couch !construct-editor-menu GenerateTownsComp TextInputField!game-menu,
		!ui-couch !construct-editor-menu GenerateIndustriesComp TextInputField!game-menu]], {
		actionPromptList = {
			{ia = "IA_LEFT", text = _("Change")},
			{ia = "IA_RIGHT", text = _("Change")},
		}
	})

	a("ConstructionMenuTab::RightButtonsLayout", {
		gravity = { 1, 0 },
		innerSpacing = { 5, 0 }
	})

	a("!construct-menu List::ListContent, !construct-editor-menu List::ListContent", {
		padding = { 0, 0, 17, 0 },
	})

	a("!construct-menu List ScrollBar, !construct-editor-menu List ScrollBar", {
		margin = { -15, 0, 0, 0 },  -- = ScrollBar height, to ensure no vertical jumps on vis change
		scaling = 0.8,
	})

	a("!construct-menu TextInputField, !construct-editor-menu TextInputField", {
		margin = { 0, 0, 0, 0 },
		padding = { 5, 0, 5, 0 },
	})
	a("!construct-menu InputTextScrollArea, !construct-editor-menu InputTextScrollArea", {
		gravity = { 0, 0 },
		size = { 180, 24 + 1*5},
		margin = { 0, 0, 2, 0 },
	})

	a("!ui-couch !construct-menu ConstructionMenuTab!cat-tab-content InputTextScrollArea", {
		visibility = "none",
	})

	a("!construct-menu !build-mode-options-group, !construct-editor-menu !build-mode-options-group", {
		gravity = { 0, 0 }
	})

	a("!ui-couch ToggleButtonGroup!build-mode-options-group", {
		gravity = { 0.5, 0 }
	})

	a("!input-controller BuildModeOptions!param-row:hover", {
		backgroundColor = ssu.makeColor(70, 150, 255, 70)
	})

	a("!ui-couch BuildModeOptions!param-row BoxLayout", {
		gravity = { -1, 0.5 },
	})

	a("ConstructionMenuTab::Categories", {
		gravity = { 0, 0 }
	})

	a("!ui-couch PopupCategoriesWrap", {
		maxSize = { 800, -1 },
	})

	a("!ui-couch PopupCategoriesWrap", {
		minSize = { 120, -1 },
	})
	
	a("!ui-couch PopupCategoriesWrap BoxLayout", {
		gravity = { -1, 0 }
	})

	a("!ui-couch PopupCategoriesWrap CategoriesRow ConstructionMenuTab::Categories", {
		gravity = { 0.5, 0 }
	})
	
	a("!ui-couch PopupCategoriesWrap CategoriesRow ConstructionMenuTab::Categories !category-button", {
		padding = { 5, 5, 5, 5 }
	})
	
	a("!ui-couch PopupCategoriesWrap CategoriesRow:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})

	a("!construct-menu List, !construct-editor-menu List", {
		minSize = { -1, 75 + 4 + 4 + 4 + 13 },
		margin = { 4, 0, 0, 0 }
	})

	a("!construct-menu !filter-button-icon, !construct-editor-menu !filter-button-icon", {
		padding = { 5, 5, 5, 5 },
		maxSize = { 100, 24 },
		minSize = { 16, 16 },
		gravity = { 0, 0 }
		--color = ssu.makeColor(255, 255, 255, 140),
	})

	a([[!ui-couch RailroadCrossingWindow::Categories]], {
		maxSize = { 460, 100 },
	})

	a("!construct-menu !entry-icon, !construct-editor-menu !entry-icon", {
		color = ssu.makeColor(255, 255, 255),
		padding = { 2, 10, 2, 10 },
		borderWidth = { 2, 2, 2, 2 },
		borderColor = ssu.makeColor(214, 214, 214, 0),
		maxSize = { 200, 75 },
		minSize = { 0, 75 },
	})
	a("!construct-menu !entry-icon:hover, !construct-editor-menu !entry-icon:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 30),
		borderColor = ssu.makeColor(255, 255, 255, 30)
	})
	a("!construct-menu !entry-icon:active, !construct-editor-menu !entry-icon:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 30),
		borderColor = ssu.makeColor(255, 255, 255, 100),
	})
	a("!construct-menu !entry-icon:disabled, !construct-editor-menu !entry-icon:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})
	
	a("!construct-menu !info-popup, !construct-editor-menu !info-popup", {
		backgroundColor = ssu.makeColor(5, 25, 40, 100),
		size = { 400, -1 },
		maxSize = {400, 145},
		padding = { vp, hp, vp, hp }
	})
	a("!ui-couch !construct-menu !info-popup, !ui-couch !construct-editor-menu !info-popup", {
	    maxSize = {400, 250}
	})
	
	a("!construct-menu !info-popup BoxLayout, !construct-editor-menu !info-popup BoxLayout", {
		innerSpacing = { 0, 5 }
	})


	a("!construct-menu ScrollView !scroll-button, !construct-editor-menu ScrollView !scroll-button", {
		scaling = 0.6,
		backgroundColor = ssu.makeColor(5, 25, 40, 200),
		margin = { 6, 0, 0, 0 },
	})

	a("!construct-menu !info-popup !title, !construct-editor-menu !info-popup !title", {
		textTransform = "UPPERCASE"
	})

	a("!construct-settings ParamsListComp", {
		minSize = { 384, -1 },  -- hides horizontal scrollbar
		maxSize = { 384, -1 },  -- hides horizontal scrollbar
		padding = { 0, 0, vp, hp / 2  }
	})
	a("!construct-settings Window::Title-bar Window::Title", {
		padding = { 0, hp, 0, hp/2  }
	})

	a("!ui-couch!input-controller !construct-settings Window::Title-bar", {
		visibility = "none",
	})

	a("!construct-menu-window", {
		anchorPoint = { .5, 1.0 },
		gravity = { .5, 1.0 },
	})
	a("!ui-classic !construct-menu-window", {
		margin = { 0, 405, 0, 405 },
	})
	a("!ui-couch !construct-menu-window", {
		size = { "100vw", -1 },
	})
	a([[!construct-menu-window ConstructionMenuContent,
		!construct-menu-window !construct-menu,
		!construct-menu-window !construct-editor-menu]], {
		gravity = { 0.5, 1 },
	})
	a("!construct-menu-window Window::Content", {
		gravity = { 0.5, -1 },
	})
	a("!construct-menu-window Window::Content", {
		padding = { 0, 0, 0, 0 },
	})
	a("!construct-menu-window Window::Title-bar", {
		visibility = "none",
	})


	a("!input-controller ParamsListComp !param-row:hover", {
		backgroundColor = ssu.makeColor(70, 150, 255, 70)
	})
	
	a("!input-controller AddModuleComp InputTextScrollArea", {
		visibility = "hidden"
	})

	a([[ParamsListComp::ButtonParam::Layout,
		ParamsListComp::SliderParam::Layout,
		ParamsListComp::ComboBoxParam::Layout,
		ParamsListComp::IconButtonParam::Layout]], {
		innerSpacing = { 0, 0 },
		gravity = { -1, .0 }
	})
	a([[!ui-couch ParamsListComp::ComboBoxParam ComboBox]], {
		gravity = { -1, 0.5 }
	})
	a([[ParamsListComp::CheckBoxParam CheckBox]], {
		gravity = { 0.5, 0.5 }
	})
	a([[!ParamsListComp::CheckBoxParam]], {
		gravity = { 0.5, 0.5 }
	})
	a([[!ui-couch!input-mouse ParamsListComp::CheckBoxParam]], {
		gravity = { 0.5, 0.5 }
	})
	a([[!ui-couch!input-controller ParamsListComp::CheckBoxParam]], {
		gravity = { -1, 0.5 }
	})
	a([[!ui-couch ParamsListComp::CheckBoxParam ComboBox!style-left-right]], {
		gravity = { -1, 0.5 }
	})
	
	a([[ParamsListComp::NoParamLabel,
		ParamsListComp::ButtonParam::Label,
		ParamsListComp::SliderParam::Label,
		ParamsListComp::ComboBoxParam::Label,
		ParamsListComp::IconButtonParam::Label]], {
		padding = { vp, hp, vp, 0 }
	})
	a("ParamsListComp::SliderParam::SliderLabel", {
		padding = { vp, hp / 2, vp, 0 }
	})
	a("ParamsListComp::SliderParam Slider", {
		padding = { vp, 0, vp, hp }
	})

	a([[!ui-couch ParamsListComp::NoParamLabel,
		ParamsListComp::ButtonParam::Label,
		ParamsListComp::SliderParam::Label,
		ParamsListComp::ComboBoxParam::Label,
		ParamsListComp::IconButtonParam::Label,
		ParamsListComp::SliderParam::SliderLabel,
		ParamsListComp::SliderParam Slider]], {
		fontSize = ssu.styles.uicouch_body_fontSize
	})

	a("ParamsListComp !label!empty", {
		visibility = "none",
	})

	a([[ParamsListComp::ButtonParam ToggleButtonGroup,
	    ParamsListComp::IconButtonParam ToggleButtonGroup]], {
		gravity = { -1.0, .0 }
	})
	a([[!ui-couch ParamsListComp::ButtonParam ToggleButtonGroup BoxLayout,
		!ui-couch ParamsListComp::ButtonParam ToggleButtonGroup FlowLayout,
        !ui-couch ParamsListComp::IconButtonParam ToggleButtonGroup FlowLayout]], {
		gravity = { .5, .0 }
	})
	
	a("ParamsListComp::SliderParam Slider", {
		gravity = { -1.0, .5 }
	})
	
	a("ParamsListComp::SliderParam::SliderLabel", {
		size = { 60, -1 }
	})
	a("ParamsListComp#menu.construction.terrain.settings ParamsListComp::SliderParam::SliderLabel", {
		size = { 100, -1 }
	})
	
	a("ParamsListComp::CheckBoxParam", {
		padding = { 0, 0, 0, hp }
	})

	a("!ui-couch ConstructionMenuTab", {
		actionPromptList = {
			{ ia = "IA_OPTION2", text = _("Filter") },
			{ ia = "selectBulldozer", text = _("Bulldozer") },
		}
	})

	a([[!ui-couch!input-mouse !action-townbuilder,
		!ui-couch!input-mouse !action-trackmodifier,
		!ui-couch!input-mouse !action-streetterminalbuilder]], {
		actionPromptList = {
			{ia = "IA_MENU_BACK", text = _("Back")},
		}
	})

	return result
end
