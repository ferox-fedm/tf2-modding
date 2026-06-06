local params = require "params"
local util = require "util"
	
return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("4", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track4")
		end,
		onFinish = function(self)
			taskutil.tasks["4b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_THIRD_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_THIRD_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_overviewpos,
				voiceOver = "MISSION_TRANSSIB_TASK_THIRD_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	--[[taskutil:new("4a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["4b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("Entscheidung treffen"),
				paragraphs = {
					{ text = _("Wähle eine Route für den letzten Abschnitt") },
				},
				options = { { _("A) Längere Bauzeit, dafür weniger Materialkosten"), "finish1" }, { _("B) Kürzere Bauzeit, dafür mehr Materialkosten"), "finish2" } },
				parentId = "4",
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

	taskutil:new("4b", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal3", 120)
			util.activate(3)
		end,
		onUpdate = function(self)
			local progress = util.updateSite(self, 3)
			util.upgrade("part4_tracklist", progress)
			if progress >= 1 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("prohibit")
			util.deactivate(3)
			util.upgrade("part4_tracklist", 1)
			--taskutil.tasks["4c"]:start()
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_THIRD_SITE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_THIRD_SITE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_TASK_THIRD_SITE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_TRANSSIB_TASK_THIRD_SITE_SUB1") % params },
					{ name = _("MISSION_TRANSSIB_TASK_THIRD_SITE_SUB2") % params },
				},
				parentId = "4",
				camera = params.jump_construction_site_3,
				voiceOver = "MISSION_TRANSSIB_TASK_THIRD_SITE_TEXT.wav",
			}
		end,
		handlers = {
			showmedal3 = function(self)
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
				end
			end,
		},
	})

	taskutil:new("4c", {
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
			if taskutil.tasks["2c"].start == nil and taskutil.tasks["2c"].finish == nil
			and taskutil.tasks["3c"].start == nil and taskutil.tasks["3c"].finish == nil then
				taskutil.tasks["5"]:start()
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_THIRD_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_THIRD_FINISH_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_TASK_THIRD_FINISH_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_gap3,
				voiceOver = "MISSION_TRANSSIB_TASK_THIRD_FINISH_TEXT.wav",
			}
		end,
	})
end
