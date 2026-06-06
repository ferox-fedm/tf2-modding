local params = require "params"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local vehiclestore = require "mission.vehiclestore"
local guidesystem = require "guidesystem"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("2", {
		onStart = function(self)
			taskutil:setMusicTrack("track2")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_ISLANDS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_ISLANDS_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_portellen_distillery,
				voiceOver = "MISSION_HIGHLANDS_TASK_ISLANDS_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			taskutil:setVisibleAndEnabled("menu.construction.water.water-buildings.item.station/water/harbor_modular.con_0", false)
			taskutil:setEnabled("menu.construction.watermenu", true)
			taskutil:setZone("blue", { polygon = zoneutil.makeCircleZone(params.glasgow_harbor_zone.pos, params.glasgow_harbor_zone.radius), draw = true, drawColor = colors.BLUE })
			taskutil.userstate.guidesystemkeys["guides_harbor"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			local entities = game.interface.getEntities(params.glasgow_harbor_zone, { type = "CONSTRUCTION" })
			for i = 1, #entities do
				local e = game.interface.getEntity(entities[i])
				if e.fileName == "station/water/harbor_modular.con" then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_harbor"] = nil
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_ISLANDS_HARBOUR_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_ISLANDS_HARBOUR_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_TASK_ISLANDS_HARBOUR_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_glasgow_harbor_zone,
				voiceOver = "MISSION_HIGHLANDS_TASK_ISLANDS_HARBOUR_TEXT.wav",
			}
		end,
	})

	taskutil:new("2b", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_dock"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			local entities = game.interface.getEntities(params.glasgow_harbor_zone, { type = "CONSTRUCTION" })
			for i = 1, #entities do
				local e = game.interface.getEntity(entities[i])
				if e.fileName == "depot/shipyard_era_a.con" then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_dock"] = nil
			taskutil:setZone("blue")
			taskutil.tasks["2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_ISLANDS_SHIPYARD_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_ISLANDS_SHIPYARD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_TASK_ISLANDS_SHIPYARD_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_glasgow_harbor_zone,
				voiceOver = "MISSION_HIGHLANDS_TASK_ISLANDS_SHIPYARD_TEXT.wav",
			}
		end,
		guiHandlers = {
			jump = function(self)
				local e = game.interface.getEntity(params.glasgow)
				game.gui.setAutoCamera({e.position[1], e.position[2], 250})
			end,
		},
	})

	taskutil:new("2c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			for k, v in pairs(vehiclestore.currentvehicles) do
				if k:match("ship") then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["2d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_ISLANDS_BUYSHIP_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_ISLANDS_BUYSHIP_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_TASK_ISLANDS_BUYSHIP_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_glasgow_harbor_zone,
				voiceOver = "MISSION_HIGHLANDS_TASK_ISLANDS_BUYSHIP_TEXT.wav",
			}
		end,
		guiHandlers = {
			jump = function(self)
				local e = game.interface.getEntity(params.glasgow)
				game.gui.setAutoCamera({e.position[1], e.position[2], 250})
			end,
		},
	})

	taskutil:new("2d", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local loc = taskutil.userstate.locationstodiscover
			if next(loc) == nil then self:finish() return end
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_ISLANDS_LINE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_ISLANDS_LINE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_TASK_ISLANDS_LINE_TASK") % params },
				},
				options = { { "Debug: Skip", "skip" } },
				parentId = "2",
				camera = params.jump_portellen_harbor,
				voiceOver = "MISSION_HIGHLANDS_TASK_ISLANDS_LINE_TEXT.wav",
			}
		end,
		handlers = {
			skip = function(self)
				taskutil:start("3")
				taskutil:start("4")
				taskutil:finish(self.name)
			end,
		},
		guiHandlers = {
			skip = function(self)
				taskutil:sendScriptFn(self.name, "skip")
			end,
		},
	})

end
