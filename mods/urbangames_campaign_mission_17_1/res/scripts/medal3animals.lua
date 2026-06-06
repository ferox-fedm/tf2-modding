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
				name = _("MISSION_OILSANDS_MEDAL_ANIMALS_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_MEDAL_ANIMALS_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_OILSANDS_MEDAL_ANIMALS_TEXT.wav",
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

	taskutil:new("m3a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local entities = game.interface.getEntities({ radius = 1e100 }, { type = "ANIMAL" })
			for i = 1, #entities do
				local animal = game.interface.getEntity(entities[i])
				if animal.modelName ~= "animal/bird_crane.mdl" and
				   animal.modelName ~= "animal/bird_eagle.mdl" and
				   animal.modelName ~= "animal/bird_gull.mdl" and
				   animal.modelName ~= "animal/fish_salmon.mdl" then
					if #game.interface.getEntities({ pos = animal.position, radius = 100 }, { type = "VEHICLE" }) > 0 then
						print(animal.modelName)
						self:finish()
						break
					end
				end
			end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_3")
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_MEDAL_ANIMALS_AREA_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_MEDAL_ANIMALS_AREA_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_MEDAL_ANIMALS_AREA_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_OILSANDS_MEDAL_ANIMALS_AREA_TEXT.wav",
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
				name = _("MISSION_OILSANDS_MEDAL_ANIMALS_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_OILSANDS_MEDAL_ANIMALS_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_OILSANDS_MEDAL_ANIMALS_FINISH_TEXT.wav",
			}
		end,
	})
end
