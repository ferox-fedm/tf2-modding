require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

local constructionMenuMainColor = ssu.makeColor(5+25, 25+25, 40+25, 200)
local constructionMenuBackColor = ssu.makeColor(5, 25, 40, 210)
local constructionMenuHoverColor = ssu.makeColor(5+10, 25+10, 40+10, 200)

local alpha = 1.0
local landUseColors = { 
	{ .525, .847, .345, alpha },
	{ .369, .839, .906, alpha },
	{ .875, .875, .384, alpha },
}

local backgroundColor = ssu.makeColor(0, 0, 0, 50)

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("TownGrowthComp Table", {
		gravity = { -1.0, .0 },
		backgroundColor1 = { 0, 0, 0, 0 },
		backgroundColor2 = { 0, 0, 0, 0 },
	})
	
	a("TownGrowthComp::RowItem", {
		gravity = { -1.0, -1.0 },
		padding = { vp, hp, vp, hp }
	})
	a([[TownGrowthComp::Value, TownGrowthComp::Score, TownGrowthComp::SummaryValue,
		TownGrowthComp::InitSizeValue, TownGrowthComp::RatingSumValue, TownGrowthComp::TargetSizeValue]], {
		gravity = { -1.0, .5 },
		textAlignment = { 1.0, .5 }
	})
	
	a("TownGrowthComp::RowSpace", {
		size = { 0, 10 }
	})

	a("TownOverview::LandUseCount", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
		gravity = { -1.0, .0 }
	})

	a("TownOverview::LandUseCount::Layout", {
		innerSpacing = { 3 * hp, vp },
		outerSpacing = { hp, 2 * vp },
	})
	
	a("TownOverview::ResidentialCounter BoxLayout, TownOverview::CommercialCounter BoxLayout, TownOverview::IndustryCounter BoxLayout", {
		innerSpacing = { 0, 0 },
	})
	
	a([[!ui-couch TownOverview::ResidentialCounter::Label,
		!ui-couch TownOverview::CommercialCounter::Label,
		!ui-couch TownOverview::IndustryCounter::Label]], {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	
	a("TownOverview::ResidentialCounter, TownOverview::CommercialCounter, TownOverview::IndustryCounter", {
		gravity = { .0, 1.0 }
	})
	
	a("TownOverview::ResidentialCounter::Tendency", {
		padding = { 9, hp, 0, 0 }, -- TODO HACK font size dependent
		gravity = { .0, .0 }
	})
	a("TownOverview::ResidentialCounter::Number", {
		fontSize = 33,
		gravity = { .0, 1.0 },
		padding = { 0, 0, -5, 0 }
	})
	
	a("TownOverview::ResidentialCounter::Number", {
		color = landUseColors[1],
	})
	a("TownOverview::CommercialCounter::Number", {
		color = landUseColors[2],
	})
	a("TownOverview::IndustryCounter::Number", {
		color = landUseColors[3],
	})
	a([[!ui-couch TownOverview::IndustryCounter::Number,
		!ui-couch TownOverview::CommercialCounter::Number]], {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	
	a("TownGrowthComp::RowItem!town-growth-results", {
		backgroundColor = ssu.makeColor(255, 255, 255, 25),
	})
	
	return result
end
