local taskutil = require "mission.taskutil"
local params = require "params"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()

	local mainguihandlers = {
		voiceOverEnded = function(self) taskutil:finish(self.name) end,
	}

	setmetatable(mainguihandlers, { __index = function(self, key)
		local n = #"jump_"
		if key:sub(1, n) == "jump_" then
			game.gui.setAutoCamera(params[key])
		end
	end})

	taskutil:new("helper", {
		onUpdate = function(self)
			if (taskutil.userstate.extramoney or 0) > 0 then
				game.interface.book(taskutil.userstate.extramoney)
				taskutil.userstate.extramoney = 0
			end
		end,
		getInfo = function(self)
			return {
				visible = false,
			}
		end,
		handlers = {
			handleEvent = function(self, id, name, param)
				if id == "__missionCallback__" then
					if param.type == "VEHICLE_INCOME" then
						local unloaded = param.params.cargoUnloaded
						if unloaded.RUM or unloaded.CIGARS then
							taskutil.userstate.extramoney = (taskutil.userstate.extramoney or 0) + 2 * param.amount
						end
					end
				end
			end
		},
	})

	taskutil:new("1", {
		onStart = function(self)
			--taskutil.tasks["m2"]:start()
			--taskutil.tasks["m3"]:start()
			self:setProgressNone()
			taskutil:setEnabled("menu.construction.railmenu", false)
			taskutil.tasks["helper"]:start()
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_RUM_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_RUM_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_miami,
				voiceOver = "MISSION_VICECOUNTY_TASK_RUM_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	local function getCargo(cargotype)
		local s = game.interface.getEntity(params.harbor_miami).stations[1]
		local e = game.interface.getEntity(game.interface.getEntity(s).stationGroup)
		return e.itemsUnloaded[cargotype] or 0
	end
	taskutil:new("1a", {
		onStart = function(self)
			taskutil.userstate.rumdelivered = 0
			taskutil.userstate.rumignored = 0
			taskutil.userstate.cigarsdelivered = 0
			taskutil.userstate.cigarsignored = 0
		end,
		onUpdate = function(self)
			local c1tot = getCargo("FRUIT")
			local c2tot = getCargo("RUM")    - taskutil.userstate.rumignored
			local c3tot = getCargo("CIGARS") - taskutil.userstate.cigarsignored
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

			local done1 = c1tot >= params.fruit_amount
			local done2 = c2tot >= params.rum_amount
			local done3 = c3tot >= params.cigars_amount

			self:setProgressCount(c1tot, params.fruit_amount, 1)
			self:setProgressCount(c2tot, params.rum_amount, 2)
			self:setProgressCount(c3tot, params.cigars_amount, 3)

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
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_RUM_BOAT_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_RUM_BOAT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_RUM_BOAT_TASK") % params },
					--{ type = "HINT", text = _("MISSION_VICECOUNTY_TASK_RUM_BOAT_HINT") % params },
				},
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_TASK_RUM_BOAT_SUB1") % params },
					{ name = _("MISSION_VICECOUNTY_TASK_RUM_BOAT_SUB2") % params },
					{ name = _("MISSION_VICECOUNTY_TASK_RUM_BOAT_SUB3") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_miami,
				voiceOver = "MISSION_VICECOUNTY_TASK_RUM_BOAT_TEXT.wav",
			}
		end,
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

	taskutil:new("1b", {
		onStart = function(self)
			taskutil:setZone("1b", { polygon = zoneutil.makeCircleZone(params.police_boat_area.pos, params.police_boat_area.radius), draw = true, drawColor = colors.RED })
			taskutil.userstate.starttime1 = game.interface.getGameTime().time
			taskutil:startLater("m1")
		end,
		onUpdate = function(self)
			local time = game.interface.getGameTime().time
			local timepassed = time - taskutil.userstate.starttime1
			if timepassed > params.police_boat_seconds then
				if legalCargo(params.police_boat_area) then
					taskutil.tasks["2"]:start()
				else
					taskutil.tasks["1c"]:start()
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
			taskutil.userstate.starttime1 = nil
			taskutil:setZone("1b")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_RUM_POLICE_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_RUM_POLICE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_RUM_POLICE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_TASK_RUM_POLICE_SUB1") % params },
				},
				options = { { "Debug: Skip", "skip" } },
				parentId = "1",
				camera = params.jump_police_boat_area,
				voiceOver = "MISSION_VICECOUNTY_TASK_RUM_POLICE_TEXT.wav",
			}
		end,
		guiHandlers = {
			skip = function(self)
				taskutil:start("1c")
				taskutil:finish(self.name)
			end,
		},
	})

	taskutil:new("1c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_RUM_CAUGHT_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_RUM_CAUGHT_TEXT") % params },
				},
				options = { { "Ok", "finish" } },
				parentId = "1",
				camera = params.jump_police_boat_area,
				voiceOver = "MISSION_VICECOUNTY_TASK_RUM_CAUGHT_TEXT.wav",
			}
		end,
	})
end
