local taskutil = require "mission.taskutil"
local params = require "params"

return function()
	taskutil:new("m4", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_4")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_MEDAL_EMISSION_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_MEDAL_EMISSION_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = {-1000, 0, 1500},
				voiceOver = "MISSION_TWENTIES_MEDAL_EMISSION_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m4b") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m4a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local emission = 0
			for _, city in pairs({ params.minneapolis, params.stpaul }) do
				emission = emission + (10 * math.log(game.interface.getTownEmission(city) / math.pow(10,-12), 10))
			end
			emission = 0.5 * emission
			self:setProgressCount(emission, 60)
			if emission <= 60 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m4b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_MEDAL_EMISSION_IMPROVE_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_MEDAL_EMISSION_IMPROVE_TEXT") },
					{ type = "TASK", text = _("MISSION_TWENTIES_MEDAL_EMISSION_IMPROVE_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m4",
				camera = {-1000, 0, 1500},
				voiceOver = "MISSION_TWENTIES_MEDAL_EMISSION_IMPROVE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m4b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local count = 0
			for j = 1, 2 do
				local pos
				if j == 1 then pos = params.pos_minneapolis
				else pos = params.pos_stpaul end
				local trees = game.interface.getEntities({pos = pos, radius = 500}, {type = "ASSET_GROUP"})
				for i = 1, #trees do
					local e = game.interface.getEntity(trees[i])
					local e1 = e.models
					if e1 ~= nil then
						local e2,_ = next(e1)
						if e2 ~= nil then
							if e2:sub(1, 4) == "tree" then
								count = count + 1
							end
						end
					end
				end
			end
			self:setProgressCount(count, params.trees_m4)
			if count >= params.trees_m4 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m4c"]:start()
			taskutil:setMedalCompleted("MEDAL_4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_MEDAL_EMISSION_TREES_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_MEDAL_EMISSION_TREES_TEXT") },
					{ type = "TASK", text = _("MISSION_TWENTIES_MEDAL_EMISSION_TREES_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m4",
				camera = {-1000, 0, 1500},
				voiceOver = "MISSION_TWENTIES_MEDAL_EMISSION_TREES_TEXT.wav",
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
				name = _("MISSION_TWENTIES_MEDAL_EMISSION_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_TWENTIES_MEDAL_EMISSION_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m4",
				camera = {-1000, 0, 1500},
				voiceOver = "MISSION_TWENTIES_MEDAL_EMISSION_FINISH_TEXT.wav",
			}
		end,
	})
end
