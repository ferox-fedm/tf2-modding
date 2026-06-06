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
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_SECOND_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_SECOND_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_overviewpos,
				voiceOver = "MISSION_TRANSSIB_TASK_SECOND_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	--[[taskutil:new("3a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("Entscheidung treffen"),
				paragraphs = {
					{ text = _("Wähle eine Route für den zweiten Abschnitt") },
				},
				options = { { _("Längere Bauzeit, dafür weniger Materialkosten"), "finish1" }, { _("Kürzere Bauzeit, dafür mehr Materialkosten"), "finish2" } },
				parentId = "3",
				camera = { pos.position[1], pos.position[2], 500 },
			}
		end,
		handlers = {
			finish1 = function(self)
				taskutil.userstate.mode = 1
				taskutil:finish(self.name)
			end,
			finish2 = function(self)
				taskutil.userstate.mode = 2
				taskutil:finish(self.name)
			end,
		},
	})]]--

	taskutil:new("3b", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal2", 120)
			util.activate(2)
		end,
		onUpdate = function(self)
			local progress = util.updateSite(self, 2)
			util.upgrade("part3_tracklist", progress)
			if progress >= 1 then self:finish() end
		end,
		onFinish = function(self)
			util.deactivate(2)
			util.upgrade("part3_tracklist", 1)
			--taskutil.tasks["3c"]:start()
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_SECOND_SITE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_SECOND_SITE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_TASK_SECOND_SITE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_TRANSSIB_TASK_THIRD_SITE_SUB2") % params },
				},
				parentId = "3",
				camera = params.jump_construction_site_2,
				voiceOver = "MISSION_TRANSSIB_TASK_SECOND_SITE_TEXT.wav",
			}
		end,
		handlers = {
			showmedal2 = function(self)
				if taskutil.tasks["m3"].start ~= nil then
					taskutil.tasks["m3"]:start()
				end
			end,
		},
	})

	taskutil:new("3c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local a1 = { pos = params.part3_tracklist[1].node0pos, radius = 5 }
			local a2 = { pos = params.part4_tracklist[1].node0pos, radius = 5 }
			if game.interface.findPath(a1, a2, { TRAIN = true }) then
				self:finish()
			end
		end,
		onFinish = function(self)
			if taskutil.tasks["4"].start ~= nil then
				taskutil.tasks["4"]:start()
			end

			if taskutil.tasks["2c"].start == nil and taskutil.tasks["2c"].finish == nil
			and taskutil.tasks["4c"].start == nil and taskutil.tasks["4c"].finish == nil then
				taskutil.tasks["5"]:start()
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_SECOND_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_SECOND_FINISH_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_TASK_SECOND_FINISH_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_gap2,
				voiceOver = "MISSION_TRANSSIB_TASK_SECOND_FINISH_TEXT.wav",
			}
		end,
	})
end
