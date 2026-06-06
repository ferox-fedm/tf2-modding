local taskutil = require "mission.taskutil"
local params = require "params"

return function()
	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_RACE")
			taskutil.userstate.lathamrunning = 1
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_LATHAM_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_MEDAL_LATHAM_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				voiceOver = "MISSION_MACHINES_MEDAL_LATHAM_TEXT.wav",
				camera = params.jump_airfield_latham,
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m3a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m3a", {
		onStart = function(self)
			--set progress to none so that no "task completed" shows up upon failure
			self:setProgressNone()
		end,
		onUpdate = function(self)
			self:setProgressCount(taskutil.userstate.lathamcount, params.lathamcount, 1) 
			
			if taskutil.userstate.lathamairborne then
				self:setProgressText(_("MISSION_MACHINES_MEDAL_LATHAM_SABOTAGE_SUB2_YES"),2)
			else
				self:setProgressText(_("MISSION_MACHINES_MEDAL_LATHAM_SABOTAGE_SUB2_NO"),2)
			end

			if taskutil.userstate.lathamcount >= params.lathamcount then
				self:finish()
			end
		end,
		onFinish = function(self)
			if taskutil.userstate.lathamcount < params.lathamcount then
				taskutil:setMedalCompleted("MEDAL_RACE")
				taskutil.tasks["m3b"]:start()
			else
				taskutil.tasks["m3c"]:start()
			end
			taskutil.userstate.lathamrunning = 0
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_LATHAM_SABOTAGE_NAME"),
				paragraphs = {
					{ text = _("MISSION_MACHINES_MEDAL_LATHAM_SABOTAGE_TEXT") },
					{ type = "TASK", text = _("MISSION_MACHINES_MEDAL_LATHAM_SABOTAGE_TASK") },
					{ type = "HINT", text = _("MISSION_MACHINES_MEDAL_LATHAM_SABOTAGE_HINT") },
				},
				options = { { _("MISSION_MACHINES_MEDAL_LATHAM_SABOTAGE_OPTION"), "sabotage" } }, --Sabotieren
				optionsRightAlign = true,
				subTasks = {
					{ name = _("MISSION_MACHINES_MEDAL_LATHAM_SABOTAGE_SUB1") },
					{ name = "" },
				},
				parentId = "m3",
				voiceOver = "MISSION_MACHINES_MEDAL_LATHAM_SABOTAGE_TEXT.wav",
				camera = params.jump_airfield_latham,
			}
		end,
		handlers = {
			sabotage = function(self)
				if taskutil.userstate.lathamairborne then
					if taskutil.userstate.sabotage == 1 then
						taskutil.userstate.lathamcount = math.max(0, taskutil.userstate.lathamcount - 1)
						taskutil.userstate.sabotage = 0
					end
				else
					taskutil.userstate.lathamcount = taskutil.userstate.lathamcount + 3
				end
			end,
		},
		guiHandlers = {
			sabotage = function(self)
				taskutil:sendScriptFn(self.name, "sabotage")
			end
		},
	})

	taskutil:new("m3b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_LATHAM_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_MACHINES_MEDAL_LATHAM_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_MACHINES_MEDAL_LATHAM_FINISH_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_MACHINES_MEDAL_LATHAM_FINISH_FAIL_NAME"),
				paragraphs = { { text = _("MISSION_MACHINES_MEDAL_LATHAM_FINISH_FAIL_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_MACHINES_MEDAL_LATHAM_FINISH_FAIL_TEXT.wav",
			}
		end,
	})

end
