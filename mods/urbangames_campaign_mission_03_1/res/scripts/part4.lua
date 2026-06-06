local params = require "params"
local guidesystem = require "guidesystem"
local guides = require "guides"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("4", {
		onStart = function(self)
			taskutil:setMusicTrack("track4")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["4a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_WHISKY_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_WHISKY_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_glasgow,
				voiceOver = "MISSION_HIGHLANDS_TASK_WHISKY_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4x", {
		onStart = function(self)
			taskutil.userstate["distilleries_4a"] = {
				params.portellen_distillery,
				params.tobermory_distillery,
			}
		end,
		onUpdate = function(self)
			local d = taskutil.userstate.distilleries_4a

			for i = 1, #d do
				if (game.interface.getEntity(game.interface.getEntity(d[i]).simBuildings[1]).itemsProduced._sum or 0) > 0 then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["4b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("unused") % params,
				paragraphs = {
					{ text = _("unused") % params },
					{ type = "TASK", text = _("unused") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_glasgow,
			}
		end,
	})

	taskutil:new("4a", {
		onStart = function(self)
			guides.restart(guidesystem.addGuiGuideLanduseButton, "landuseButton")
			taskutil.userstate.guidesystemkeys["guides_landuse"] = guidesystem.getTime()
			taskutil:invokeLater(self.name, "showm1", 120)
		end,
		onUpdate = function(self)
			--[[local w = game.interface.getTownCargoSupplyAndLimit(params.glasgow).WHISKEY
			local ratio = w[1] / w[2]
			if ratio >= params.whiskey_glasgow then
				self:finish()
			end
			self:setProgressPercent(math.floor(ratio))]]--

			local pos = game.interface.getEntity(params.glasgow).position
			local stations = game.interface.getEntities({pos = pos, radius = 500}, {type = "STATION"})

			local tot = 0
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.WHISKEY or 0
				tot = tot + s
			end
			if tot >= params.whiskey_glasgow then
				self:finish()
			end
			self:setProgressCount(tot, params.whiskey_glasgow)

		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_landuse"] = nil
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_WHISKY_DELIVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_WHISKY_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_TASK_WHISKY_DELIVER_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_glasgow,
				voiceOver = "MISSION_HIGHLANDS_TASK_WHISKY_DELIVER_TEXT.wav",
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

end
