local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"

return function()
	taskutil:new("4", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track4")
		end,
		onFinish = function(self)
			taskutil.tasks["4a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_TASK_FUEL_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_FUEL_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_fuelfactory,
				voiceOver = "MISSION_TWENTIES_TASK_FUEL_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local consumed = game.interface.getEntity(game.interface.getEntity(params.fuelfactory).simBuildings[1]).itemsConsumed.OIL or 0
			if consumed > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["4b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_TASK_FUEL_PRODUCE_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_FUEL_PRODUCE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TWENTIES_TASK_FUEL_PRODUCE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_fuelfactory,
				voiceOver = "MISSION_TWENTIES_TASK_FUEL_PRODUCE_TEXT.wav",
			}
		end,
	})

	taskutil:new("4b", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal4", 120)
		end,
		onUpdate = function(self)
			local consumed_total = 0
			for i = 1, 6 do
				local consumed = game.interface.getEntity(game.interface.getEntity(params["gasstation" .. i]).simBuildings[1]).itemsConsumed.FUEL or 0
				consumed_total = consumed_total + consumed
			end
			self:setProgressCount(consumed_total, params.goal_fuel, 1)
			if consumed_total >= params.goal_fuel then self:finish() end
		end,
		onFinish = function(self)
			if taskutil.tasks["5"].start ~= nil then
				taskutil:startLater("5")
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_TASK_FUEL_DELIVER_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_FUEL_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TWENTIES_TASK_FUEL_DELIVER_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_TWENTIES_TASK_FUEL_DELIVER_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = {-600, -800, 1500},
				voiceOver = "MISSION_TWENTIES_TASK_FUEL_DELIVER_TEXT.wav",
			}
		end,
		handlers = {
			showmedal4 = function(self) taskutil:start("m4") end,
		},
	})
end
