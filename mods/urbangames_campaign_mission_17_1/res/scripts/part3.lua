local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

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
				name = _("MISSION_OILSANDS_TASK_NATURE_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_NATURE_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_OILSANDS_TASK_NATURE_TEXT.wav",
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
			local fishpos = params.fishpos3
			fishpos[3] = 15
			taskutil:setMarker("3b", { entity = params.sedimentationtank3, type = "question" }, self.name, "start3b")
			taskutil:setMarker("3c", { pos = fishpos, type = "question" }, self.name, "start3c")
			--taskutil:setMarker("3d", { entity = params.refinery, type = "question" }, self.name, "start3d")
			taskutil:setMarker("3e", { entity = params.athabasca, type = "question" }, self.name, "start3e")
			taskutil:invokeLater(self.name, "showm1", 120)
		end,
		onUpdate = function(self)
			local count = 0
			count = count + (taskutil:finished("3b") and 1 or 0)
			count = count + (taskutil:finished("3c2") and 1 or 0)
			count = count + (taskutil:finished("3e") and 1 or 0)
			self:setProgressCount(count, 3)
			if count == 3 then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_NATURE_MEASURES_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_NATURE_MEASURES_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_NATURE_MEASURES_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_OILSANDS_TASK_NATURE_MEASURES_TEXT.wav",
				options = { { "Debug: Skip", "skip" } },
				parentId = "3",
			}
		end,
		handlers = {
			start3b = function(self)
				if taskutil.tasks["3b"].start then taskutil.tasks["3b"]:start() end
				taskutil:setMarker("3b")
			end,
			start3c = function(self)
				if taskutil.tasks["3c"].start then taskutil.tasks["3c"]:start() end
				taskutil:setMarker("3c")
			end,
			start3d = function(self)
				if taskutil.tasks["3d"].start then taskutil.tasks["3d"]:start() end
				taskutil:setMarker("3d")
			end,
			start3e = function(self)
				if taskutil.tasks["3e"].start then taskutil.tasks["3e"]:start() end
				taskutil:setMarker("3e")
			end,
			skip = function(self)
				if taskutil.tasks["3b"].start then taskutil.tasks["3b"]:start() end
				if taskutil.tasks["3c"].start then taskutil.tasks["3c"]:start() end
				--if taskutil.tasks["3d"].start then taskutil.tasks["3d"]:start() end
				if taskutil.tasks["3e"].start then taskutil.tasks["3e"]:start() end
				taskutil:setMarker("3b")
				taskutil:setMarker("3c")
				--taskutil:setMarker("3d")
				taskutil:setMarker("3e")
			end,
			showm1 = function(self)
				if taskutil.tasks["m1"].start ~= nil then
					taskutil.tasks["m1"]:start()
				end
			end,
		},
		guiHandlers = {
			start3b = function(self)
				taskutil:sendScriptFn(self.name, "start3b")
			end,
			start3c = function(self)
				taskutil:sendScriptFn(self.name, "start3c")
			end,
			start3d = function(self)
				taskutil:sendScriptFn(self.name, "start3d")
			end,
			start3e = function(self)
				taskutil:sendScriptFn(self.name, "start3e")
			end,
			skip = function(self)
				taskutil:sendScriptFn(self.name, "skip")
			end,
		},
	})

	taskutil:new("3b", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.sedimentationtank3, "industry/sedimentationtank.con", { mode1 = true })
		end,
		onUpdate = function(self)
			local e = game.interface.getEntity(game.interface.getEntity(params.sedimentationtank3).simBuildings[1])
			local count = e.itemsConsumed.PLASTIC or 0

			--self:setProgressCount(count, params.plastic_amount, 1)
			if count >= params.plastic_amount then self:finish() end
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_NATURE_CLARIFIER_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_NATURE_CLARIFIER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_NATURE_CLARIFIER_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_OILSANDS_TASK_NATURE_CLARIFIER_SUB1") % params },
				},
				camera = params.jump_oilsands,
				voiceOver = "MISSION_OILSANDS_TASK_NATURE_CLARIFIER_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
			}
		end,
	})

	taskutil:new("3c", {
		onStart = function(self)
			local fishpos = params.fishpos1
			fishpos[3] = 15
			taskutil:setMarker("fish", { pos = fishpos, type = "question" }, self.name, "finish")
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMarker("fish")
			taskutil.tasks["3c1"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_NATURE_FISH_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_NATURE_FISH_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_NATURE_FISH_TASK") % params },
				},
				camera = params.jump_fishpos1marker,
				voiceOver = "MISSION_OILSANDS_TASK_NATURE_FISH_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
			}
		end,
	})

	taskutil:new("3c1", {
		onStart = function(self)
			local fishpos = params.fishpos2
			fishpos[3] = 15
			taskutil:setMarker("fish", { pos = fishpos, type = "question" }, self.name, "finish")
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMarker("fish")
			taskutil.tasks["3c2"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_NATURE_FISH2_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_NATURE_FISH2_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_NATURE_FISH2_TASK") % params },
				},
				camera = params.jump_fishpos2marker,
				voiceOver = "MISSION_OILSANDS_TASK_NATURE_FISH2_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
			}
		end,
	})

	taskutil:new("3c2", {
		onStart = function(self)
			local fishpos = params.fishpos3
			fishpos[3] = 15
			taskutil:setMarker("fish", { pos = fishpos, type = "question" }, self.name, "finish")
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMarker("fish")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_NATURE_FISH3_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_NATURE_FISH3_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_NATURE_FISH3_TASK") % params },
				},
				camera = params.jump_fishpos3marker,
				voiceOver = "MISSION_OILSANDS_TASK_NATURE_FISH3_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
			}
		end,
	})

	taskutil:new("3d", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local time = game.interface.getGameTime().time
			local tu = taskutil.userstate
			tu.lasttrucktime = tu.lasttrucktime or time
			tu.lastprodtime = tu.lastprodtime or time

			local vehicles = game.interface.getEntities({ pos = params.pos_refinery, radius = 200 }, { type = "VEHICLE" })
			if #vehicles > 0 then
				tu.lasttrucktime = time
			end

			local e = game.interface.getEntity(game.interface.getEntity(params.refinery).simBuildings[1])
			local oil = e.itemsProduced.OIL or 0
			tu.lastprodval = tu.lastprodval or oil
			if oil ~= tu.lastprodval then
				tu.lastprodval = oil
				tu.lastprodtime = time
			end

			local d1 = time - tu.lasttrucktime
			local d2 = time - tu.lastprodtime
			--self:setProgressText(tostring(math.floor(d1)), 1)
			--self:setProgressText(tostring(math.floor(d2)), 2)

			local done1 = d1 >= params.stoptime
			local done2 = d2 >= params.stoptime
			--self:setSubtaskCompleted(1, done1)
			--self:setSubtaskCompleted(2, done2)
			
			--progress: x sekunden nichts produziert, params.nodelivery (minuten)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_NATURE_PROBE_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_NATURE_PROBE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_NATURE_PROBE_TASK") % params },
				},
				--subTasks = {
				--	{ name = _("MISSION_OILSANDS_TASK_NATURE_PROBE_SUB1") % params },
				--	{ name = _("MISSION_OILSANDS_TASK_NATURE_PROBE_SUB2") % params },
				--},
				camera = params.jump_default,
				voiceOver = "MISSION_OILSANDS_TASK_NATURE_PROBE_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
			}
		end,
	})

	taskutil:new("3e", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local c = taskutil.userstate.income3e or 0

			self:setProgressCount(c, params.goodsmoney)
			if c >= params.goodsmoney then self:finish() end
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_NATURE_BRIBE_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_NATURE_BRIBE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_NATURE_BRIBE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_OILSANDS_TASK_NATURE_BRIBE_SUB1") % params },
				},
				camera = params.jump_athabasca,
				voiceOver = "MISSION_OILSANDS_TASK_NATURE_BRIBE_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
			}
		end,
		handlers = {
			handleEvent = function(self, id, name, param)
				if id == "__missionCallback__" then
					if param.type == "VEHICLE_INCOME" then
						local unloaded = param.params.cargoUnloaded
						if unloaded.GOODS then
							local entity = game.interface.getEntity(param.params.entity)
							if entity.line >= 0 then
								local line = game.interface.getEntity(entity.line)
								local stop = game.interface.getEntity(line.stops[entity.stopIndex + 1])
								local station = game.interface.getEntity(stop.stations[1])
								if station.town == params.athabasca then
									taskutil.userstate.income3e = (taskutil.userstate.income3e or 0) + param.amount
								end
							end
						end
					end
				end
			end
		},
	})
end
