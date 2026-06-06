local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local calendar = require "mission.calendar"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local util = require "util"

return function()
	taskutil:new("3", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track3")
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_TASK_PRIVATE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_PRIVATE_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_PRIVATE_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
			util.foralltrainstations(params.cregional, function (con)
				game.interface.setBulldozeable(con.id, true)
			end)
			taskutil:invokeLater(self.name, "showm1", 120)
		end,
		onUpdate = function(self)
			local platformcount = 0
			local trackcount = 0
			for i = 1, #params.cregional do
				local town = params.cregional[i]
				local stations = game.interface.getStations({ town = town, carrier = "RAIL" })
				for j = 1, #stations do
					local con = util.station2construction(stations[j])
					local m = con.params.modules
					for _, v in pairs(m) do
						if v.name == "station/rail/modular_station/platform_passenger_era_c.module" then
							platformcount = platformcount + 1
						elseif v.name == "station/rail/modular_station/platform_high_speed_track_catenary.module" then
							trackcount = trackcount + 1
						elseif v.name == "station/rail/modular_station/platform_track_catenary.module" then
							trackcount = trackcount + 1
						end
					end
				end
			end

			platformcount = platformcount * 40
			trackcount = trackcount * 40

			self:setProgressText(tostring(platformcount - params.platformcount), 1)
			self:setProgressText(tostring(trackcount - params.trackcount), 2)

			local done1 = platformcount <= params.platformcount
			local done2 = trackcount <= params.trackcount

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_TASK_PRIVATE_REDUCE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_PRIVATE_REDUCE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ICE_TASK_PRIVATE_REDUCE_TASK") % params },
					{ type = "HINT", text = _("MISSION_ICE_TASK_PRIVATE_REDUCE_HINT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_PRIVATE_REDUCE_TEXT.wav",
				subTasks = {
					{ name = _("MISSION_ICE_TASK_PRIVATE_REDUCE_SUB1") % params },
					{ name = _("MISSION_ICE_TASK_PRIVATE_REDUCE_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
			}
		end,
		handlers = {
			showm1 = function(self)
				if taskutil.tasks["m1"].start ~= nil then
					taskutil.tasks["m1"]:start()
				end
			end,
		},
	})

	taskutil:new("3b", {
		onStart = function(self)
			taskutil.userstate.time3b =  game.interface.getGameTime().time
		end,
		onUpdate = function(self)
			local time = game.interface.getGameTime().time
			local income = game.interface.getPlayerJournal(math.max(taskutil.userstate.time3b, (time - calendar.secondsperyearif(params.millisperday))) * 1000, time * 1000).income._sum
			self:setProgressText(string.makeMoneyString(income) .. "/" .. string.makeMoneyString(params.revenue))
			if income >= params.revenue then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_TASK_PRIVATE_REVENUE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_PRIVATE_REVENUE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ICE_TASK_PRIVATE_REVENUE_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_PRIVATE_REVENUE_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
			}
		end,
	})
end
