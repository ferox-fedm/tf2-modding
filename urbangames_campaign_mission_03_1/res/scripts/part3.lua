local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local guidesystem = require "guidesystem"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("3", {
		onStart = function(self)
			taskutil:setMusicTrack("track3")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_WORKERS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_WORKERS_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_glasgow,
				voiceOver = "MISSION_HIGHLANDS_TASK_WORKERS_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_trainstation"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			local pos1 = game.interface.getEntity(params.fortwilliam).position
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
			taskutil.userstate.guidesystemkeys["guides_trainstation"] = nil
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_WORKERS_CONNECT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_WORKERS_CONNECT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_TASK_WORKERS_CONNECT_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_fortwilliam,
				voiceOver = "MISSION_HIGHLANDS_TASK_WORKERS_CONNECT_TEXT.wav",
			}
		end,
	})

	taskutil:new("3b", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm5", 120)
			arrivaltracker.track("3b", { cargotype = "PASSENGERS", from = params.fortwilliam, to = params.glasgow })
		end,
		onUpdate = function(self)
			local tot = arrivaltracker.get("3b")
			if tot >= params.glasgow_passengers then
				self:finish()
				return
			end
			self:setProgressCount(tot, params.glasgow_passengers)

		end,
		onFinish = function(self)
			arrivaltracker.track("3b")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_WORKERS_TRANSPORT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_WORKERS_TRANSPORT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_TASK_WORKERS_TRANSPORT_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_glasgow,
				voiceOver = "MISSION_HIGHLANDS_TASK_WORKERS_TRANSPORT_TEXT.wav",
			}
		end,
		handlers = {
			showm5 = function(self)
				if taskutil.tasks["m5"].start ~= nil then
					taskutil.tasks["m5"]:start()
				end
			end,
		},
	})

	--[[taskutil:new("3c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			local e = game.interface.getEntity(params.fortwilliam)
			local t = {
				A = params.fortwilliam,
			}
			for k,v in pairs(table.copy(t)) do t[k.."1"] = game.interface.getEntity(v).name end
			t.x = 100 * params.lineusage_3c

			return {
				name = _("Linienutzung erhöhen"),
				paragraphs = {
					{ type = "TASK", text = _("Erhöhe die Linienutzung in [link=${A}]${A1}[/link] erhöhen auf ${x}%") % t },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = { e.position[1], e.position[2], 500 },
			}
		end,
	})]]--

end
