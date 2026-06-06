local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"

return function()
	taskutil:new("3", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track3")
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_TASK_HIGHWAY_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_HIGHWAY_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = {-600, -800, 1500},
				voiceOver = "MISSION_TWENTIES_TASK_HIGHWAY_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal2", 120)
		end,
		onUpdate = function(self)
			--local b = taskutil.userstate.builtareas
			local consumed_total_constrmat = 0
			local consumed_total_asphalt = 0
			for i = 1, 2 do
				local consumed = game.interface.getEntity(game.interface.getEntity(params["constructionsite" .. i]).simBuildings[1]).itemsConsumed
				local c = consumed.CONSTRUCTION_MATERIALS or 0
				local a = consumed.ASPHALT or 0
				consumed_total_constrmat = consumed_total_constrmat + c
				consumed_total_asphalt = consumed_total_asphalt + a
			end
			self:setProgressCount(consumed_total_constrmat, params.goal_constrmat, 1)
			self:setProgressCount(consumed_total_asphalt, params.goal_asphalt, 2)

			self:setSubtaskCompleted(1, consumed_total_constrmat >= params.goal_constrmat)
			self:setSubtaskCompleted(2, consumed_total_asphalt >= params.goal_asphalt)

			if consumed_total_constrmat >= params.goal_constrmat and consumed_total_asphalt >= params.goal_asphalt then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_medium_old.lua", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_large_old.lua", true)

			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_medium_new.lua", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_large_new.lua", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_x_large_new.lua", true)

			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_medium_one_way_new.lua", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_large_one_way_new.lua", true)

			if taskutil.tasks["4"].start ~= nil then
				taskutil.tasks["4"]:start()
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_TASK_HIGHWAY_DEPARTMENT_NAME"),
				paragraphs = {
					{  text = _("MISSION_TWENTIES_TASK_HIGHWAY_DEPARTMENT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TWENTIES_TASK_HIGHWAY_DEPARTMENT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_TWENTIES_TASK_HIGHWAY_DEPARTMENT_SUB1") },
					{ name = _("MISSION_TWENTIES_TASK_HIGHWAY_DEPARTMENT_SUB2") },
				},
				parentId = "3",
				camera = {-600, -800, 1500},
				voiceOver = "MISSION_TWENTIES_TASK_HIGHWAY_DEPARTMENT_TEXT.wav",
			}
		end,
		handlers = {
			showmedal2 = function(self) taskutil:start("m2") end,
		},
	})
end
