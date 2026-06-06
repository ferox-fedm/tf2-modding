local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local vec3 = require "vec3"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("2", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track2")
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_TOWN_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_TOWN_TEXT") % params }
				},
				camera = params.jump_fortmcmurray,
				voiceOver = "MISSION_OILSANDS_TASK_TOWN_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.refinery, "industry/refinery.con", {
				industrialCapacity = 100,
				stocks = { "OIL_SAND" },
				input = { { 1 } },
				output = { OIL = 1 },
			})
			arrivaltracker.track("2a", { cargotype = "PASSENGERS", to = params.refinery })
		end,
		onUpdate = function(self)
			local c = arrivaltracker.get("2a")
			local done = c >= params.people_to_refinery

			self:setProgressCount(c, params.people_to_refinery, 1)

			if done then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("2a")
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_TOWN_WORKERS_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_TOWN_WORKERS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_TOWN_WORKERS_TASK") % params },
				},
				camera = params.jump_refinery,
				voiceOver = "MISSION_OILSANDS_TASK_TOWN_WORKERS_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_OILSANDS_TASK_TOWN_WORKERS_SUB1") },
				},
				parentId = "2",
			}
		end,
	})

	taskutil:new("2b", {
		onStart = function(self)
			arrivaltracker.track("2agoods", { cargotype = "GOODS", to = params.fortmcmurray })
			arrivaltracker.track("2afood", { cargotype = "FOOD", to = params.fortmcmurray })
		end,
		onUpdate = function(self)
			local c1 = game.interface.getTownReachability(params.fortmcmurray)[2]
			local c2 = arrivaltracker.get("2agoods")
			local c3 = arrivaltracker.get("2afood")

			self:setProgressCount(c1, params.public_transport, 1)
			--self:setProgressCount(c2, params.goods_to_fort, 2)
			--self:setProgressCount(c3, params.food_to_fort, 3)

			local done1 = c1 >= params.public_transport
			local done2 = c2 >= params.goods_to_fort
			local done3 = c3 >= params.food_to_fort

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)
			self:setSubtaskCompleted(3, done3)

			if done1 and done2 and done3 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("2agoods")
			arrivaltracker.track("2afood")
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_TOWN_GROW_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_TOWN_GROW_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_TOWN_GROW_TASK") % params },
				},
				camera = params.jump_fortmcmurray,
				voiceOver = "MISSION_OILSANDS_TASK_TOWN_GROW_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_OILSANDS_TASK_TOWN_GROW_SUB1") },
					{ name = _("MISSION_OILSANDS_TASK_TOWN_GROW_SUB2") },
					{ name = _("MISSION_OILSANDS_TASK_TOWN_GROW_SUB3") },
				},
				parentId = "2",
			}
		end,
	})
end
