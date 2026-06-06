local taskutil = require "mission.taskutil"
local params = require "params"

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
				name = _("MISSION_SWISSMADE_TASK_BOOM_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_BOOM_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_BOOM_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal1", 120)

			if 	taskutil.userstate.gotthardblowup then 
				for _, v in pairs({"constructionsite_tunnel"}) do
					game.interface.upgradeConstruction(params[v], "industry/custom.con", {
						productionLevel = 0,
						stocks = {
							{ cargoType = "MACHINES", type = "RECEIVING", x = 0, y = 0, sizex = 1, sizey = 1 },
						},
						input = { { 1 } },
						output = { },
						capacity = 400,
					})
				end
				taskutil.userstate.mid5a = true
				game.interface.upgradeConstruction(params.tracktunnel, "industry/tracklist.con", { productionLevel = 0 })
			else
				game.interface.upgradeConstruction(params.constructionsite_north, "industry/custom.con", {
					productionLevel = 0,
					stocks = {
						{ cargoType = "MACHINES", type = "RECEIVING", x = 0, y = 0, sizex = 1, sizey = 1 },
					},
					input = { { 1 } },
					output = { },
					capacity = 400,
				})
				taskutil.userstate.north5a = true
				game.interface.upgradeConstruction(params.tracknorth, "industry/tracklist.con", { productionLevel = 0 })
			end

		end,
		onUpdate = function(self)

			local consumed3 = game.interface.getEntity(game.interface.getEntity(params.constructionsite_tunnel).simBuildings[1]).itemsConsumed
			local consumed1 = game.interface.getEntity(game.interface.getEntity(params.constructionsite_north).simBuildings[1]).itemsConsumed

			local m1 = consumed1.MACHINES or 0
			local m3 = consumed3.MACHINES or 0

			if taskutil.userstate.gotthardblowup then 
				self:setProgressCount(m3, params.machines_tunnel, 1)
				self:setSubtaskCompleted(1, m3 > params.machines_tunnel)
			else
				self:setProgressCount(m1, params.machines_north, 1)
				self:setSubtaskCompleted(1, m1 > params.machines_north)
			end

			if m1 > params.machines_north and taskutil.userstate.north5a ~= nil then
				game.interface.upgradeConstruction(params.tracknorth, "industry/tracklist.con", { productionLevel = 0, tracklist = params.tracklist_north })
				taskutil.userstate.north5a = nil
			end
			if m3 > params.machines_tunnel and taskutil.userstate.mid5a ~= nil then
				game.interface.upgradeConstruction(params.tracktunnel, "industry/tracklist.con", { productionLevel = 0, tracklist = params.tracklist_mid, edgeType = "TUNNEL" })
				taskutil.userstate.mid5a = nil
			end

			if taskutil.userstate.gotthardblowup then 
				if m3 > params.machines_tunnel then self:finish() end
			else
				if m1 > params.machines_north then self:finish() end
			end

		end,
		onFinish = function(self)
			game.interface.upgradeConstruction(params.tracknorth, "industry/tracklist.con", { productionLevel = 0, tracklist = params.tracklist_north })
			game.interface.upgradeConstruction(params.tracktunnel, "industry/tracklist.con", { productionLevel = 0, tracklist = params.tracklist_mid, edgeType = "TUNNEL" })
			taskutil.tasks["5b"]:start()
		end,
		getInfo = function(self)
			local text = ""
			local task = ""
			local subTasks = {}
			local camera = {}
			local voiceOver = ""

			if 	taskutil.userstate.gotthardblowup then 
				text = _("MISSION_SWISSMADE_TASK_BOOM_REPAIR_TEXT2") % params
				task = _("MISSION_SWISSMADE_TASK_BOOM_REPAIR_TASK2") % params
				subTasks = {
					{ name = _("MISSION_SWISSMADE_TASK_BOOM_REPAIR_SUB3") }
				}
				camera = params.jump_constructionsite_tunnel
				voiceOver = "MISSION_SWISSMADE_TASK_BOOM_REPAIR_TEXT2.wav"
			else
				text = _("MISSION_SWISSMADE_TASK_BOOM_REPAIR_TEXT1")
				task = _("MISSION_SWISSMADE_TASK_BOOM_REPAIR_TASK1")
				subTasks = {
					{ name = _("MISSION_SWISSMADE_TASK_BOOM_REPAIR_SUB1") },
				}
				camera = params.jump_constructionsite_north
				voiceOver = "MISSION_SWISSMADE_TASK_BOOM_REPAIR_TEXT1.wav"
			end

			return {
				name = _("MISSION_SWISSMADE_TASK_BOOM_REPAIR_NAME"),
				paragraphs = {
					{ text = text % params },
					{ type = "TASK", text = task % params },
				},
				subTasks = subTasks,
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = camera,
				voiceOver = voiceOver,
			}
		end,
		handlers = {
			showmedal1 = function(self) taskutil:start("m1") end,
		},
	})

	local function net()
		local time = game.interface.getGameTime().time
		return game.interface.getPlayerJournal((time - 12 * 60) * 1000, time * 1000)._sum
	end
	local function update5bprogress(self, net)
		self:setProgressText(_("MISSION_SWISSMADE_TASK_BOOM_PROFIT_PROGRESS") % { x = net }, 1) --Gewinn im letzten Jahr: ${x}
	end
	taskutil:new("5b", {
		onStart = function(self)
			taskutil.userstate.lastmeasurement = 0
			taskutil.userstate.revenuegoods = 0
			taskutil.userstate.revenuepassengers = 0
		end,
		onUpdate = function(self)
			local u = taskutil.userstate
			local net = net()
			update5bprogress(self, net)
			if net > 0 then u.posnet = true end

			self:setSubtaskCompleted(1, u.posnet ~= nil)
			self:setSubtaskCompleted(2, u.revenuegoods  >= params.goods_5b)
			self:setSubtaskCompleted(3, u.revenuepassengers  >= params.passengers_5b)

			self:setProgressText(u.revenuegoods .. "/" .. params.goods_5b_formated, 2)
			self:setProgressText(u.revenuepassengers .. "/" .. params.passengers_5b_formated, 3)

			if u.posnet and u.revenuegoods >= params.goods_5b and u.revenuepassengers >= params.passengers_5b then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["end"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_TASK_BOOM_PROFIT_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_BOOM_PROFIT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SWISSMADE_TASK_BOOM_PROFIT_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_SWISSMADE_TASK_BOOM_PROFIT_SUB1") },
					{ name = _("MISSION_SWISSMADE_TASK_BOOM_PROFIT_SUB2") },
					{ name = _("MISSION_SWISSMADE_TASK_BOOM_PROFIT_SUB3") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.default_camera,
				voiceOver = "MISSION_SWISSMADE_TASK_BOOM_PROFIT_TEXT.wav",
			}
		end,
		handlers = {
			handleEvent = function(self, id, name, param)
				if id == "__missionCallback__" and name == "JOURNAL_ENTRY" then
					local unloaded = param.params.cargoUnloaded
					local amount = param.amount
					if param.type ~= "VEHICLE_INCOME" then return end
					if next(unloaded) == nil then return end
					if unloaded.PASSENGERS ~= nil then
						taskutil.userstate.revenuepassengers = taskutil.userstate.revenuepassengers + amount
					else
						taskutil.userstate.revenuegoods = taskutil.userstate.revenuegoods + amount
					end
				end
			end,
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
				name = _("MISSION_SWISSMADE_TASK_FINISH_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_TASK_FINISH_TEXT") % params },
				},
				parentId = "5",
				voiceOver = "MISSION_SWISSMADE_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
