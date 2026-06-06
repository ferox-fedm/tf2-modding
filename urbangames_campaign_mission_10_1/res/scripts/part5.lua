local taskutil = require "mission.taskutil"
local params = require "params"
local proposalutil = require "mission.proposalutil"
local util = require "util"
local vec2 = require "vec2"

return function()
	taskutil:new("5", {
		onStart = function(self)
			taskutil:setMusicTrack("track5")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["5a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PREMIERE_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PREMIERE_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_premiere,
				voiceOver = "MISSION_STARFLIGHT_TASK_PREMIERE_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
			taskutil.userstate.donecount5 = 0
			taskutil:setMarker("5a3", { entity = params.party,            type = "question" }, "1", "5a3")
			taskutil:setMarker("5a4", { entity = params.premiere,         type = "question" }, "1", "5a4")
			taskutil:setMarker("5a5", { entity = params.trainstation_la,  type = "question" }, "1", "5a5")
		end,
		onUpdate = function(self)
			if taskutil.userstate.donecount5 >= 3 then self:finish() end
			self:setProgressCount(taskutil.userstate.donecount5, 3)
		end,
		onFinish = function(self)
			game.interface.upgradeConstruction(params.premiere, "industry/premiere.con", { productionLevel = 0, active = true })
			util.endchapter(5)
			taskutil.userstate.targetbalance = math.floor(0.5 + (game.interface.getEntity(game.interface.getPlayer()).balance + params.targetbalance) / 1000000) * 1000000
			taskutil.userstate.totalincome = 0
			taskutil.tasks["5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PREMIERE_ORGANIZE_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PREMIERE_ORGANIZE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_PREMIERE_ORGANIZE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_premiere,
				voiceOver = "MISSION_STARFLIGHT_TASK_PREMIERE_ORGANIZE_TEXT.wav",
			}
		end,
	})

	taskutil:new("5a3", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.party, "industry/party.con", { productionLevel = 0, active2 = true })
		end,
		onUpdate = function(self)
			local stations = game.interface.getEntities({pos = params.pos_party, radius = 200}, {type = "STATION"})
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.FOOD or 0
				if s > 0 then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.userstate.donecount5 = taskutil.userstate.donecount5 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PREMIERE_ICE_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PREMIERE_ICE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_PREMIERE_ICE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_party,
				voiceOver = "MISSION_STARFLIGHT_TASK_PREMIERE_ICE_TEXT.wav",
			}
		end,
	})

	taskutil:new("5a4", {
		onStart = function(self)
			taskutil.userstate.bustable = {}
		end,
		onUpdate = function(self)
			local lines = game.interface.getLines()
			local goodlines = {}
			for l = 1, #lines do
				local found0 = false
				local found1 = false
				local premiereidx = 0
				local stops = game.interface.getEntity(lines[l]).stops
				if #stops == 2 then
					for i = 1, #stops do
						local pos = vec2.new(table.unpack(game.interface.getEntity(stops[i]).position))
						if vec2.distance(pos, vec2.new(table.unpack(params.pos_airport_la))) < 400 then found0 = true end
						if vec2.distance(pos, vec2.new(table.unpack(params.pos_premiere))) < 100 then found1 = true premiereidx = i end
					end
					if found0 and found1 and #util.line2vehicles(lines[l]) > 0 then goodlines[lines[l]] = premiereidx end
				end
			end

			self:setSubtaskCompleted(1, next(goodlines) ~= nil)

			local t = taskutil.userstate.bustable
			local vehicles = game.interface.getVehicles()
			local max = 0
			local time = game.interface.getGameTime().time
			local found
			for i = 1, #vehicles do
				local id = vehicles[i]
				local v = game.interface.getEntity(id)
				local premiereidx = goodlines[v.line]
				if premiereidx == v.stopIndex + 1 then
					if (v.carrier == "ROAD" or v.carrier == "TRAM") and (v.cargoLoad.PASSENGERS or 0) > 0 then
						found = true
						if v.state == "EN_ROUTE" then
							if t[id] == nil then
								t[id] = time
							end
						else
							t[id] = nil
						end
						if t[id] then
							local d = time - t[id]
							max = math.max(d, max)
						end
					end
				end
			end

			self:setSubtaskCompleted(2, found == true)

			self:setProgressCount(max, params.line_minutes * 60, 3)
			if max >= params.line_minutes * 60 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.donecount5 = taskutil.userstate.donecount5 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PREMIERE_PRESS_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PREMIERE_PRESS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_PREMIERE_PRESS_TASK") % params },
					{ type = "HINT", text = _("MISSION_STARFLIGHT_TASK_PREMIERE_PRESS_HINT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_TASK_PREMIERE_PRESS_SUB1") },
					{ name = _("MISSION_STARFLIGHT_TASK_PREMIERE_PRESS_SUB2") },
					{ name = _("MISSION_STARFLIGHT_TASK_PREMIERE_PRESS_SUB3") },
				},
				parentId = "5",
				camera = params.jump_premiere,
				voiceOver = "MISSION_STARFLIGHT_TASK_PREMIERE_PRESS_TEXT.wav",
			}
		end,
	})

	taskutil:new("5a5", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.premiere, "industry/premiere.con", { productionLevel = 0, active = true })
		end,
		onUpdate = function(self)
			local la = game.interface.getEntity(params.trainstation_la)
			local sf = game.interface.getEntity(params.trainstation_sanfrancisco)
			local stations1 = la.stations
			local stations2 = sf.stations

			local done1 = false
			for i = 1, #stations1 do
				for j = 1, #stations2 do
					local path = game.interface.findPath(stations1[i], stations2[j], { TRAIN = true })
					if path ~= nil then
						done1 = true
						break
					end
				end
				if done1 then break end
			end

			if not done1 then return end

			local vehicles = game.interface.getVehicles({ carrier = "RAIL" })
			local linesWithVehicles = {}
			for i = 1, #vehicles do
				local v = game.interface.getEntity(vehicles[i])
				if v.line >= 0 then linesWithVehicles[v.line] = 1 end
			end

			local done2 = false
			local lines = game.interface.getLines()
			for i = 1, #lines do
				local l = game.interface.getEntity(lines[i])

				if linesWithVehicles[lines[i]] then
					local stops = {}
					for j = 1, #l.stops do
						stops[l.stops[j]] = 1
					end

					local found = false
					for j = 1, #stations1 do
						local s = game.interface.getEntity(stations1[j])
						if stops[s.stationGroup] then found = true break end
					end

					if found then
						for j = 1, #stations2 do
							local s = game.interface.getEntity(stations2[j])
							if stops[s.stationGroup] then done2 = true break end
						end
					end

					if done2 then break end
				end
			end

			if not done2 then return end

			self:finish()
		end,
		onFinish = function(self)
			taskutil.userstate.donecount5 = taskutil.userstate.donecount5 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PREMIERE_STARS_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PREMIERE_STARS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_PREMIERE_STARS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_trainstation_la,
				voiceOver = "MISSION_STARFLIGHT_TASK_PREMIERE_STARS_TEXT.wav",
			}
		end,
	})

	taskutil:new("5b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			--self:setProgressText( string.makeMoneyString(game.interface.getEntity(game.interface.getPlayer()).balance) .. "/" .. string.makeMoneyString(taskutil.userstate.targetbalance), 1 )
			self:setProgressText( string.makeMoneyString(taskutil.userstate.totalincome) .. "/" .. string.makeMoneyString(params.targetbalance), 1 )
			--if game.interface.getEntity(game.interface.getPlayer()).balance >= taskutil.userstate.targetbalance then
			if taskutil.userstate.totalincome >= params.targetbalance then
				game.interface.book(-taskutil.userstate.targetbalance)
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["end"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_PREMIERE_BUYBACK_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_PREMIERE_BUYBACK_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_PREMIERE_BUYBACK_TASK") % { x = params.targetbalance } },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_TASK_PREMIERE_BUYBACK_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_premiere,
				voiceOver = "MISSION_STARFLIGHT_TASK_PREMIERE_BUYBACK_TEXT.wav",
			}
		end,
		handlers = {
			handleEvent = function(self, id, name, param)
				if id == "__missionCallback__" then
					local e = game.interface.getEntity(param.params.entity)
					if param.type == "VEHICLE_INCOME" then
						taskutil.userstate.totalincome = taskutil.userstate.totalincome  + param.amount
					end
				end
			end
		},
	})

	taskutil:new("end", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setCompleted()
			taskutil:invokeLater(self.name, "finish", 0.6)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_FINISH_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_FINISH_TEXT") % params },
				},
				parentId = "5",
				voiceOver = "MISSION_STARFLIGHT_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
