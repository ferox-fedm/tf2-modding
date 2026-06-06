require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5
local defaultMargin = hp

local constructionMenuMainColor = ssu.makeColor(5+25, 25+25, 40+25, 200)
local constructionMenuBackColor = ssu.makeColor(5, 25, 40, 210)
local constructionMenuHoverColor = ssu.makeColor(5+10, 25+10, 40+10, 200)

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)

	a("ExportMapComp List, ImportHeightmapComp List", {
		backgroundColor = ssu.makeColor(0, 0, 0, 50)
	})
	
	a([[GenerateHeightmapComp, ImportHeightmapComp, ExportMapComp,
		GenerateTownsComp, GenerateIndustriesComp, GenerateStreetsComp, GameSettingsComp]], {
		padding = { vp, hp, vp, hp }
	})
	
	a([[GenerateHeightmapComp BoxLayout,
		ImportHeightmapComp BoxLayout,
		ExportMapComp BoxLayout,
		GenerateTownsComp BoxLayout,
		GenerateIndustriesComp BoxLayout,
		GenerateStreetsComp BoxLayout,
		GameSettingsComp BoxLayout]], {
		gravity = { -1.0, .0 },
		innerSpacing = { 5, 5 }
	})
	
	a("GameSettingsComp", {
		minSize = { 300, 200 }
	})
	
	a([[GenerateHeightmapComp::Settings::Layout,
		ImportHeightmapComp::Settings::Layout,
		ExportMapComp::Settings::Layout,
		GenerateTownsComp::Settings::Layout,
		GenerateIndustriesComp::Settings::Layout,
		GenerateStreetsComp::Settings::Layout]], {
		innerSpacing = { 0, 15 }
	})
	
	a([[GenerateHeightmapComp::Settings, ImportHeightmapComp::Settings, ExportMapComp::Settings,
		GenerateTownsComp::Settings, GenerateIndustriesComp::Settings, GenerateStreetsComp::Settings]], {
		size = { 250, -1 }
	})

	a([[!input-controller GenerateTownsComp::Settings Slider:active,
	    !input-controller GenerateIndustriesComp::Settings Slider:active,
	    !input-controller GenerateHeightmapComp::Settings LabelValueItemGroup:hover,
		!input-controller GenerateTownsComp::Settings LabelValueItemGroup:hover,
		!input-controller GenerateIndustriesComp::Settings LabelValueItemGroup:hover]], {
		backgroundColor = ssu.makeColor(70, 150, 255, 70)
	})

	return result
end
