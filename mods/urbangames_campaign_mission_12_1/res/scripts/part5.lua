local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("5", {
		onStart = function(self)
			taskutil:setMusicTrack("track5")
			taskutil:invokeLater(self.name, "showm4", 120)
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["5a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_NEEDS_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
		handlers = {
			showm3 = function(self)
				if taskutil.tasks["m4"].start ~= nil then
					taskutil.tasks["m4"]:start()
				end
			end,
		},
	})

	local function countpassengers(airportid)
		local stations = game.interface.getEntity(airportid).stations
		local count = 0
		for i = 1, #stations do
			local sg = game.interface.getEntity(stations[i]).stationGroup
			count = count + (game.interface.getEntity(sg).itemsLoaded.PASSENGERS or 0)
		end
		return count
	end

	taskutil:new("5a", {
		onStart = function(self)
			taskutil:setMarker("de", { entity = params.palma, type = "question" }, self.name, "de")
			taskutil:setMarker("at", { entity = params.inca, type = "question" }, self.name, "at")
			taskutil:setMarker("ch", { entity = params.sarenal, type = "question" }, self.name, "ch")
			taskutil:invokeLater(self.name, "showm4", 120)
		end,
		onUpdate = function(self)

			if (taskutil.tasks["5aa"].start == nil and taskutil.tasks["5aa"].finish == nil) and (taskutil.tasks["5ab"].start == nil and taskutil.tasks["5ab"].finish == nil)  and (taskutil.tasks["5ac"].start == nil and taskutil.tasks["5ac"].finish == nil) then
				self:finish()
			end

			local done = 0
			if (taskutil.tasks["5aa"].start == nil and taskutil.tasks["5aa"].finish == nil) then done = done + 1 end
			if (taskutil.tasks["5ab"].start == nil and taskutil.tasks["5ab"].finish == nil) then done = done + 1 end
			if (taskutil.tasks["5ac"].start == nil and taskutil.tasks["5ac"].finish == nil) then done = done + 1 end
			self:setProgressCount(done, 3)

			end,
		onFinish = function(self)
			taskutil.tasks["end"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_FULLFIL_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_FULLFIL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_FULLFIL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_NEEDS_FULLFIL_TEXT.wav",
			}
		end,
		handlers = {
			de = function(self) taskutil:setMarker("de") taskutil:start("5aa") end,
			at = function(self) taskutil:setMarker("at") taskutil:start("5ab") end,
			ch = function(self) taskutil:setMarker("ch") taskutil:start("5ac") end,
			showm4 = function(self) 
				if taskutil.tasks["m4"].start ~= nil then
					taskutil.tasks["m4"]:start()
				end
			end,
		},
	})

	taskutil:new("5aa", {
		onStart = function(self)
			arrivaltracker.track("5aa", { cargotype = "ALCOHOL", to = params.palma })
		end,
		onUpdate = function(self)
			local count_private = game.interface.getTownReachability(params.palma)[1]

			self:setProgressCount(arrivaltracker.get("5aa"), params.alcohol5, 1)
			self:setProgressCount(count_private, params.private_cover, 2)

			self:setSubtaskCompleted(1, arrivaltracker.get("5aa") >= params.alcohol5)
			self:setSubtaskCompleted(2, count_private >= params.private_cover)

			if arrivaltracker.get("5aa") >= params.alcohol5 and count_private >= params.private_cover then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("5aa")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_GERMAN_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_GERMAN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_GERMAN_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_GERMAN_SUB1") % params },
					{ name = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_GERMAN_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_palma,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_NEEDS_GERMAN_TEXT.wav",
			}
		end,
	})

	taskutil:new("5ab", {
		onStart = function(self)
			arrivaltracker.track("5ab", { cargotype = "FOOD", to = params.inca })
		end,
		onUpdate = function(self)
			local count_public = game.interface.getTownReachability(params.inca)[2]

			self:setProgressCount(arrivaltracker.get("5ab"), params.food5, 1)
			self:setProgressCount(count_public, params.public_cover, 2)

			self:setSubtaskCompleted(1, arrivaltracker.get("5ab") >= params.food5)
			self:setSubtaskCompleted(2, count_public >= params.public_cover)

			if arrivaltracker.get("5ab") >= params.food5 and count_public >= params.public_cover then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("5ab")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_AUSTRIAN_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_AUSTRIAN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_AUSTRIAN_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_AUSTRIAN_SUB1") % params },
					{ name = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_AUSTRIAN_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_inca,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_NEEDS_AUSTRIAN_TEXT.wav",
			}
		end,
	})

	taskutil:new("5ac", {
		onStart = function(self)
			arrivaltracker.track("5ac", { cargotype = "GOODS", to = params.sarenal })
		end,
		onUpdate = function(self)
			local emission = (10 * math.log(game.interface.getTownEmission(params.sarenal) / math.pow(10,-12), 10))
			self:setProgressCount(arrivaltracker.get("5ac"), params.goods5, 1)
			--self:setProgressCount(emission, params.max_emission, 2)

			self:setSubtaskCompleted(1, arrivaltracker.get("5ac") >= params.goods5)
			--self:setSubtaskCompleted(2, emission <= params.max_emission)

			--if arrivaltracker.get("5ac") >= params.goods5 and emission <= params.max_emission then self:finish() end
			if arrivaltracker.get("5ac") >= params.goods5 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("5ac")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_SWISS_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_SWISS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_SWISS_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_SWISS_SUB1") % params },
					--{ name = _("MISSION_ALLINCLUSIVE_TASK_NEEDS_SWISS_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_sarenal,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_NEEDS_SWISS_TEXT.wav",
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
				name = _("MISSION_ALLINCLUSIVE_TASK_FINISH_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_FINISH_TEXT") % params },
				},
				parentId = "5",
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
