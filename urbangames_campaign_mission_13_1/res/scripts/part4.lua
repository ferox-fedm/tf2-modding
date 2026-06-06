local taskutil = require "mission.taskutil"
local params = require "params"

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
				name = _("MISSION_SHINKANSEN_TASK_OPERATE_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_OPERATE_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_OPERATE_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4a", {
		onStart = function(self)
			taskutil.userstate.averagewaiting = params.standtime
			taskutil.userstate.lastgametime = game.interface.getGameTime().time
			taskutil:invokeLater(self.name, "showm5", 120)
		end,
		onUpdate = function(self)
			taskutil.userstate.completed4a = false

			local function getdecimal(number)
				return number - math.floor(number)
			end

			local d1 = getdecimal(game.interface.getGameTime().time)
			local d2 = getdecimal(taskutil.userstate.lastgametime)
			taskutil.userstate.lastgametime = game.interface.getGameTime().time
			if d1 >= d2 then
				return
			end
			local trains = game.interface.getVehicles({ carrier = "RAIL" })
			local n = 0
			local speed = 0
			local numwaiting = 0
			local capacity = 0
			for i = 1, #trains do
				local e = game.interface.getEntity(trains[i])
				local isshinkansen = e.vehicles[1].fileName == "vehicle/train/asia/shinkansen_0s_front_v2.mdl"
				if isshinkansen then
					n = n + 1
					capacity = capacity + (e.allCapacities.PASSENGERS or 0)
					speed = speed + e.speed
					if e.speed == 0 then
						numwaiting = numwaiting + 1
					end
				end
			end
			if n > 0 then
				speed = 3.6 * speed / n
			end

			taskutil.userstate.averagewaiting = (99 * taskutil.userstate.averagewaiting + numwaiting / math.max(n, 1)) / 100

			local goalcap = params.goalcap
			self:setProgressCount(capacity, goalcap, 1)
			self:setSubtaskCompleted(1, capacity >= goalcap)

			self:setProgressPercent(taskutil.userstate.averagewaiting, 2)
			self:setSubtaskCompleted(2, taskutil.userstate.averagewaiting <= params.standtime)

			local goalspeed = params.goalspeed
			self:setProgressCount(speed, goalspeed, 3)
			self:setSubtaskCompleted(3, speed >= goalspeed )

			taskutil.userstate.completed4a = capacity >= goalcap and taskutil.userstate.averagewaiting <= params.standtime and speed >= goalspeed
			if taskutil.userstate.completed4a then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.userstate.completed4a = true
			taskutil.userstate.averagewaiting = nil
			taskutil.userstate.lastgametime = nil

			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_OPERATE_TRACKS_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_OPERATE_TRACKS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_OPERATE_TRACKS_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_SHINKANSEN_TASK_OPERATE_TRACKS_SUB1") },
					{ name = _("MISSION_SHINKANSEN_TASK_OPERATE_TRACKS_SUB2") % { x = params.standtime_formated } },
					{ name = _("MISSION_SHINKANSEN_TASK_OPERATE_TRACKS_SUB3") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_OPERATE_TRACKS_TEXT.wav",
			}
		end,
		handlers = {
			showm5 = function(self)
				if taskutil.tasks["m5"].start ~= nil then
					taskutil.tasks["m5"]:start()
				end
			end,
		},
	})

	taskutil:new("4b", {
		onStart = function(self)
			taskutil:setMarker("4ba", { entity = params.shiga, type = "question" }, self.name, "4ba")
			taskutil:setMarker("4bb", { entity = params.hamamatsu, type = "question" }, self.name, "4bb")
			taskutil:setMarker("4bc", { entity = params.mishima,    type = "question" }, self.name, "4bc")
		end,
		onUpdate = function(self)
			local function completed(name)
				return taskutil.tasks[name].start == nil and taskutil.tasks[name].finish == nil
			end
			
			local done = 0
			if completed("4ba") then done = done + 1 end
			if completed("4bb") then done = done + 2 end
			if completed("4bc") then done = done + 3 end
			self:setProgressCount(done,3)

			if completed("4ba") and completed("4bb") and completed("4bc") then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISE_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_OPERATE_NOISE_TEXT.wav",
			}
		end,
		handlers = {
			["4ba"] = function(self)
				taskutil:start("4ba")
				taskutil:setMarker("4ba")
			end,
			["4bb"] = function(self)
				taskutil:start("4bb")
				taskutil:setMarker("4bb")
			end,
			["4bc"] = function(self)
				taskutil:start("4bc")
				taskutil:setMarker("4bc")
			end,
		},
	})

	taskutil:new("4ba", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local emission = (10 * math.log(game.interface.getTownEmission(params.shiga) / math.pow(10,-12), 10))
			self:setProgressCount(emission, params.max_emission_shiga)
			if emission <= params.max_emission_shiga then self:finish() end
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEA_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEA_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEA_TASK") % params },
				},
				options = { { _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEA_OPTION"), "pay" }, { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_shiga,
				voiceOver = "MISSION_SHINKANSEN_TASK_OPERATE_NOISEA_TEXT.wav",
			}
		end,
		handlers = {
			pay = function(self)
				if game.interface.getEntity(game.interface.getPlayer()).balance >= params.payamount then
					game.interface.book(params.payamount)
					taskutil:finish(self.name)
				end
			end,
		},
	})

	taskutil:new("4bb", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local emission = (10 * math.log(game.interface.getTownEmission(params.hamamatsu) / math.pow(10,-12), 10))
			self:setProgressCount(emission, params.max_emission_hamamatsu)
			if emission <= params.max_emission_hamamatsu then self:finish() end
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEB_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEB_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEB_TASK") % params },
				},
				options = { { _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEB_OPTION"), "pay" }, { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_hamamatsu,
				voiceOver = "MISSION_SHINKANSEN_TASK_OPERATE_NOISEB_TEXT.wav",
			}
		end,
		handlers = {
			pay = function(self)
				if game.interface.getEntity(game.interface.getPlayer()).balance >= params.payamount then
					game.interface.book(params.payamount)
					taskutil:finish(self.name)
				end
			end,
		},
	})

	taskutil:new("4bc", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local emission = (10 * math.log(game.interface.getTownEmission(params.mishima) / math.pow(10,-12), 10))
			self:setProgressCount(emission, params.max_emission_mishima)
			if emission <= params.max_emission_mishima then self:finish() end
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEC_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEC_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEC_TASK") % params },
				},
				options = { { _("MISSION_SHINKANSEN_TASK_OPERATE_NOISEC_OPTION"), "pay" }, { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_mishima,
				voiceOver = "MISSION_SHINKANSEN_TASK_OPERATE_NOISEC_TEXT.wav",
			}
		end,
		handlers = {
			pay = function(self)
				if game.interface.getEntity(game.interface.getPlayer()).balance >= params.payamount then
					game.interface.book(params.payamount)
					taskutil:finish(self.name)
				end
			end,
		},
	})
end
