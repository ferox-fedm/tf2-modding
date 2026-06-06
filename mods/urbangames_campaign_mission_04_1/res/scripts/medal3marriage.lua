local params = require "params"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m3", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_MARRIAGE")
			self:setProgressNone()
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_MEDAL_MARIAGE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_MARIAGE_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_topolobampo,
				voiceOver = "MISSION_PARADISO_MEDAL_MARIAGE_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self)
				taskutil:start("m3a")
				taskutil:finish(self.name)
			end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m3a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local pos = game.interface.getEntity(params.platform).position
			local stations = game.interface.getEntities({pos = pos, radius = 500}, {type = "STATION"})

			local people = 0
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.PASSENGERS or 0
				people = people + s
			end
			self:setProgressCount(people, params.marriage_transport_people, 1)
			if people >= params.marriage_transport_people then self:setSubtaskCompleted(1) end

			local trees = game.interface.getEntities({pos = pos, radius = 25}, {type = "ASSET_GROUP"})
			local count = 0
			for i = 1, #trees do
				local e = game.interface.getEntity(trees[i])
				local mdls = e.models
				for k,v in pairs(mdls) do
					if k:sub(1, 4) == "tree" then
						count = count + v
					end
				end
			end
			self:setProgressCount(count, params.marriage_transport_people, 2)
			if count >= params.marriage_transport_people then self:setSubtaskCompleted(2) end

			if people >= params.marriage_transport_people and count >= params.marriage_transport_people then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_MEDAL_MARIAGE_TRANSPORT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_MARIAGE_TRANSPORT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_MEDAL_MARIAGE_TRANSPORT_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_PARADISO_MEDAL_MARIAGE_TRANSPORT_SUB1") % params },
					{ name = _("MISSION_PARADISO_MEDAL_MARIAGE_TRANSPORT_SUB2") % params },
				},
				parentId = "m3",
				camera = params.jump_platform,
				voiceOver = "MISSION_PARADISO_MEDAL_MARIAGE_TRANSPORT_TEXT.wav",
			}
		end,
	})

	taskutil:new("m3b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_MARRIAGE")
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_MEDAL_MARIAGE_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_MARIAGE_FINISH_TEXT") % params }
				},
				options = { { _("Unfortunate!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m3",
				voiceOver = "MISSION_PARADISO_MEDAL_MARIAGE_FINISH_TEXT.wav",
			}
		end,
	})
end
