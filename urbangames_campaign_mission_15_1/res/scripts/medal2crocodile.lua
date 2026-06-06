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
				name = _("MISSION_VICECOUNTY_MEDAL_CROCODILE_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_MEDAL_CROCODILE_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_crocodile_area,
				voiceOver = "MISSION_VICECOUNTY_MEDAL_CROCODILE_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m2a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m2a", {
		onStart = function(self)
			taskutil:setZone("m2a", { polygon = zoneutil.makeCircleZone(params.crocodile_area.pos, params.crocodile_area.radius), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local count = 0
			local entities = game.interface.getEntities({ pos = params.crocodile_area.pos, radius = params.crocodile_area.radius }, { type = "VEHICLE" } )
			for i = 1, #entities do
				local e = game.interface.getEntity(entities[i])
				if e.vehicles[1].fileName == "vehicle/ship/srn6_v2.mdl" then
					count = count + 1
				end
			end
			self:setProgressCount(count, params.crocodile_boat_count, 1)
			if count >= params.crocodile_boat_count then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("m2a")
			taskutil:setMedalCompleted("MEDAL_2")
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_MEDAL_CROCODILE_REMOVE_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_MEDAL_CROCODILE_REMOVE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_MEDAL_CROCODILE_REMOVE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_MEDAL_CROCODILE_REMOVE_SUB1") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_crocodile_area,
				voiceOver = "MISSION_VICECOUNTY_MEDAL_CROCODILE_REMOVE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m2b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_MEDAL_CROCODILE_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_VICECOUNTY_MEDAL_CROCODILE_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_VICECOUNTY_MEDAL_CROCODILE_FINISH_TEXT.wav",
			}
		end,
	})
end
