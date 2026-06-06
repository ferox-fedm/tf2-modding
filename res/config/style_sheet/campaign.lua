require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

local markerSize = { 36, 51 }
local markerColor = ssu.makeColor(255, 255, 255, 200)

local positiveColor = { .6, .8, 1.0, 1.0 }
local negativeColor = { 1.0, .6, .6, 1.0 }

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)

	a([[!ui-couch MissionDisplay!tab-widget-content ScrollArea]], {
		maxSize = { -1, 410 }
	})

	a("Window#missionDisplayWindow", {
		size = {600, 525}
	})

	a("!ui-couch Window#missionDisplayWindow Window::Locate", {
		visibility = "transparent"
	})

	a("!input-controller TaskDisplay::VoiceOverButton", {
		visibility = "transparent"
	})


	a("TaskList BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	
	a("TaskList::TaskButton:hover, TaskDisplay::Button:hover, TaskDisplay::VoiceOverButton:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})
	a("TaskList::TaskButton:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 100),
	})
	a("TaskList::TaskButton:disabled", {
		color = ssu.makeColor(150, 150, 150)
	})
	
	a("TaskComp::Name, TaskComp::ProgressLabel", {
		fontSize = 16
	})
	a([[!ui-couch TaskComp::Name,
		!ui-couch TaskComp::ProgressLabel]], {
		fontSize = ssu.styles.uicouch_body_fontSize
	})
	
	a("TaskComp", {
		padding = { vp, hp, vp, hp }
	})
	
	a("MissionTaskListLayoutComp ScrollArea", {
		backgroundColor = ssu.makeColor(5, 25, 40, 150),
		blurRadius = 4 * 9
	})
	
	a("MissionDisplay LinearLayout", {
		innerSpacing = { hp, vp }
	})
	
	a("MissionDisplay::Task", {
		padding = { vp, hp, vp, hp }
	})

	a("!ui-couch MissionDisplay TabWidget KeybindingHintDisplay", {
		visibility = "none"
	})
	a("!ui-couch TaskList KeybindingHintDisplay", {
		gravity = {1, 0.5},
	})

	a([[!ui-couch MissionDisplay!tab-widget-content ScrollArea]], {
		gravity = {-1, 0}
	})

	a([[!ui-couch MissionDisplay::ChildTask,
		!ui-couch MissionDisplay::Task]], {
		fontSize = ssu.styles.uicouch_body_fontSize,
		minSize = {180, -1}
	})

	a("MissionDisplay::ChildTask!task-active", {
		color = positiveColor
	})
	a("MissionDisplay::ChildTask", {
		padding = { vp, hp, vp, hp + 20 }
	})
	a("MissionDisplay::Task:hover, MissionDisplay::ChildTask:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})
	a("MissionDisplay::Task:active, MissionDisplay::ChildTask:active", {
		backgroundColor = ssu.makeColor(255, 255, 255, 100),
	})
	a("MissionDisplay::Task:disabled, MissionDisplay::ChildTask:disabled", {
		backgroundColor = ssu.makeColor(150, 150, 150)
	})
	
	a("TaskDisplay::Content", {
		padding = { vp, hp, vp, hp }
	})
	
	a("TaskDisplay::TaskName", {
		fontSize = 16
	})
	a("!ui-couch TaskDisplay::TaskName", {
		fontSize = ssu.styles.uicouch_subtitle_fontSize
	})

	a("TaskDisplay::TaskMessage", {
		fontSize = 14,
		--fontFamily = styleSheetRep->GetFontNameBold(),
		backgroundColor = ssu.makeColor(138, 198, 241, 75),
		borderColor = ssu.makeColor(138, 198, 241, 100),
		borderWidth = { 0, 0, 1, 0 },
		color = ssu.makeColor(255, 255, 255),
		padding = { 5, 3, 3, 5 }
	})
	a([[!ui-couch TaskDisplay::TaskMessage,
		!ui-couch TaskDisplay::TextMessage]], {
		fontSize = ssu.styles.uicouch_body_fontSize,
	})
	a("!ui-couch TaskDisplay::TaskMessage KeybindingHintDisplay", {
		scaling = 0.65,
		margin = { 0, -20, 0, 0 }
	})

	a("TaskDisplay::HintMessage", {
		fontSize = 12,
		backgroundImage1 = { fileName = "ui/campaign/hint-icon.tga", horizontal = { 0, 11, 11, 11 }, vertical = { 0, 18, 18, 18 } },
		backgroundColor1 = ssu.makeColor(214-2*12, 214-12, 214),
		color = ssu.makeColor(214-2*12, 214-12, 214),
		padding = { 2, 3, 3, 20 }
	})
	a("!ui-couch TaskDisplay::HintMessage", {
		fontSize = ssu.styles.uicouche_hints_fontSize,
	})

	a("TaskDisplay::TaskParagraph", {
		padding = { 0, 15, 0, 15 }
	})
	a("TaskDisplay::HintParagraph", {
		padding = { 0, 5, 0, 5 }
	})
	a("!ui-couch TaskDisplay::Button", {
		margin = { 0, 25, 0, 0 },
		minSize = { 55, -1 },
	})
	
	a("TaskDisplay::Button::Text", {
		padding = { vp, hp, vp, hp },
		fontSize = 13,
		textTransform = "UPPERCASE"
	})
	a("!ui-couch TaskDisplay::Button::Text", {
		fontSize = ssu.styles.uicouch_primarybuttons_fontSize,
		textTransform = ssu.styles.uicouch_primarybuttons_textTransform
	})

	a("!ui-couch MissionDisplay TaskDisplay::Button KeybindingHintDisplay!overflowMode", {
		gravity = ssu.styles.action_keybinding_gravity,
		scaling = ssu.styles.action_keybinding_scale,
		margin = { 0, 0, 10, 35 },
	})

	a([[!ui-couch!input-controller MissionDisplay TaskDisplay,
		!ui-couch!input-controller MissionDisplay TaskDisplay *]], {
		actionPromptList = {
			{ia = "IA_LEFT", text = _("Select link/option")},
			{ia = "IA_RIGHT", text = _("Select link/option")},
		}
	})

	a("MissionMedalsComp::MedalComp", {
	
	})

	a("MissionMedalsComp::MedalIcon", {
		gravity = { .5, .0 },
	})

	a("MissionMedalsComp::MedalLabel", {
		gravity = { .5, .0 },
		fontSize = 10,

	})
	a("!ui-couch MissionMedalsComp::MedalLabel", {
		fontSize = ssu.styles.uicouch_body_fontSize,
		textAlignment = { 0.5, -1 }
	})
	
	a("!mission-end-window", {
		anchorPoint = {0.5, 0.5},
		gravity = {0.5, 0.5},
	})

	a("MissionEnd::Layout", {
		innerSpacing = { hp, hp },
		outerSpacing = { hp, hp }
	})
	
	a("MissionEnd::Info::Layout", {
		gravity = { -1.0, -1.0 }
	})
	
	a("MissionEnd::Info::Text", {
		shadowNinePatch = { fileName = "ui/design/main-menu/loading_screen_background.tga", horizontal = { 0, 74, 75, 148 }, vertical = { 0, 70, 71, 140 } },
		shadowWidth = { 60, 60, 60, 60 },
		shadowColor = ssu.makeColor(0, 0, 0, 200),
		gravity = { .5, 1.0 }
	})
	
	a("MissionEnd::Buttons", {
		gravity = { .5, .5 }
	})
	
	a("!ui-couch MissionEnd Button", {
		margin = {0, 50, 0, 50}
	})

	a("CampaignInfoComp", {
		minSize = { 0, 200 },
	})

	return result
end
