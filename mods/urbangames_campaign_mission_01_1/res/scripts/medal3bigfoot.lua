local taskutil = require "mission.taskutil"
local params = require "params"
local gui = require "gui"

local function getSaloon()
	local entities = game.interface.getEntities({ pos = params.pos_virginiaCity, radius = 200 }, { type = "CONSTRUCTION" })
	for i = 1, #entities do
		local e = game.interface.getEntity(entities[i])
		if e.fileName:match("/com_") then
			return entities[i]
		end
	end
	return params.silverOreMine
end

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_BIGFOOT")
			self:setProgressNone()
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_TEXT") % params },
				},
				isMedal = true,
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				camera = { params.pos_virginiaCity[1], params.pos_virginiaCity[2], 1000 },
				voiceOver = "MISSION_SILVERCITY_MEDAL_BIGFOOT_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m3a") taskutil:finish(self.name) end,
			decline = function(self)
				gui.window_get("missionDisplayWindow"):close()
				taskutil:finish(self.name)
			end,
		},
	})

	taskutil:new("m3a", {
		onStart = function(self)
			self:setProgressNone()
			taskutil.userstate.saloon = getSaloon()
			game.interface.setBulldozeable(taskutil.userstate.saloon, false)
			taskutil:setMarker("bigfoot1", { entity = taskutil.userstate.saloon, type = "question" }, self.name, "finish")
		end,
		onUpdate = function(self)
			if game.interface.getEntity(taskutil.userstate.saloon) == nil then
				taskutil.userstate.saloon = getSaloon()
				game.interface.setBulldozeable(taskutil.userstate.saloon, false)
				taskutil:setMarker("bigfoot1", { entity = taskutil.userstate.saloon, type = "question" }, self.name, "finish")
			end
		end,
		onFinish = function(self)
			taskutil:setMarker("bigfoot1")
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE1_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE1_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE1_TASK") % params },
				},
				parentId = "m3",
				camera = { params.pos_virginiaCity[1], params.pos_virginiaCity[2], 1000 },
				voiceOver = "MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE1_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3b", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMarker("bigfoot2", { entity = params.forestCarson, type = "question" }, self.name, "finish")
		end,
		onFinish = function(self)
			taskutil:setMarker("bigfoot2")
			taskutil:startLater("m3c")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE2_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE2_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE2_TASK") % params },
				},
				parentId = "m3",
				camera = { params.pos_forestCarson[1], params.pos_forestCarson[2], 1000 },
				voiceOver = "MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE2_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3c", {
		onStart = function(self)
			self:setProgressNone()

			taskutil:setMarker("bigfootTask3", { entity = params.lakeHouse, type = "question" }, self.name, "finish")
		end,
		onFinish = function(self)
			taskutil:setMarker("bigfootTask3")
			taskutil:setMedalCompleted("MEDAL_BIGFOOT")
			taskutil:startLater("m3d")
		end,
		onUpdate = function(self)
			if game.interface.getEntity(params.lakeHouse) == nil then
				self:finish()
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE3_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE3_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE3_TASK") % params },
				},
				parentId = "m3",
				camera = { params.lakepos[1], params.lakepos[2], 1250 },
				voiceOver = "MISSION_SILVERCITY_MEDAL_BIGFOOT_CLUE3_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3d", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_MEDAL_BIGFOOT_FINISH_TEXT") % params },
				},
				parentId = "m3",
				options = { { label or _("Ok!"), "finish" } },
				optionsRightAlign = true,
				voiceOver = "MISSION_SILVERCITY_MEDAL_BIGFOOT_FINISH_TEXT.wav",
			}
		end,
	})
end
