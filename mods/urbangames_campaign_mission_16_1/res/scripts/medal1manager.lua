local taskutil = require "mission.taskutil"
local params = require "params"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local util = require "util"

return function()
	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_1")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_MANAGER_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_MEDAL_MANAGER_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_MEDAL_MANAGER_TEXT.wav",
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m1a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m1a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local trains = game.interface.getVehicles({ carrier = "RAIL" })
			local singles = 0
			for i = 1, #trains do
				local v = game.interface.getEntity(trains[i])
				local veh = v.vehicles
				local count = 0
				for j = 1, #veh do
					if veh[j].fileName == params.icetrain then
						count = count + 1
					end
				end
				if count == 2 then singles = singles + 1 end
			end
			self:setProgressText(tostring(singles))
			if singles == 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_MANAGER_DRIVERS_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_MEDAL_MANAGER_DRIVERS_TEXT") },
					{ type = "TASK", text = _("MISSION_ICE_MEDAL_MANAGER_DRIVERS_TASK") % params  },
					{ type = "HINT", text = _("MISSION_ICE_MEDAL_MANAGER_DRIVERS_HINT") % params  },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_MEDAL_MANAGER_DRIVERS_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["m1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_MANAGER_MANAGER1_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_MEDAL_MANAGER_MANAGER1_TEXT") },
					{ type = "TASK", text = _("MISSION_ICE_MEDAL_MANAGER_MANAGER1_TASK") % params  },
				},
				options = { { _("MISSION_ICE_MEDAL_MANAGER_MANAGER1_OPTION"), "pay" } },
				optionsRightAlign = true,
				parentId = "m1",
			}
		end,
		handlers = {
			pay = function(self)
				if game.interface.getEntity(game.interface.getPlayer()).balance >= params.blumerbonus then
					game.interface.book(-params.blumerbonus)
					taskutil:finish(self.name)
				end
			end,
		},
		guiHandlers = {
			pay = function(self)
				taskutil:sendScriptFn(self.name, "pay")
			end,
		}
	})

	local function countmodules(module)
		local count = 0
		for i = 1, #params.call do
			local town = params.call[i]
			local stations = game.interface.getStations({ town = town, carrier = "RAIL" })
			for j = 1, #stations do
				local con = util.station2construction(stations[j])
				local m = con.params.modules
				for _, v in pairs(m) do
					if v.name == module then
						count = count + 1
					end
				end
			end
		end

		return count
	end

	taskutil:new("m1c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local roofcount = countmodules("station/rail/modular_station/platform_passenger_roof_era_c.module")
			local sidebuildingscount = countmodules("station/rail/modular_station/side_building_1_era_c.module")

			self:setProgressText(tostring(roofcount - params.roofcount), 1)
			self:setProgressText(tostring(sidebuildingscount - params.sidebuildingscount), 2)

			local done1 = roofcount <= params.roofcount
			local done2 = sidebuildingscount <= params.sidebuildingscount

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m1d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_MANAGER_INFRASTRUCTURE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_MEDAL_MANAGER_INFRASTRUCTURE_TEXT") },
					{ type = "TASK", text = _("MISSION_ICE_MEDAL_MANAGER_INFRASTRUCTURE_TASK") % params  },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_MEDAL_MANAGER_INFRASTRUCTURE_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_ICE_MEDAL_MANAGER_INFRASTRUCTURE_SUB1") % params },
					{ name = _("MISSION_ICE_MEDAL_MANAGER_INFRASTRUCTURE_SUB2") % params },
				},
				parentId = "m1",
			}
		end,
	})

	taskutil:new("m1d", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["m1e"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_MANAGER_MANAGER2_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_MEDAL_MANAGER_MANAGER2_TEXT") },
					{ type = "TASK", text = _("MISSION_ICE_MEDAL_MANAGER_MANAGER2_TASK") % params  },
				},
				voiceOver = "MISSION_ICE_MEDAL_MANAGER_MANAGER2_TEXT.wav",
				options = { { _("MISSION_ICE_MEDAL_MANAGER_MANAGER2_OPTION"), "pay" } },
				optionsRightAlign = true,
				parentId = "m1",
			}
		end,
		handlers = {
			pay = function(self)
				if game.interface.getEntity(game.interface.getPlayer()).balance >= params.blumerbonus then
					game.interface.book(-params.blumerbonus)
					taskutil:finish(self.name)
				end
			end,
		},
		guiHandlers = {
			pay = function(self)
				taskutil:sendScriptFn(self.name, "pay")
			end,
		}
	})

	local function getairlines(town)
		local lines = {}
		local stations = game.interface.getStations({ town = town, carrier = "AIR" })
		for j = 1, #stations do
			local stationGroup = game.interface.getEntity(stations[j]).stationGroup
			local newlines = game.interface.getLines({ stationGroup = stationGroup })
			for k = 1, #newlines do
				lines[newlines[k]] = 1
			end
		end
		return lines
	end

	taskutil:new("m1e", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local lines1 = getairlines(params.stuttgart)
			local lines2 = getairlines(params.frankfurt)

			local goodlines = {}
			local found = false
			for k, _ in pairs(lines1) do
				if lines2[k] then
					goodlines[k] = 1
				end
			end

			local vehicles = game.interface.getVehicles({ carrier = "AIR" })
			for i = 1, #vehicles do
				local v = game.interface.getEntity(vehicles[i])
				if goodlines[v.line] then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m1f"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_MANAGER_AIRLINE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_MEDAL_MANAGER_AIRLINE_TEXT") },
					{ type = "TASK", text = _("MISSION_ICE_MEDAL_MANAGER_AIRLINE_TASK") % params  },
				},
				camera = params.jump_planelocator,
				voiceOver = "MISSION_ICE_MEDAL_MANAGER_AIRLINE_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
			}
		end,
	})

	taskutil:new("m1f", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:startLater("m1g")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_MANAGER_MANAGER3_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_MEDAL_MANAGER_MANAGER3_TEXT") },
					{ type = "TASK", text = _("MISSION_ICE_MEDAL_MANAGER_MANAGER3_TASK") % params },
				},
				options = { { _("MISSION_ICE_MEDAL_MANAGER_MANAGER3_OPTION"), "pay" } },
				optionsRightAlign = true,
				parentId = "m1",
			}
		end,
		handlers = {
			pay = function(self)
				if game.interface.getEntity(game.interface.getPlayer()).balance >= params.blumerbonus then
					game.interface.book(-params.blumerbonus)
					taskutil:finish(self.name)
				end
			end,
		},
		guiHandlers = {
			pay = function(self)
				taskutil:sendScriptFn(self.name, "pay")
			end,
		}
	})

	taskutil:new("m1g", {
		onStart = function(self)
			taskutil:setMedalCompleted("MEDAL_1")
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_MANAGER_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_ICE_MEDAL_MANAGER_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_ICE_MEDAL_MANAGER_FINISH_TEXT.wav",
			}
		end,
	})
end
