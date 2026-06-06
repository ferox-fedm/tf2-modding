require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

local positiveColor = { .38, .59, .78, 1.0 }
local positiveColor2 = { .6, .8, 1.0, 1.0 }
local negativeColor = { .7, .6, .38, 1.0 }

local backgroundColor = ssu.makeColor(0, 0, 0, 50)

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("SimBuilding::Overview::Layout", {
		innerSpacing = { 2 * hp, 2 * vp }
	})
	
	a("SimBuilding::Overview Table!stock-table", {
		backgroundColor1 = { 0, 0, 0, 0 },
		backgroundColor2 = { 0, 0, 0, 0 },
	})
	
	a("SimBuilding::StocksLabel", {
		padding = { vp, hp, vp, hp }
	})

	
	a("SimBuilding::ClosureLayout", {
		padding = { vp, 2*hp, vp, 2*hp },
		innerSpacing = { -2*hp, 2*vp },
		color = positiveColor2,
	})

	a("SimBuilding::OverloadedIcon", {
		padding = { vp, 2*hp, vp, 2*hp },
		color = positiveColor2,
		scaling = 2 / 3,
		margin = { 0, hp, 0, 0 },
		gravity = { 1.0, .5 }
	})

	a("!stock-table Table::TableLayout, !stock-overview-table Table::TableLayout", {
		outerSpacing = { hp, vp },
		innerSpacing = { hp, vp }
	})

	a("!stock-table !table-item, !stock-overview-table !table-item", {
		outerSpacing = { hp, vp },
		innerSpacing = { hp, vp }
	})

	a("LevelLayout", {
		outerSpacing = { hp, vp },
		innerSpacing = { hp, vp }
	})
	
	a("LevelProgressBar, StockListOverviewBars", {
		gravity = { -1.0, .0 },
	})
	
	a("LevelProgressBar BoxLayout", {
		innerSpacing = { 2, 0 }
	})
	
	a("LevelProgressBar::Level", {
		size = { -1, 25 },
		gravity = { -1.0, .0 },
		color = ssu.makeColor(0, 0, 0, 50),
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
		backgroundColor1 = ssu.makeColor(255, 255, 255, 100),
		backgroundColor2 = positiveColor
	})
	
	a("LimitedProgressBar", {
		size = { -1, 25 },
		minSize = { 250, -1 },
		gravity = { -1.0, .0 },
		color = positiveColor,
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
		backgroundColor1 = negativeColor,
		backgroundColor2 = ssu.makeColor(255, 255, 255, 100),
		shadowColor = negativeColor,
		borderWidth = { 2, 2, 2, 2 }
	})
	
	a("LimitedProgressBar::Down, LimitedProgressBar::Label, LimitedProgressBar::Up", {
		gravity = { .5, .5 },
		fontSize = 12
	})
	a([[!ui-couch LimitedProgressBar::Down,
		!ui-couch LimitedProgressBar::Label,
		!ui-couchLimitedProgressBar::Up]], {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a("LimitedProgressBar::Down, LimitedProgressBar::Up", {
		color = ssu.makeColor(255, 255, 255, 50)
	})
	
	a("LimitedProgressBar::Lower", {
		borderColor = ssu.makeColor(255, 255, 255, 50),
		borderWidth = { 0, 1, 0, 0 },
		gravity = { -1.0, -1.0 }
	})
	a("LimitedProgressBar::Middle", {
		borderColor = ssu.makeColor(255, 255, 255, 50),
		borderWidth = { 0, 1, 0, 1 },
		gravity = { -1.0, -1.0 }
	})
	a("LimitedProgressBar::Upper", {
		borderColor = ssu.makeColor(255, 255, 255, 50),
		borderWidth = { 0, 0, 0, 1 },
		gravity = { -1.0, -1.0 }
	})
	
	return result
end
