local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("2", {
		onStart = function(self)
			taskutil:setMusicTrack("track2")
			taskutil.userstate.options[#taskutil.userstate.options + 1] = { _("Food factory"), "food_processing_plant.con" }
			taskutil.userstate.options[#taskutil.userstate.options + 1] = { _("Goods factory"), "goods_factory.con", {
				stocks = { "MACHINES" },
				input = { { 1 } },
				output = { GOODS = 1 },
				capacity = 200,
			} }
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
			taskutil:invokeLater("2", "start2b", 30)
			taskutil:invokeLater(self.name, "showm2", 120)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_PLAN_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_PLAN_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_PLAN_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
		handlers = {
			start2b = function(self)
				if taskutil.tasks["2b"].start ~= nil then
					taskutil.tasks["2b"]:start()
				end
			end,
			showm2 = function(self)
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
				end
			end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			for i = 1, #params.cities do
				arrivaltracker.track("2afood"..i, { cargotype = "FOOD", to = params[params.cities[i]] })
				arrivaltracker.track("2agoods"..i, { cargotype = "GOODS", to = params[params.cities[i]] })
			end
		end,
		onUpdate = function(self)
			local cargo_goods_total = 0
			local cargo_food_total = 0

			for i = 1, #params.cities do
				cargo_food_total = cargo_food_total + arrivaltracker.get("2afood"..i)
				cargo_goods_total = cargo_goods_total + arrivaltracker.get("2agoods"..i)
			end

			self:setProgressCount(cargo_food_total, params.cargo2, 1)
			self:setProgressCount(cargo_goods_total, params.cargo2, 2)

			self:setSubtaskCompleted(1, cargo_food_total >= params.cargo2)
			self:setSubtaskCompleted(2, cargo_goods_total >= params.cargo2)

			if cargo_food_total >= params.cargo2 and cargo_goods_total >= params.cargo2 then self:finish() end
		end,
		onFinish = function(self)
			for i = 1, #params.cities do
				arrivaltracker.track("2afood"..i)
				arrivaltracker.track("2agoods"..i)
			end
			if taskutil.tasks["2b"].start == nil and taskutil.tasks["2b"].finish == nil then
				taskutil:startLater("3")
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_PLAN_TOWNS_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_PLAN_TOWNS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_REDSTAR_TASK_PLAN_TOWNS_TASK") % params },
					{ type = "HINT", text = _("MISSION_REDSTAR_TASK_PLAN_TOWNS_HINT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				subTasks = {
					{ name = _("MISSION_REDSTAR_TASK_PLAN_TOWNS_SUB1") },
					{ name = _("MISSION_REDSTAR_TASK_PLAN_TOWNS_SUB2") },
				},
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_PLAN_TOWNS_TEXT.wav",
			}
		end,
	})

	taskutil:new("2b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local c = math.floor(taskutil.userstate.metersXcargo / 1000)
			self:setProgressCount(c, params.kmpermonth3)
			if c >= params.kmpermonth3 then self:finish() end
		end,
		onFinish = function(self)
			if taskutil.tasks["2a"].start == nil and taskutil.tasks["2a"].finish == nil then
				taskutil:startLater("3")
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_CORRECTION_MAXTRAIN_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_CORRECTION_MAXTRAIN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_REDSTAR_TASK_CORRECTION_MAXTRAIN_TASK") % params },
					{ type = "HINT", text = _("MISSION_REDSTAR_TASK_CORRECTION_MAXTRAIN_HINT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_CORRECTION_MAXTRAIN_TEXT.wav",
			}
		end,
	})

end
