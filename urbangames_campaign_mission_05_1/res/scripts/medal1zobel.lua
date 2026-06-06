local params = require "params"
local vec2 = require "vec2"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_ZOBEL")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_MEDAL_ZOBEL_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_MEDAL_ZOBEL_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_irkutsk,
				voiceOver = "MISSION_TRANSSIB_MEDAL_ZOBEL_TEXT.wav",
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
			taskutil.userstate.progress_m1a = {}
		end,
		onUpdate = function(self)
			local pos = game.interface.getEntity(params.irkutsk).position
			local stationsid = game.interface.getEntities({pos = pos, radius = 250}, {type = "STATION"})
			local stations = {}
			for i = 1, #stationsid do
				local s = game.interface.getEntity(stationsid[i])
				if s.carriers["ROAD"] and s.cargo == false then
					local p = s.position
					stations[#stations + 1] = { stationsid[i], vec2.new(p[1], p[2]) }
				end
			end
			local t = taskutil.userstate.progress_m1a

			local vehicles = game.interface.getVehicles()
			for i = 1, #vehicles do
				local v = game.interface.getEntity(vehicles[i]).position
				local pv = vec2.new(v[1], v[2])
				for j = 1, #stations do
					local s = stations[j]
					if vec2.distance(pv, s[2]) < 20 then
						t[s[1]] = 1
					end
				end
			end

			local count = 0
			for k, _ in pairs(t) do
				count = count + 1
			end
			local n = params.zobel_stations
			self:setProgressCount(count, n)
			if count >= n then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_MEDAL_ZOBEL_AD_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_MEDAL_ZOBEL_AD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_MEDAL_ZOBEL_AD_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_irkutsk,
				voiceOver = "MISSION_TRANSSIB_MEDAL_ZOBEL_AD_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local pos = game.interface.getEntity(params.irkutsk).position
			local constructions = game.interface.getEntities({pos = pos, radius = 450}, {type = "CONSTRUCTION"})
			local count = 0
			for i = 1, #constructions do
				local c = game.interface.getEntity(constructions[i])
				if c.fileName == "industry/zobel_building.con" then
					count = count + 1
				end
			end
			self:setProgressCount(3 - count, 3)
			if count == 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_ZOBEL")
			taskutil.tasks["m1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_MEDAL_ZOBEL_MEETING_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_MEDAL_ZOBEL_MEETING_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_MEDAL_ZOBEL_MEETING_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_irkutsk,
				voiceOver = "MISSION_TRANSSIB_MEDAL_ZOBEL_MEETING_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_MEDAL_ZOBEL_FINISH_NAME") % params,
				paragraphs = { { text = _("MISSION_TRANSSIB_MEDAL_ZOBEL_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_TRANSSIB_MEDAL_ZOBEL_FINISH_TEXT.wav",
			}
		end,
	})
end
