local taskutil = require "mission.taskutil"
local params = require "params"
local proposalutil = require "mission.proposalutil"
local util = require "util"

return function()
	taskutil:new("3", {
		onStart = function(self)
			taskutil:setMusicTrack("track3")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PLANES_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PLANES_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_STARFLIGHT_TASK_PLANES_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm2", 120)
			taskutil.userstate.donecount3 = 0
			taskutil:setMarker("3a1", { entity = params.toolsfactory,          type = "question" }, "1", "3a1")
			taskutil:setMarker("3a2", { entity = params.steelmill,             type = "question" }, "1", "3a2")
			taskutil:setMarker("3a3", { entity = params.sawmill,               type = "question" }, "1", "3a3")
		end,
		onUpdate = function(self)
			if taskutil.userstate.donecount3 >= 3 then self:finish() end
			self:setProgressCount(taskutil.userstate.donecount3, 3)
		end,
		onFinish = function(self)
			util.endchapter(3)
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PLANES_TASKS_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PLANES_TASKS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_PLANES_TASKS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.default_camera,
				voiceOver = "MISSION_STARFLIGHT_TASK_PLANES_TASKS_TEXT.wav",
			}
		end,
		handlers = {
			showm2 = function(self)
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
				end
			end,
		},
	})

	taskutil:new("3a1", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.hugesfactory).simBuildings[1]).itemsConsumed.TOOLS or 0
			if c > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.donecount3 = taskutil.userstate.donecount3 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PLANES_TOOLS_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PLANES_TOOLS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_PLANES_TOOLS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_hugesfactory,
				voiceOver = "MISSION_STARFLIGHT_TASK_PLANES_TOOLS_TEXT.wav",
			}
		end,
	})

	taskutil:new("3a2", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.hugesfactory).simBuildings[1]).itemsConsumed.STEEL or 0
			if c > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.donecount3 = taskutil.userstate.donecount3 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PLANES_STEEL_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PLANES_STEEL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_PLANES_STEEL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_hugesfactory,
				voiceOver = "MISSION_STARFLIGHT_TASK_PLANES_STEEL_TEXT.wav",
			}
		end,
	})

	taskutil:new("3a3", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.hugesfactory).simBuildings[1]).itemsConsumed.PLANKS or 0
			if c > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.donecount3 = taskutil.userstate.donecount3 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PLANES_WOOD_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PLANES_WOOD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_PLANES_WOOD_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_hugesfactory,
				voiceOver = "MISSION_STARFLIGHT_TASK_PLANES_WOOD_TEXT.wav",
			}
		end,
	})

	local function lines3b()
		local pstationsantabarbara = util.airfield2pstationgroup(params.airfield_santabarbara)
		local pstationsanfrancisco = util.airfield2pstationgroup(params.airport_sanfrancisco)
		local lines = game.interface.getLines()
		local goodlines = {}
		for l = 1, #lines do
			local found0 = false
			local found1 = false
			local stops = game.interface.getEntity(lines[l]).stops
			if #stops == 2 then
				for i = 1, #stops do
					if stops[i] == pstationsantabarbara then found0 = true end
					if stops[i] == pstationsanfrancisco then found1 = true end
				end
			end
			if found0 and found1 and #util.line2vehicles(lines[l]) > 0 then goodlines[#goodlines + 1] = lines[l] end
		end
		return goodlines
	end

	taskutil:new("3b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local goodlines = lines3b()
			local transported = 0
			for i = 1, #goodlines do
				transported = transported + game.interface.getEntity(goodlines[i]).itemsTransported._sum
			end
			self:setProgressCount(transported, params.passengers_planes, 1)
			if transported >= params.passengers_planes then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PLANES_PENALTY_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PLANES_PENALTY_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_PLANES_PENALTY_TASK") % params },
					{ type = "HINT", text = _("MISSION_STARFLIGHT_TASK_PLANES_PENALTY_HINT") % params },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_TASK_PLANES_PENALTY_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.default_camera,
				voiceOver = "MISSION_STARFLIGHT_TASK_PLANES_PENALTY_TEXT.wav",
			}
		end,
		handlers = {
			handleEvent = function(self, id, name, param)
				if id == "__missionCallback__" then
					local e = game.interface.getEntity(param.params.entity)
					if param.type == "VEHICLE_INCOME" and e.carrier == "AIR" then
						local goodlines = lines3b()
						for i = 1, #goodlines do
							if goodlines[i] == e.line then
								return 0
							end
						end
					end
				end
			end
		},
	})
end
