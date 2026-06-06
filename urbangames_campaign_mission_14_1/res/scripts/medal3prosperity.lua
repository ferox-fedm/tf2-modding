local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_3")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_MEDAL_PROSPERITY_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_MEDAL_PROSPERITY_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_tribunelocator,
				voiceOver = "MISSION_LEADER_MEDAL_PROSPERITY_TEXT.wav",
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
			for i = 1, 4 do
				game.interface.upgradeConstruction(params["tribune" .. i], "industry/tribune.con", {
					productionLevel = 3,
					commercialCapacity = 100,
				})
			end
			for i = 1, 4 do
				arrivaltracker.track("m3a" .. i, { cargotype = "PASSENGERS", to = params["tribune" .. i] })
			end
		end,
		onUpdate = function(self)
			--1
			local found = 0
			for i = 1, 4 do
				local assets = game.interface.getEntities({ pos = params["pos_tribune" .. i], radius = 80 }, {type = "ASSET_GROUP"})
				for i = 1, #assets do
					local a = game.interface.getEntity(assets[i])
					for k, v in pairs(a.models) do
						--if k == "tree/usa/acacia.mdl"
						if k:match("apple") then found = found + v end
					end
				end
			end
			local n = params.tree_prosperity_amount
			self:setProgressCount(found, n, 1)

			--2
			local unloaded = 0
			for i = 1, 4 do
				unloaded = unloaded + arrivaltracker.get("m3a" .. i)
			end
			self:setProgressCount(unloaded, params.people_tribune_amount, 2)

			local done1 = found >= n
			local done2 = unloaded >= params.people_tribune_amount

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			for i = 1, 4 do
				arrivaltracker.track("m3a" .. i)
			end
			taskutil:setMedalCompleted("MEDAL_3")
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_MEDAL_PROSPERITY_TRIUMPHAL_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_MEDAL_PROSPERITY_TRIUMPHAL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_MEDAL_PROSPERITY_TRIUMPHAL_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_LEADER_MEDAL_PROSPERITY_TRIUMPHAL_SUB1") % params },
					{ name = _("MISSION_LEADER_MEDAL_PROSPERITY_TRIUMPHAL_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
				camera = params.jump_tribunelocator,
				voiceOver = "MISSION_LEADER_MEDAL_PROSPERITY_TRIUMPHAL_TEXT.wav",
			}
		end,
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
				name = _("MISSION_LEADER_MEDAL_PROSPERITY_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_LEADER_MEDAL_PROSPERITY_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_LEADER_MEDAL_PROSPERITY_FINISH_TEXT.wav",
			}
		end,
	})
end
