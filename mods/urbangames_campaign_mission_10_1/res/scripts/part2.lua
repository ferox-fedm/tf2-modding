local taskutil = require "mission.taskutil"
local params = require "params"
local proposalutil = require "mission.proposalutil"
local util = require "util"

return function()
	taskutil:new("2", {
		onStart = function(self)
			taskutil:setMusicTrack("track2")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_TYCOON_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_TYCOON_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_STARFLIGHT_TASK_TYCOON_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm1", 120)
			taskutil.userstate.donecount2 = 0
			taskutil:setMarker("2a3", { entity = params.airfield_santabarbara, type = "question" }, "1", "2a3")
			taskutil:setMarker("2a4", { entity = params.golfcourse,            type = "question" }, "1", "2a4")
			taskutil:setMarker("2a5", { entity = params.party,                 type = "question" }, "1", "2a5")
		end,
		onUpdate = function(self)
			if taskutil.userstate.donecount2 >= 3 then self:finish() end
			self:setProgressCount(taskutil.userstate.donecount2, 3)
		end,
		onFinish = function(self)
			game.interface.upgradeConstruction(params.party, "industry/party.con", { productionLevel = 0, active1 = true })
			util.endchapter(2)
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_TYCOON_STOCK_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_TYCOON_STOCK_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_TYCOON_STOCK_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.default_camera,
				voiceOver = "MISSION_STARFLIGHT_TASK_TYCOON_STOCK_TEXT.wav",
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

	taskutil:new("2a3", {
		onStart = function(self)
			taskutil.userstate.airplanetable = {}
		end,
		onUpdate = function(self)
			local t = taskutil.userstate.airplanetable
			local vehicles = game.interface.getVehicles()
			local max = 0
			local time = game.interface.getGameTime().time
			for i = 1, #vehicles do
				local id = vehicles[i]
				local v = game.interface.getEntity(id)
				if v.carrier == "AIR" then
					if v.state == "AT_TERMINAL" then
						t[id] = nil
					else
						local p = v.position
						local z = game.interface.getHeight({p[1], p[2]})
						if p[3] - z > 35 then
							if t[id] == nil then
								t[id] = time
							end
						end
					end
				end
				if t[id] then
					local d = time - t[id]
					max = math.max(d, max)
				end
			end
			self:setProgressCount(max, params.tycoon_minutes * 60, 1)
			if max >= params.tycoon_minutes * 60 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.donecount2 = taskutil.userstate.donecount2 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_TYCOON_RECORD_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_TYCOON_RECORD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_TYCOON_RECORD_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_TASK_TYCOON_RECORD_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_airfield_santabarbara,
				voiceOver = "MISSION_STARFLIGHT_TASK_TYCOON_RECORD_TEXT.wav",
			}
		end,
	})

	taskutil:new("2a4", {
		onStart = function(self)
			local cargo_active = taskutil:started("m1a")
			game.interface.upgradeConstruction(params.golfcourse, "industry/golfcourse.con", { productionLevel = 0, cargo_active = cargo_active, people_active = true })
		end,
		onUpdate = function(self)
			local stations = game.interface.getEntities({pos = params.pos_golfcourse, radius = 200}, {type = "STATION"})
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.PASSENGERS or 0
				if s > 0 then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.userstate.donecount2 = taskutil.userstate.donecount2 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_TYCOON_GOLF_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_TYCOON_GOLF_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_TYCOON_GOLF_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_golfcourse,
				voiceOver = "MISSION_STARFLIGHT_TASK_TYCOON_GOLF_TEXT.wav",
			}
		end,
	})

	taskutil:new("2a5", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.party, "industry/party.con", { productionLevel = 0, active1 = true })
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.party).simBuildings[1]).itemsConsumed
			local x1 = c.ALCOHOL or 0
			if x1 > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.donecount2 = taskutil.userstate.donecount2 + 1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_TYCOON_PARTY_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_TYCOON_PARTY_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_TYCOON_PARTY_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_TASK_TYCOON_PARTY_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_party,
				voiceOver = "MISSION_STARFLIGHT_TASK_TYCOON_PARTY_TEXT.wav",
			}
		end,
	})

	taskutil:new("2b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local pstationla = util.airfield2pstationgroup(params.airport_la)
			local pstationsanfrancisco = util.airfield2pstationgroup(params.airport_sanfrancisco)
			local lines = game.interface.getLines()
			local goodlines = {}
			for l = 1, #lines do
				local found0 = false
				local found1 = false
				local stops = game.interface.getEntity(lines[l]).stops
				if #stops == 2 then
					for i = 1, #stops do
						if stops[i] == pstationla then found0 = true end
						if stops[i] == pstationsanfrancisco then found1 = true end
					end
				end
				if found0 and found1 and #util.line2vehicles(lines[l]) > 0 then goodlines[#goodlines + 1] = lines[l] end
			end
			local transported = 0
			for i = 1, #goodlines do
				transported = transported + game.interface.getEntity(goodlines[i]).itemsTransported._sum
			end
			self:setProgressCount(transported, params.passengers_tycoon)
			if transported >= params.passengers_tycoon then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_TYCOON_COMPANY_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_TYCOON_COMPANY_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_TYCOON_COMPANY_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.default_camera,
				voiceOver = "MISSION_STARFLIGHT_TASK_TYCOON_COMPANY_TEXT.wav",
			}
		end,
	})
end
