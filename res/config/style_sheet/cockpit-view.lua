require "tableutil"
local ssu = require "stylesheetutil"

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("CockpitCamera::Line1", {
		backgroundColor =  ssu.makeColor(0, 0, 0, 100),
		padding = { 4, 4, 4, 4 },
		fontSize = 16,
	})
	
	a("CockpitCamera::Line2", {
		backgroundColor =  ssu.makeColor(0, 0, 0, 100),
		padding = { 4, 4, 4, 4 },
		fontSize = 20,
	})
	
	a("CockpitCamera::Speed", {
		backgroundColor =  ssu.makeColor(0, 0, 0, 100),
		padding = { 4, 4, 4, 4 },
		fontSize = 26,
	})
	a("!ui-couch CockpitCamera::Speed", {
		fontSize = ssu.styles.uicouche_cockpit_view_label_fontSize
	})
	a("CockpitCamera::CameraHelp", {
		backgroundColor =  ssu.makeColor(0, 0, 0, 100),
		padding = { 4, 4, 4, 4 },
		fontSize = 14,
	})
	a("!ui-couch CockpitCamera::CameraHelp", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a("CockpitCamera::HornHelp", {
		backgroundColor =  ssu.makeColor(0, 0, 0, 100),
		padding = { 4, 4, 4, 4 },
		fontSize = 14,
	})
	a("!ui-couch CockpitCamera::HornHelp", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a("CockpitCamera::Cargo", {
		backgroundColor =  ssu.makeColor(0, 0, 0, 50),
	})
	
	a("CockpitCamera::Cargo CargoItem::Text", {
		padding = { 4, 4, 4, 4 },
		fontSize = 26,
	})
	a("!ui-couch CockpitCamera::Cargo CargoItem::Text", {
		fontSize = ssu.styles.uicouche_cockpit_view_label_fontSize
	})
	a("CockpitCamera::Cargo CargoItem::Icon", {
		padding = { 4, 4, 4, 4 },
		scaling = 1.2,
	})
	
	return result
end
