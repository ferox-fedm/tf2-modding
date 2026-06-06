local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_3")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_MEDAL_3_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_MEDAL_3_TEXT") % params },
				},
				camera = params.jump_pearl,
				voiceOver = "MISSION_FUTURECITY_MEDAL_3_TEXT.wav",
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
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

	local function upgradeTower(level)
		game.interface.upgradeConstruction(params.pearl, "industry/pearl.con", {
			industrialCapacity = 100,
			productionLevel = level,
		})
	end

	taskutil:new("m3a", {
		onStart = function(self)
			upgradeTower(0)
			arrivaltracker.track("m3aworkers", { cargotype = "PASSENGERS", to = params.pearl })
		end,
		onUpdate = function(self)
			local c1 = arrivaltracker.get("m3aworkers")

			self:setProgressCount(c1, params.pearlworkers, 1)

			local done = c1 >= params.pearlworkers

			local level = math.floor(4 * math.min(1, c1 / params.pearlworkers))
			if (game.interface.getEntity(params.pearl).params.productionLevel or 0) < level then
				upgradeTower(level)
			end

			self:setSubtaskCompleted(1, done)

			if done then self:finish() end
		end,
		onFinish = function(self)
			upgradeTower(4)
			arrivaltracker.track("m3aworkers")
			arrivaltracker.track("m3aconmat")
			taskutil.tasks["m3b"]:start()
			taskutil:setMedalCompleted("MEDAL_3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_MEDAL_3_IMPLEMENT_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_MEDAL_3_IMPLEMENT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_MEDAL_3_IMPLEMENT_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_FUTURECITY_MEDAL_3_IMPLEMENT_SUB1") % params },
					--{ name = _("MISSION_FUTURECITY_MEDAL_3_IMPLEMENT_SUB2") % params },
				},
				camera = params.jump_pearl,
				voiceOver = "MISSION_FUTURECITY_MEDAL_3_IMPLEMENT_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "m3",
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
				name = _("MISSION_FUTURECITY_MEDAL_3_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_FUTURECITY_MEDAL_3_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_FUTURECITY_MEDAL_3_FINISH_TEXT.wav",
			}
		end,
	})
end
