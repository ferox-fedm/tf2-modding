local taskutil = require "mission.taskutil"
local params = require "params"
local proposalutil = require "mission.proposalutil"
local util = require "util"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"

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
				name = _("MISSION_STARFLIGHT_TASK_STUDIO_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_STUDIO_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = {-300, -4300, 1000},
				voiceOver = "MISSION_STARFLIGHT_TASK_STUDIO_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm3", 120)
			taskutil.userstate.donecount4 = 0
			taskutil:setMarker("4a1", { entity = params.filmset1,       type = "question" }, "1", "4a1")
			taskutil:setMarker("4a4", { entity = params.filmset2,       type = "question" }, "1", "4a4")
			taskutil:setMarker("4a5", { entity = params.filmset3,       type = "question" }, "1", "4a5")
		end,
		onUpdate = function(self)
			if taskutil.userstate.donecount4 >= 3 then self:finish() end
			self:setProgressCount(taskutil.userstate.donecount4, 3)
		end,
		onFinish = function(self)
			game.interface.upgradeConstruction(params.filmset1, "industry/filmset1.con", {
				stocks = { "STEEL" },
				input = { { 1 } },
				output = { },
				capacity = 100,
			})

			util.endchapter(4)
			taskutil.tasks["4b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_STUDIO_SETS_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_STUDIO_SETS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_STUDIO_SETS_TASK") % params },
				},
				voiceOver = "MISSION_STARFLIGHT_TASK_STUDIO_SETS_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = {-300, -4300, 1000},
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

	taskutil:new("4a1", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.filmset1, "industry/filmset1.con", {
				stocks = { "STEEL" },
				input = { { 1 } },
				output = { },
				capacity = 100,
			})
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.filmset1).simBuildings[1]).itemsConsumed
			local x0 = c.STEEL or 0
			self:setProgressCount(x0, params.setsteel, 1)
			if x0 >= params.setsteel then self:finish() end
		end,
		onFinish = function(self)
			game.interface.upgradeConstruction(params.filmset1, "industry/filmset1.con", {
				stocks = { "STEEL" },
				input = { { 1 } },
				output = { },
				capacity = 100,
			})
			taskutil.userstate.donecount4 = taskutil.userstate.donecount4 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_STUDIO_BH_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_STUDIO_BH_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_STUDIO_BH_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_TASK_STUDIO_BH_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_filmset1,
				voiceOver = "MISSION_STARFLIGHT_TASK_STUDIO_BH_TEXT.wav",
			}
		end,
	})

	taskutil:new("4a4", {
		onStart = function(self)
			taskutil:setZone("4a4", { polygon = zoneutil.makeCircleZone(params.zone_4a4.pos, params.zone_4a4.radius), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local found = 0
			local assets = game.interface.getEntities(params.zone_4a4, {type = "ASSET_GROUP"})
			for i = 1, #assets do
				local a = game.interface.getEntity(assets[i])
				for k, v in pairs(a.models) do
					if k:match("lamp") or k:match("bench") then found = found + 1 end
				end
			end
			self:setProgressCount(found, params.decoration_filmset, 1)
			if found >= params.decoration_filmset then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("4a4")
			taskutil.userstate.donecount4 = taskutil.userstate.donecount4 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_STUDIO_ROMANCE_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_STUDIO_ROMANCE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_STUDIO_ROMANCE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_TASK_STUDIO_ROMANCE_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_filmset2,
				voiceOver = "MISSION_STARFLIGHT_TASK_STUDIO_ROMANCE_TEXT.wav",
			}
		end,
	})

	taskutil:new("4a5", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.filmset3, "industry/filmset3.con", {
				stocks = { "PLANKS" },
				input = { { 1 } },
				output = { },
				capacity = 400
			})
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.filmset3).simBuildings[1]).itemsConsumed
			local x0 = c.PLANKS or 0
			self:setProgressCount(x0, params.setplanks, 1)
			if x0 >= params.setplanks then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.donecount4 = taskutil.userstate.donecount4 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_STUDIO_CASTLE_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_STUDIO_CASTLE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_STUDIO_CASTLE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_TASK_STUDIO_CASTLE_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_filmset3,
				voiceOver = "MISSION_STARFLIGHT_TASK_STUDIO_CASTLE_TEXT.wav",
			}
		end,
	})

	taskutil:new("4b", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.filmset4, "industry/filmset4.con", {
				stocks = { "SAND" },
				input = { { 1 } },
				output = { },
				capacity = 400,
			})
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.filmset4).simBuildings[1]).itemsConsumed
			local x0 = c.SAND or 0
			self:setProgressCount(x0, params.setsand, 1)
			if x0 >= params.setsand then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_STUDIO_SAND_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_STUDIO_SAND_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_STUDIO_SAND_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_TASK_STUDIO_SAND_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_filmset4,
				voiceOver = "MISSION_STARFLIGHT_TASK_STUDIO_SAND_TEXT.wav",
			}
		end,
	})
end
