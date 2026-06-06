require "tableutil"
local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local hp = 10
local vp = 5
local defaultMargin = hp

local constructionMenuMainColor = ssu.makeColor(5+25, 25+25, 40+25, 200)
local constructionMenuBackColor = ssu.makeColor(5, 25, 40, 210)
local constructionMenuHoverColor = ssu.makeColor(5+10, 25+10, 40+10, 200)

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)

	a("PopupManager::Popup", {
		backgroundColor = ssu.makeColor(5, 25, 40, 130),
		blurRadius = 16 * 4,
		gravity = { .5, .0 }
	})

	a("!ui-couch PopupManager::Popup", {
		margin = { 0, 10, 0, 10 }
	})

	a("PopupManager::Popup::Title", {
		fontSize = 18
	})
	a("!ui-couch PopupManager::Popup::Title", {
		fontSize = ssu.styles.uicouch_subtitle_fontSize
	})

	a("PopupManager::Popup::Icon", {
		padding = { 5, 0, 10, 10 }
	})

	a("PopupManager::Popup::Label", {
		fontSize = 16
	})
	a("!ui-couch PopupManager::Popup::Label", {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	a("PopupManager::Popup::Title, PopupManager::Popup::Label, PopupManager::Popup::Text", {
		padding = { vp, hp + 25, vp, hp } -- TODO +20 because of close button
	})

	a("PopupManager::Popup RendererComponent", {
		minSize = { 306, 172 },
		padding = { 0, 5, 5, 5 },
		gravity = { -1, 0.5 },
	})
	a("!ui-couch PopupManager::Popup RendererComponent", {
		minSize = { 350, 150 },
	})

	a("PopupManager::Popup PopupManager::Popup::Label", {
		gravity = { -1, 0 },
		border = { 5, 5, 0, 5 },
	})

	a([[PopupManager::Popup !popup-list-item ImageView, 
		PopupManager::Popup !popup-list-item TextView]], {
		gravity = { .5, .0 },
		padding = { vp, hp, vp + 10, hp }
	})
	a("PopupManager::Popup !popup-list-item, PopupManager::Popup !popup-list-item TextView", {
		gravity = { .5, .5 }
	})

	a("PopupManager::Popup RemoveIndustry !popup-list-item ImageView", {
		color = { .7, .7, .7, .6 }
	})

	a("NewVehicles:enabled", {
		soundEffect1 = sound.get("newVehicle")
	})

	a("PopupManager::Popup FlowLayout", {
		gravity = { .5, .5 },
		innerSpacing = { hp, vp }
	})

	a("NewVehicle", {
		--backgroundColor = ssu.makeColor(50, 50, 50, 150),
		gravity = { .5, .0 },
		padding = { vp, hp, vp, hp }
	})
	
	a("NewVehicle::Label", {
		gravity = { .5, .0 },
		padding = { vp, hp, vp, hp }
	})
	a("NewVehicle::Icon", {
		gravity = { .5, .0 }
	})
	
	a("NewVehicle::InfoLayout", {
		gravity = { -1.0, .0 }
	})
	
	a("NewVehicle::Info", {
		gravity = { .5, .0 },
		padding = { vp, hp, vp, hp }
	})

	a("RemoveIndustry::MainComp", {
		gravity = { .5, .5 },
	})

	a("PopupManager::Popup !items-list", {
		padding = { 0, hp, vp, hp }
	})

	a("PopupManager::Popup !industry TextView", {
		minSize = { 190, -1 },
		textAlignment = { .5, .5 },
	})

	a("PopupManager::Popup CargoType TextView", {
		minSize = { -1, -1 },
		textAlignment = { .5, .5 },
	})

	a("Popup ToggleButtonGroup:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})

	a("Popup ComboBox!fullWidth", {
		gravity = { -1, -1 },
	})

	a("Popup StatisticsSortPopup", {
		size = { 250, -1 },
	})

	a("Popup StatisticsSortPopup ComboBox", {
		minSize = { -1, 31 }
	})

	a("Popup StatisticsSortPopup ComboBox wrap BoxLayout", { -- for icons inside combobox
		gravity = { 0.5, -1 },
	})

	a("!input-controller PopupManager::Popup SimpleButton!popup-close-button", {
		visibility = "hidden"
	})

	a("PopupManager::Notification::Layout", {
		-- gravity = {0.5, 0.5},
	})
	a("PopupManager::Notification::Layout2", {
		size = {342, 114},
		minSize = {342, 114},
		maxSize = {342, 114}
	})

	a("PopupManager::Notification::DescLayout", {
		gravity = {-1, -1},
	})

	a("PopupManager::Notification::DescLayout2", {
		size = {248, 65},
		minSize = {248, 65},
		maxSize = {248, 65},
		margin = {5, 10, 5, 10}
	})

	a("PopupManager::Notification::Title", {
		fontSize = 17,
		maxSize = {300, -1},
		margin = { 5, 0, 5, 10 }
	})
	a("PopupManager::Notification::SubTitle", {
		maxSize = {250, -1},
		gravity = {0.0, 0.0},
		fontSize = 15,
		textAlignment = {0.0, 0.0},
		margin = {0, 0, 5, 0},
	})

	a("PopupManager::Notification::InfoText", {
		fontSize = 14,
		margin = {-5, 0, 0, 0},
	})

	a("PopupManager::Notification::Icon", {
		margin = { 5, 0, 10, 10 }
	})

	a("PopupManager::Notification::CargoTypeIcon", {
		scaling = 0.75,
		margin = { 0, 0, 5, 0 }
	})

	return result
end
