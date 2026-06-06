local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("3", {
		onStart = function(self)
			taskutil:setMusicTrack("track3")
			local o = taskutil.userstate.options

			o[#o + 1] = { _("Chemical plant"), "chemical_plant.con", { inputEnabled = 0 } }

			local goodsfactoryparams = {
				stocks = { "MACHINES", "PLASTIC" },
				input = { { 1, 1 } },
				output = { GOODS = 1 },
				capacity = 200,
			}
			for i = 1, #o do
				if o[i][2] == "goods_factory.con" then
					o[i][3] = goodsfactoryparams
				end
			end

			for i = 1, params.numconsites do
				local e = game.interface.getEntity(params["constructionsite" .. i])
				if e.fileName == "industry/goods_factory.con" then
					game.interface.upgradeConstruction(params["constructionsite" .. i], e.fileName, goodsfactoryparams)
				end
			end
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_CORRECTION_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_CORRECTION_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_CORRECTION_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local count = 0
			for i = 1, params.numconsites do
				local e = game.interface.getEntity(params["constructionsite" .. i])
				if e.fileName == "industry/chemical_plant.con" then
					count = count + 1
				end
			end
			if count >= 1 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_CORRECTION_PLASTIC_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_CORRECTION_PLASTIC_TEXT") % params },
					{ type = "TASK", text = _("MISSION_REDSTAR_TASK_CORRECTION_PLASTIC_TASK") % params },
					{ type = "HINT", text = _("MISSION_REDSTAR_TASK_CORRECTION_PLASTIC_HINT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_CORRECTION_PLASTIC_TEXT.wav",
			}
		end,
		handlers = {
			start3c = function(self)
				if taskutil.tasks["3c"].start ~= nil then
					taskutil.tasks["3c"]:start()
				end	
			end,
		},
	})

	taskutil:new("3b", {
		onStart = function(self)
			for i = 1, #params.cities do
				arrivaltracker.track("3b"..i, { cargotype = "GOODS", to = params[params.cities[i]] })
			end
		end,
		onUpdate = function(self)
			local cargo_total = 0
			local people_total = 0

			for i = 1, #params.cities do
				people_total = people_total + game.interface.getTownCapacities(params[params.cities[i]])[1]
				cargo_total = cargo_total + arrivaltracker.get("3b"..i)
			end

			self:setProgressCount(people_total, params.people_total3, 1)
			self:setProgressCount(cargo_total, params.cargo3, 2)

			self:setSubtaskCompleted(1, people_total >= params.people_total3)
			self:setSubtaskCompleted(2, cargo_total >= params.cargo3)

			if cargo_total >= params.cargo3 and people_total >= params.people_total3 then self:finish() end
		end,
		onFinish = function(self)
			for i = 1, #params.cities do
				arrivaltracker.track("3b"..i)
			end
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_CORRECTION_TOWNS_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_CORRECTION_TOWNS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_REDSTAR_TASK_CORRECTION_TOWNS_TASK") % params },
					{ type = "HINT", text = _("MISSION_REDSTAR_TASK_CORRECTION_TOWNS_HINT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				subTasks = {
					{ name = _("MISSION_REDSTAR_TASK_CORRECTION_TOWNS_SUB1") },
					{ name = _("MISSION_REDSTAR_TASK_CORRECTION_TOWNS_SUB2") },
				},
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_CORRECTION_TOWNS_TEXT.wav",
			}
		end,
	})

end
