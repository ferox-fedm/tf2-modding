require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a([[#menu.layers.landuseWindow, #menu.layers.contoursWindow, #menu.layers.watersWindow,
		"#menu.layers.speedLimitsWindow, #menu.layers.trafficLayerWindow, #menu.layers.emissionLayerWindow,
		"#menu.layers.destinationWindow, #menu.layers.cargoWindow, #menu.layers.stationWindow]], {
		size = { 300, -1 },
		minSize = { -1, 150 }
	})
	
	a([[DestinationLayerComp GradientLegend,
		CargoLayerComp GradientLegend, StationLayerComp GradientLegend]], {
		padding = { 0, 0, 15, 0 }
	})
	
	a("ContourLinesComp::ContourBackground", {
		backgroundColor = ssu.makeColor(255, 255, 255, 200)
	})
	
	a("LandValueComp GradientLegend", {
		padding = { 0, hp, 15, hp }
	})
	a("!ui-couch LandValueComp GradientLegend", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	
	a("EmissionLayerComp GradientLegend, TrafficLayerComp GradientLegend, SpeedLimitsComp GradientLegend", {
		padding = { hp + 15, hp, hp + 15, hp }
	})
	
	a("EmissionLayerComp ComboBox", {
		gravity = { .0, .5 }
	})
	
	a("majorContour, minorContour, intermediateContour, detailContour, waters", {
		margin = { vp, hp, vp, hp }
	})
	
	a([[LandValueComp::Layout, ContourLinesComp::Layout, NavigableWatersComp::Layout,
		SpeedLimitsComp::Layout, TrafficLayerComp::Layout, EmissionLayerComp::Layout GradientLegend::Layout,
		DestinationLayerComp::Layout, CargoLayerComp::Layout, StationLayerComp::Layout]], {
		innerSpacing = { 10, 10 }
	})
	
	a("GradientLegend", {
		padding = { 15, 0, 15, 0 },
		gravity = { -1.0, .0 }
	})
	a("!ui-couch GradientLegend", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a([[TrafficControlComp::PrecedenceButton::Icon,
		TrafficControlComp::TrafficLightButton::Icon,
		TrafficControlComp::PlayerOwnedButton::Icon]], {
		color = ssu.makeColor(100, 100, 100),
		backgroundColor = ssu.makeColor(150, 165, 175),
		borderColor = ssu.makeColorOffset(150, 165, 175, 255, -10),
		borderWidth = { 1, 1, 1, 1 },
		padding = { 2, 2, 2, 2 },
		gravity = { .0, .0 }
	})
	a([[TrafficControlComp::PrecedenceButton::Icon:hover,
		TrafficControlComp::TrafficLightButton::Icon:hover,
		TrafficControlComp::PlayerOwnedButton::Icon:hover]], {
		backgroundColor = ssu.makeColorOffset(150, 165, 175, 255, 25),
		borderColor = ssu.makeColorOffset(150, 165, 175, 255, 15),
	})
	a([[TrafficControlComp::PrecedenceButton::Icon:active,
		TrafficControlComp::TrafficLightButton::Icon:active,
		TrafficControlComp::PlayerOwnedButton::Icon:active]], {
		color = ssu.makeColor(255, 255, 255),
		backgroundColor = ssu.makeColor(150, 165, 175),
		borderColor = ssu.makeColorOffset(150, 165, 175, 255, -10),
	})
	a([[TrafficControlComp::PrecedenceButton::Icon:disabled,
		TrafficControlComp::TrafficLightButton::Icon:disabled,
		TrafficControlComp::PlayerOwnedButton::Icon:disabled]], {
		color = ssu.makeColor(100, 100, 100),
		backgroundColor = ssu.makeColor(150, 165, 175),
		borderColor = ssu.makeColorOffset(150, 165, 175, 255, -10),
	})
	
	return result
end
