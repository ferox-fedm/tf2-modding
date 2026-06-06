local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"
local proposalutil = require "mission.proposalutil"
local stringutil = require "stringutil"

return function()

	local mainguihandlers = {
		checkTrackProposal = function(self, id, name, param)
			local fn = proposalutil.checkTrackBuildOrBulldozeInAreas({})
			return fn(id, name, param)
		end,
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
			taskutil:setProposal("trackproposal", "1", "checkTrackProposal")
			
			taskutil:setEnabled("menu.construction.rail.rail-buildings", false)
			taskutil:setEnabled("menu.construction.rail.track-constructions", false)
			self:setProgressNone()
		end,
		onFinish = function(self)
			--taskutil.tasks["m3"]:start()
			--taskutil.tasks["m2"]:start()
			--taskutil.tasks["m1"]:start()
			--taskutil.tasks["m4"]:start()
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_PREWAR_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_PREWAR_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_PREWAR_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	local function net()
		local time = game.interface.getGameTime().time
		return game.interface.getPlayerJournal((time - 60) * 1000, time * 1000)._sum -- 30 days
	end
	local function update1aprogress(self, net)
		self:setProgressText("${x}" % { x = string.makeMoneyString(math.floor(0.5 + (net / 1000)) * -1000) }, 1)
	end
	taskutil:new("1a", {
		onStart = function(self)
			taskutil.userstate.lastmeasurement = 0
			update1aprogress(self, net())
		end,
		onUpdate = function(self)
			local u = taskutil.userstate
			local time = game.interface.getGameTime()
			if time.date.day == 1 and time.date.month ~= u.lastmeasurement then
				u.lastmeasurement = time.date.month
				local net = net()
				update1aprogress(self, net)
				if net > -params.loss_1a then self:finish() end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_PREWAR_OPTIMIZE_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_PREWAR_OPTIMIZE_TEXT") },
					{ type = "TASK", text = _("MISSION_SWISSMADE_TASK_PREWAR_OPTIMIZE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_SWISSMADE_TASK_PREWAR_OPTIMIZE_SUB1") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_PREWAR_OPTIMIZE_TEXT.wav",
			}
		end,
	})

	taskutil:new("1b", {
		onStart = function(self)
			local count_passengers = 0
			for i = 1, #params.cities do
				local f = util.unloaded(params.cities[i], "PASSENGERS")
				count_passengers = count_passengers + f
			end
			taskutil.userstate.count_passengers_1b = count_passengers
		end,
		onUpdate = function(self)

			local count_passengers = -taskutil.userstate.count_passengers_1b
			local count_public = 0

			for i = 1, #params.cities do
				local f = util.unloaded(params.cities[i], "PASSENGERS")
				count_passengers = count_passengers + f
			end

			for i = 1, #params.cities do
				local c = game.interface.getTownReachability(params[params.cities[i]])[2]
				count_public = count_public + c
			end

			self:setSubtaskCompleted(1, count_passengers >= params.passengers_1b)
			self:setSubtaskCompleted(2, count_public >= params.public_transport_1b)

			self:setProgressCount(count_passengers, params.passengers_1b, 1)
			self:setProgressCount(count_public, params.public_transport_1b, 2)

			if count_passengers >= params.passengers_1b and count_public >= params.public_transport_1b then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_PREWAR_PASSENGERS_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_PREWAR_PASSENGERS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SWISSMADE_TASK_PREWAR_PASSENGERS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_SWISSMADE_TASK_PREWAR_PASSENGERS_SUB1") % params },
					{ name = _("MISSION_SWISSMADE_TASK_PREWAR_PASSENGERS_SUB2") % params },
				},
				parentId = "1",
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_PREWAR_PASSENGERS_TEXT.wav",
			}
		end,
	})
end
