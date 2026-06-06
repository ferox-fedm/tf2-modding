local params = require "params"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("2", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track2")
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_TASK_TAURUS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_TAURUS_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_overview,
				voiceOver = "MISSION_BAGDAD_TASK_TAURUS_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local pos = {}
			pos[#pos + 1] = game.interface.getEntity(params.konya).position
			pos[#pos + 1] = game.interface.getEntity(params.ergeli).position
			pos[#pos + 1] = game.interface.getEntity(params.aleppo).position
			pos[#pos + 1] = game.interface.getEntity(params.adana).position

			local count = 0

			for i = 1, 3, 2 do
				local j = i + 1
				local path
				local stations1 = game.interface.getEntities({pos = pos[i], radius = 500}, {type = "STATION"})
				local stations2 = game.interface.getEntities({pos = pos[j], radius = 500}, {type = "STATION"})

				for k = 1, #stations1 do
					local s1 = stations1[k]
					for l = 1, #stations2 do
						local s2 = stations2[l]
						path = game.interface.findPath(s1, s2, { TRAIN = true })
						if path ~= nil then
							break
						end
					end
					if path ~= nil then break end
				end

				local unloaded = false
				for k = 1, #stations2 do
					local s = game.interface.getEntity(stations2[k])
					if s.carriers["RAIL"] then
						local sg = game.interface.getEntity(s.stationGroup)
						if (sg.itemsUnloaded.PASSENGERS or 0) > 0 then
							unloaded = true
							break
						end
					end
				end

				self:setSubtaskCompleted(i == 1 and 1 or 2, path ~= nil)
				self:setSubtaskCompleted(i == 1 and 3 or 4, unloaded)
				if path ~= nil then count = count + 1 end
				if unloaded then count = count + 1 end
			end

			if count == 4 then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_TASK_TAURUS_CONNECT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_TAURUS_CONNECT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_TASK_TAURUS_CONNECT_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_BAGDAD_TASK_TAURUS_CONNECT_SUB1") % params },
					{ name = _("MISSION_BAGDAD_TASK_TAURUS_CONNECT_SUB2") % params },
					{ name = _("MISSION_BAGDAD_TASK_TAURUS_CONNECT_SUB4") % params },
					{ name = _("MISSION_BAGDAD_TASK_TAURUS_CONNECT_SUB3") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_overview,
				voiceOver = "MISSION_BAGDAD_TASK_TAURUS_CONNECT_TEXT.wav",
			}
		end,
	})
end
