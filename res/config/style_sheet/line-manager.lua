require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

local positiveColor = { .6, .8, 1.0, 1.0 }

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)

	a("Window!line-manager", {
	    anchorPoint = { 0.5, 1 },
	    gravity = { 0.5, 1 },
	    size = {1000, 350},
		padding = { 0, 0, 25, 0} --HACK avoid overlap
	})
	a("!ui-couch Window!line-manager", {
	    size = {"100vw", 250},
	})

	a("!ui-couch Window!line-manager Window::Title-bar", {
	    visibility = "folded",
	})

	a("LineManager::Layout", {
		innerSpacing = { hp, vp }
	})
	
	a("#lineManager.newLine BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	
	a([[LineManager NoLinesHint,
		LineManager NoStationsHint]], {
		gravity = { 0.5, -1.0 },
	})

	a([[LineManager NoLinesHint ImageView,
		LineManager NoStationsHint ImageView,
		LineManager NoStationsHint AddStationHintButton]], {
		gravity = { 0.5, 0.5 },
	})

	a("#lineManager.newLine TextView", {
		padding = { 0, 10, 0, 0 }
	})

	a("!ui-couch LineManager::LineEditorComp", {
		margin = {0, -10, 0, 0}
	})

	a("!ui-couch #lineManager.newLine, !ui-couch #lineManager.searchFieldScroll", {
		visibility = "folded"
	})
	a("!ui-couch #lineEditor.addStation", {
		visibility = "folded"
	})
	a("!ui-couch LineEditor::ColorLabel::Layout", {
		visibility = "hidden",
		size = { -1, 4 }
	})

	a("!ui-couch!input-mouse Window!line-manager LineManager::Close", {
		gravity = {0, 0},
		visibility = "visible"
	})

	a("LineManager::ButtonLayout", {
		innerSpacing = { 5, 0 },
		gravity = { -1.0, .0 }
	})
	
	a("LineManager InputTextScrollArea", {
		size = { 125, 24 + 5},
		margin = { 0, 0, 5, 0 },
	})
	a("LineManager InputTextScrollArea > ScrollArea::Content > TextInputField", {
		margin = { 0, 0, 0, 0 },
	})
	
	a("VehicleManager InputTextScrollArea, LinesTable InputTextScrollArea, VehiclesTable InputTextScrollArea", {
		size = { 180, 24 + 5}
	})
	
	a("LineManager LineDepotFilter Table !table-header, LineManager LineDepotFilter Table !table-item", {
		padding = { 0, 0, 0, 0 }
	})
	
	a("LineFilterItem::LineComp TextInputField", {
		padding = { 0, hp, 0, hp },
		size = { -1, 27 }, -- HACK 27
	})

	a([[!ui-couch!input-controller LineFilterItem::RowComp !rename, 
		!ui-couch!input-controller LineFilterItem::RowComp !delete-line]], {
		visibility = "folded"
	})
	
	a("LineFilterItem::ButtonComp", {
		gravity = { 1.0, .5 }
	})
	
	a("LineEditor::Layout", {
		innerSpacing = { hp, vp }
	})
	
	a("LineEditor::Settings::Layout", {
		gravity = { .0, .0 },
		innerSpacing = { hp, vp }
	})

	a("LineEditor::TopSettings::Layout", {
		gravity = { -1, 0 }
	})

	a("LineEditor::ColorLabel::Layout", {
		gravity = { 1, -1 },
		minSize = {150, 0},
		padding = { 0, 10, 1, 20 }
	})

	a("LineFilterItem::ButtonComp Button::Icon, LineFilterItem::LineComp Button::Icon", {
		padding = { vp, hp, vp, hp }
	})

	a("LineFilterItem::LineComp Button!locate-button Button::Icon", {
		padding = { 0, 0, 0, 0 }
	})
	
	a("LineEditor Table !table-header, LineEditor Table !table-item", {
		padding = { 0, 0, 0, 0 }
	})
	
	a("StopCounterLabel TextView", {
		padding = { 0, 0, 0, 0 }
	})
	
	a("!table-item!delete-station-button", {
		padding = { vp + 2, hp, vp + 3, hp },
	})

	a("!ui-couch!input-controller !table-item!delete-station-button", {
		visibility = "folded"
	})
	
	a("!cargo-config-button", {
		backgroundColor = ssu.makeColor(0, 0, 0, 50),
	})
	
	a("LineEditor::CargoFilter::Text", {
		backgroundColor = ssu.makeColor(150, 0, 0, 100),
		padding = { 5, 15, 5, 15 }
	})
	
	a("LineEditor::CargoFilter::Popup", {
		padding = { 0, 0, 0, 0 }
	})
	
	a("LineEditor::CargoFilter::Popup Table !table-item", {
		padding = { 0, 0, 0, 0 },
		gravity = { .5, .5 },
	})

	a("!cargo-config-button-valid", {
		color = positiveColor
	})

	a("!cargo-config-button-invalid", {
		color = ssu.makeColor(255, 255, 255)
	})
	
	a("StopCounterLabel", {
		margin = { 0, hp, 0, 2 }
	})

	a("StopCounterLabel TextView", {
		--gravity = { -1.0, .5 },
		fontSize = 12,
		minSize = { 24, 24 },
		textAlignment = { .5, .5 }
	})
	a("!ui-couch StopCounterLabel TextView", {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})
	a("VehicleListComp", {
		padding = { 0, hp, 0, hp },
	})
	
	a("VehicleListComp::Vehicles::Counter", {
		backgroundColor1 = ssu.makeColor(83, 151, 198, 200),
		backgroundImage1 = { fileName = "ui/design/buttons/disk_arrow.tga", horizontal = { 0, 9, 10, 20 }, vertical = { 0, 9, 10, 20 } },
		padding = { 2, 5, 2, 5 },
		fontSize = 12
	})
	a("!ui-couch VehicleListComp::Vehicles::Counter", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a("StationTerminal::Icon", {
		padding = { 0, 0, 0, hp },
	})
	
	a("LineEditor LineStop!table-item", {
		padding = { 0, 5, 0, 5 },
	})
	a("LineEditor !alternative-terminals-button!alternative-terminals-active Button::Icon", {
		color = positiveColor,
	})

	a("!input-controller LineManager LineDepotFilter ScrollArea::Content:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 15),
	})

	a("!input-controller LineManager LineEditor:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 15),
	})

	-- special cases where keybinding hint in table items should be centered
	a([[!ui-couch LineManager LineDepotFilter RowWrap!table-item KeybindingHintDisplay!overflowMode,
		!ui-couch LineManager LineEditor LineFilterItem::RowComp!table-item TextView!line-label KeybindingHintDisplay!overflowMode]], {
		gravity = { 0.9, 0.5 },
	})

	return result
end
