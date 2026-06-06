local params = require "params"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("4", {
		onStart = function(self)
			taskutil:setMusicTrack("track4")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil:invokeLater(self.name, "showm2", 120)
			local i = taskutil.userstate.task3choice
			if i == 1 then
				taskutil.tasks["4aa"]:start()
			elseif i == 2 then
				taskutil.tasks["4ba"]:start()
			--elseif i == 3 then
			--	taskutil.tasks["4ca"]:start()
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_HAPPYNESS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_HAPPYNESS_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_topolobampo,
				voiceOver = "MISSION_PARADISO_TASK_HAPPYNESS_TEXT.wav",
			}
		end,
		handlers = {
			showm2 = function(self)
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
				end
			end,
		},
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4aa", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local g = game.interface.getEntity(game.interface.getEntity(params.guano_deposit).simBuildings[1]).itemsConsumed._sum or 0
			self:setProgressCount(g, params.happiness_farm_guano)
			if g >= params.happiness_farm_guano then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["4ab"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_HAPPYNESS_FARM_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_HAPPYNESS_FARM_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_HAPPYNESS_FARM_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_guano_deposit,
				voiceOver = "MISSION_PARADISO_TASK_HAPPYNESS_FARM_TEXT.wav",
			}
		end,
	})

	taskutil:new("4ab", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_HAPPYNESS_FARM_END_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_HAPPYNESS_FARM_END_TEXT") % params }
				},
				options = { { _("Unfortunate!"), "finish" } },
				optionsRightAlign = true,
				parentId = "4",
				camera = params.jump_cactus_farm,
				voiceOver = "MISSION_PARADISO_TASK_HAPPYNESS_FARM_END_TEXT.wav",
			}
		end,
	})

	taskutil:new("4ba", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local l = game.interface.getEntity(game.interface.getEntity(params.log_deposit).simBuildings[1]).itemsConsumed._sum or 0
			self:setProgressCount(l, params.happiness_mine_logs)
			if l >= params.happiness_mine_logs then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["4bb"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_HAPPYNESS_MINE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_HAPPYNESS_MINE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_HAPPYNESS_MINE_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_log_deposit,
				voiceOver = "MISSION_PARADISO_TASK_HAPPYNESS_MINE_TEXT.wav",
			}
		end,
	})

	taskutil:new("4bb", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_HAPPYNESS_MINE_END_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_HAPPYNESS_MINE_END_TEXT") % params }
				},
				options = { { _("Unfortunate!"), "finish" } },
				optionsRightAlign = true,
				parentId = "4",
				camera = params.jump_silverore_mine,
				voiceOver = "MISSION_PARADISO_TASK_HAPPYNESS_MINE_END_TEXT.wav",
			}
		end,
	})

	--[[taskutil:new("4ca", {
		onStart = function(self)
			taskutil:setZone("4ca", { polygon = zoneutil.makeCircleZone(params.zone_4ca.pos, params.zone_4ca.radius), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local found = 0
			local assets = game.interface.getEntities(params.zone_4ca, {type = "ASSET_GROUP"})
			for i = 1, #assets do
				local a = game.interface.getEntity(assets[i])
				for k, v in pairs(a.models) do
					if k == "tree/usa/acacia.mdl" then found = found + v end
				end
			end
			local n = params.happiness_trees
			self:setProgressCount(found, n)
			if found >= n then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["4cb"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_HAPPYNESS_TREES_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_HAPPYNESS_TREES_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_HAPPYNESS_TREES_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_forest,
				voiceOver = "MISSION_PARADISO_TASK_HAPPYNESS_TREES_TEXT.wav",
			}
		end,
		guiHandlers = {
		},
	})]]--

	--unused
	--[[
	taskutil:new("4cb", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_HAPPYNESS_TREES_END_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_HAPPYNESS_TREES_END_TEXT") % params }
				},
				options = { { _("Unfortunate!"), "finish" } },
				optionsRightAlign = true,
				parentId = "4",
				camera = params.jump_forest,
				voiceOver = "MISSION_PARADISO_TASK_HAPPYNESS_TREES_END_TEXT.wav",
			}
		end,
	})
	]]--

end
