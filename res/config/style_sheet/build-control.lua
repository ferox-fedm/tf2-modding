require "tableutil"
local ssu = require "stylesheetutil"

local hp = 5
local vp = 2

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a([[BuildControlComp::BuildButton,
		BuildControlComp::CancelButton,
		BuildControlComp::CostsLabel,
		BuildControlComp::ErrorLabel,
		BuildControlComp::WarningLabel,
		BuildControlComp::GamePausedLabel,
		BuildControlComp::ConfirmLabel,
		BuildControlComp::FixSlopeButton,
		BuildControlComp::RaiseSlopeButton,
		BuildControlComp::LowerSlopeButton]], {
		
		gravity = { .0, .0 }
	})

	a("BuildControlComp::CostsLabel", {
		fontSize = 18,
		backgroundColor = ssu.makeColor(50, 50, 50, 200),
		padding = { vp, hp, vp, hp }
	})
	a("!ui-couch BuildControlComp::CostsLabel", {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})

	a("BuildControlComp::ErrorLabel, BuildControlComp::GamePausedLabel", {
		fontSize = 16,
		backgroundColor = ssu.makeColor(200, 0, 0, 200),
		padding = { vp, hp, vp, hp }
	})
	a([[!ui-couch BuildControlComp::ErrorLabel, 
		!ui-couch BuildControlComp::GamePausedLabel]], {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})

	a("BuildControlComp::WarningLabel", {
		fontSize = 16,
		backgroundColor = ssu.makeColor(180, 160, 0, 200),
		padding = { vp, hp, vp, hp }
	})

	a("BuildControlComp::PendingLabel", {
		fontSize = 16,
		backgroundColor = ssu.makeColor(70, 83, 93, 190),
		padding = { vp, hp, vp, hp }
	})

	a("!ui-couch BuildControlComp::WarningLabel", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a([[BuildControlComp::FixSlopeButton::Icon,
		BuildControlComp::RaiseSlopeButton::Icon,
		BuildControlComp::LowerSlopeButton::Icon]], {
		backgroundColor = ssu.makeColor(70, 83, 93, 190),
		padding = { 1, 1, 1, 1 }
	})
	a([[BuildControlComp::FixSlopeButton::Icon:hover,
		BuildControlComp::RaiseSlopeButton::Icon:hover,
		BuildControlComp::LowerSlopeButton::Icon:hover]], {
		backgroundColor = ssu.makeColorOffset(70, 83, 93, 190, 25),
	})
	a([[BuildControlComp::FixSlopeButton::Icon:active,
		BuildControlComp::RaiseSlopeButton::Icon:active,
		BuildControlComp::LowerSlopeButton::Icon:active]], {
		backgroundColor = ssu.makeColorOffset(70, 83, 93, 190, 50),
	})
	a([[BuildControlComp::FixSlopeButton::Icon:disabled,
		BuildControlComp::RaiseSlopeButton::Icon:disabled,
		BuildControlComp::LowerSlopeButton::Icon:disabled]], {
		color = ssu.makeColor(25, 25, 25, 200)
	})

	a("BuildControlComp::BuildButton::Icon", {
		backgroundColor = ssu.makeColor(50, 125, 200, 200),
		padding = { 1, 1, 1, 1 }
	})
	a("BuildControlComp::BuildButton::Icon:hover", {
		backgroundColor = ssu.makeColorOffset(50, 125, 200, 200, 25),
	})
	a("BuildControlComp::BuildButton::Icon:active", {
		backgroundColor = ssu.makeColorOffset(50, 125, 200, 200, 50),
	})
	a("BuildControlComp::BuildButton::Icon:disabled", {
		color = ssu.makeColor(25, 25, 25, 100)
	})


	a("!input-controller BuildControlComp::CancelButton", {
	    visibility = "transparent"
	})
	a("BuildControlComp::CancelButton::Icon", {
		backgroundColor = ssu.makeColor(200, 50, 50, 200),
		padding = { 1, 1, 1, 1 }
	})
	a("BuildControlComp::CancelButton::Icon:hover", {
		backgroundColor = ssu.makeColorOffset(200, 50, 50, 200, 25),
	})
	a("BuildControlComp::CancelButton::Icon:active", {
		backgroundColor = ssu.makeColorOffset(200, 50, 50, 200, 50),
	})
	a("BuildControlComp::CancelButton::Icon:disabled", {
		color = ssu.makeColor(25, 25, 25, 100)
	})

	a("!ui-couch BuildControlComp::SectionTypeButton KeybindingHintDisplay", {
		visibility = "none"
	})
	
	return result
end
