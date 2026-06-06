require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

local positiveColor = { .6, .8, 1.0, 1.0 }
local negativeColor = { 1.0, .6, .6, 1.0 }

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("WarningsComp::Label", {
		padding = { vp, hp, vp, hp }
	})
	
	a("StationWarningsComp Table !table-item", {
		padding = { 0, 0, 0, 0 }
	})

	a("!ui-couch WarningsButton#menu.warningsButton KeybindingHintDisplay!overflowMode", {
		gravity = { 0.5, 1.0 }
	})

	a("!input-controller #warningsWindow Window::Close!window-button", {
	    visibility = "transparent"
	})

	a("!input-controller #warningsWindow !locate-button", {
	    visibility = "folded"
	})
	
	a("!ui-couch #warningsWindow LocateWrap", {
		actionPromptList = {
			{ia = "IA_OPTION1", text = _("Locate")},
		}
	})

	a("!ui-couch #warningsWindow Button::Text, !ui-couch #warningsWindow TextView, !ui-couch #warningsWindow LineButton::Text", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	
	return result
end
