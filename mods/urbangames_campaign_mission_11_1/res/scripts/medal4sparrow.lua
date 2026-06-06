local taskutil = require "mission.taskutil"
local params = require "params"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"
local polygonutil = require "polygonutil"

return function()
	taskutil:new("m4", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_4")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_MEDAL_SPARROW_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_MEDAL_SPARROW_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_MEDAL_SPARROW_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m4a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m4a", {
		onStart = function(self)
			taskutil.userstate.noisetodo = params.bulldoze_count
			taskutil:setProposal("bulldoze", self.name, "bulldoze")
		end,
		onUpdate = function(self)
			self:setProgressCount(params.bulldoze_count - taskutil.userstate.noisetodo, params.bulldoze_count, 1)
		end,
		onFinish = function(self)
			taskutil:setProposal("bulldoze")
			taskutil.tasks["m4b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_MEDAL_SPARROW_NOISE_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_MEDAL_SPARROW_NOISE_TEXT") },
					{ type = "TASK", text = _("MISSION_REDSTAR_MEDAL_SPARROW_NOISE_TASK") },
				},
				subTasks = {
					{ name = _("MISSION_REDSTAR_MEDAL_SPARROW_NOISE_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m4",
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_MEDAL_SPARROW_NOISE_TEXT.wav",
			}
		end,
		handlers = {
			bulldoze = function(self)
				taskutil.userstate.noisetodo = taskutil.userstate.noisetodo - 1
				if taskutil.userstate.noisetodo <= 0 then
					taskutil.userstate.noisetodo = nil
					taskutil:finish(self.name)
				end
			end,
		},
		guiHandlers = {
			bulldoze = function(self, id, name, param, isApply)
				if not isApply or self.finish == nil or taskutil.userstate.noisetodo == nil then return end
				taskutil:sendScriptFn(self.name, "bulldoze")
			end,
		},
	})

	taskutil:new("m4b", {
		onStart = function(self)
			taskutil:setZone("pesticide1", { polygon = zoneutil.makeCircleZone(params.pesticide_zone1.pos, params.pesticide_zone1.radius), draw = true, drawColor = colors.RED })
			taskutil:setZone("pesticide2", { polygon = zoneutil.makeCircleZone(params.pesticide_zone2.pos, params.pesticide_zone2.radius), draw = true, drawColor = colors.RED })
			taskutil.userstate.m4b1_completed = false
			taskutil.userstate.m4b2_completed = false
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getVehicles({ carrier = "ROAD" })
			local poly1 = zoneutil.makeCircleZone(params.pesticide_zone1.pos, params.pesticide_zone1.radius)
			local poly2 = zoneutil.makeCircleZone(params.pesticide_zone2.pos, params.pesticide_zone2.radius)
			local count = 0
			for j = 1, 2 do
				if taskutil.userstate["m4b" .. j .. "_completed"] == false then
					local poly = poly1
					if j == 2 then poly = poly2 end
					for i = 1, #vehicles do
						local pos = game.interface.getEntity(vehicles[i]).position
						if polygonutil.contains(poly, pos) then
							taskutil.userstate["m4b" .. j .. "_completed"] = true
							break
						end
					end
				end
				if taskutil.userstate["m4b" .. j .. "_completed"] == true then
					count = count + 1
				end
			end
			self:setProgressCount(count, 2, 1)
			if count == 2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("pesticide1")
			taskutil:setZone("pesticide2")
			taskutil:setMedalCompleted("MEDAL_4")
			taskutil.tasks["m4c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_MEDAL_SPARROW_BUGS_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_MEDAL_SPARROW_BUGS_TEXT") },
					{ type = "TASK", text = _("MISSION_REDSTAR_MEDAL_SPARROW_BUGS_TASK") },
				},
				subTasks = {
					{ name = _("MISSION_REDSTAR_MEDAL_SPARROW_BUGS_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m4",
				camera = { -700, 500, 1500 },
				voiceOver = "MISSION_REDSTAR_MEDAL_SPARROW_BUGS_TEXT.wav",
			}
		end,
	})

	taskutil:new("m4c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_MEDAL_SPARROW_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_REDSTAR_MEDAL_SPARROW_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m4",
				voiceOver = "MISSION_REDSTAR_MEDAL_SPARROW_FINISH_TEXT.wav",
			}
		end,
	})
end
