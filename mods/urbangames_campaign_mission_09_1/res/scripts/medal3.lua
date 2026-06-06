
local taskutil = require "mission.taskutil"
local params = require "params"

local function getAllLineBetweenZones(zone1, zone2)
	local stations1 = game.interface.getEntities(zone1, { type = "STATION" })
	local stations2 = game.interface.getEntities(zone2, { type = "STATION" })

	local result = {}

	for s1Idx = 1, #stations1 do
		local s1Entity = game.interface.getEntity(stations1[s1Idx])
		if s1Entity.carriers["ROAD"] then
			local s1Lines = game.interface.getLines({ stationGroup = s1Entity.stationGroup})
			for s2Idx = 1, #stations2 do
				local s2Entity = game.interface.getEntity(stations2[s2Idx])
				if s2Entity.carriers["ROAD"] then
					local s2Lines = game.interface.getLines({ stationGroup = s2Entity.stationGroup})
					for line1Idx = 1, #s1Lines do
						for line2Idx = 1, #s2Lines do
							if s1Lines[line1Idx] == s2Lines[line2Idx] then
								result[#result + 1] = s1Lines[line1Idx]
							end
						end
					end
				end
			end
		end
	end
	return result
end

return function()
	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_3")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_MEDAL_ESCAPE_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_MEDAL_ESCAPE_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_stgallen,
				voiceOver = "MISSION_SWISSMADE_MEDAL_ESCAPE_TEXT.wav",
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

			local goodlines = getAllLineBetweenZones({ pos = params.pos_stgallen, radius = 250 }, { pos = params.pos_bregenz, radius = 250 })

			local passengers_transported = 0
			for i = 1, #goodlines do
				passengers_transported = passengers_transported + game.interface.getEntity(goodlines[i]).itemsTransported._sum
			end

			self:setSubtaskCompleted(1, #goodlines > 0)
			--self:setProgressCount(passengers_transported, params.passengers_escape, 2)
			self:setSubtaskCompleted(2, passengers_transported > params.passengers_escape)

			if #goodlines > 0 and passengers_transported > params.passengers_escape then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_3")
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_MEDAL_ESCAPE_HELP_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_MEDAL_ESCAPE_HELP_TEXT") },
					{ type = "TASK", text = _("MISSION_SWISSMADE_MEDAL_ESCAPE_HELP_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_SWISSMADE_MEDAL_ESCAPE_HELP_SUB1") },
					{ name = _("MISSION_SWISSMADE_MEDAL_ESCAPE_HELP_SUB2") },
				},
				parentId = "m3",
				camera = params.escape_camera,
				voiceOver = "MISSION_SWISSMADE_MEDAL_ESCAPE_HELP_TEXT.wav",
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
				name = _("MISSION_SWISSMADE_MEDAL_ESCAPE_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_SWISSMADE_MEDAL_ESCAPE_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_SWISSMADE_MEDAL_ESCAPE_FINISH_TEXT.wav",
			}
		end,
	})
end
