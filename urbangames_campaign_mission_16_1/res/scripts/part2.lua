local taskutil = require "mission.taskutil"
local vehiclestore = require "mission.vehiclestore"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local vec3 = require "vec3"

return function()
	taskutil:new("2", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track2")
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_TASK_HIGHSPEED_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_HIGHSPEED_TEXT") % params }
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_HIGHSPEED_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount(params.testice, nil)
		end,
		onUpdate = function(self)
			taskutil.userstate.measurements2a = taskutil.userstate.measurements2a or {}
			taskutil.userstate.traindata2a = taskutil.userstate.traindata2a or {}
			local mdata = taskutil.userstate.measurements2a
			local tdata = taskutil.userstate.traindata2a

			mdata[1] = mdata[1] or { { [params.stuttgart] = 1, [params.mannheim] = 1 }, -1 }
			mdata[2] = mdata[2] or { { [params.mannheim] = 1, [params.frankfurt] = 1 }, -1 }
			mdata[3] = mdata[3] or { { [params.frankfurt] = 1, [params.wuerzburg] = 1 }, -1 }
			mdata[4] = mdata[4] or { { [params.wuerzburg] = 1, [params.nuremberg] = 1 }, -1 }

			local trains = game.interface.getVehicles({ carrier = "RAIL" })
			for i = 1, #trains do
				local v = game.interface.getEntity(trains[i])
				if v.vehicles[2] and v.vehicles[2].fileName == params.testice then
					if v.state == "AT_TERMINAL" then
						local line = game.interface.getEntity(v.line)
						local stop = game.interface.getEntity(line.stops[v.stopIndex + 1])
						local station = game.interface.getEntity(stop.stations[1])
						local town = station.town
						local td = tdata[trains[i]]
						if td ~= nil then
							local storedtown = td[1]
							local time = td[2]
							if storedtown ~= town then
								for i = 1, #mdata do
									local cities = mdata[i][1]
									if cities[storedtown] and cities[town] then
										local dt = math.floor(game.interface.getGameTime().time - time)
										if mdata[i][2] == -1 or dt < mdata[i][2] then
											mdata[i][2] = dt
										end
									end
								end
							end
						end
						tdata[trains[i]] = { town, game.interface.getGameTime().time }
					end
				end
			end

			local completed = 0
			for i = 1, #mdata do
				local time = mdata[i][2]
				if time < 0 then
					time = "?/"
					self:setProgressText(time .. params.timedata[i], i)
				elseif time <= params.timedata[i] then
					completed = completed + 1
					self:setSubtaskCompleted(i)
				else
					self:setProgressCount(time, params.timedata[i], i)
				end
			end

			if completed == #mdata then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.measurements2a = nil
			taskutil.userstate.traindata2a = nil
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_TASK_HIGHSPEED_PLAN_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_HIGHSPEED_PLAN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ICE_TASK_HIGHSPEED_PLAN_TASK") % params },
					{ type = "HINT", text = _("MISSION_ICE_TASK_HIGHSPEED_PLAN_HINT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_HIGHSPEED_PLAN_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_ICE_TASK_HIGHSPEED_PLAN_SUB1") },
					{ name = _("MISSION_ICE_TASK_HIGHSPEED_PLAN_SUB2") },
					{ name = _("MISSION_ICE_TASK_HIGHSPEED_PLAN_SUB3") },
					{ name = _("MISSION_ICE_TASK_HIGHSPEED_PLAN_SUB4") },
				},
				parentId = "2",
			}
		end,
	})

	local oldpositions = {}
	taskutil:new("2b", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount(params.regularice, nil)
		end,
		onUpdate = function(self)
			taskutil.userstate.meters2b = taskutil.userstate.meters2b or 0
			local icecount = 0
			local positions = {}
			local trains = game.interface.getVehicles({ carrier = "RAIL" })
			for i = 1, #trains do
				local v = game.interface.getEntity(trains[i])
				if v.vehicles[2] and v.vehicles[2].fileName == params.regularice then
					icecount = icecount + 1

					positions[v.id] = v.position
					if oldpositions[v.id] ~= nil then
						local x = vec3.new(table.unpack(positions[v.id]))
						local y = vec3.new(table.unpack(oldpositions[v.id]))
						taskutil.userstate.meters2b = taskutil.userstate.meters2b + vec3.distance(x, y)
					end
				end
			end
			oldpositions = positions
			local meters = math.floor(taskutil.userstate.meters2b)

			self:setProgressCount(icecount, params.icecount, 1)
			self:setProgressText(meters .. "/" .. params.icemeter .. " " .. _("meters"), 2)

			local done1 = icecount >= params.icecount
			local done2 = taskutil.userstate.meters2b >= params.icemeter

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_TASK_HIGHSPEED_OPERATE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_HIGHSPEED_OPERATE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ICE_TASK_HIGHSPEED_OPERATE_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_HIGHSPEED_OPERATE_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_ICE_TASK_HIGHSPEED_OPERATE_SUB1") },
					{ name = _("MISSION_ICE_TASK_HIGHSPEED_OPERATE_SUB2") },
				},
				parentId = "2",
			}
		end,
	})
end
