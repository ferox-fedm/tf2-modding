require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

function data()
	local result = { }

	local a = ssu.makeAdder(result)

	a("!railroadcrossing-view", {
		anchorPoint = { 0, 1 },
		size = {400, 280},
	})

	a("!railroadcrossing-view ConstructionTable", {
		gravity = { 0, -1 },
		margin = { 4, 20, 4, 20 },
	})

	a("!railroadcrossing-view Button!cancel-button", {
		minSize = {50, 34},
	})

	a("Popup !railroadcrossing-menu", {
		maxSize = { 504, 200 }
	})

	a("!railroadcrossing-menu !filter-button-icon", {
		padding = { 6, 6, 6, 6 },
		maxSize = { 100, 16 },
		minSize = { 16, 16 },
	})
	
	a("Window!entity-window !filter-button-icon", {
		padding = { 5, 5, 5, 5 },
		maxSize = { 100, 24 },
		minSize = { 24, 24 },
	})

	a("!ui-couch Window!entity-window !filter-button-icon", {
		padding = { 6, 6, 6, 6 },
		maxSize = { 100, 16 },
		minSize = { 16, 16 },
	})

	a("!ui-couch Window!entity-window SectionTypeComp::FilterLabel", {
		fontSize = ssu.styles.uicouch_body_fontSize,
		margin = { 0, 10, 0, 5 },
	})
	
	a("!ui-couch Window!entity-window SectionTypeComp", {
		margin = { 5, 5, 5, 5 },
	})

	a("!ui-couch Window!entity-window Button!cancel-button", {
		visibility = "none"
	})

	a([[!railroadcrossing-menu !entry-icon,
		Window!entity-window !entry-icon]], {
		color = ssu.makeColor(255, 255, 255),
		padding = { 2, 10, 2, 10 },
		borderWidth = { 2, 2, 2, 2 },
		borderColor = ssu.makeColor(214, 214, 214, 0),
		minSize = { 60, 40 },
		margin = { 2, 2, 2, 2 },
	})

	a("!railroadcrossing-menu !entry-icon:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 30),
		borderColor = ssu.makeColor(255, 255, 255, 100),
	})
	a("Window!entity-window !entry-icon:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 30),
		borderColor = ssu.makeColor(255, 255, 255, 30),
	})

	a([[!railroadcrossing-menu !entry-icon:active,
		Window!entity-window !entry-icon:active]], {
		backgroundColor = ssu.makeColor(255, 255, 255, 30),
		borderColor = ssu.makeColor(255, 255, 255, 100),
	})
	a([[!railroadcrossing-menu !entry-icon:disabled
		Window!entity-window !entry-icon:disabled]], {
		color = ssu.makeColor(150, 150, 150)
	})

	a("!railroadcrossing-menu !cancel-button", {
		padding = { 6, 4, 6, 4 },
	})

	a("BuildControlComp::SectionTypeButton::Icon", {
		backgroundImage1 = { fileName = "ui/design/buttons/disk_big_behind.tga" },
		backgroundImage2 = { fileName = "ui/design/buttons/disk_big_surface.tga" },
		borderImage = { fileName = "ui/design/buttons/disk_big_contour.tga" },
		backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
		backgroundColor2 = ssu.makeColor(15, 35, 50),
		borderColor = ssu.makeColor(255, 255, 255, 128)
	})
	
	a("BuildControlComp::SectionTypeButton::Icon:hover", {
		backgroundColor1 = ssu.makeColor(183, 188, 193, 128),
		borderColor = ssu.makeColor(255, 255, 255)
	})
	a("!section-type-button-active BuildControlComp::SectionTypeButton::Icon", {
		backgroundColor1 = ssu.makeColor(183, 188, 193, 128),
		borderColor = ssu.makeColor(255, 255, 255)
	})

	a("!ui-couch Popup !railroadcrossing-menu KeybindingHintDisplay", {
		visibility = "none"
	})

	a([[!input-controller !railroadcrossing-menu ConstructionTable !entry-icon]], {
		actionPromptList = {
			{ ia = "IA_SELECT", text = _("Select") }
		},
	})
	
	a([[!input-controller Window!entity-window ConstructionTable !entry-icon]], {
		actionPromptList = {
			{ ia = "IA_SELECT", text = _("Replace") }
		},
	})

	a("ErrorTextView::Text!section-type-error", {
		color = ssu.makeColor(255, 255, 255),
		backgroundColor = ssu.makeColor(255, 0, 0, 100),
		gravity = { -1, 0.5 },
		padding = { 4, 12, 4, 12 },
	})

	return result
end
