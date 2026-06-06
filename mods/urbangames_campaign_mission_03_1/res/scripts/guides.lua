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
	landuseButton           = { stageName = "guides_landuse",      delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildHarbor             = { stageName = "guides_harbor",       delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildDock               = { stageName = "guides_dock",         delay = { delayFromStart = guidesystem.timeUtil.sec(20), delayBetween = guidesystem.timeUtil.sec(10) } },
	buildTrainStationPassenger  = { stageName = "guides_trainstation", delay = { delayFromStart = guidesystem.timeUtil.sec(25), delayBetween = guidesystem.timeUtil.sec(10) } },
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

	guidesystem.addConFileGuideBuildHarbor()
	guidesystem.addConFileGuideBuildDock()
	guidesystem.addConFileGuideBuildTrainStationPassenger()

	for k,v in pairs(guidesystem.guides) do
		if reuselist[k] == nil then guidesystem.guides[k] = nil end
	end

	for k,v in pairs(reuselist) do
		setMayBeSpawnedNoFn(k)
	end
end

return guides
