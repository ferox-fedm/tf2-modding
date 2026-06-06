local params = require "params"
local guidesystem = require "guidesystem"
local guides = require "guides"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("5", {
		onStart = function(self)
			taskutil:setMusicTrack("track5")
			taskutil:setEnabled("menu.construction.watermenu", true)
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["5a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_FISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_FISH_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_glasgow,
				voiceOver = "MISSION_HIGHLANDS_TASK_FISH_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local pos1 = game.interface.getEntity(params.mallaig_fishery).position
			local stations1 = game.interface.getEntities({pos = pos1, radius = 500}, {type = "STATION"})

			local pos2 = game.interface.getEntity(params.glasgow).position
			local stations2 = game.interface.getEntities({pos = pos2, radius = 500}, {type = "STATION"})
			for i = 1, #stations1 do
				for j = 1, #stations2 do
					local path = game.interface.findPath(stations1[i], stations2[j], { TRAIN = true })
					if path ~= nil then
						self:finish()
						return
					end
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_FISH_CONNECT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_FISH_CONNECT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_TASK_FISH_CONNECT_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_mallaig_fishery,
				voiceOver = "MISSION_HIGHLANDS_TASK_FISH_CONNECT_TEXT.wav",
			}
		end,
	})

	taskutil:new("5b", {
		onStart = function(self)
			guides.restart(guidesystem.addGuiGuideLanduseButton, "landuseButton")
			taskutil.userstate.guidesystemkeys["guides_landuse"] = guidesystem.getTime()
			taskutil:invokeLater(self.name, "showm2", 120)
		end,
		onUpdate = function(self)
			--[[local f = game.interface.getTownCargoSupplyAndLimit(params.glasgow).FISH
			local ratio = f[1] / f[2]
			if ratio >= params.fish_glasgow then
				self:finish()
			end
			self:setProgressPercent(math.floor(ratio))]]--

			local pos = game.interface.getEntity(params.glasgow).position
			local stations = game.interface.getEntities({pos = pos, radius = 500}, {type = "STATION"})

			local tot = 0
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.FISH or 0
				tot = tot + s
			end
			if tot >= params.fish_glasgow then
				self:finish()
			end
			self:setProgressCount(tot, params.fish_glasgow)

		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_landuse"] = nil
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_FISH_DELIVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_FISH_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_TASK_FISH_DELIVER_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_glasgow,
				voiceOver = "MISSION_HIGHLANDS_TASK_FISH_DELIVER_TEXT.wav",
			}
		end,
		handlers = {
			showm2 = function(self)
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
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
				name = _("MISSION_HIGHLANDS_TASK_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_FINISH_TEXT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				voiceOver = "MISSION_HIGHLANDS_TASK_FINISH_TEXT.wav",
			}
		end,
	})

end
