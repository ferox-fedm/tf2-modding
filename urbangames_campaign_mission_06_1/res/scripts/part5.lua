local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"

return function(taskutil)
	local tasks = taskutil.tasks

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
				name = _("MISSION_BAGDAD_TASK_MACHINES_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_MACHINES_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_overview,
				voiceOver = "MISSION_BAGDAD_TASK_MACHINES_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
			game.interface.upgradeConstruction(params.constructionsite, "industry/construction_site.con", { productionLevel = 0, active = true })
		end,
		onUpdate = function(self)
			local consumed1 = game.interface.getEntity(game.interface.getEntity(params.constructionsite).simBuildings[1]).itemsConsumed.MACHINES or 0
			local consumed2 = 0
			local sb = game.interface.getEntity(params.well1).simBuildings[1]
			if sb then
				consumed2 = game.interface.getEntity(sb).itemsConsumed.MACHINES or 0
			end
			self:setProgressCount(consumed2, params.machines_deliver_amount2, 1)
			self:setProgressCount(consumed1, params.machines_deliver_amount, 2)
			self:setSubtaskCompleted(1, consumed2 >= params.machines_deliver_amount2)
			self:setSubtaskCompleted(2, consumed1 >= params.machines_deliver_amount)
			if consumed1 >= params.machines_deliver_amount and consumed2 >= params.machines_deliver_amount2 then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["5b"]:start()
		end,
		getInfo = function(self)
			local pos = game.interface.getEntity(params.constructionsite)
			return {
				name = _("MISSION_BAGDAD_TASK_MACHINES_DELIVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_MACHINES_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_TASK_MACHINES_DELIVER_TASK") % params, },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_constructionsite,
				voiceOver = "MISSION_BAGDAD_TASK_MACHINES_DELIVER_TEXT.wav",
				subTasks = {
					{ name = _("MISSION_BAGDAD_TASK_MACHINES_DELIVER_SUB2") % params },
					{ name = _("MISSION_BAGDAD_TASK_MACHINES_DELIVER_SUB1") % params },
				},
			}
		end,
	})

	taskutil:new("5b", {
		onStart = function(self)
			taskutil:setZone("prohibitedzone")
			taskutil:setProposal("prohibitedzone")
		end,
		onUpdate = function(self)
			local stations1 = game.interface.getEntities({pos = game.interface.getEntity(params.ergeli).position, radius = 500}, {type = "STATION"})
			local stations2 = game.interface.getEntities({pos = game.interface.getEntity(params.adana).position, radius = 500}, {type = "STATION"})

			for k = 1, #stations1 do
				local s1 = stations1[k]
				for l = 1, #stations2 do
					local s2 = stations2[l]
					local path = game.interface.findPath(s1, s2, { TRAIN = true })
					if path ~= nil then
						self:finish()
						return
					end
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["5c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_TASK_MACHINES_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_MACHINES_FINISH_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_TASK_MACHINES_FINISH_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_ergeli_adana_mid,
				voiceOver = "MISSION_BAGDAD_TASK_MACHINES_FINISH_TEXT.wav",
			}
		end,
	})

	taskutil:new("5c", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal2", 120)
			arrivaltracker.track("5c", { cargotype = "CRUDE", to = params.konya })
		end,
		onUpdate = function(self)
			local c = arrivaltracker.get("5c")
			if c >= params.crude_amount then
				self:finish()
			end
			self:setProgressCount(c, params.crude_amount)
		end,
		onFinish = function(self)
			arrivaltracker.track("5c")
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_TASK_MACHINES_CRUDE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_MACHINES_CRUDE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_TASK_MACHINES_CRUDE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_konya,
				voiceOver = "MISSION_BAGDAD_TASK_MACHINES_CRUDE_TEXT.wav",
			}
		end,
		handlers = {
			showmedal2 = function(self) taskutil:start("m2") end,
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
				name = _("MISSION_BAGDAD_TASK_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_FINISH_TEXT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				voiceOver = "MISSION_BAGDAD_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
