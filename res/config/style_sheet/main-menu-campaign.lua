require "tableutil"
local ssu = require "stylesheetutil"

local hp = 2*10
local vp = 2*5

local markerColor = ssu.makeColor(255, 255, 255, 200)

local winOuterSpacing = 40
local winInnerSpacing = 25

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("CampaignIcon", {
		padding = { 5, 5, 5, 5 },
		size = { 210, 120 }
	})
	
	a("CampaignComp", {
		size = { -1, 600 }
	})
	a("!ui-couch CampaignComp", {
		size = { -1, -1 }
	})
	
	a("CampaignComp::MissionTitle", {
		fontSize = 18
	})
	a("!ui-couch CampaignComp::MissionTitle", {
		fontSize = ssu.styles.uicouch_subtitle_fontSize
	})
	
	a("CampaignComp::MissionYears", {
		color = ssu.makeColor(255, 255, 255, 200)
	})

	a("!ui-couch CampaignComp::MissionYears", {
	    fontSize = ssu.styles.uicouch_body_fontSize,
	})
	
	a("CampaignComp::MissionDescription", {
		size = { 450, -1 }
	})
	a("!ui-couch CampaignComp::MissionDescription", {
	    fontSize = ssu.styles.uicouch_body_fontSize,
		size = { 610, -1 }
	})
	
	a("CampaignComp::Mission", {
		padding = { vp, 0, 0, 0 },
		size = { -1, 200 - vp }
	})
	a("!ui-couch CampaignComp::Mission", {
		padding = { 0, 0, 0, 0 },
		size = { -1, 200},
	})
	
	a("CampaignComp::MedalsLayout, CampaignComp::MissionTextLayout, CampaignComp::MissionLayout", {
		gravity = { .0, .0 }
	})
	
	a("CampaignComp::MissionSelectLayout, CampaignComp::MissionLayout", {
		innerSpacing = { winInnerSpacing, winInnerSpacing }
	})
	
	a("CampaignComp::MissionTextLayout", {
		innerSpacing = { 0, vp }
	})
	
	a("CampaignComp::Map", {
		color = ssu.makeColor(200, 200, 200, 150),
	})
	a("!ui-classic CampaignComp::Map", {
		maxSize = { 800 , -1 },
	})

	a("CampaignComp::Marker", {
		color = ssu.makeColor(255, 255, 255),
		size = { 36, 51 },
		anchorPoint = { 0.3, 0.76 },
	})
	a("CampaignComp::Marker", {
		backgroundImage1 = { fileName = "ui/campaign/flag_played.tga" },
		backgroundColor1 = markerColor,
	})
	a("CampaignComp::Marker:hover", {
		backgroundImage1 = { fileName = "ui/campaign/flag_hover.tga" },
		backgroundColor1 = markerColor,
	})
	a("CampaignComp::Marker:active", {
		backgroundImage1 = { fileName = "ui/campaign/flag_selected.tga" },
		backgroundColor1 = markerColor,
	})
	a("CampaignComp::Marker:disabled", {
		backgroundImage1 = { fileName = "ui/campaign/flag_locked.tga" },
		backgroundColor1 = markerColor,
	})
	
	a("CampaignComp::Image", {
		size = { 300, 168 },
	})
	a("!ui-couch CampaignComp::Image", {
		maxSize = { 240, -1 },
	})

	a("CampaignComp List", {
		size = { 300, -1 },
		maxSize = { -1, 400 }
	})
	a("!ui-couch CampaignComp List", {
		maxSize = { -1, "50vh" },
	})
	
	return result
end
