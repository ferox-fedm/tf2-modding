local guidesystem = require "guidesystem"
local taskutil = require "mission.taskutil"
local apputil = require "apputil"

local guides = {}

local function mayBeSpawnedNowFn(key, delay)
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
	contoursButton         = { stageName = "guides_contours",     delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildTracks            = { stageName = "guides_track",        delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildTrainDepot        = { stageName = "guides_depot_rail",   delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildTrainStationCargo = { stageName = "guides_railstation",  delay = { delayFromStart = guidesystem.timeUtil.sec(15), delayBetween = guidesystem.timeUtil.sec(10) } },
	createLine             = { stageName = "guides_lines",        delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
	unpause                = { stageName = "guides_gamespeed",    delay = { delayFromStart = guidesystem.timeUtil.sec(30), delayBetween = guidesystem.timeUtil.sec(10) } },
	openTownWindow         = { stageName = "guides_townwindow",   delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildSignals           = { stageName = "guides_signals",      delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
	bulldozer              = { stageName = "guides_bulldoze",     delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
	companyHeadQuarter     = { stageName = "guides_hq",           delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
}

local function setMayBeSpawnedNoFn(name)
	local v = reuselist[name]
	guidesystem.guides[name].mayBeSpawnedNowFn = function()
		if apputil.isCouchUiMode then
			local window = api.gui.util.getById("missionDisplayWindow")
			if window ~= nil and not window:isVisible() then
				if (guidesystem.savedData.time - guidesystem.savedData.timeLastMissionWindowVisibilityChange) > 2 then
					if mayBeSpawnedNowFn(v.stageName, v.delay) then
						return true
					end
				end
				return false
			end
			return false
		end
		
		return mayBeSpawnedNowFn(v.stageName, v.delay)
	end
end

function guides.restart(addfn, name)
	addfn()
	setMayBeSpawnedNoFn(name)
end

function guides.register()
	taskutil.userstate.guidesystemkeys = taskutil.userstate.guidesystemkeys or {}

	guidesystem.addGuideAddToLine()
	guidesystem.addGuiGuideLocateButton()
	guidesystem.addGuiGuideCockpitView()
	guidesystem.addGuiGuideCreateLine()
	guidesystem.addGuiGuideBuildSignals()
	guidesystem.addConFileGuideBuildBusDepot()
	guidesystem.addConFileGuideBuildTrainDepot()
	guidesystem.addConFileGuideBuildTrainStationCargo()

	guidesystem.guides.buildSignals.isCompletedFn = function()
		local t = taskutil.tasks["3b"]
		return t.start == nil and t.finish == nil
	end

	for k,v in pairs(guidesystem.guides) do
		if reuselist[k] == nil then guidesystem.guides[k] = nil end
	end

	for k,v in pairs(reuselist) do
		setMayBeSpawnedNoFn(k)
	end

	--ensure unpause can't be completed by cutscene:
	for k,v in pairs({unpause = 1}) do
		local oldfn = guidesystem.guides[k].isCompletedFn
		guidesystem.guides[k].isCompletedFn = function() return taskutil.userstate.guidesystemkeys["guides_gamespeed"] ~= nil and oldfn() end
	end
end

return guides
