require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

function data()
	local result = { }

	local a = ssu.makeAdder(result)

	a("VehicleEditor::MoveButtons BoxLayout", {
		innerSpacing = { 0, 0 }
	})

	a("VehicleEditor::MoveButtons Button::Icon", {
		padding = { 3, 5, 3, 5 },
	})

	a("VehicleEditor !vehicle-configs !list-item", {
		borderWidth = { 0, 0, 0, 5 }
	})
	a("VehicleEditor !vehicle-configs !list-item:hover", {
		backgroundColor = ssu.makeColor(83, 151, 198, 25),
		borderColor = ssu.makeColor(83, 151, 198, 25)
	})
	a("VehicleEditor !vehicle-configs !list-item:active", {
		backgroundColor = ssu.makeColor(83, 151, 198, 50),
		borderColor = ssu.makeColor(83, 151, 198, 200)
	})

	a("VehicleEditor::Vehicle", {
		size = { -1, 54 }
	})

	a("VehicleEditor BuyButton", {
		margin = { 0, 10, 0, 0 }
	})

	a("VehicleEditor BuyButton !vehicle-buy-money", {
		minSize = { 85, 0 },
		textAlignment = { 1.0, .5 }
	})

	a("VehicleEditor::BuyLayout", {
		innerSpacing = { 15, 0 },
		gravity = { -1.0, 1.0 }
	})

	a("VehicleEditor::BuyQuantity", {
		gravity = { 1.0, .5 }
	})
	a([[!ui-couch VehicleEditor::BuyQuantity,
		!ui-couch VehicleEditor !vehicle-cancel-button,
		!input-controller VehicleEditor !vehicle-reset-button]], {
		visibility = "none",
	})

	a([[!ui-couch VehicleEditor !info-message]], {
		visibility = "none"
	})

	a([[!ui-couch VehicleEditor CurrentList]], {
		backgroundColor = ssu.makeColor(150, 150, 150, 100),
	})

	a([[!ui-couch VehicleEditor !vehicle-list-label]], {
		-- backgroundColor = ssu.makeColor(150, 150, 150, 100),
		gravity = {0.0, -1.0},
		maxSize = {220, -1},
		minSize = {220, -1}
	})

	a([[!ui-couch VehicleEditor !vehicle-list]], {
		-- backgroundColor = ssu.makeColor(150, 150, 150, 100),
		gravity = {1.0, -1.0},
	})

	a([[!ui-classic VehicleEditor !vehicle-list-label]], {
		visibility = "none"
	})

	a([[!ui-classic VehicleEditor !vehicle-list]], {
		visibility = "none"
	})

	a("!vehicle-buy-count", {
		maxSize = { 100, -1 },
	})

	a("VehicleDepotDisplay::VehicleLength", {
		gravity = { .5, .5 }
	})

	a("VehicleDepotDisplay::VehicleButtons", {
		gravity = { 1.0, .5 }
	})

	a("VehicleDepotDisplay::VehicleInfo", {
		backgroundColor = ssu.makeColor(0, 0, 0, 64)
	})

	a("VehicleDepotDisplay::VehicleComp", {
		backgroundColor = ssu.makeColor(150, 150, 150, 100),
		borderColor = ssu.makeColor(0, 0, 0, 128),
		borderWidth = { 0, 0, 2, 0 },
		padding = { 5, 0, 0, 0 }
	})

	a("!ui-couch VehicleStore", {
		actionPromptList = {
			{ ia = "IA_MENU_BACK", text = _("Back") },
			{ ia = "IA_OPTION2", text = _("Filter/Sort") },
		},
	})
	a("!ui-couch!input-controller VehicleStore", {
		actionPromptList = {
			{ ia = "IA_SCROLL_DOWN", text = _("Scroll Details") },
			{ ia = "IA_OPTION1", text = _("Buy") },
		},
	})

	a("!ui-couch!input-controller VehicleStore::VehicleInfoScrollArea", {
		actionPromptList = {
			{ ia = "IA_DOWN", text = _("Scroll Details") },
			{ ia = "IA_UP", text = _("Scroll Details") },
		},
	})

	a("!ui-couch VehicleStore::VariantList List::ListContent", {
		actionPromptList = {
			{ ia = "IA_DOWN", text = _("Switch variant") },
		},
	})

	a("!ui-couch VehicleStore VehicleList", {
		actionPromptList = {
			{ ia = "IA_SELECT", text = _("Add") },
		},
	})

	a("!ui-couch VehicleEditor VehicleEditor::MoveButtons Button!remove-vehicle", {
		actionPromptList = {
			{ ia = "ACTION_CLICK", text = _("Remove") },
		},
	})

	a("!ui-couch VehicleEditor VehicleEditor::MoveButtons Button!flip-vehicle", {
		actionPromptList = {
			{ ia = "ACTION_CLICK", text = _("Flip") },
		},
	})

	a([[VehicleEditor VehicleEditor::MoveButtons Button!remove-vehicle!hide,
		VehicleEditor VehicleEditor::MoveButtons Button!flip-vehicle!hide,
		VehicleEditor VehicleEditor::MoveButtons Button!move-vehicle-leftmost!hide,
		VehicleEditor VehicleEditor::MoveButtons Button!move-vehicle-left!hide,
		VehicleEditor VehicleEditor::MoveButtons Button!move-vehicle-rightmost!hide,
		VehicleEditor VehicleEditor::MoveButtons Button!move-vehicle-right!hide]], {
		visibility = "folded",
	})

	a("!ui-couch VehicleEditor BuyButton!vehicle-buy-button KeybindingHintDisplay!overflowMode", {
		visibility = "none"
	})
	a("!ui-couch VehicleEditor VehicleDetails ColorChooserButton Button KeybindingHintDisplay!overflowMode", {
		visibility = "none"
	})

	a("!ui-couch VehicleEditor VehicleDetails ColorChooserButton Button", {
		actionPromptList = {
			{ ia = "ACTION_CLICK", text = _("Color") },
		},
	})

	a([[!ui-couch!input-controller VehicleEditor VehicleEditor::Vehicle wrap!fake-hover VehicleEditor::MoveButtons Button!remove-vehicle KeybindingHintDisplay,
		!ui-couch!input-controller VehicleEditor VehicleEditor::Vehicle wrap!fake-hover VehicleEditor::MoveButtons Button!flip-vehicle KeybindingHintDisplay]], {
		visibility = "none",
	})

	a("!ui-couch!input-controller VehicleEditor VehicleEditor::Vehicle wrap!fake-hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})

	a("!ui-couch!input-controller VehicleEditor BuyButton!vehicle-buy-button", {
		actionPromptList = {
			{ ia = "ACTION_CLICK", text = _("Buy") },
		},
	})

	a("!ui-couch!input-controller Window!vehicle-store Window::Close", {
		visibility = "folded"
	})

	a("VehicleStore TextInputField", {
		gravity = { -1.0, .5 }
	})

	a("VehicleStore::FilterButtons::Layout", {
		innerSpacing = { 0, 5 }
	})

	a("VehicleStore::FilterButtons ToggleButton", {
		gravity = { -1.0, .5 }
	})
	
	a("VehicleStore::FilterButtons::SecondLevel ToggleButton", {
		padding = { 0, 0, 0, 2*hp }
	})
	a("VehicleStore::FilterButtons::SecondLevel ToggleButton::Text", {
		textTransform = "NONE"
	})
	a("!ui-couch VehicleStore::MiddleComp VehicleStore::VehicleAndCargoFilter ComboBox", {
		gravity = { -1, 0.5 },
	})
	a([[!ui-couch VehicleStore::MiddleComp VehicleStore::VehicleAndCargoFilter ComboBox::Button ImageView!left-button!hide-left-right-buttons,
		!ui-couch VehicleStore::MiddleComp VehicleStore::VehicleAndCargoFilter ComboBox::Button ImageView!right-button!hide-left-right-buttons,
		!ui-couch VehicleStore::MiddleComp VehicleStore::OrderingFilter ComboBox::Button ImageView!left-button!hide-left-right-buttons,
		!ui-couch VehicleStore::MiddleComp VehicleStore::OrderingFilter ComboBox::Button ImageView!right-button!hide-left-right-buttons]], {
		visibility = "none"
	})
	a("!ui-couch VehicleStore::MiddleComp VehicleStore::OrderingFilter", {
		gravity = { -1.0, 0.5 },
	})
	a("!ui-couch VehicleStore::MiddleComp VehicleStore::OrderingFilter ComboBox", {
		gravity = { -1.0, 0.5 },
	})

	a("VehicleStore::VehicleInfo::Title", {
		padding = { vp, hp, vp, hp },
		backgroundColor = ssu.makeColor(255, 255, 255, 25)
	})

	a("VehicleStore::VehicleInfo::Name", {
		fontSize = 18,
		gravity = { 1.0, 1.0 }
	})
	a("!ui-couch VehicleStore::VehicleInfo::Name", {
		fontSize = ssu.styles.uicouch_subtitle_fontSize
	})
	a("VehicleStore::VehicleInfo::Price, VehicleStore::VehicleInfo::RunningCosts", {
		gravity = { 1.0, 1.0 }
	})

	a("VehicleStore::VehicleInfo::MultipleUnitIcon", {
		padding = { vp, hp, 8, hp } -- 8 scroll bar
	})

	a("VehicleStore::VehicleInfo::Description", {
		textAlignment = { .0, .0 },
		padding = { vp, hp, vp, hp },
		minSize = { 0, 55 }
	})

	a("VehicleStore::VehicleInfo::CargoTypes", {
		maxSize = { 200, -1 }
	})

	a("VehicleStore::EmptyIcon", {
		color = ssu.makeColor(0, 0, 0, 100)
	})

	a("!ui-classic VehicleStore ComboBox !content-button TextView", {
		padding = { 0, 0, 0, 30 },
	})

	a("VehicleStore CargoFilterItem::Icon", {
		margin = { 0, -5, 0, 0 },
	})
	a("!ui-couch VehicleStore CargoFilterItem::Icon", {
		margin = { 0, 0, 0, 0 },
	})

	a("!ui-couch Popup CargoItem!combo-box-list-item!list-item", {
		gravity = { 0.5, -1 },
	})

	a("VehicleStore !filterCargoItemCargoIcon", {
		margin = { 0, 0, 0, hp },
	})


	a("VehicleList !activate-button Button::Icon", {
		backgroundColor = ssu.makeColor(0, 0, 0, 100)
	})

	a("VehicleList::Item!list-item", {
		padding = { 0, 0, 0, 0 }
	})

	a("VehicleList::Item::Layout", {
		gravity = { -1.0, .0 }
	})

	a("VehicleList::Item::Label", {
		padding = { vp, hp, vp, hp },
	})

	a("VehicleList::Item::VehicleIcon, VehicleList::Item::MultipleUnitIcon", {
		margin = { vp, hp, vp, hp },
		maxSize = { 350, -1 }
	})

	return result
end
