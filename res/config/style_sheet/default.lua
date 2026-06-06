require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local hp = 10
local vp = 5

local positiveColor = { .6, .8, 1.0, 1.0 }
local negativeColor = { 1.0, .6, .6, 1.0 }
local warningColor = { 1.0, 1.0, .4, 1.0 }

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a([[!ui-couch TextView,
		!ui-couch LineButton::Text,
		!ui-couch CargoItem::Text,
		!ui-couch DepotButton::Text]], {
		fontSize= ssu.styles.uicouch_body_fontSize,
	})

	a("BoxLayout", {
		innerSpacing = { 5, 5 }
	})
	
	a("TextView", {
		padding = { vp, hp, vp, hp }
	})

	a("#contexthelper.textView", {
		textAlignment = {0, 0},
	})

	a("TextView > AbsoluteLayout", {
		gravity = {-1, -1},
	})

	a("!inline", {
		gravity = {0, 0},
		margin = {0,0,0,0},
		padding = {0,0,0,0},
	})
	
	a("Table, Table::TableLayout", { })
	a("List, List::Layout", { })
	
	a("Slider:active, DoubleSpinBox:active", {
		soundEffect1 = sound.get("componentActive")
	})
	
	a("Button::Text, ToggleButton::Text", {
		padding = { vp, hp, vp, hp },
		fontSize = 13,
		textTransform = "UPPERCASE"
	})
	a([[!ui-couch Button::Text,
		!ui-couch ToggleButton::Text]], {
		fontSize = ssu.styles.uicouch_secondarybuttons_fontSize,
		textTransform = ssu.styles.uicouch_secondarybuttons_textTransform
	})
	a("Button, ToggleButton", {
		--borderWidth = { 1, 1, 1, 1 },
		borderColor = ssu.makeColor(255, 255, 255, 0),
		transitionDuration = { .1 },
	})
	a("!ui-couch !list-item ComboBox:hover", {
		soundEffect1 = sound.get("buttonHover")
	})
	a("Button:hover, ToggleButton:hover, CheckBox:hover, ComboBox::Button:hover, AddStationHintButton:hover", {
		soundEffect1 = sound.get("buttonHover")
	})
	a("Button:active, ComboBox::Button:active", {
		soundEffect1 = sound.get("buttonClick")
	})
	a("ToggleButton:active, CheckBox:active, ComboBox !left-button:active, ComboBox !right-button:active", { -- NOTE: checkbox sound
		soundEffect1 = sound.get("toggleOn"),
		soundEffect2 = sound.get("toggleOff")
	})
	a("ToggleButtonGroup ToggleButton:active", {
		soundEffect1 = sound.get("toggleOn"),
		soundEffect2 = { }
	})
	
	a("ComboBox, Slider", {
		gravity = { .0, .5 }
	})

	a("!ui-couch ComboBox::Button wrap BoxLayout", {
		gravity = { 0.5, -1 },
	})

	a("!ui-couch ComboBox TextView", {
		gravity = { -1, .5 },
		textAlignment = {0.5, 0.5},
	})
	a("!ui-couch TextView!combo-box-list-item!list-item", {
		textAlignment = {0.5, 0.5},
	})

	a("ComboBox!style-popup ComboBox::Button", {
		backgroundColor = ssu.makeColor(0, 0, 0, 50),
	})
	a("ParamsListComp ComboBox!style-popup ComboBox::Button wrap", {
		maxSize = {360, -1}
	})
	a("!paramsListComp-popup TextView!combo-box-list-item!list-item", {
		maxSize = {340, -1}
	})

	a("Button:hover, ToggleButton:hover, SimpleButton:hover, SimpleToggleButton:hover, ComboBox!style-popup ComboBox::Button:hover, AddStationHintButton:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
		--borderColor = ssu.makeColor(255, 255, 255, 50)
	})
	a("!input-controller LineEditor ComboBox!table-item ComboBox::Button:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 100),
	})
	a("!input-mouse LineEditor ComboBox!table-item ComboBox::Button:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})

	a("Button:active, ToggleButton:active, SimpleButton:active, SimpleToggleButton:active, ComboBox!style-popup ComboBox::Button:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 100),
		--borderColor = ssu.makeColor(255, 255, 255, 150)
	})
	a([[
		TextView:disabled,
		ParamsListComp !label:disabled,
		ParamsListComp::SliderParam::SliderLabel:disabled,
		Button::Text:disabled,
		Button::Icon:disabled,
		TaskDisplay::Button::Text:disabled,
		ToggleButton::Text:disabled,
		ToggleButton::Icon:disabled,
		Button TextView:disabled,
		Button ImageView:disabled,
		ToggleButton TextView:disabled,
		ToggleButton ImageView:disabled,
		SimpleButton::Text:disabled,
		SimpleButton::Icon:disabled,
		SimpleToggleButton::Text:disabled,
		SimpleToggleButton::Icon:disabled,
		ComboBox::Button TextView:disabled,
		ComboBox::Button ImageView:disabled,
		!content-button ImageView:disabled,
		!content-button TextView:disabled,
		ImageView!filter-icon:disabled]],
	{
		color = ssu.makeColor(150, 150, 150)
	})

	a("TextView:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})
	
	a("CheckBox, ParamsListComp::CheckBoxParam", {
		backgroundColor1 = ssu.makeColor(255, 255, 255)
	})
	a("CheckBox:hover, ParamsListComp::CheckBoxParam:hover", {
		backgroundColor1 = ssu.makeColor(255, 255, 255, 100)
	})
	a("CheckBox:active, ParamsListComp::CheckBoxParam:active", {
		backgroundColor1 = ssu.makeColor(255, 255, 255)
	})
	a("CheckBox:disabled, ParamsListComp::CheckBoxParam:disabled", {
		backgroundColor1 = ssu.makeColor(150, 150, 150)
	})

	a("!ui-couch Slider", {
		color = ssu.makeColor(255, 255, 255),
		gravity = {-1, 0.5}
	})
	
	a("Slider:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})
	
	a("TabWidget::IndicatorLayout, TabWidget::ContentLayout", {
		innerSpacing = { 0, 0 }
	})

	a("!ui-couch TabWidget > KeybindingHintDisplay, !ui-couch TabWidget Indicators > KeybindingHintDisplay, !ui-couch TabWidget TabWidgetIndicatorHintWrap > KeybindingHintDisplay", {
		minSize = { 33, -1 },
		padding = { 0, 2, 0, 2},
	})

	a("TabWidget TabWidgetIndicatorHintWrap > KeybindingHintDisplay!left", {
	    gravity = {0.0, 0.5}
	})
	a("TabWidget TabWidgetIndicatorHintWrap > KeybindingHintDisplay!right", {
	    gravity = {1.0, 0.5}
	})

	a("!tab-widget-indicator, !tab-widget-icon-indicator", {
		color = ssu.makeColor(255, 255, 255),
		fontSize = 13,
		textTransform = "UPPERCASE",
		borderColor = ssu.makeColor(0, 0, 0, 0),
		borderWidth = { 0, 0, 2, 0 },
		minSize = { 0, 33 }
	})
	a("!tab-widget-indicator", {
		padding = { 0, hp, -1, hp }
	})
	a("!tab-widget-icon-indicator", {
		size = { 37, 30 },
		padding = { 0, 8, -1, 8 }
	})
	a("!ui-couch !tab-widget-indicator", {
		fontSize = ssu.styles.uicouch_tab_title_fontSize,
		textTransform = ssu.styles.uicouch_tab_title_textTransform,
	})
	a("!tab-widget-indicator:hover, !tab-widget-icon-indicator:hover", {
		color = ssu.makeColor(255, 255, 255),
		backgroundColor = ssu.makeColor(255, 255, 255, 25),
		borderColor = ssu.makeColor(255, 255, 255, 25),
		--soundEffect1 = sound.get("buttonHover")
	})
	a("!tab-widget-indicator:active, !tab-widget-icon-indicator:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 0),
		backgroundColor1 = ssu.makeColor(0, 0, 0, 0),
		borderColor = ssu.makeColor(255, 255, 255, 200),
		soundEffect1 = sound.get("tabClick")
	})
	a("!tab-widget-indicator:disabled, !tab-widget-icon-indicator:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})
	
	a("Popup, !popup", {
		gravity = { .0, .0 },
		backgroundColor = ssu.makeColor(35, 35, 35, 230),
		--padding = { 3, 3, 3, 3 },
		--borderWidth = { 1, 1, 1, 1 },
		borderColor = ssu.makeColor(60, 60, 60, 250),
		shadowNinePatch = { fileName = "ui/l1_window_shadow.tga", horizontal = { 0, 16, 48, 64 }, vertical= { 0, 16, 48, 64 } },
		shadowWidth = { 16, 16, 16, 16 },
		blurRadius = 16 * 4
	})

	a("Popup > KeybindingHintDisplay!overflowMode", {
		visibility = "none",
	})

	a("List::Content::Layout", {
		gravity = { -1.0, .0 }
	})

	a("List !list-item:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50)
	})
	a("!ui-couch Button!list-item:hover", {
		soundEffect1 = sound.get("buttonHover")
	})
	a("List !list-item:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 100),
		soundEffect1 = sound.get("componentActive")
	})
	a("List !list-item:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})

	--a("NavList::ListLayout", {
	--	innerSpacing = { 0, 5 }
	--})
	a("NavList::Content::Layout", {
	    gravity = { -1.0, 0.0 },  -- have content top-aligned by default
	})

	a("!tab-widget-content > NavList::Content, !tab-widget-content > ScrollArea::Content", {
		padding = { 0, hp, 0, 0 }
	})
	a("NavList !list-item, ParamsListComp!sub-list !param-row", {
		padding = { vp / 2, hp, (vp + 1) / 2, 0 }
	})
	a([[!input-controller NavList !list-item:hover,
		!input-controller CustomGameSettingsComp LabelValueItemGroup:hover]], {
		backgroundColor = ssu.makeColor(70, 150, 255, 70)
	})

	a("NavList TextView!list-item", {
		padding = { vp, hp, vp, hp }
	})

	a("Table::HeaderLayout, Table::Layout", {
		innerSpacing = { 0, 0 }
	})
	
	a("Table !table-item!highlight", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})

	a("!ui-couch LineEditor Table !table-item TextView:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})
	a("!ui-couch LineEditor Table !table-item ComboBox::Button TextView:hover", {
		backgroundColor = ssu.makeColor(100, 100, 255, 0),
	})
	
	a("Table:active", {
		soundEffect1 = sound.get("componentActive")
	})
	
	a("!table-row:hover", {
		backgroundColor1 = ssu.makeColor(255, 255, 255, 50),
		backgroundColor2 = ssu.makeColor(255, 255, 255, 50),
	})
	a("!table-row:active", {
		backgroundColor1 = ssu.makeColor(255, 255, 255, 100),
		backgroundColor2 = ssu.makeColor(255, 255, 255, 100),
	})
	a("!table-row:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})

	a("CheckBox!table-item, CheckBoxTableItemParent!table-item CheckBoxInBetweenWrapper CheckBox", {
		padding = { vp, hp, vp, hp }
	})
	a("CheckBox!table-header, CheckBoxTableItemParent!table-header CheckBoxInBetweenWrapper CheckBox", {
		padding = { vp + hp, hp, vp, hp } -- TODO HACK padding top
	})
	a([[CheckBox!table-item:active, CheckBox!table-header!active,
		CheckBoxWrapper!table-item:active, CheckBoxWrapper!table-header!active,
		CheckBoxTableItemParent!table-item:active, CheckBoxTableItemParent!table-header!active
		]], {
		soundEffect1 = { },
		soundEffect2 = { }
	})

	a("DataTable::HeaderItem!table-header:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50)
	})
	a("DataTable::HeaderItem!table-header:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 100)
	})
	a([[DataTable::HeaderItem!table-header TextView:disabled,
		DataTable::HeaderItem!table-header ImageView:disabled]], {
		color = ssu.makeColor(150, 150, 150)
	})


	a([[!ui-couch ComboBox !left-button!hide-left-right-buttons,
		!ui-couch ComboBox !right-button!hide-left-right-buttons]], {
		visibility = "none"
	})

	a([[!ui-couch ComboBox !left-button!hide-left-right-buttons,
		!ui-couch ComboBox !right-button!hide-left-right-buttons]], {
		visibility = "hidden"
	})

	a([[DoubleSpinBox !left-button!hide-left-right-buttons,
		DoubleSpinBox !right-button!hide-left-right-buttons]], {
		visibility = "none"
	})

	a("ScrollArea::Content::Layout", {
		gravity = { -1.0, .0 }
	})
	
	a("ScrollBar", {
		backgroundColor1 = ssu.makeColor(255, 255, 255, 50)
	})
	a("ScrollBar:hover, ScrollBar:active", {
		backgroundColor1 = ssu.makeColor(255, 255, 255, 100)
	})
	
	a("ScrollBar::Button", {
		backgroundColor = ssu.makeColor(255, 255, 255, 25)
	})
	a("ScrollBar::Button:hover, ScrollBar::Button:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50)
	})

	a("InputTextScrollArea > ScrollArea::Content > TextInputField", {
		gravity = { 0, 0 },
		margin = { 0, 0, 0, 0 },
		padding = { 5, 0, 0, 0 },
		backgroundColor = ssu.makeColor(0, 0, 0, 0),
	})
	a("InputTextScrollArea", {
		padding = { 0, 10, 0, 10 },
		backgroundColor = ssu.makeColor(0, 0, 0, 50),
	})

	a("TextInputField, DoubleSpinBox", {
		backgroundColor = ssu.makeColor(0, 0, 0, 50),
		padding = { vp, hp, vp, hp },
	})
	a([[!ui-couch DateWindow TextInputField,
		!ui-couch DateWindow DoubleSpinBox]], {
		padding = { vp, hp, vp, hp },
	})
	a([[!input-controller DateWindow DoubleSpinBox TextInputField,
		!input-controller DateWindow DoubleSpinBox]], {
		backgroundColor = ssu.makeColor(30, 30, 30, 0),
	})
	a([[!ui-couch DateWindow DoubleSpinBox::Input]], {
		gravity = {0.5, 0.5}
	})
	a("TextInputField!selected-text, DoubleSpinBox::Input!selected-text", {
		color = ssu.makeColor(255, 255, 255, 50)
	})
	a("TextInputField:disabled, DoubleSpinBox::Input:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})
	
	a("DoubleSpinBox::Input", {
		gravity = { -1.0, .0 }
	})

	a("!ui-couch DoubleSpinBox::Input", {
		gravity = { .0, .0 },
	})

	a("ParamsListComp", {
		padding = { 0, 0, 10, 0 }
	})
	
	a("Chart", {
		gravity = { -1.0, -1.0 }
	})
	a("!ui-couch Chart", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	
	a("Chart, Chart::TimeScale, SimpleLegend", {
		padding = { vp, hp, vp, hp }
	})
	
	a("Chart::TimeScale", {
		gravity = { 1.0, .0 }
	})
	a("Chart::TimeScale::Number", {
		size = { 55, -1 },
		textAlignment = { 1.0, .5 }
	})
	
	a("ColorChooserButton", {
		--borderColor = ssu.makeColor(0, 0, 0, 100),
		--borderWidth = { 1, 1, 1, 1 },
		backgroundColor = ssu.makeColor(0, 0, 0, 50)
	})
	a("ColorChooserButton BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	a("ColorChooserButton SimpleButton", {
		padding = { vp, hp, vp, hp }
	})
	a("vehicleColorComp", {
		gravity = { -1.0, -1.0 }
	})
	
	a("HorizontalLine", {
		backgroundColor = ssu.makeColor(255, 255, 255, 15),
		gravity = { -1.0, .5 },
		size = { -1, 1 }
	})
	
	a("VerticalLine", {
		backgroundColor = ssu.makeColor(255, 255, 255, 15),
		gravity = { .5, -1.0 },
		size = { 1, -1 },
		margin = { 5, 0, 5, 0 }
	})
	
	a("!neutral", {
		color = ssu.makeColor(255, 255, 255)
	})
	a("!positive", {
		color = positiveColor
	})
	a("!negative", {
		color = negativeColor
	})
	a("!price", {
		color = ssu.makeColor(255, 240, 100)
	})
	a("!warning", {
		color = warningColor
	})

	a("RadialButton!for-4-segments", {
	    size = {596/2, 263/2},
		backgroundImage1 = { fileName = "ui/design/buttons/4_segment_button_surface@2x.tga" },
		shadowNinePatch = { fileName = "ui/design/buttons/4_segment_button_behind@2x.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/4_segment_button_contour@2x.tga" },
	})
	a("RadialButton!for-5-segments", {
	    size = {486/2, 240/2},
		backgroundImage1 = { fileName = "ui/design/buttons/5_segment_button_surface@2x.tga" },
		shadowNinePatch = { fileName = "ui/design/buttons/5_segment_button_behind@2x.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/5_segment_button_contour@2x.tga" },
	})
	a("RadialButton!for-6-segments", {
	    size = {407/2, 229/2},
		backgroundImage1 = { fileName = "ui/design/buttons/6_segment_button_surface@2x.tga" },
		shadowNinePatch = { fileName = "ui/design/buttons/6_segment_button_behind@2x.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/6_segment_button_contour@2x.tga" },
	})
	a("RadialButton!for-7-segments", {
	    size = {348/2, 222/2},
		backgroundImage1 = { fileName = "ui/design/buttons/7_segment_button_surface@2x.tga" },
		shadowNinePatch = { fileName = "ui/design/buttons/7_segment_button_behind@2x.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/7_segment_button_contour@2x.tga" },
	})
	a("RadialButton!for-8-segments", {
	    size = {302/2, 218/2},
		backgroundImage1 = { fileName = "ui/design/buttons/8_segment_button_surface@2x.tga" },
		shadowNinePatch = { fileName = "ui/design/buttons/8_segment_button_behind@2x.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/8_segment_button_contour@2x.tga" },
	})

	a("CustomGameSettingsComp RadialMenu", {
	    gravity = { 0.5, 0.5 }
	})
	a("RadialMenuInfoText", {
	    size = {444/2, 444/2},
	})
	a("RadialMenuSpotlight", {
	    size = {914/2, 914/2},
	})
	a("RadialMenuInfoText", {
	    size = {444/2, 444/2},
	})

	a("RadialMenuInfoCircle", {
	    size = {444/2, 444/2},
        backgroundColor1 = ssu.makeColor(255, 255, 255, 255),
		backgroundImage1 = { fileName = "ui/design/buttons/info_circle_surface@2x.tga" },
        backgroundColor2 = ssu.makeColor(255, 255, 255, 128),
		backgroundImage2 = { fileName = "ui/design/buttons/info_circle_contour@2x.tga" },
	})

	a("RadialMenuBackgroundCircle", {
	    size = {914/2, 914/2},
        backgroundColor1 = ssu.makeColor(255, 255, 255, 240),
		backgroundImage1 = { fileName = "ui/design/buttons/bg_circle_surface@2x.tga" },
		backgroundColor2 = ssu.makeColor(255, 255, 255, 128),
		backgroundImage2 = { fileName = "ui/design/buttons/bg_circle_contour@2x.tga" },
	})
	a("RadialButton", {
        backgroundColor1 = ssu.makeColor(15, 35, 50),
        shadowColor = ssu.makeColor(5-10, 25-10, 40-10, 100),
        backgroundColor2 = ssu.makeColor(255, 255, 255, 128),
	})
	a("RadialButton:active", {
        backgroundColor1 = ssu.makeColor(55, 97, 167, 255),
		backgroundColor2 = ssu.makeColor(255, 255, 255, 255),
	})
	a("RadialButton:disabled", {
	    backgroundColor1 = ssu.makeColor(35, 35, 35, 230)
	})
	a("RadialMenuSpotlight:active", {
        backgroundColor2 = ssu.makeColor(255, 255, 255, 153),
		backgroundImage2 = { fileName = "ui/design/buttons/spotlight@2x.tga" },
	})

	a("RadialMenuPopup", {
		gravity = { 0, 0 },
	})

	a("CheckBoxWrapper FloatingLayout", {
		gravity = {-1, 0.5}
	})
	a("CheckBoxWrapper", {
		gravity = { 0.0, 0.5 }
	})

	a("!ui-couch Popup CheckBoxWrapper", {
		gravity = { 0.0, 0.5 }
    })
	a("!ui-couch Popup CheckBoxWrapper CheckBox", {
		gravity = { 0.5, 0.5 },
		margin = {7, 7, 7, 7}
	})

	a("!ui-couch CheckBoxWrapper", {
		gravity = { -1, 0.5 }
	})
	a("!ui-couch CheckBoxWrapper CheckBox", {
		gravity = { 0.5, 0.5 },
		margin = {7, 0, 7, 0}
	})
	a("!ui-couch CheckBoxWrapper ComboBox", {
		gravity = { -1, -1 },
		margin = { 0, 0, -1, 0 },
	})
	a("ButtonPromptList!no-bottom-margin", {
	    margin = {0,10,0,0},
	})
	a("ButtonPromptList!with-bottom-margin", {
	    margin = {0,10,10,0},
	})
	a("ButtonPromptList > Button, ButtonPromptList > FakeButton, ButtonPromptList > ToggleButton", {
	    fontSize = ssu.styles.uicouch_secondarybuttons_fontSize,
		backgroundColor = ssu.makeColor(19, 33, 47, 37),
		blurRadius = 32,
	})
	a("ButtonPromptList KeybindingHintDisplay Button", {
		margin = {0,0,0,0},
	})
	a("ButtonPromptList Button!detached", {
	    visibility = "none"
	})
	a("!input-controller ButtonPromptList Button!no-combo", {
	    visibility = "none"
	})

	a("ButtonPromptList Button!testing-build!detached", {
	    backgroundColor = { 1.0, .2, .2, 1.0 },
	    visibility = "visible"
	})
	a("ButtonPromptList Button!testing-build!no-combo, !input-controller ButtonPromptList Button!testing-build!no-combo, !input-mouse ButtonPromptList Button!testing-build!no-combo", {
	    backgroundColor = { 0.9, 0.9, .2, 1.0 },
	    visibility = "visible"
	})
	a("ButtonPromptList TextView", {
	    fontSize = ssu.styles.uicouch_secondarybuttons_fontSize,
		textTransform = ssu.styles.uicouch_secondarybuttons_textTransform,
		padding = { 0, 0, 0, 0 },
	})
	a("ButtonPromptList > Button BoxLayout, ButtonPromptList > FakeButton BoxLayout, ButtonPromptList > ToggleButton BoxLayout", {
	    innerSpacing = {0, 0},
	})

	a("!input-controller Popup ComboBox:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})
	a("!input-controller Popup ComboBox:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 100),
	})

	a("!visible", {
	    visibility = "visible"
	})
	a("!invisible", {
	    visibility = "none"
	})

	a("!input-controller !controller-invisible", {
		visibility = "hidden"
	})
	a("!input-controller !controller-visible", {
		visibility = "visible"
	})
	a("!ui-classic !classic-none", {
		visibility = "none"
	})
	a("!platform-console !console-none", {
		visibility = "none"
	})

	a("!input-controller ScrollView::Right!scroll-button!visible, !input-controller ScrollView::Left!scroll-button!visible", {
		visibility = "hidden"
	})

	a("ImageView#inspector-crosshair", {
		gravity = {0.5, 0.5}
	})
	a("!input-mouse ImageView#inspector-crosshair", {
		visibility = "none"
	})

	return result
end
