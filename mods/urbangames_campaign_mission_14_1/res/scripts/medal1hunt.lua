local taskutil = require "mission.taskutil"
local params = require "params"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_1")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_MEDAL_HUNT_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_MEDAL_HUNT_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_huntlocator,
				voiceOver = "MISSION_LEADER_MEDAL_HUNT_TEXT.wav",
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
			for i = 1, 3 do
				local p = params["zone_hunt" .. i].pos
				local r = params["zone_hunt" .. i].radius
				taskutil:setZone("m1a" .. i, { polygon = zoneutil.makeCircleZone(p, r), draw = true, drawColor = colors.BLUE })
			end

			--for debugging:
			--local entities = game.interface.getEntities({ radius = 1e100 }, { type = "ANIMAL" })
			--local k = 0
			--for i = 1, #entities do
			--	local animal = game.interface.getEntity(entities[i])
			--	if animal.modelName:match("bear") then
			--		k = k + 1
			--		taskutil:setMarker("animal" .. k, { entity = entities[i], type = "question" }, self.name, "nothing")
			--	end
			--end
		end,
		onUpdate = function(self)
			--1
			local pathdone = { false, false }
			local progress = 0
			for i = 1, 2 do
				local z1 = params["zone_hunt" .. i]
				local z2 = params["zone_hunt" .. i + 1]
				pathdone[i] = game.interface.findPath({ pos = z1.pos, radius = z1.radius },
				                                      { pos = z2.pos, radius = z2.radius }) ~= nil
				if pathdone[i] then progress = progress + 1 end
			end
			self:setProgressCount(progress, #pathdone, 1)

			--2
			local found = 0
			for i = 1, 3 do
				local assets = game.interface.getEntities({ pos = params["zone_hunt" .. i].pos, radius = params["zone_hunt" .. i].radius - 40 }, {type = "ASSET_GROUP"})
				for i = 1, #assets do
					local a = game.interface.getEntity(assets[i])
					for k, v in pairs(a.models) do
						--if k == "tree/usa/acacia.mdl"
						if k:match("tree") then found = found + v end
					end
				end
			end
			local n = params.tree_amount
			self:setProgressCount(found, n, 2)

			local done1 = progress == #pathdone
			local done2 = found >= n
			local done3 = taskutil.userstate.bearfound == true

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)
			self:setSubtaskCompleted(3, done3)

			if done1 and done2 and done3 then self:finish() end
		end,
		onFinish = function(self)
			for i = 1, 3 do
				taskutil:setZone("m1a" .. i)
			end
			taskutil.userstate.bearfound = nil
			taskutil:setMedalCompleted("MEDAL_1")
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_MEDAL_HUNT_FOREST_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_MEDAL_HUNT_FOREST_TEXT") },
					{ type = "TASK", text = _("MISSION_LEADER_MEDAL_HUNT_FOREST_TASK") },
				},
				subTasks = {
					{ name = _("MISSION_LEADER_MEDAL_HUNT_FOREST_SUB1") % params },
					{ name = _("MISSION_LEADER_MEDAL_HUNT_FOREST_SUB2") % params },
					{ name = _("MISSION_LEADER_MEDAL_HUNT_FOREST_SUB3") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_huntlocator,
				voiceOver = "MISSION_LEADER_MEDAL_HUNT_FOREST_TEXT.wav",
			}
		end,
		handlers = {
			selectanimal = function(self)
				taskutil.userstate.bearfound = true
			end,
		},
		guiHandlers = {
			selectanimal = function(self)
				taskutil:sendScriptFn(self.name, "selectanimal")
			end,
			guiHandleEvent = function(self, id, name, param)
				if id == "mainView" and name == "select" then
					print("select", param)
					local e = game.interface.getEntity(param)
					if e == nil then
						return
					end

					if (e.modelName or "") == "animal/wildlife_bear.mdl" then
						taskutil:sendScriptFn(self.name, "selectanimal")
					end
				end
			end,
		},
	})

	taskutil:new("m1b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_MEDAL_HUNT_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_LEADER_MEDAL_HUNT_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_LEADER_MEDAL_HUNT_FINISH_TEXT.wav",
			}
		end,
	})
end
