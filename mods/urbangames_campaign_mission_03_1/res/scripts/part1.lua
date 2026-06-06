local params = require "params"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"
local vehiclestore = require "mission.vehiclestore"
local guidesystem = require "guidesystem"

return function(taskutil)
	local tasks = taskutil.tasks

	local mainguihandlers = {
		checkProposal = function(self, id, name, param, isApply)
			if id ~= "trackBuilder" then return true end
			local as = param.proposal.proposal.addedSegments
			for i = 1, #as do
				if as[i].comp.type == "BRIDGE" then
					return _("MISSION_PROPOSAL_FEEDBACK_NO_BRIDGES_ALLOWED")
				end
			end
			return true
		end,
		voiceOverEnded = function(self) taskutil:finish(self.name) end,
	}

	setmetatable(mainguihandlers, { __index = function(self, key)
		local n = #"jump_"
		if key:sub(1, n) == "jump_" then
			game.gui.setAutoCamera(params[key])
		end
	end})

	taskutil:new("1", {
		onStart = function(self)
			taskutil:setEnabled("menu.construction.watermenu", false)

			taskutil:enableProposalCheck()
			taskutil:setProposalCheckBlacklist()
			taskutil:setProposal("nobridge", self.name, "checkProposal")
			self:setProgressNone()

		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_SHIPS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_SHIPS_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_firth_cam,
				voiceOver = "MISSION_HIGHLANDS_TASK_SHIPS_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.glasgow_steelmill).simBuildings[1]).itemsConsumed
			if c.IRON_ORE ~= nil and c.COAL ~= nil then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_SHIPS_STEEL_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_SHIPS_STEEL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_TASK_SHIPS_STEEL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_glasgow_steelmill,
				voiceOver = "MISSION_HIGHLANDS_TASK_SHIPS_STEEL_TEXT.wav",
			}
		end,
	})

	taskutil:new("1b", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_landuse"] = guidesystem.getTime()
		end,
		onUpdate = function(self)

			local pos = game.interface.getEntity(params.glasgow).position
			local stations = game.interface.getEntities({pos = pos, radius = 500}, {type = "STATION"})

			local tot = 0
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.STEEL or 0
				tot = tot + s
			end
			if tot >= params.steel_task_ships_deliver then
				self:finish()
			end
			self:setProgressCount(tot, params.steel_task_ships_deliver)

		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_landuse"] = nil
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_TASK_SHIPS_DELIVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_TASK_SHIPS_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_TASK_SHIPS_DELIVER_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_glasgow,
				voiceOver = "MISSION_HIGHLANDS_TASK_SHIPS_DELIVER_TEXT.wav",
			}
		end,
	})

end
