local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
	taskutil:new("5", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track5")
		end,
		onFinish = function(self)
			if taskutil.userstate.choice4a == 1 then
				taskutil.tasks["4d"]:start()
			else
				taskutil.tasks["4b"]:start()
			end
		end,
		getInfo = function(self)
			local name = _("MISSION_OILSANDS_TASK_ALTERNATIVEB_NAME")
			local text = _("MISSION_OILSANDS_TASK_ALTERNATIVEB_TEXT")
			local vo = "MISSION_OILSANDS_TASK_ALTERNATIVEB_TEXT.wav"
			if taskutil.userstate.choice4a == 2 then
				name = _("MISSION_OILSANDS_TASK_ALTERNATIVEA_NAME")
				text = _("MISSION_OILSANDS_TASK_ALTERNATIVEA_TEXT")
				vo = "MISSION_OILSANDS_TASK_ALTERNATIVEA_TEXT.wav"
			end
			return {
				name = name,
				paragraphs = {
					{ text = text % params },
				},
				camera = params.jump_oilsands,
				voiceOver = vo,
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
			local tu = taskutil.userstate
			game.interface.upgradeConstruction(params.sedimentationtank3, "industry/sedimentationtank.con", { mode3 = true })
			tu.conmatdecay5a = 0
			taskutil:invokeLater(self.name, "showm3", 120)
		end,
		onUpdate = function(self)
			local e = game.interface.getEntity(game.interface.getEntity(params.sedimentationtank3).simBuildings[1])
			local count = e.itemsConsumed.CONSTRUCTION_MATERIALS or 0
			local decay = taskutil.userstate.conmatdecay5a
			if count - decay > 0.5 then
				taskutil.userstate.conmatdecay5a = decay + 0.01
			elseif count > 0.5 * params.conmat_amount_catastrophe and taskutil.tasks["5b"].start then
				taskutil.tasks["5b"]:start()
			end
			count = count - decay
			local done = count >= params.conmat_amount_catastrophe
			self:setProgressCount(count, params.conmat_amount_catastrophe, 1)
			if done or count >= params.conmat_amount_catastrophe_max then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_ALTERNATIVE_CATASTROPHE_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_ALTERNATIVE_CATASTROPHE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_ALTERNATIVE_CATASTROPHE_TASK") % params },
					{ type = "HINT", text = _("MISSION_OILSANDS_TASK_ALTERNATIVE_CATASTROPHE_HINT") % params },
				},
				subTasks = {
					{ name = _("MISSION_OILSANDS_TASK_ALTERNATIVE_CATASTROPHE_SUB1") % params },
					--{ name = _("MISSION_OILSANDS_TASK_ALTERNATIVE_CATASTROPHE_SUB2") % params },
					--{ name = _("MISSION_OILSANDS_TASK_ALTERNATIVE_CATASTROPHE_SUB3") % params },
				},
				camera = params.jump_oilsands,
				voiceOver = "MISSION_OILSANDS_TASK_ALTERNATIVE_CATASTROPHE_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				optionsRightAlign = true,
				parentId = "5",
			}
		end,
		handlers = {
			showm3 = function(self)
				if taskutil.tasks["m3"].start ~= nil then
					taskutil.tasks["m3"]:start()
				end
			end,
		},
	})

	taskutil:new("5b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_ALTERNATIVE_CATASTROPHE_LEAK_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_ALTERNATIVE_CATASTROPHE_LEAK_TEXT") % params },
				},
				camera = params.jump_oilsands,
				voiceOver = "MISSION_OILSANDS_TASK_ALTERNATIVE_CATASTROPHE_LEAK_TEXT.wav",
				options = { { _("Ok"), "finish" } },
				optionsRightAlign = true,
				parentId = "5",
			}
		end,
	})

	taskutil:new("end", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setCompleted()
			taskutil:invokeLater(self.name, "finish", 0.6)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_FINISH_TEXT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				voiceOver = "MISSION_OILSANDS_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
