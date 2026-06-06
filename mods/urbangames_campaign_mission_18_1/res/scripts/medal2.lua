local taskutil = require "mission.taskutil"
local params = require "params"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_2")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_MEDAL_2_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_MEDAL_2_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_MEDAL_2_TEXT.wav",
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
			}
		end,
		guiHandlers = {
			accept = function(self)
				if taskutil.userstate.choice2a == 1 then
					taskutil:start("m2a")
				else
					taskutil:start("m2b")
				end
				taskutil:finish(self.name)
			end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m2a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local rating = 0
			for i = 1, #params.cities do
				rating = rating + game.interface.getTownTrafficRating(params.cities[i])
			end
			rating = rating / #params.cities
			self:setProgressPercent(rating)
			if rating <= params.trafficrating then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m2c"]:start()
			taskutil:setMedalCompleted("MEDAL_2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_MEDAL_2_IMPLEMENT_NAMEA"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_MEDAL_2_IMPLEMENT_TEXTA") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_MEDAL_2_IMPLEMENT_TASKA") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_MEDAL_2_IMPLEMENT_TEXTA.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
			}
		end,
	})

	taskutil:new("m2b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local arrived = 0
			local sent = 0
			for i = 1, #params.cities do
				local transportsamples = game.interface.getTownTransportSamples(params.cities[i])
				arrived = arrived + transportsamples[1]
				sent = sent + transportsamples[2]
			end
			if sent < 100 then
				arrived = 100
				sent = 100
			end
			local transportrating = arrived / sent
			self:setProgressPercent(transportrating)
			if transportrating <= params.transportrating then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m2c"]:start()
			taskutil:setMedalCompleted("MEDAL_2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_MEDAL_2_IMPLEMENT_NAMEB"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_MEDAL_2_IMPLEMENT_TEXTB") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_MEDAL_2_IMPLEMENT_TASKB") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_MEDAL_2_IMPLEMENT_TEXTB.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
			}
		end,
	})

	taskutil:new("m2c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_MEDAL_2_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_FUTURECITY_MEDAL_2_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_FUTURECITY_MEDAL_2_FINISH_TEXT.wav",
			}
		end,
	})
end
