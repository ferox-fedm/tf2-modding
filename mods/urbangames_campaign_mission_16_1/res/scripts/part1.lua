local taskutil = require "mission.taskutil"
local vehiclestore = require "mission.vehiclestore"
local params = require "params"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

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
			--taskutil.tasks["m1"]:start()
			--taskutil.tasks["m2"]:start()
			--taskutil.tasks["m3"]:start()
			self:setProgressNone()
			vehiclestore.setAllowedVehicleCount(params.testice, 0)
			vehiclestore.setAllowedVehicleCount(params.regularice, 0)
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_TASK_REGIONAL_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_REGIONAL_TEXT") % params }
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_REGIONAL_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local count = 0
			for i = 1, #params.call do
				local c = game.interface.getTownReachability(params.call[i])[2]
				count = count + c
			end

			self:setProgressCount(count, params.public_transport, 1)

			if count >= params.public_transport then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_TASK_REGIONAL_OPERATION_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_REGIONAL_OPERATION_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ICE_TASK_REGIONAL_OPERATION_TASK") % params },
					{ type = "HINT", text = _("MISSION_ICE_TASK_REGIONAL_OPERATION_HINT") % params },
				},
				subTasks = {
					{ name = _("MISSION_ICE_TASK_REGIONAL_OPERATION_SUB1") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_REGIONAL_OPERATION_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
			}
		end,
	})

	taskutil:new("1b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local capacity = 0
			local lines = {}

			local trains = game.interface.getVehicles({ carrier = "RAIL" })
			for i = 1, #trains do
				local v = game.interface.getEntity(trains[i])
				capacity = capacity + (v.allCapacities.PASSENGERS or 0)
				if v.line >= 0 then
					lines[v.line] = 1
				end
			end

			local rate = 0
			local n = 0
			for k,_ in pairs(lines) do
				local v = game.interface.getEntity(k)
				if v.frequency > 0 then
					n = n + 1
					rate = rate + 1 / v.frequency
				end
			end
			if n > 0 then rate = rate / n end

			self:setProgressCount(capacity, params.capacity, 1)
			self:setProgressCount(rate, params.rate, 2)

			local done1 = capacity >= params.capacity
			local done2 = n > 0 and rate <= params.rate

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_TASK_REGIONAL_SERVICE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_REGIONAL_SERVICE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ICE_TASK_REGIONAL_SERVICE_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_REGIONAL_SERVICE_TEXT.wav",
				subTasks = {
					{ name = _("MISSION_ICE_TASK_REGIONAL_SERVICE_SUB1") % params },
					{ name = _("MISSION_ICE_TASK_REGIONAL_SERVICE_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
			}
		end,
	})
end
