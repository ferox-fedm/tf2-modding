local taskutil = require "mission.taskutil"
local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local util = require "util"

return function()

	local mainguihandlers = {
		voiceOverEnded = function(self) taskutil:finish(self.name) end,
	}

	setmetatable(mainguihandlers, { __index = function(self, key)
		local n = #"jump_"
		if key:sub(1, n) == "jump_" then
			game.gui.setAutoCamera(params[key])
		end
	end})

	taskutil:new("1", {
		onStart = function(self)
			self:setProgressNone()
			vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", 1)
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_FIRSTTRY_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_FIRSTTRY_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_workshop_player,
				voiceOver = "MISSION_MACHINES_TASK_FIRSTTRY_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local consumed = game.interface.getEntity(game.interface.getEntity(params.machines_factory).simBuildings[1]).itemsConsumed.STEEL or 0
			self:setProgressCount(consumed, params.machines_1a)
			if consumed >= params.machines_1a then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_FIRSTTRY_PRODUCE_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_FIRSTTRY_PRODUCE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_FIRSTTRY_PRODUCE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_machines_factory,
				parentId = "1",
				voiceOver = "MISSION_MACHINES_TASK_FIRSTTRY_PRODUCE_TEXT.wav",
			}
		end,
	})

	taskutil:new("1b", {
		onStart = function(self)
			taskutil.userstate.planedata = {}
			vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", 2)
			util.activateAirfield(params.airfield_paris)
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getVehicles({ carrier = "AIR" })
			local data = taskutil.userstate.planedata
			local stopid = game.interface.getEntity(game.interface.getEntity(params.airfield_paris).stations[1]).stationGroup

			local done1 = false
			local done2 = false
			for i = 1, #vehicles do
				local e = game.interface.getEntity(vehicles[i])
				if e.line >= 0 then
					local l = game.interface.getEntity(e.line)
					local lineok = #l.stops > 0
					for j = 1, #l.stops do
						if l.stops[j] ~= stopid then
							lineok = false
							break
						end
					end
					if lineok then
						done1 = true
						local z = game.interface.getHeight({e.position[1], e.position[2]})
						done2 = e.position[3] - z > 35
						if done2 then break end
					end
				end
			end
			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)
			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			vehiclestore.setAllowedVehicleCount("vehicle/plane/bleriot_xi.mdl", 1)
			taskutil.tasks["1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_FIRSTTRY_FLIGHT_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_FIRSTTRY_FLIGHT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_FIRSTTRY_FLIGHT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_airfield_paris,
				subTasks = {
					{ name = _("MISSION_MACHINES_TASK_FIRSTTRY_FLIGHT_SUB1") },
					{ name = _("MISSION_MACHINES_TASK_FIRSTTRY_FLIGHT_SUB2") },
				},
				parentId = "1",
				voiceOver = "MISSION_MACHINES_TASK_FIRSTTRY_FLIGHT_TEXT.wav",
			}
		end,
	})

	taskutil:new("1c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			if vehiclestore.currentvehicles["vehicle/plane/bleriot_xi.mdl"] == 1 then
				self:finish()
			end
		end,
		onFinish = function(self)
			util.deactivateAirfield(params.airfield_paris)
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_TASK_FIRSTTRY_RETURN_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_TASK_FIRSTTRY_RETURN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_MACHINES_TASK_FIRSTTRY_RETURN_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				camera = params.jump_airfield_paris,
				parentId = "1",
				voiceOver = "MISSION_MACHINES_TASK_FIRSTTRY_RETURN_TEXT.wav",
			}
		end,
	})
end
