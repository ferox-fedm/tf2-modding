local taskutil = require "mission.taskutil"
local params = require "params"

return function()
	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_2")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_PILOT_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_PILOT_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_golfcourse,
				voiceOver = "MISSION_STARFLIGHT_MEDAL_PILOT_TEXT.wav",
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
			taskutil.userstate.planedata_m2a = taskutil.userstate.planedata_m2a or {}
			local d = taskutil.userstate.planedata_m2a

			local count = taskutil.userstate.landings_m2a or 0

			local stopids = {}
			local cons = game.interface.getEntities({ pos = params.pos_golfcourse, radius = params.airfield_distance_to_golfcourse }, { type = "CONSTRUCTION" })
			for i = 1, #cons do
				local c = game.interface.getEntity(cons[i])
				if c.fileName == "station/air/airfield.con" then
					local s = game.interface.getEntity(cons[i]).stations[1]
					if s then
						stopids[game.interface.getEntity(s).stationGroup] = 1
					end
				end
			end

			local vehicles = game.interface.getVehicles({ carrier = "AIR" })
			for i = 1, #vehicles do
				local e = game.interface.getEntity(vehicles[i])

				local planepos = e.position
				local z = game.interface.getHeight({planepos[1], planepos[2]})
				local flying = planepos[3] - z > 35
				if flying then
					d[vehicles[i]] = 1
				end

				if e.stopIndex >= 0 then
					local l = game.interface.getEntity(e.line)
					if stopids[l.stops[e.stopIndex + 1]] then
						if e.state == "AT_TERMINAL" and d[vehicles[i]] then
							d[vehicles[i]] = nil
							count = count + 1
						end
					end
				end
			end

			taskutil.userstate.landings_m2a = count
			self:setProgressCount(count, params.num_landings_at_golfcourse)
			if count >= params.num_landings_at_golfcourse then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_PILOT_TRAIN_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_PILOT_TRAIN_TEXT") },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_MEDAL_PILOT_TRAIN_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_golfcourse,
				voiceOver = "MISSION_STARFLIGHT_MEDAL_PILOT_TRAIN_TEXT.wav",
			}
		end,
	})

	taskutil:new("m2b", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.hospital, "industry/hospital.con", { productionLevel = 0, active = true })
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.hospital).simBuildings[1]).itemsConsumed
			local x0 = c.TOOLS or 0
			local x1 = c.STEEL or 0
			if x0 > 0 and x1 > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_2")
			taskutil.tasks["m2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_PILOT_BED_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_PILOT_BED_TEXT") },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_MEDAL_PILOT_BED_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_hospital,
				voiceOver = "MISSION_STARFLIGHT_MEDAL_PILOT_BED_TEXT.wav",
			}
		end,
	})

	taskutil:new("m2c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_PILOT_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_STARFLIGHT_MEDAL_PILOT_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_STARFLIGHT_MEDAL_PILOT_FINISH_TEXT.wav",
			}
		end,
	})
end
