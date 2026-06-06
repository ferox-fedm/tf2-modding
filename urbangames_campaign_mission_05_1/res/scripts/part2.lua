local params = require "params"
local util = require "util"
local colors = require "mission.colors"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("2", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track2")
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_FIRST_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_FIRST_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_overviewpos,
				voiceOver = "MISSION_TRANSSIB_TASK_FIRST_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	--unused
	--[[
	taskutil:new("2x", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_FIRST_WORKERS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_FIRST_WORKERS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_TASK_FIRST_WORKERS_TASK") % params },
				},
				options = { { _("MISSION_TRANSSIB_TASK_FIRST_WORKERS_OPTION1") % params, "finish1" }, { _("MISSION_TRANSSIB_TASK_FIRST_WORKERS_OPTION2") % params, "finish2" } },
				parentId = "2",
				camera = params.jump_overviewpos,
				voiceOver = "MISSION_TRANSSIB_TASK_FIRST_WORKERS_TEXT.wav",
			}
		end,
		guiHandlers = {
			finish1 = function(self)
				self:finish()
			end,
			finish2 = function(self)
				self:finish()
			end,
		},
	})]]--

	taskutil:new("2a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_FIRST_ROUTE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_FIRST_ROUTE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_TASK_FIRST_ROUTE_TASK") % params },
				},
				options = { { _("MISSION_TRANSSIB_TASK_FIRST_ROUTE_OPTION1") % params, "finish1" }, { _("MISSION_TRANSSIB_TASK_FIRST_ROUTE_OPTION2") % params, "finish2" } },
				parentId = "2",
				camera = params.jump_overviewpos,
				voiceOver = "MISSION_TRANSSIB_TASK_FIRST_ROUTE_TEXT.wav",
			}
		end,
		handlers = {
			setmode = function(self, mode)
				taskutil.userstate.mode = mode
			end
		},
		guiHandlers = {
			finish1 = function(self)
				taskutil:sendScriptFn(self.name, "setmode", { 1 })
				taskutil:finish(self.name)
			end,
			finish2 = function(self)
				taskutil:sendScriptFn(self.name, "setmode", { 2 })
				taskutil:finish(self.name)
			end,
		},
	})

	taskutil:new("2b", {
		onStart = function(self)
			util.activate(1)
			taskutil:invokeLater(self.name, "showmedal1", 120)
		end,
		onUpdate = function(self)
			local progress = util.updateSite(self, 1)
			util.upgrade("part2_tracklist", progress)
			if progress >= 0.3 and taskutil.tasks["3"].start ~= nil then
				taskutil.tasks["3"]:start()
			end
			if progress >= 1 then self:finish() end
		end,
		onFinish = function(self)
			util.deactivate(1)
			util.upgrade("part2_tracklist", 1)
			taskutil:setZone("prohibit",     { polygon = params.prohibit_part3, draw = true , drawColor = colors.RED, buildToolMode = "PROHIBIT" })
			--if taskutil.tasks["2c"].start ~= nil then
			--	taskutil.tasks["2c"]:start()
			--end
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_FIRST_SITE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_FIRST_SITE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_TASK_FIRST_SITE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_TRANSSIB_TASK_THIRD_SITE_SUB1") % params },
				},
				parentId = "2",
				camera = params.jump_construction_site_1,
				voiceOver = "MISSION_TRANSSIB_TASK_FIRST_SITE_TEXT.wav",
			}
		end,
		handlers = {
			showmedal1 = function(self)
				if taskutil.tasks["m1"].start ~= nil then
					taskutil.tasks["m1"]:start()
				end
			end,
		},
	})

	taskutil:new("2c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local a1 = { pos = params.part2_tracklist[1].node0pos, radius = 5 }
			local a2 = { pos = params.part4_tracklist[1].node0pos, radius = 5 }
			if game.interface.findPath(a1, a2, { TRAIN = true }) then
				self:finish()
			end
		end,
		onFinish = function(self)
			if taskutil.tasks["3"].start ~= nil then
				taskutil.tasks["3"]:start()
			end
			if taskutil.tasks["4"].start ~= nil then
				taskutil.tasks["4"]:start()
			end

			if taskutil.tasks["3c"].start == nil and taskutil.tasks["3c"].finish == nil
			and taskutil.tasks["4c"].start == nil and taskutil.tasks["4c"].finish == nil then
				taskutil.tasks["5"]:start()
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_FIRST_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_FIRST_FINISH_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_TASK_FIRST_FINISH_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_gap1,
				voiceOver = "MISSION_TRANSSIB_TASK_FIRST_FINISH_TEXT.wav",
			}
		end,
	})
end
