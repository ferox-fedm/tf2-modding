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
				name = _("MISSION_REDSTAR_MEDAL_PROFIT_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_MEDAL_PROFIT_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_MEDAL_PROFIT_TEXT.wav",
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

	local function countGoods()
		local total = 0
		for i = 1, params.numconsites do
			local e = game.interface.getEntity(params["constructionsite" .. i])
			if e.fileName == "industry/goods_factory.con" then
				total = total + (game.interface.getEntity(e.simBuildings[1]).itemsConsumed.MACHINES or 0)	--arrival tracker!
			end
		end
		return total
	end

	taskutil:new("m2a", {
		onStart = function(self)
			taskutil.userstate.machinesbeforem2a = countGoods()
			taskutil.userstate.incomem2a = 0
		end,
		onUpdate = function(self)
			local delivered = countGoods() - taskutil.userstate.machinesbeforem2a
			self:setProgressCount(delivered, params.amount_machines_m2)
			if delivered > params.amount_machines_m2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_MEDAL_PROFIT_MACHINES_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_MEDAL_PROFIT_MACHINES_TEXT") },
					{ type = "TASK", text = _("MISSION_REDSTAR_MEDAL_PROFIT_MACHINES_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_MEDAL_PROFIT_MACHINES_TEXT.wav",
			}
		end,
		handlers = {
			handleEvent = function(self, id, name, param)
				if id == "__missionCallback__" then
					if param.type == "VEHICLE_INCOME" and (param.params.cargoUnloaded.MACHINES or 0) > 0 then
						local x = param.amount * 2
						taskutil.userstate.incomem2a = taskutil.userstate.incomem2a + x
						return x
					end
				end
			end
		},
	})

	taskutil:new("m2b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local stations = game.interface.getEntities({pos = params.pos_machinesimport, radius = 200}, {type = "STATION"})
			local stationgroups = {}
			for i = 1, #stations do
				local s = game.interface.getEntity(stations[i])
				stationgroups[s.stationGroup] = 1
			end
			local badlines = 0
			local lines = game.interface.getLines()
			for i = 1, #lines do
				local l = game.interface.getEntity(lines[i])
				for k = 1, #l.stops do
					if stationgroups[l.stops[k]] then
						badlines = badlines + 1
						break
					end
				end
			end
			self:setProgressText(_("MISSION_REDSTAR_MEDAL_PROFIT_HIDE_PROGRESS") % { x = badlines })
			if badlines == 0 then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_MEDAL_PROFIT_HIDE_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_MEDAL_PROFIT_HIDE_TEXT") },
					{ type = "TASK", text = _("MISSION_REDSTAR_MEDAL_PROFIT_HIDE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_MEDAL_PROFIT_HIDE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m2c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_2")
			taskutil.tasks["m2d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_MEDAL_PROFIT_PAYBACK_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_MEDAL_PROFIT_PAYBACK_TEXT") },
					{ type = "TASK", text = _("MISSION_REDSTAR_MEDAL_PROFIT_PAYBACK_TASK") % { x = taskutil.userstate.incomem2a } },
				},
				options = {
					{ _("MISSION_REDSTAR_MEDAL_PROFIT_PAYBACK_OPTION") % { x = taskutil.userstate.incomem2a }, "pay" },
				},
				optionsRightAlign = true,
				parentId = "m2",
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_MEDAL_PROFIT_PAYBACK_TEXT.wav",
			}
		end,
		handlers = {
			pay = function(self)
				local cost = taskutil.userstate.incomem2a
				if game.interface.getEntity(game.interface.getPlayer()).balance > cost then
					game.interface.book(-cost)
					taskutil:finish(self.name)
				end
			end
		},
		guiHandlers = {
			pay = function(self)
				taskutil:sendScriptFn(self.name, "pay")
			end
		},
	})

	taskutil:new("m2d", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_MEDAL_PROFIT_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_REDSTAR_MEDAL_PROFIT_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_REDSTAR_MEDAL_PROFIT_FINISH_TEXT.wav",
			}
		end,
	})
end
