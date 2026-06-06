require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("EditorUI::Menu", {
		backgroundColor = ssu.makeColor(5, 25, 40, 230),
	})
	
	a("EditorUI Slider", {
		gravity = { -1.0, .5 }
	})
	
	a("EditorUI ToggleButtonGroup BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	
	a("EditorUI ToggleButtonGroup ToggleButton::Text", {
		minSize = { 25, -1 },
		textAlignment = { .5, .5 }
	})
	
	a("EditorUI::Menu DoubleSpinBox", {
		gravity = { .5, .0 }
	})
	
	a("EditorUI Window ToggleButton", {
		gravity = { -1.0, .5 }
	})
	
	a("EditorUI OpenDialog", {
		minSize = {600, 450}
	})

	a("EditorUI OpenDialog TextView!list-item", {
		minSize = {300, -1}
	})

	a("EditorUI OpenDialog List!main-menu", {
		maxSize = {350, 450}
	})

	a("EditorUI OpenDialog ContentView", {
		size = {450, 450},
		maxSize = {450, 450},
	})

	a("EditorUI OpenDialog ImageView", {
		size = {512, 512},
		maxSize = {512, 512},
	})

	a("EditorUI OpenDialog Button", {
		gravity = {1, 0.5},
	})
	
	return result
end
