local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

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
				name = _("MISSION_VICECOUNTY_TASK_CARGO_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_CARGO_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_miami,
				voiceOver = "MISSION_VICECOUNTY_TASK_CARGO_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	local function getCargo(cargotype, station)
		local s = game.interface.getEntity(params.miami_airport).stations[station]
		local e = game.interface.getEntity(game.interface.getEntity(s).stationGroup)
		return e.itemsUnloaded[cargotype] or 0
	end
	taskutil:new("2a", {
		onStart = function(self)

			game.interface.setPlayer(params.nassau_airport, game.interface.getPlayer())
			game.interface.setPlayer(params.cuba_airport, game.interface.getPlayer())
			game.interface.setPlayer(params.miami_airport, game.interface.getPlayer())
			game.interface.setBulldozeable(params.nassau_airport, false)
			game.interface.setBulldozeable(params.cuba_airport, false)
			game.interface.setBulldozeable(params.miami_airport, false)
			taskutil:setEnabled("menu.construction.airmenu", true)

			taskutil.userstate.rumdelivered = 0
			taskutil.userstate.rumignored = 0
			taskutil.userstate.cigarsdelivered = 0
			taskutil.userstate.cigarsignored = 0
			taskutil:invokeLater(self.name, "showm2", 120)
		end,
		onUpdate = function(self)
			local c1tot = getCargo("PASSENGERS", 1)
			local c2tot = getCargo("RUM", 2)    - taskutil.userstate.rumignored
			local c3tot = getCargo("CIGARS", 2) - taskutil.userstate.cigarsignored
			local c2 = c2tot - taskutil.userstate.rumdelivered
			local c3 = c3tot - taskutil.userstate.cigarsdelivered

			if c1tot < 2 * c2tot then
				taskutil.userstate.running = nil
				taskutil.userstate.rumignored = taskutil.userstate.rumignored + c2
			else
				taskutil.userstate.running = true
				taskutil.userstate.rumdelivered = taskutil.userstate.rumdelivered + c2
			end

			if c1tot < 2 * c3tot then
				taskutil.userstate.running = nil
				taskutil.userstate.cigarsignored = taskutil.userstate.cigarsignored + c3
			else
				taskutil.userstate.running = true
				taskutil.userstate.cigarsdelivered = taskutil.userstate.cigarsdelivered + c3
			end

			local done1 = c1tot >= params.passenger_amount_air
			local done2 = c2tot >= params.rum_amount_air
			local done3 = c3tot >= params.cigars_amount_air

			self:setProgressCount(c1tot, params.passenger_amount_air, 1)
			self:setProgressCount(c2tot, params.rum_amount_air, 2)
			self:setProgressCount(c3tot, params.cigars_amount_air, 3)

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)
			self:setSubtaskCompleted(3, done3)

			if done1 and done2 and done3 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.rumdelivered = nil
			taskutil.userstate.rumignored = nil
			taskutil.userstate.cigarsdelivered = nil
			taskutil.userstate.cigarsignored = nil
			taskutil.userstate.running = nil
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_CARGO_PLANE_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_CARGO_PLANE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_CARGO_PLANE_TASK") % params },
					{ type = "HINT", text = _("MISSION_VICECOUNTY_TASK_CARGO_PLANE_HINT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_TASK_CARGO_PLANE_SUB1") },
					{ name = _("MISSION_VICECOUNTY_TASK_CARGO_PLANE_SUB2") },
					{ name = _("MISSION_VICECOUNTY_TASK_CARGO_PLANE_SUB3") },
				},
				parentId = "2",
				camera = params.jump_miami,
				voiceOver = "MISSION_VICECOUNTY_TASK_CARGO_PLANE_TEXT.wav",
			}
		end,
		handlers = {
			showm2 = function(self)
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
				end
			end,
		},
	})

	local function legalCargo(area)
		local entities = game.interface.getEntities(area, { type = "VEHICLE" } )
		for i = 1, #entities do
			local e = game.interface.getEntity(entities[i])
			for k, _ in pairs(e.cargoLoad) do
				if k == "RUM" or k == "CIGARS" then
					return false
				end
			end
		end
		return true
	end

	taskutil:new("2b", {
		onStart = function(self)
			taskutil:setZone("2b", { polygon = zoneutil.makeCircleZone(params.pos_miami_airport, params.police_boat_area.radius), draw = true, drawColor = colors.RED })
			taskutil.userstate.starttime2 = game.interface.getGameTime().time
		end,
		onUpdate = function(self)
			local time = game.interface.getGameTime().time
			local timepassed = time - taskutil.userstate.starttime2
			if timepassed > params.police_air_seconds then
				if legalCargo({ pos = params.pos_miami_airport, radius = params.police_boat_area.radius }) then
					taskutil.tasks["3"]:start()
				else
					taskutil.tasks["2c"]:start()
					if taskutil.tasks["m1a"].finish ~= nil then
						taskutil.userstate.caught = true
						taskutil.tasks["m1a"]:finish()
					end
				end
				self:finish()
			end
			self:setProgressText(tostring(params.police_boat_seconds - math.floor(timepassed)), 1)
		end,
		onFinish = function(self)
			taskutil.userstate.starttime2 = nil
			taskutil:setZone("2b")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_CARGO_POLICE_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_CARGO_POLICE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_CARGO_POLICE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_TASK_CARGO_POLICE_SUB1") % params },
				},
				options = { { "Debug: Skip", "skip" } },
				parentId = "2",
				camera = params.jump_miami_airport,
				--voiceOver = "MISSION_VICECOUNTY_TASK_CARGO_POLICE_TEXT.wav",
			}
		end,
		guiHandlers = {
			skip = function(self)
				taskutil:finish(self.name)
				taskutil:start("2c")
			end,
		},
	})

	taskutil:new("2c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_CARGO_CAUGHT_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_CARGO_CAUGHT_TEXT") % params },
				},
				options = { { "Ok", "finish" } },
				parentId = "2",
				camera = params.jump_miami_airport,
				voiceOver = "MISSION_VICECOUNTY_TASK_CARGO_CAUGHT_TEXT.wav",
			}
		end,
	})
end
