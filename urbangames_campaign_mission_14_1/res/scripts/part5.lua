local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
	taskutil:new("5", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track5")
		end,
		onFinish = function(self)
			taskutil.tasks["5a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_PALACE_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_PALACE_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_marbleconsumer,
				voiceOver = "MISSION_LEADER_TASK_PALACE_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
			arrivaltracker.track("5a", { cargotype = "PASSENGERS" })
			taskutil.userstate.pageantryshipped = 0
			taskutil.userstate.running = false
			arrivaltracker.track("5ap", { cargotype = "PAGEANTRY", to = params.marbleconsumer })
			taskutil:invokeLater(self.name, "showm3", 120)
		end,
		onUpdate = function(self)
			local persons = arrivaltracker.get("5a")

			local shipped = 0

			if taskutil.userstate.running then
				local e = game.interface.getEntity(game.interface.getEntity(params.goodsfactory).simBuildings[1])
				shipped = e.itemsShipped._sum or 0
				taskutil.userstate.pageantryshipped = shipped
			else
				shipped = taskutil.userstate.pageantryshipped
			end

			local allowed = persons / 10
			if taskutil.userstate.timer5a == nil then
				if shipped >= allowed then
					if taskutil.userstate.running then
						taskutil.userstate.running = false
						game.interface.upgradeConstruction(params.goodsfactory, "industry/goods_factory.con", {
							stocks = { },
							input = { { } },
							output = { PAGEANTRY = 1 },
							capacity = 0,
						})
					end
				else
					if not taskutil.userstate.running then
						taskutil.userstate.running = true
						taskutil.userstate.timer5a = game.interface.getGameTime().time
						game.interface.upgradeConstruction(params.goodsfactory, "industry/goods_factory.con", {
							stocks = { },
							input = { { } },
							output = { PAGEANTRY = 1 },
							capacity = 100,
						})
					end
				end
			else
				if game.interface.getGameTime().time - taskutil.userstate.timer5a > 20 then --run at least 20 seconds
					taskutil.userstate.timer5a = nil
				end
			end

			self:setProgressCount(arrivaltracker.get("5ap"), params.pageantry_amount)
			if arrivaltracker.get("5ap") >= params.pageantry_amount then self:finish() end

		end,
		onFinish = function(self)
			taskutil.userstate.timer5a = nil
			arrivaltracker.track("5a")
			arrivaltracker.track("5ap")
			taskutil.tasks["5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_PALACE_PAGEANTRY_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_PALACE_PAGEANTRY_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_PALACE_PAGEANTRY_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				optionsRightAlign = true,
				parentId = "5",
				camera = params.jump_goodsfactory,
				voiceOver = "MISSION_LEADER_TASK_PALACE_PAGEANTRY_TEXT.wav",
			}
		end,
		handlers = {
			showm3 = function(self)
				if taskutil.tasks["m3"].start ~= nil then
					taskutil.tasks["m3"]:start()
				end
			end,
		},
	})

	taskutil:new("5b", {
		onStart = function(self)
			arrivaltracker.track("5b", { cargotype = "MARBLE", to = params.marbleconsumer })
		end,
		onUpdate = function(self)
			local c = arrivaltracker.get("5b")
			self:setProgressCount(c, params.marble_amount)
			local done = c >= params.marble_amount
			if done then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("5b")
			taskutil.tasks["5c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_PALACE_MARBLE_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_PALACE_MARBLE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_PALACE_MARBLE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				optionsRightAlign = true,
				parentId = "5",
				camera = params.jump_marble,
				voiceOver = "MISSION_LEADER_TASK_PALACE_MARBLE_TEXT.wav",
			}
		end,
	})

	taskutil:new("5c", {
		onStart = function(self)
			for i = 1, 4 do
				game.interface.upgradeConstruction(params["tribune" .. i], "industry/tribune.con", {
					productionLevel = 3,
					commercialCapacity = 100,
				})
			end
			for i = 1, 4 do
				taskutil:setZone("5c" .. i, { polygon = zoneutil.makeCircleZone(params["pos_tribune" .. i], params.tribune_radius), draw = true, drawColor = colors.BLUE })
			end
		end,
		onUpdate = function(self)
			local done = { false, false, false }
			local progress = 0
			for i = 1, 3 do
				done[i] = game.interface.findPath({ pos = params["pos_tribune" .. i    ], radius = params.tribune_radius },
				                                  { pos = params["pos_tribune" .. i + 1], radius = params.tribune_radius }) ~= nil
				if done[i] then progress = progress + 1 end
			end
			self:setProgressCount(progress, #done, 1)
			local done1 = progress == #done

			taskutil.userstate.reached5c = taskutil.userstate.reached5c or { false, false, false, false }
			local reached = taskutil.userstate.reached5c
			local sumreached = 0
			for i = 1, 4 do
				if not reached[i] then
					local entities = game.interface.getEntities({ pos = params["pos_tribune" .. i], radius = params.tribune_radius }, { type = "VEHICLE" })
					for j = 1, #entities do
						local e = game.interface.getEntity(entities[j])
						if e.vehicles[1].fileName == "vehicle/bus/asia/limousine_v2.mdl" then
							reached[i] = true
						end
					end
				end
				sumreached = sumreached + (reached[i] and 1 or 0)
			end
			self:setProgressCount(sumreached, #reached, 2)
			local done2 = sumreached == #reached

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)
			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			for i = 1, 4 do
				taskutil:setZone("5c" .. i)
			end
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_PALACE_TRIUMPH_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_PALACE_TRIUMPH_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_PALACE_TRIUMPH_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_LEADER_TASK_PALACE_TRIUMPH_SUB1") % params },
					{ name = _("MISSION_LEADER_TASK_PALACE_TRIUMPH_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				optionsRightAlign = true,
				parentId = "5",
				camera = params.jump_tribunelocator,
				voiceOver = "MISSION_LEADER_TASK_PALACE_TRIUMPH_TEXT.wav",
			}
		end,
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
				name = _("MISSION_LEADER_TASK_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_FINISH_TEXT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				voiceOver = "MISSION_LEADER_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
