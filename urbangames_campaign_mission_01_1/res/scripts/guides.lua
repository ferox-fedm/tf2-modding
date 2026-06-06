local guidesystem = require "guidesystem"
local taskutil = require "mission.taskutil"
local apputil = require "apputil"

local guides = {}

local function mayBeSpawnedNowFn(key, delay)
	guidesystem.setOverrideAutoCloseDelay(apputil.isCouchUiMode() and 60 * 5 or 60) -- always set timer workaround

	local timeSinceStageStart = taskutil.userstate.guidesystemkeys[key]
	if timeSinceStageStart == nil then return false end
	if delay == nil then
		return guidesystem.delayOver()
	else
		return guidesystem.delayOver({
			delayFromStart = delay.delayFromStart + timeSinceStageStart,
			delayBetween = delay.delayBetween,
		})
	end
end

local reuselist = {
	closeMissionWindow	   = { stageName = "guides_closeMissionWindow", delay = { delayFromStart = guidesystem.timeUtil.sec(30), delayBetween = guidesystem.timeUtil.sec(10) }, couchOnly = true },
	mousePan               = { stageName = "guides_camera",          delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	mouseWheel             = { stageName = "guides_camera",          delay = { delayFromStart = guidesystem.timeUtil.sec(25), delayBetween = guidesystem.timeUtil.sec(10) } },
	mouseRotate            = { stageName = "guides_camera",          delay = { delayFromStart = guidesystem.timeUtil.sec(35), delayBetween = guidesystem.timeUtil.sec(10) } },
	locateButton           = { stageName = "guides_locatebutton",    delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) }, classicOnly = true },
	inspectorButton        = { stageName = "guides_inspectorbutton", delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) }, couchOnly = true },
	buildBusStationCargo   = { stageName = "guides_busstation",      delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	createLine             = { stageName = "guides_lines",           delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildBusDepot          = { stageName = "guides_depot",           delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
	addToLine              = { stageName = "guides_lines2",          delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	unpause                = { stageName = "guides_gamespeed",       delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	gameSpeed              = { stageName = "guides_gamespeed",       delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildTrainStationCargo = { stageName = "guides_railstation",     delay = { delayFromStart = guidesystem.timeUtil.sec(30), delayBetween = guidesystem.timeUtil.sec(10) } },
	rotateConstructions    = { stageName = "guides_railstation",     delay = { delayFromStart = guidesystem.timeUtil.sec(40), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildTracks            = { stageName = "guides_track",           delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildTrainDepot        = { stageName = "guides_depot_rail",      delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
	landuseButton          = { stageName = "guides_landuse",         delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildBusStop           = { stageName = "guides_busstop",         delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	cockpitView            = { stageName = "guides_cockpit",         delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildStreets           = { stageName = "guides_street",          delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	keyScroll              = { stageName = "guides_camera",          delay = { delayFromStart = guidesystem.timeUtil.sec(25), delayBetween = guidesystem.timeUtil.sec(10) } },
}

local function setMayBeSpawnedNowFn(name)
	local v = reuselist[name]
	local exceptionList = {"mousePan", "mouseWheel", "mouseRotate", "keyScroll", "gameSpeed"}
	guidesystem.guides[name].mayBeSpawnedNowFn = function()

		local window = api.gui.util.getById("missionDisplayWindow")
		if (v.classicOnly or not apputil.isCouchUiMode()) and not v.couchOnly then
			return mayBeSpawnedNowFn(v.stageName, v.delay) and not apputil.isCouchUiMode()
		elseif apputil.isCouchUiMode() then
			if name == "keyScroll" and apputil.isGamepadInputMode() then
				return false
			end
			if name == "closeMissionWindow" then
				if not apputil.isGamepadInputMode() then
					return false
				end
				return mayBeSpawnedNowFn(v.stageName, v.delay)
			end
			if window ~= nil and not window:isVisible() then
				if (guidesystem.savedData.time - guidesystem.savedData.timeLastMissionWindowVisibilityChange) > 2 then
					if mayBeSpawnedNowFn(v.stageName, v.delay) then
						return true
					end
				end
			end

			for i, exc in ipairs(exceptionList) do
				if exc == name then
					return mayBeSpawnedNowFn(v.stageName, v.delay)
				end
			end
		else
			return false;
		end
	end
end

function guides.restart(addfn, name)
	addfn()
	setMayBeSpawnedNowFn(name)
end

function guides.register()
	taskutil.userstate.guidesystemkeys = taskutil.userstate.guidesystemkeys or {}

	guidesystem.addGuiGuideMissionWindowClose()
	guidesystem.addGuideAddToLine()
	guidesystem.addGuiGuideLocateButton()
	guidesystem.addGuiGuideCockpitView()
	guidesystem.addGuiGuideCreateLine()
	guidesystem.addGuiGuideBuildSignals()
	guidesystem.addConFileGuideBuildBusStationCargo()
	guidesystem.addConFileGuideBuildBusDepot()
	guidesystem.addConFileGuideBuildTrainStationCargo()
	guidesystem.addConFileGuideBuildTrainDepot()
	
	guidesystem.addGuiGuideInspector()

	guidesystem.guides.addToLine.isCompletedFn = function()
		local t = taskutil.tasks["2e"]
		return t.start == nil and t.finish == nil
	end

	for k,v in pairs(guidesystem.guides) do
		if reuselist[k] == nil then guidesystem.guides[k] = nil end
	end

	for k,v in pairs(reuselist) do
		setMayBeSpawnedNowFn(k)
	end

	--ensure gameSpeed & unpause can't be completed by cutscene:
	for k,v in pairs({unpause = 1, gameSpeed =1}) do
		local oldfn = guidesystem.guides[k].isCompletedFn
		guidesystem.guides[k].isCompletedFn = function() return taskutil.userstate.guidesystemkeys["guides_gamespeed"] ~= nil and oldfn() end
	end
end

return guides
