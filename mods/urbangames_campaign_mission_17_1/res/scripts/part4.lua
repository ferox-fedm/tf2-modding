local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

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
				name = _("MISSION_OILSANDS_TASK_DECISION_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_DECISION_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_OILSANDS_TASK_DECISION_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm2", 120)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_DECISION_DECIDE_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_DECISION_DECIDE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_DECISION_DECIDE_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_OILSANDS_TASK_DECISION_DECIDE_TEXT.wav",
				options = { { "Debug: Skip", "finish" },
							{ _("MISSION_OILSANDS_TASK_DECISION_DECIDE_OPTION1"), "option1" },
				            { _("MISSION_OILSANDS_TASK_DECISION_DECIDE_OPTION2"), "option2" } },
				parentId = "4",
			}
		end,
		handlers = {
			option1 = function(self)
				taskutil.userstate.choice4a = 1
				taskutil:start("4b")
				taskutil:finish(self.name)
			end,
			option2 = function(self)
				taskutil.userstate.choice4a = 2
				taskutil:start("4d")
				taskutil:finish(self.name)
			end,
			showm2 = function(self)
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
				end
			end,
		},
		guiHandlers = {
			option1 = function(self)
				taskutil:sendScriptFn(self.name, "option1")
			end,
			option2 = function(self)
				taskutil:sendScriptFn(self.name, "option2")
			end,
		},
	})

	taskutil:new("4b", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.goodsfactory, "industry/goods_factory.con", {
				stocks = { "PLASTIC" },
				input = { { 1 } },
				output = { GOODS = 1 },
				capacity = 100,
			})
		end,
		onUpdate = function(self)
			local e = game.interface.getEntity(game.interface.getEntity(params.goodsfactory).simBuildings[1])
			local count = e.itemsConsumed.PLASTIC or 0

			local done1 = count >= params.plastic_amount_clean
			local done2 = taskutil.userstate.paid4b == true

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			--self:setProgressCount(count, params.plastic_amount_clean, 1)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["4c"]:start()
		end,
		getInfo = function(self)
			local parentId = "4"
			if taskutil.userstate.choice4a == 2 then parentId = "5" end
			return {
				name = _("MISSION_OILSANDS_TASK_DECISION_CLEAN_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_DECISION_CLEAN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_DECISION_CLEAN_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_OILSANDS_TASK_DECISION_CLEAN_SUB1") % params },
					{ name = _("MISSION_OILSANDS_TASK_DECISION_CLEAN_SUB2") % params },
				},
				camera = params.jump_goodsfactory,
				voiceOver = "MISSION_OILSANDS_TASK_DECISION_CLEAN_TEXT.wav",
				options = { { "Debug: Skip", "finish" },
							{ _("MISSION_OILSANDS_TASK_DECISION_CLEAN_OPTION"), "pay" } },
				parentId = parentId,
			}
		end,
		handlers = {
			pay = function(self)
				if not taskutil.userstate.paid4b and game.interface.getEntity(game.interface.getPlayer()).balance >= params.pay_science then
					game.interface.book(-params.pay_science)
					taskutil.userstate.paid4b = true
					self:setOptionUnavailable(2)
				end
			end,
		},
		guiHandlers = {
			pay = function(self) taskutil:sendScriptFn(self.name, "pay") end,
		},
	})

	taskutil:new("4c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getEntities({ pos = params.pos_fortmcmurray, radius = 500 }, { type = "VEHICLE" })
			local tram = false
			local bus = false
			for i = 1, #vehicles do
				local v = game.interface.getEntity(vehicles[i])
				if v.carrier == "ROAD" and v.allCapacities.PASSENGERS then bus = true end
				if v.carrier == "TRAM" then tram = true end
			end
			if tram and not bus then self:finish() end
		end,
		onFinish = function(self)
			if taskutil.userstate.choice4a == 1 then
				taskutil:startLater("5")
			else
				taskutil.tasks["5a"]:start()
			end
		end,
		getInfo = function(self)
			local parentId = "4"
			if taskutil.userstate.choice4a == 2 then parentId = "5" end
			return {
				name = _("MISSION_OILSANDS_TASK_DECISION_CLEAN2_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_DECISION_CLEAN2_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_DECISION_CLEAN2_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_OILSANDS_TASK_DECISION_CLEAN2_SUB1") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_OILSANDS_TASK_DECISION_CLEAN2_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = parentId,
			}
		end,
	})

	taskutil:new("4d", {
		onStart = function(self)
			--game.interface.upgradeConstruction(params.refinery, "industry/refinery.con", { withconmat = true })
			game.interface.upgradeConstruction(params.machinesdump, "industry/machinesdump.con", { active = true })
		end,
		onUpdate = function(self)
			local e = game.interface.getEntity(game.interface.getEntity(params.machinesdump).simBuildings[1])
			local count = e.itemsConsumed.MACHINES or 0

			local done1 = count >= params.machines_amount_dirty
			local done2 = taskutil.userstate.paid4d == true

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			--self:setProgressCount(count, params.machines_amount_dirty, 1)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["4e"]:start()
		end,
		getInfo = function(self)
			local parentId = "4"
			if taskutil.userstate.choice4a == 1 then parentId = "5" end
			return {
				name = _("MISSION_OILSANDS_TASK_DECISION_DIRTY_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_DECISION_DIRTY_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_DECISION_DIRTY_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_OILSANDS_TASK_DECISION_DIRTY_SUB1") % params },
					{ name = _("MISSION_OILSANDS_TASK_DECISION_DIRTY_SUB2") % params },
				},
				camera = params.jump_refinery,
				voiceOver = "MISSION_OILSANDS_TASK_DECISION_DIRTY_TEXT.wav",
				options = { { "Debug: Skip", "finish" },
							{ _("MISSION_OILSANDS_TASK_DECISION_CLEAN_OPTION"), "pay" } },
				parentId = parentId,
			}
		end,
		handlers = {
			pay = function(self)
				if not taskutil.userstate.paid4d and game.interface.getEntity(game.interface.getPlayer()).balance >= params.pay_modern then
					game.interface.book(-params.pay_modern)
					taskutil.userstate.paid4d = true
					self:setOptionUnavailable(2)
				end
			end,
		},
		guiHandlers = {
			pay = function(self) taskutil:sendScriptFn(self.name, "pay") end,
		},
	})

	taskutil:new("4e", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.sedimentationtank3, "industry/sedimentationtank.con", { mode2 = true })
		end,
		onUpdate = function(self)
			local count = 0
			local e = game.interface.getEntity(game.interface.getEntity(params.sewage).simBuildings[1])
			count = count + (e.itemsConsumed.WASTE_WATER or 0)

			self:setProgressCount(count, params.wastewater_amount)
			if count >= params.wastewater_amount then self:finish() end
		end,
		onFinish = function(self)
			if taskutil.userstate.choice4a == 2 then
				taskutil:startLater("5")
			else
				taskutil.tasks["5a"]:start()
			end
		end,
		getInfo = function(self)
			local parentId = "4"
			if taskutil.userstate.choice4a == 1 then parentId = "5" end
			return {
				name = _("MISSION_OILSANDS_TASK_DECISION_DIRTY2_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_DECISION_DIRTY2_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_DECISION_DIRTY2_TASK") % params },
				},
				camera = params.jump_oilsands,
				voiceOver = "MISSION_OILSANDS_TASK_DECISION_DIRTY2_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = parentId,
			}
		end,
	})
end
