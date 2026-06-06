local taskutil = require "mission.taskutil"
local params = require "params"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local util = require "util"

return function()
	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_2")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_FIRSTTRY_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_MEDAL_FIRSTTRY_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_MEDAL_FIRSTTRY_TEXT.wav",
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
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
		end,
		onUpdate = function(self)
			if not taskutil.userstate.choice4a then return end
			local forbiddenzone = taskutil.userstate.choice4a == 1 and params.zone_b or params.zone_a

			if taskutil.userstate.datam2a == nil then
				local towns = util.collecttowns(forbiddenzone)
				local data = {}
				for i = 1, #towns do
					data[towns[i]] = 1
				end
				taskutil.userstate.datam2a = data
			end

			local data = taskutil.userstate.datam2a

			util.collecttownsfromregionaltrains(function(townid)
				data[townid] = nil
			end)

			local count = 0
			for _, _ in pairs(data) do
				count = count + 1
			end

			if taskutil.userstate.m2atowncount == nil then
				taskutil.userstate.m2atowncount = count
			end

			count = taskutil.userstate.m2atowncount - count

			self:setProgressCount(count, params.towns_to_visit_count, 1)

			if count >= params.towns_to_visit_count then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m2win"]:start()
		end,
		getInfo = function(self)
			local camera
			if taskutil.userstate.choice4a == 1 then camera = params.jump_bayern end
			if taskutil.userstate.choice4a == 2 then camera = params.jump_bw end
			return {
				name = _("MISSION_ICE_MEDAL_FIRSTTRY_REGION_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_MEDAL_FIRSTTRY_REGION_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ICE_MEDAL_FIRSTTRY_REGION_TASK") % { zone = params.zone_names_not[taskutil.userstate.choice4a]} },
				},
				subTasks = {
					{ name = _("MISSION_ICE_MEDAL_FIRSTTRY_REGION_SUB1") % params },
				},
				camera = camera,
				voiceOver = "MISSION_ICE_MEDAL_FIRSTTRY_REGION_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
			}
		end,
	})

	taskutil:new("m2win", {
		onStart = function(self)
			taskutil:setMedalCompleted("MEDAL_2")
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_FIRSTTRY_SUCCESS_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_ICE_MEDAL_FIRSTTRY_SUCCESS_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
			}
		end,
	})

	taskutil:new("m2loss", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_MEDAL_FIRSTTRY_FAIL_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_ICE_MEDAL_FIRSTTRY_FAIL_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_ICE_MEDAL_FIRSTTRY_FAIL_FINISH_TEXT.wav",
			}
		end,
	})
end
