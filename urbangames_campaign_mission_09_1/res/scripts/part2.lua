local taskutil = require "mission.taskutil"
local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local util = require "util"

return function()
	local function counttrucks()
		local vehicles = vehiclestore.currentvehicles
		local count = (vehicles["vehicle/truck/dmg_cannstatt_v2.mdl"] or 0)
		            + (vehicles["vehicle/truck/benz1912_lkw_universal_v2.mdl"] or 0)
		            + (vehicles["vehicle/truck/opel_blitz_1930_universal_v2.mdl"] or 0)
		return count
	end

	taskutil:new("2", {
		onStart = function(self)
				taskutil:setMusicTrack("track2")
				self:setProgressNone()
		end,
		onFinish = function(self)
			if counttrucks() > params.trucks_2a then
				taskutil.tasks["2a"]:start()
			else
				taskutil.tasks["2b"]:start()
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_MOBILE_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_MOBILE_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_MOBILE_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			taskutil.userstate.counttrucks2a = counttrucks()
		end,
		onUpdate = function(self)
			if taskutil.userstate.counttrucks2a - counttrucks() >= params.trucks_2a_sell then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_MOBILE_BORDER_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_MOBILE_BORDER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SWISSMADE_TASK_MOBILE_BORDER_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_MOBILE_BORDER_TEXT.wav",
			}
		end,
	})

	taskutil:new("2b", {
		onStart = function(self)
			for _,v in pairs({params.storage_north, params.storage_south}) do
				game.interface.upgradeConstruction(v, "industry/custom.con", {
					productionLevel = 0,
					stocks = {
						{ cargoType = "GRAIN", type = "RECEIVING", x = 0, y = 0, sizex = 1, sizey = 1 },
					},
					input = { { 1 } },
					output = { },
					capacity = 400,
				})
			end
		end,
		onUpdate = function(self)
			local coverage_ok = 0
			local supply = 0
			local demand = 0
			local coverage = 0

			for i = 1, #params.cities do
				local f = game.interface.getTownCargoSupplyAndLimit(params[params.cities[i]]).FOOD
				if f then
					supply = f[1]
					demand = f[2]
					coverage = supply / demand * 100
					if coverage >= params.coverage_2b then coverage_ok = coverage_ok + 1 end
				end
			end

			local consumed1 = game.interface.getEntity(game.interface.getEntity(params.storage_north).simBuildings[1]).itemsConsumed.GRAIN or 0
			local consumed2 = game.interface.getEntity(game.interface.getEntity(params.storage_south).simBuildings[1]).itemsConsumed.GRAIN or 0
			local consumed = consumed1 + consumed2

			self:setProgressCount(coverage_ok, params.coverage_towns_2b, 1)
			self:setProgressCount(consumed, params.grain_2b, 2)

			local done1 = coverage_ok >= params.coverage_towns_2b
			local done2 = consumed >= params.grain_2b
			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then
				self:finish()
			end

		end,
		onFinish = function(self)
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_MOBILE_RESERVES_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_MOBILE_RESERVES_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SWISSMADE_TASK_MOBILE_RESERVES_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_SWISSMADE_TASK_MOBILE_RESERVES_SUB1") % params },
					{ name = _("MISSION_SWISSMADE_TASK_MOBILE_RESERVES_SUB2") % params },
				},
				parentId = "2",
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_MOBILE_RESERVES_TEXT.wav",
			}
		end,
	})

end
