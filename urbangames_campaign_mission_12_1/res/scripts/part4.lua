local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"

return function()
	taskutil:new("4", {
		onStart = function(self)
			taskutil:setMusicTrack("track4")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["4a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4a", {
		onStart = function(self)
			taskutil:setMarker("hotel1", { entity = params.hotel1, type = "question" }, self.name, "hotel1")
			taskutil:setMarker("hotel2", { entity = params.hotel2, type = "question" }, self.name, "hotel2")
			taskutil:setMarker("hotel3", { entity = params.hotel3, type = "question" }, self.name, "hotel3")
		end,
		onUpdate = function(self)
			if (taskutil.tasks["4aa"].start == nil and taskutil.tasks["4aa"].finish == nil) and (taskutil.tasks["4ab"].start == nil and taskutil.tasks["4ab"].finish == nil)  and (taskutil.tasks["4ac"].start == nil and taskutil.tasks["4ac"].finish == nil) then
				self:finish()
			end

			local done = 0
			if (taskutil.tasks["4aa"].start == nil and taskutil.tasks["4aa"].finish == nil) then done = done + 1 end
			if (taskutil.tasks["4ab"].start == nil and taskutil.tasks["4ab"].finish == nil) then done = done + 1 end
			if (taskutil.tasks["4ac"].start == nil and taskutil.tasks["4ac"].finish == nil) then done = done + 1 end
			self:setProgressCount(done, 3)

		end,
		onFinish = function(self)
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_DELIVER_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_DELIVER_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_DELIVER_TEXT.wav",
			}
		end,
		handlers = {
			hotel1 = function(self) taskutil:setMarker("hotel1") taskutil:start("4aa") end,
			hotel2 = function(self) taskutil:setMarker("hotel2") taskutil:start("4ab") end,
			hotel3 = function(self) taskutil:setMarker("hotel3") taskutil:start("4ac") end,
		},
	})

	taskutil:new("4aa", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.hotel1, "industry/hotel1.con", {
				stocks = { "TOOLS" },
				input = { { 1 } },
				output = { },
				capacity = 200,
				autoUpgrade = 0,
			})
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.hotel1).simBuildings[1]).itemsConsumed
			local x = c.TOOLS or 0
			self:setProgressCount(x, params.tools_amount, 1)
			self:setSubtaskCompleted(1, x >= params.tools_amount)
			if x >= params.tools_amount then self:finish() end
		end,
		onFinish = function(self)
			game.interface.upgradeConstruction(params.hotel1, "industry/hotel1.con", {
				productionLevel = 1,
				stocks = { "TOOLS" },
				input = { { 1 } },
				output = { },
				capacity = 200,
				autoUpgrade = 0,
			})
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL1_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL1_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL1_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL1_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_hotel1,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL1_TEXT.wav",
			}
		end,
	})

	taskutil:new("4ab", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.hotel2, "industry/hotel2.con", {
				stocks = { "STEEL" },
				input = { { 1 } },
				output = { },
				capacity = 200,
				autoUpgrade = 0,
			})
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.hotel2).simBuildings[1]).itemsConsumed
			local x = c.STEEL or 0
			self:setProgressCount(x, params.steel_amount, 1)
			self:setSubtaskCompleted(1, x >= params.steel_amount)
			if x >= params.steel_amount then self:finish() end
		end,
		onFinish = function(self)
			game.interface.upgradeConstruction(params.hotel2, "industry/hotel2.con", {
				productionLevel = 1,
				stocks = { "STEEL" },
				input = { { 1 } },
				output = { },
				capacity = 200,
				autoUpgrade = 0,
			})
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL2_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL2_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL2_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL2_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_hotel2,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL2_TEXT.wav",
			}
		end,
	})

	taskutil:new("4ac", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.hotel3, "industry/hotel3.con", {
				stocks = { "PLASTIC" },
				input = { { 1 } },
				output = { },
				capacity = 200,
				autoUpgrade = 0,
			})
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.hotel3).simBuildings[1]).itemsConsumed
			local x = c.PLASTIC or 0
			self:setProgressCount(x, params.plastic_amount, 1)
			self:setSubtaskCompleted(1, x >= params.plastic_amount)
			if x >= params.plastic_amount then self:finish() end
		end,
		onFinish = function(self)
			game.interface.upgradeConstruction(params.hotel3, "industry/hotel3.con", {
				productionLevel = 1,
				stocks = { "PLASTIC" },
				input = { { 1 } },
				output = { },
				capacity = 200,
				autoUpgrade = 0,
			})
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL3_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL3_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL3_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL3_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_hotel3,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_INFRASTRUCTURE_HOTEL3_TEXT.wav",
			}
		end,
	})

end
