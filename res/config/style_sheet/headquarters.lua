require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local hp = 10
local vp = 5

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("HQComp::ButtonsLayout", {
		gravity = { .5, .0 }
	})
	
	a("HQComp::CompanyValue", {
		fontSize = 33,
		color = { 1.0, 1.0, .2, 1.0 },
		padding = { 0, 0, -5, 0 }
	})
	a("HQComp::CompanyLabel", {
		fontSize = 12
	})
	a("!ui-couch HQComp::CompanyLabel", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a("HQComp::CompanyValueComp", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
		gravity = { -1.0, .0 },
		padding = { 2*vp, hp, 2*vp, hp }
	})
	
	a("HQComp::CompanyValueComp BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	
	a("HQComp !headquarters-label!headquarters-level1", {
		padding = { 0, 0, 0, 2 * hp }
	})
	a("HQComp !headquarters-label!headquarters-level2", {
		padding = { 0, 0, 0, 4 * hp }
	})
	
	a("HQComp !headquarters-value", {
		gravity = { 1.0, .5 }
	})
	
	return result
end
