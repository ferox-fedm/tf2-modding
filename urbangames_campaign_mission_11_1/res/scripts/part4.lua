local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("4", {
		onStart = function(self)
			taskutil:setMusicTrack("track4")
			local o = taskutil.userstate.options

			o[#o + 1] = { _("Machine factory"), "machines_factory.con", { inputEnabled = 0 } }

			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["4a"]:start()
			taskutil:invokeLater("4", "start4c", 30)
			taskutil:invokeLater(self.name, "showm4", 120)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_DECENTRAL_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_DECENTRAL_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_DECENTRAL_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
		handlers = {
			start4c = function(self)
				taskutil:start("4c")
			end,
			showm4 = function(self)
				if taskutil.tasks["m4"].start ~= nil then
					taskutil.tasks["m4"]:start()
				end
			end,
		},
	})

	taskutil:new("4a", {
		onStart = function(self)
			taskutil.userstate.options[#taskutil.userstate.options + 1] = { _("Farm for steel production"), "steel_farm.con" }
			taskutil:invokeLater(self.name, "showm3", 120)
		end,
		onUpdate = function(self)
			for i = 1, params.numconsites do
				local e = game.interface.getEntity(params["constructionsite" .. i])
				local steel_total = 0
				if e.fileName == "industry/steel_farm.con" then
					local c = game.interface.getEntity(e.simBuildings[1]).itemsProduced.STEEL or 0
					steel_total = steel_total + c
				end
				if steel_total >= params.steel_amount then
					self:finish()
					return
				end
			end
			self:setProgressCount(steel_total, params.steel_amount)
		end,
		onFinish = function(self)
			if taskutil.tasks["4c"].start == nil and taskutil.tasks["4c"].finish == nil then
				taskutil:startLater("5")
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_DECENTRAL_STEEL_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_DECENTRAL_STEEL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_REDSTAR_TASK_DECENTRAL_STEEL_TASK") % params },
					{ type = "HINT", text = _("MISSION_REDSTAR_TASK_DECENTRAL_STEEL_HINT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_DECENTRAL_STEEL_TEXT.wav",
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

	taskutil:new("4c", {
		onStart = function(self)
			taskutil.userstate.metersXcargo4c = taskutil.userstate.metersXcargo
		end,
		onUpdate = function(self)
			taskutil.userstate.metersXcargo4c = math.max(taskutil.userstate.metersXcargo, taskutil.userstate.metersXcargo4c)
			local c = math.floor(taskutil.userstate.metersXcargo / 1000)
			self:setProgressCount(c, params.kmpermonth4_max)
		end,
		onFinish = function(self)
			if taskutil.tasks["4a"].start == nil and taskutil.tasks["4a"].finish == nil then
				taskutil:startLater("5")
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_DECENTRAL_MINTRAIN_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_DECENTRAL_MINTRAIN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_REDSTAR_TASK_DECENTRAL_MINTRAIN_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_DECENTRAL_MINTRAIN_TEXT.wav",
			}
		end,
		handlers = {
			monthwasreset = function(self)
				if not taskutil:started(self.name) or taskutil:finished(self.name) then return end
				local c = math.floor(taskutil.userstate.metersXcargo4c / 1000)
				if c <= params.kmpermonth4_max then
					taskutil.userstate.metersXcargo4c = nil
					self:finish()
					return
				end
				taskutil.userstate.metersXcargo4c = 0
			end,
		},
	})

end
