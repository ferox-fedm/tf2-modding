require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

function data()
	local result = { }

	local a = ssu.makeAdder(result)

	a("!draw-call-table TextView", {
		fontSize = 12
	})

	a("!ui-couch DebugViewComp", {
		scaling = 0.55
	})

	a("!ui-classic DebugViewComp !memory-data", {
		maxSize = { "90vw", 800 },
	})

	a("!ui-couch DebugViewComp !memory-data", {
		maxSize = { "90vw", 500 },
		fontSize = 10
	})

	a("DebugViewComp !label", {
		minSize = { 220, -1 },
	})
	
	a("DebugViewComp !label-small", {
		minSize = { 60, -1 },
    })
	
	a("DebugViewComp !highlighted", {
		color = { .6, .8, 1.0, 1.0 },
    })
	
	a("DebugViewComp !ignored", {
		color = { .4, .4, .4, 1.0 },
    })
	
	a("DebugViewComp !items-group", {
		padding = { 0, 0, 5, 5 },
	})

	a("Window!debug-ruler", {
		anchorPoint = { 1, 0 },
	})

	a("VehicleDebug !debug-show-path-button ToggleButton::Text", {
		textTransform = "NONE"
	})

	a("DebugViewComp ScrollArea!ui-dump", {
		maxSize = { -1, 400 },
	})

	a("UiItemTreeDump > Button!layout", {
		margin = { 0, 0, -2, 10 },
	})

	a("UiHierarchyTreeDebugView", {
	    gravity = {-1, 0.5},
		minSize = { 400, 100 },
		maxSize = { 500, -1 },
	})
	a("UiHierarchyTreeDebugView ScrollArea", {
        maxSize = { -1, 300 },
	})
	a("UiHierarchyTreeDebugView ChildListContent, UiHierarchyTreeDebugView Box, UiHierarchyTreeDebugView TextView", {
	    gravity = {0, 0},
	})

	return result
end
