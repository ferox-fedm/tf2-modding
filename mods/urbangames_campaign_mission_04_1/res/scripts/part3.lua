local params = require "params"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("3", {
		onStart = function(self)
			taskutil:setMusicTrack("track3")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["3x"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_SURPLUS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_SURPLUS_TEXT") % params },
				},
				optionsRightAlign = true,
				options = { { "Continue", "finish" } },
				camera = params.jump_topolobampo,
				voiceOver = "MISSION_PARADISO_TASK_SURPLUS_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3x", {
		onStart = function(self)
		end,
		onFinish = function(self)
			taskutil:invokeLater(self.name, "showm3", 120)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_TASK") % params },
				},
				parentId = "3",
				options = {
					{ _("MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_OPTION1") % params, "alcohol" },
					{ _("MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_OPTION2") % params, "spoon" },
				},
				optionsRightAlign = true,
				camera = params.jump_harbor_export,
				voiceOver = "MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_TEXT.wav",
			}
		end,
		handlers = {
			showm3 = function(self)
				if taskutil.tasks["m3"].start ~= nil then
					taskutil.tasks["m3"]:start()
				end
			end
		},
		guiHandlers = {
			alcohol = function(self) taskutil:finish(self.name) taskutil:start("3a1") end,
			spoon   = function(self) taskutil:finish(self.name) taskutil:start("3a2") end,
			paper   = function(self) taskutil:finish(self.name) taskutil:start("3a3") end,
		},
	})

	local update = function(self)
		local x = game.interface.getEntity(game.interface.getEntity(params.export).simBuildings[1]).itemsConsumed._sum or 0

		local pos = game.interface.getEntity(params.harbor_export).position
		local stations = game.interface.getEntities({pos = pos, radius = 300}, {type = "STATION"})

		local tot = 0
		for i = 1, #stations do
			local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.ALCOHOL or 0
			tot = tot + s
			local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.SPOON or 0
			tot = tot + s
			local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.PAPER or 0
			tot = tot + s
		end

		local export_amount = params.export_amount
		if taskutil.userstate.task3choice == 1 then export_amount = params.export_alcohol end
		if taskutil.userstate.task3choice == 2 then export_amount = params.export_spoon end

		self:setProgressCount(tot, export_amount)
		if tot >= export_amount then
			self:finish()
		end
	end
	taskutil:new("3a1", {
		onStart = function(self)
			taskutil.userstate.task3choice = 1
			game.interface.upgradeConstruction(params.export, "industry/export.con", { productionLevel = 0, cargo ="ALCOHOL" })
		end,
		onUpdate = update,
		onFinish = function(self)
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_ALC_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_ALC_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_ALC_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_harbor_export,
				voiceOver = "MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_ALC_TEXT.wav",
			}
		end,
	})

	taskutil:new("3a2", {
		onStart = function(self)
			taskutil.userstate.task3choice = 2
			game.interface.upgradeConstruction(params.export, "industry/export.con", { productionLevel = 0, cargo ="SPOON" })
		end,
		onUpdate = update,
		onFinish = function(self)
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_SILVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_SILVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_SILVER_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_harbor_export,
				voiceOver = "MISSION_PARADISO_TASK_SURPLUS_OVERSEAS_SILVER_TEXT.wav",
			}
		end,
	})

	--[[taskutil:new("3a3", {
		onStart = function(self)
			taskutil.userstate.task3choice = 3
			game.interface.upgradeConstruction(params.export, "industry/export.con", { productionLevel = 0, cargo ="PAPER" })
		end,
		onUpdate = update,
		onFinish = function(self)
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("unused") % params,
				paragraphs = {
					{ text = _("unused") % params },
					{ type = "TASK", text = _("unused") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_harbor_export,
			}
		end,
	})]]--
end
