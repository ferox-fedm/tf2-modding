local taskutil = require "mission.taskutil"
local params = require "params"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"

return function()
	taskutil:new("m5", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_5")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_GARDEN_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_MEDAL_GARDEN_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = { params.zone_m5.pos[1], params.zone_m5.pos[2], 500 },
				voiceOver = "MISSION_SHINKANSEN_MEDAL_GARDEN_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m5a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m5a", {
		onStart = function(self)
			taskutil:setZone("m5", { polygon = zoneutil.makeCircleZone(params.zone_m5.pos, params.zone_m5.radius), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local trees = 0
			local rocks = 0
			local assets = game.interface.getEntities(params.zone_m5, {type = "ASSET_GROUP"})
			for i = 1, #assets do
				local a = game.interface.getEntity(assets[i])
				for k, v in pairs(a.models) do
					if k:match("tree") then trees = trees + 1 end
					if k:match("rock") then rocks = rocks + 1 end
				end
			end
			local m = 16
			local n = 14
			self:setProgressText("" .. rocks, 1)
			self:setProgressText("" .. trees, 2)
			self:setSubtaskCompleted(1, rocks == m)
			self:setSubtaskCompleted(2, trees == n)
			if rocks == m and trees == n then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setZone("m5")
			taskutil:setMedalCompleted("MEDAL_5")
			taskutil.tasks["m5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_GARDEN_DECO_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_MEDAL_GARDEN_DECO_TEXT") },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_MEDAL_GARDEN_DECO_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_SHINKANSEN_MEDAL_GARDEN_DECO_SUB1") },
					{ name = _("MISSION_SHINKANSEN_MEDAL_GARDEN_DECO_SUB2") },
				},
				parentId = "m5",
				camera = { params.zone_m5.pos[1], params.zone_m5.pos[2], 500 },
				voiceOver = "MISSION_SHINKANSEN_MEDAL_GARDEN_DECO_TEXT.wav",
			}
		end,
	})

	taskutil:new("m5b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_GARDEN_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_SHINKANSEN_MEDAL_GARDEN_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m5",
				voiceOver = "MISSION_SHINKANSEN_MEDAL_GARDEN_FINISH_TEXT.wav",
			}
		end,
	})
end
