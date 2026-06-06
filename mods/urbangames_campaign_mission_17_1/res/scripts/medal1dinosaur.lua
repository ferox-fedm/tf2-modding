local taskutil = require "mission.taskutil"
local params = require "params"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_1")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_MEDAL_DINOSAUR_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_MEDAL_DINOSAUR_TEXT") % params },
				},
				camera = params.jump_excavation,
				voiceOver = "MISSION_OILSANDS_MEDAL_DINOSAUR_TEXT.wav",
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m1a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m1a", {
		onStart = function(self)
			taskutil:setZone("m1a", { polygon = zoneutil.makeCircleZone(params.digzone.pos, params.digzone.radius), draw = true, drawColor = colors.BLUE })
			taskutil.userstate.dinoheight = game.interface.getHeight(params.digzone.pos)
			arrivaltracker.track("m1a", { cargotype = "PASSENGERS", from = params.fortmcmurray, to = params.excavation })
		end,
		onUpdate = function(self)
			local done1 = arrivaltracker.get("m1a") > 0
			local done2 = game.interface.getHeight(params.digzone.pos) < taskutil.userstate.dinoheight - 6
			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)
			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("m1a")
			taskutil:setZone("m1a")
			taskutil:setMedalCompleted("MEDAL_1")
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_MEDAL_DINOSAUR_DIG_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_MEDAL_DINOSAUR_DIG_TEXT") },
					{ type = "TASK", text = _("MISSION_OILSANDS_MEDAL_DINOSAUR_DIG_TASK") },
				},
				subTasks = {
					{ name = _("MISSION_OILSANDS_MEDAL_DINOSAUR_DIG_SUB1") % params },
					{ name = _("MISSION_OILSANDS_MEDAL_DINOSAUR_DIG_SUB2") % params },
				},
				camera = params.jump_excavation,
				voiceOver = "MISSION_OILSANDS_MEDAL_DINOSAUR_DIG_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_MEDAL_DINOSAUR_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_OILSANDS_MEDAL_DINOSAUR_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_OILSANDS_MEDAL_DINOSAUR_FINISH_TEXT.wav",
			}
		end,
	})
end
