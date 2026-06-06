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
				name = _("MISSION_FUTURECITY_MEDAL_1_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_MEDAL_1_TEXT") % params },
				},
				camera = params.jump_export,
				voiceOver = "MISSION_FUTURECITY_MEDAL_1_TEXT.wav",
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
				if taskutil.userstate.choice4a == 1 then
					taskutil:start("m1a")
				else
					taskutil:start("m1b")
				end
				taskutil:finish(self.name)
			end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m1a", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.export, "industry/export.con", { export = true })
		end,
		onUpdate = function(self)
			local e = game.interface.getEntity(game.interface.getEntity(params.export).simBuildings[1])
			local count = e.itemsConsumed._sum or 0
			self:setProgressCount(count, params.export_amount)
			if count >= params.export_amount then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_1")
			taskutil.tasks["m1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_MEDAL_1_IMPLEMENT_NAMEA"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_MEDAL_1_IMPLEMENT_TEXTA") },
					{ type = "TASK", text = _("MISSION_FUTURECITY_MEDAL_1_IMPLEMENT_TASKA") % params  },
				},
				camera = params.jump_export,
				voiceOver = "MISSION_FUTURECITY_MEDAL_1_IMPLEMENT_TEXTA.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.export, "industry/export.con", { import = true })
			arrivaltracker.track("m1b", { cargotype = "GOODS", from = params.export })
		end,
		onUpdate = function(self)
			local count = arrivaltracker.get("m1b")
			self:setProgressCount(count, params.import_amount)
			if count >= params.import_amount then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("m1b")
			taskutil:setMedalCompleted("MEDAL_1")
			taskutil.tasks["m1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_MEDAL_1_IMPLEMENT_NAMEB"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_MEDAL_1_IMPLEMENT_TEXTB") },
					{ type = "TASK", text = _("MISSION_FUTURECITY_MEDAL_1_IMPLEMENT_TASKB") % params },
				},
				camera = params.jump_export,
				voiceOver = "MISSION_FUTURECITY_MEDAL_1_IMPLEMENT_TEXTB.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
			}
		end,
	})

	taskutil:new("m1c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_MEDAL_1_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_FUTURECITY_MEDAL_1_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_FUTURECITY_MEDAL_1_FINISH_TEXT.wav",
			}
		end,
	})
end
