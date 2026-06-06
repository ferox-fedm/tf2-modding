local params = require "params"
local util = require "util"

return function(taskutil)
	local tasks = taskutil.tasks

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
				name = _("MISSION_BAGDAD_TASK_HQ_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_HQ_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_adana_harbor,
				voiceOver = "MISSION_BAGDAD_TASK_HQ_TEXT.wav",
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
			local hq = util.getHq()
			if hq ~= nil then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_TASK_HQ_BUILD_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_HQ_BUILD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_TASK_HQ_BUILD_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_adana,
				voiceOver = "MISSION_BAGDAD_TASK_HQ_BUILD_TEXT.wav",
			}
		end,
	})

	taskutil:new("3b", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.silver_mine, "industry/silver_mine.con", { productionLevel = 0, output = { SILVER_ORE = 1 }, capacity = 400 })
		end,
		onUpdate = function(self)
			local hq = util.getHq()
			local processed = 0
			if hq ~= nil then
				processed = game.interface.getEntity(hq.simBuildings[1]).itemsConsumed.SILVER_ORE or 0
			end
			self:setProgressCount(processed, params.hq_silver_amount)
			if processed >= params.hq_silver_amount then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["3c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_TASK_HQ_SILVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_HQ_SILVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_TASK_HQ_SILVER_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_silver_mine,
				voiceOver = "MISSION_BAGDAD_TASK_HQ_SILVER_TEXT.wav",
			}
		end,
	})

	taskutil:new("3c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			game.interface.setPlayer(params.airailline, game.interface.getPlayer())
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_TASK_HQ_RAILROAD_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_HQ_RAILROAD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_TASK_HQ_RAILROAD_TASK") % params },
				},
				options = { { _("MISSION_BAGDAD_TASK_HQ_RAILROAD_OPTION") % params, "finish" } },
				optionsRightAlign = true,
				parentId = "3",
				camera = params.jump_line,
				voiceOver = "MISSION_BAGDAD_TASK_HQ_RAILROAD_TEXT.wav",
			}
		end,
	})
end
