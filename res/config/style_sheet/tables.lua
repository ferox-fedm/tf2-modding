require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

local positiveColor = { .6, .8, 1.0, 1.0 }
local negativeColor = { 1.0, .6, .6, 1.0 }

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)

	a("!ui-couch Label!table-item", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a("!ui-couch Table CheckBoxInBetweenWrapper:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})

	a("!table-item!level0!group-label", {
		color = ssu.makeColor(200, 200, 200, 200),
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})


	a("DataTable::HeaderItem!table-header > wrap", {
		gravity = {-1.0, 0.0},
	})

	a([[DataTable::HeaderItem!table-header!headerItem-left-align DataTable::SortButton > Button::Layout,
	    DataTable::HeaderItem!table-header!headerItem-left-align > wrap > BoxLayout]], {
		gravity = {0.0, 0.0},
	})
	a([[DataTable::HeaderItem!table-header!headerItem-center-align DataTable::SortButton > Button::Layout,
	    DataTable::HeaderItem!table-header!headerItem-center-align > wrap > BoxLayout]], {
		gravity = {0.5, 0.0},
	})
	a([[DataTable::HeaderItem!table-header!headerItem-right-align DataTable::SortButton > Button::Layout,
	    DataTable::HeaderItem!table-header!headerItem-right-align > wrap > BoxLayout]], {
		gravity = {1.0, 0.0},
	})
	
	a("!table-item!level0, !table-item!level0 TextView, !table-item!level1", {
		gravity = { -1.0, -1.0 },
		textAlignment = { 1.0, .5 }
	})
	
	a("!table-item!level0", {
		backgroundColor = ssu.makeColor(255, 255, 255, 20),
	})
	a("!table-item!level1", {
		backgroundColor = ssu.makeColor(0, 0, 0, 20),
	})
	a("!table-item!total", {
		backgroundColor = ssu.makeColor(255, 255, 255, 75),
	})

	a("!ui-couch !table-item KeybindingHintDisplay!overflowMode", {
		scaling = ssu.styles.action_keybinding_scale,
		gravity = ssu.styles.action_keybinding_gravity
	})
	
	return result
end
