local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"

return function()
	taskutil:new("3", {
		onStart = function(self)
			taskutil:setMusicTrack("track3")
			self:setProgressNone()
			taskutil:invokeLater(self.name, "showm2", 120)
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_FUEL_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_FUEL_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_FUEL_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
		handlers = {
			showm2 = function(self)
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
				end
			end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm2", 120)
		end,
		onUpdate = function(self)
			local count = 0
			local count_public = 0
			local count_private = 0

			for _, city in pairs({"palma", "sarenal", "inca"}) do
				local f = (game.interface.getTownCargoSupplyAndLimit(params[city]).FUEL or {0})[1]
				count = count + f

				local pub = game.interface.getTownReachability(params[city])[2]
				count_public = count_public + pub

				local priv = game.interface.getTownReachability(params[city])[1]
				count_private = count_private + priv

			end
			self:setProgressCount(count, params.fuel_amount, 1)
			self:setSubtaskCompleted(1, count > params.fuel_amount)

			self:setProgressCount(count_public, params.public_cover_3, 2)
			self:setSubtaskCompleted(2, count_public >= params.public_cover_3)

			self:setProgressCount(count_private, params.private_cover_3, 3)
			self:setSubtaskCompleted(3, count_private >= params.private_cover_3)

			if count >= params.fuel_amount and count_public >= params.public_cover_3 and count_private >= params.private_cover_3 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_FUEL_DELIVER_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_FUEL_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_FUEL_DELIVER_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_FUEL_DELIVER_SUB1") % params },
					{ name = _("MISSION_ALLINCLUSIVE_TASK_FUEL_DELIVER_SUB2") % params },
					{ name = _("MISSION_ALLINCLUSIVE_TASK_FUEL_DELIVER_SUB3") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_FUEL_DELIVER_TEXT.wav",
			}
		end,
		handlers = {
			showm2 = function(self) 
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
				end
			end,
		},
	})

end
