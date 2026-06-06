local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local util = require "util"

return function()
	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_3")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_STUTTGART_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_MEDAL_STUTTGART_TEXT") % params },
				},
				camera = params.jump_stuttgart,
				voiceOver = "MISSION_ICE_MEDAL_STUTTGART_TEXT.wav",
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m3a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	local function hasHeadMainBuilding(modules)
		for x, _ in pairs(modules) do
			local mainBuildingOffset = 3400000
			local rest = math.floor((x - mainBuildingOffset) / 100000)
			if rest == 3 or rest == 4 then return true end
		end
		return false
	end


	local function hasSideMainBuilding(modules)
		for x, _ in pairs(modules) do
			local mainBuildingOffset = 3400000
			local rest = math.floor((x - mainBuildingOffset) / 100000)
			if rest < 2 then return true end
		end
		return false
	end

	taskutil:new("m3a", {
		onStart = function(self)
			taskutil:setZone("m3atrees",  { polygon = zoneutil.makeCircleZone(params.treezone.pos, params.treezone.radius), draw = true, drawColor = colors.GREEN })
			taskutil:setZone("m3ahouse",  { polygon = zoneutil.makeCircleZone(params.housezone.pos, params.housezone.radius), draw = true, drawColor = colors.YELLOW })
			taskutil:setZone("m3awater",  { polygon = zoneutil.makeCircleZone(params.waterzone.pos, params.waterzone.radius), draw = true, drawColor = colors.BLUE })
			taskutil:setZone("m3atunnel", { polygon = zoneutil.makeCircleZone(params.tunnelzone.pos, params.tunnelzone.radius), draw = true, drawColor = colors.RED })
			game.interface.setBulldozeable(params.station_stuttgart, true)
		end,
		onUpdate = function(self)
			local done1 = false
			local count = 0
			local stations = game.interface.getStations({ town = params.stuttgart, carrier = "RAIL" })
			for j = 1, #stations do
				local con = util.station2construction(stations[j])
				local m = con.params.modules
				if not hasHeadMainBuilding(m) and hasSideMainBuilding(m) then done1 = true end
			end

			local done2 = false
			local tunneltracks = game.interface.getEntities(params.tunnelzone, { type = "BASE_EDGE" })
			for i = 1, #tunneltracks do
				local t = game.interface.getEntity(tunneltracks[i])
				local pos0 = t.node0pos
				local pos1 = t.node1pos
				local z0 = game.interface.getHeight(pos0)
				local z1 = game.interface.getHeight(pos1)
				if t.track and (z0 - pos0[3] > 5 or z1 - pos1[3] > 5)then
					done2 = true
				end
			end

			local done3 = true
			local trees = game.interface.getEntities({ pos = params.treezone.pos, radius = 0.5 * params.treezone.radius }, {type = "ASSET_GROUP"})
			for i = 1, #trees do
				local e = game.interface.getEntity(trees[i])
				local mdls = e.models
				for k,v in pairs(mdls) do
					if k:sub(1, 4) == "tree" then
						done3 = false
					end
				end
			end

			local houses = game.interface.getEntities({ pos = params.housezone.pos, radius = 0.5 * params.housezone.radius }, { type = "TOWN_BUILDING" })
			local done4 = #houses == 0

			local done5 = false
			local watertracks = game.interface.getEntities(params.waterzone, { type = "BASE_EDGE" })
			for i = 1, #watertracks do
				local t = game.interface.getEntity(watertracks[i])
				if t.track then done5 = true end
			end

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)
			self:setSubtaskCompleted(3, done3)
			self:setSubtaskCompleted(4, done4)
			self:setSubtaskCompleted(5, done5)

			if done1 and done2 and done3 and done4 and done5 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("m3atrees")
			taskutil:setZone("m3ahouse")
			taskutil:setZone("m3awater")
			taskutil:setZone("m3atunnel")
			taskutil:setMedalCompleted("MEDAL_3")
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_STUTTGART_BUILD_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_MEDAL_STUTTGART_BUILD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ICE_MEDAL_STUTTGART_BUILD_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ICE_MEDAL_STUTTGART_BUILD_SUB1") % params },
					{ name = _("MISSION_ICE_MEDAL_STUTTGART_BUILD_SUB2") % params },
					{ name = _("MISSION_ICE_MEDAL_STUTTGART_BUILD_SUB3") % params },
					{ name = _("MISSION_ICE_MEDAL_STUTTGART_BUILD_SUB4") % params },
					{ name = _("MISSION_ICE_MEDAL_STUTTGART_BUILD_SUB5") % params },
				},
				camera = params.jump_stuttgart,
				voiceOver = "MISSION_ICE_MEDAL_STUTTGART_BUILD_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
			}
		end,
	})

	taskutil:new("m3b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_STUTTGART_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_ICE_MEDAL_STUTTGART_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_ICE_MEDAL_STUTTGART_FINISH_TEXT.wav",
			}
		end,
	})
end
