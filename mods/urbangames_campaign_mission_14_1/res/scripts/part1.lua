local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"

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

	taskutil:new("1", {
		onStart = function(self)
			--taskutil.tasks["m1"]:start()
			--taskutil.tasks["m2"]:start()
			--taskutil.tasks["m3"]:start()
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_GIANT_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_GIANT_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_bukarest,
				voiceOver = "MISSION_LEADER_TASK_GIANT_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm1", 120)
			for i = 1, 3 do
				local z = params["zone_hunt" .. i]
				for j = 1, 10 do game.interface.spawnAnimal("animal/wildlife_bear.mdl", params["zone_hunt" .. i].pos) end
			end
		end,
		onUpdate = function(self)
			local e = game.interface.getEntity(game.interface.getEntity(params.oilrefinery).simBuildings[1])

			local processed = e.itemsConsumed.CRUDE or 0
			--self:setProgressCount(processed, params.crude_amount) 
			if processed >= params.crude_amount then --only 1
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_GIANT_OIL_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_GIANT_OIL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_GIANT_OIL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_oilrefinery,
				voiceOver = "MISSION_LEADER_TASK_GIANT_OIL_TEXT.wav",
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

	taskutil:new("1b", {
		onStart = function(self)
			arrivaltracker.track("1b", { cargotype = "OIL", to = params.bukarest })
		end,
		onUpdate = function(self)
			local c = arrivaltracker.get("1b")
			self:setProgressCount(c, params.oil_amount, 1)
			local done1 = c >= params.oil_amount

			local done2 = false
			local e = game.interface.getEntity(game.interface.getEntity(params.chemicalplant).simBuildings[1])
			local processed = e.itemsConsumed.OIL or 0
			self:setProgressCount(processed, params.plastic_amount, 2)
			if processed >= params.plastic_amount then
				done2 = true
			end

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			self:setProgressCount(c, params.oil_amount, 1)
			self:setProgressCount(processed, params.plastic_amount, 2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("1b")
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_GIANT_DELIVER_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_GIANT_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_GIANT_DELIVER_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_LEADER_TASK_GIANT_DELIVER_SUB1") % params },
					{ name = _("MISSION_LEADER_TASK_GIANT_DELIVER_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_bukarest,
				voiceOver = "MISSION_LEADER_TASK_GIANT_DELIVER_TEXT.wav",
			}
		end,
	})
end
