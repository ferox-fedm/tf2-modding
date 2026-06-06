local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("5", {
		onStart = function(self)
			taskutil:setMusicTrack("track5")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_LEAP_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_LEAP_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_LEAP_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	local function upgradeDam(level)
		game.interface.upgradeConstruction(params.damsite, "industry/dam.con", {
			stocks = { "MACHINES","STEEL" },
			input = { { 1, 0 }, { 0, 1 } },
			output = { },
			capacity = 100,
			productionLevel = level,
			autoUpgrade = 0,
		})
	end
	taskutil:new("5b", {
		onStart = function(self)
			upgradeDam(0)
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.damsite).simBuildings[1]).itemsConsumed
			local c2 = c.STEEL or 0
			local c3 = c.MACHINES or 0

			self:setSubtaskCompleted(1, c2 >= params.dam_steel)
			self:setSubtaskCompleted(2, c3 >= params.dam_machines)

			local level = math.floor(3 * math.min(1, c2 / params.dam_steel, c3 / params.dam_machines))
			if game.interface.getEntity(params.damsite).params.productionLevel < level then
				upgradeDam(level)
			end

			self:setProgressCount(c2, params.dam_steel, 1)
			self:setProgressCount(c3, params.dam_machines, 2)

			if c2 >= params.dam_steel and c3 >= params.dam_machines then self:finish() end
		end,
		onFinish = function(self)
			game.interface.upgradeConstruction(params.damsite, "industry/dam.con", { productionLevel = 3, capacity = 0 })
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_LEAP_DAM_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_LEAP_DAM_TEXT") % params },
					{ type = "TASK", text = _("MISSION_REDSTAR_TASK_LEAP_DAM_TASK") % params },
				},
				subTasks = {
					--{ name = _("MISSION_REDSTAR_TASK_LEAP_DAM_SUB1") },
					{ name = _("MISSION_REDSTAR_TASK_LEAP_DAM_SUB2") },
					{ name = _("MISSION_REDSTAR_TASK_LEAP_DAM_SUB3") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_damsite,
				voiceOver = "MISSION_REDSTAR_TASK_LEAP_DAM_TEXT.wav",
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
				name = _("MISSION_REDSTAR_TASK_FINISH_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_FINISH_TEXT") % params },
				},
				parentId = "5",
				voiceOver = "MISSION_REDSTAR_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
