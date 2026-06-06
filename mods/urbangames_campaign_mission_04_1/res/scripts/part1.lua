local params = require "params"
local vehiclestore = require "mission.vehiclestore"

return function(taskutil)
	local tasks = taskutil.tasks

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
			vehiclestore.setAllowedVehicleCount("vehicle/tram/usa/san_diego_v2.mdl", 0)
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_CITY_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_CITY_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_topolobampo,
				voiceOver = "MISSION_PARADISO_TASK_CITY_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local stations = game.interface.getEntities({pos = game.interface.getEntity(params.topolobampo).position, radius = 400}, {type = "STATION"})
			local logs = 0
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded
				logs = logs + (s.LOGS or 0)
			end

			self:setProgressCount(logs, params.city_material_logs)

			if logs >= params.city_material_logs then
				self:finish()
			end
		end,
		onFinish = function(self)
			--local t = { "2", "2a", "2b", "2c" }
			--for i = 1, #t do
			--	if taskutil.tasks[t[i]].start ~= nil then taskutil.tasks[t[i]]:start() end
			--end
			taskutil.tasks["2"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_CITY_MATERIAL_NAME") % params,
				paragraphs = {
					{  text = _("MISSION_PARADISO_TASK_CITY_MATERIAL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_CITY_MATERIAL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_forest,
				voiceOver = "MISSION_PARADISO_TASK_CITY_MATERIAL_TEXT.wav",
			}
		end,
	})

end
