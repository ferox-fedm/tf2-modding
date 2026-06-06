local params = require "params"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m5", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_SHEEP")
			self:setProgressNone()
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_MEDAL_SHEEP_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_MEDAL_SHEEP_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = { 0, 0, 5000 },
				voiceOver = "MISSION_HIGHLANDS_MEDAL_SHEEP_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m5a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	local maxAnimals = 100
	local task = {
		onStart = function(self)
			taskutil.userstate.sheepid2marker = {}
			taskutil.userstate.marker2sheepid = {}
			local entities = game.interface.getEntities({ radius = 1e100 }, { type = "ANIMAL" })
			local k = 0
			for i = 1, #entities do
				local animal = game.interface.getEntity(entities[i])
				if animal.modelName:match("sheep") then
					k = k + 1
					taskutil:setMarker("animal" .. k, { entity = entities[i], type = "question" }, self.name, "selectanimal" .. k)
					taskutil.userstate.sheepid2marker[entities[i]] = k
					taskutil.userstate.marker2sheepid[k] = entities[i]
					if k >= maxAnimals then break end
				end
			end
			taskutil.userstate.animalstoselect = math.min(4, k)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			for i = 1, maxAnimals do
				taskutil:setMarker("animal" .. i)
			end
			taskutil.tasks["m5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_MEDAL_SHEEP_COUNT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_MEDAL_SHEEP_COUNT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_MEDAL_SHEEP_COUNT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m5",
				camera = { 0, 0, 5000 },
				voiceOver = "MISSION_HIGHLANDS_MEDAL_SHEEP_COUNT_TEXT.wav",
			}
		end,
		handlers = {
			selectanimal = function(self, id)
				local i = taskutil.userstate.sheepid2marker[id]
				if i ~= nil then
					taskutil.userstate.sheepid2marker[id] = nil
					taskutil.userstate.marker2sheepid[i] = nil
					taskutil:setMarker("animal" .. i)
					taskutil.userstate.animalstoselect = taskutil.userstate.animalstoselect - 1
					if taskutil.userstate.animalstoselect <= 0 then
						taskutil:finish(self.name)
					end
				end
			end
		},
		guiHandlers = {
			guiHandleEvent = function(self, id, name, param)
				if id == "mainView" and name == "select" then
					taskutil:sendScriptFn(self.name, "selectanimal", { param })
				end
			end
		},
	}

	for i = 1, maxAnimals do
		local name = "selectanimal" .. i
		task.guiHandlers[name] = function(self)
			taskutil:sendScriptFn(self.name, "selectanimal", { taskutil.userstate.marker2sheepid[i] })
		end
	end

	taskutil:new("m5a", task)

	taskutil:new("m5b", {
		onStart = function(self)
			taskutil.userstate.noisetodo = 3
			taskutil:enableProposalCheck()
			taskutil:setProposal("bulldoze", self.name, "bulldoze")
		end,
		onUpdate = function(self)
			self:setProgressCount(3 - taskutil.userstate.noisetodo, 3, 1)
		end,
		onFinish = function(self)
			taskutil:setProposal("bulldoze")
			taskutil:disableProposalCheck()
			taskutil:setMedalCompleted("MEDAL_SHEEP")
			taskutil.tasks["m5c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_MEDAL_SHEEP_SLEEP_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_MEDAL_SHEEP_SLEEP_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_MEDAL_SHEEP_SLEEP_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_HIGHLANDS_MEDAL_SHEEP_SLEEP_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m5",
				camera = { 0, 0, 5000 },
				voiceOver = "MISSION_HIGHLANDS_MEDAL_SHEEP_SLEEP_TEXT.wav",
			}
		end,
		handlers = {
			bulldoze = function(self, id, name, param, isApply)
				taskutil.userstate.noisetodo = taskutil.userstate.noisetodo - 1
				if taskutil.userstate.noisetodo == 0 then
					taskutil:finish(self.name)
				end
			end,
		},
		guiHandlers = {
			bulldoze = function(self, id, name, param, isApply)
				if isApply then
					taskutil:sendScriptFn(self.name, "bulldoze")
				end
				return true
			end,
		},
	})

	taskutil:new("m5c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_MEDAL_SHEEP_FINISH_NAME") % params,
				paragraphs = { { text = _("MISSION_HIGHLANDS_MEDAL_SHEEP_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m5",
				voiceOver = "MISSION_HIGHLANDS_MEDAL_SHEEP_FINISH_TEXT.wav",
			}
		end,
	})
end
