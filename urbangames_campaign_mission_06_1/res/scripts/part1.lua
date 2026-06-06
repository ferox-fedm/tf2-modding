local params = require "params"
local util = require "util"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local proposalutil = require "mission.proposalutil"
local vehiclestore = require "mission.vehiclestore"

return function(taskutil)
	local tasks = taskutil.tasks

	local mainguihandlers = {
		jump_hq = function(self)
			local hq = util.getHq()
			if hq == nil then return end
			game.gui.setAutoCamera({ hq.position[1], hq.position[2], 250 })
		end,
		checkProposal = function(self, id, name, param)
			return proposalutil.checkTrackBuildOrBulldozeInAreaBlacklist(params.prohibitedzone)(id, name, param)
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
			taskutil:invokeLater(self.name, "showmedal3", 180)
			vehiclestore.setAllowedVehicleCount("vehicle/waggon/sultan_v2.mdl", 0)
			taskutil:enableProposalCheck()
			taskutil:setProposalCheckBlacklist()
			taskutil:setZone("prohibitedzone", { polygon = params.prohibitedzone, draw = true, drawColor = colors.RED })
			taskutil:setProposal("prohibitedzone", self.name, "checkProposal")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_TASK_DEVELOP_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_DEVELOP_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_overview,
				voiceOver = "MISSION_BAGDAD_TASK_DEVELOP_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
		handlers = {
			showmedal3 = function(self) taskutil:start("m3") end,
		},
	})

	taskutil:new("1a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local level = game.interface.getEntity(game.interface.getEntity(params.food_processing).simBuildings[1]).level + 1
			self:setProgressCount(level, 2)

			--local f = game.interface.getTownCargoSupplyAndLimit(params.konya).FOOD
			--local done2 = f[1] >= params.food_1a
			--self:setProgressCount(f[1], params.food_1a, 2)

			if level == 2 then self:finish() end

		end,
		onFinish = function(self)
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_BAGDAD_TASK_DEVELOP_CONNECT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_BAGDAD_TASK_DEVELOP_CONNECT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_BAGDAD_TASK_DEVELOP_CONNECT_TASK") % params },
				},
				--subTasks = {
				--	{ name = _("MISSION_BAGDAD_TASK_DEVELOP_CONNECT_SUB1") % params },
				--	{ name = _("MISSION_BAGDAD_TASK_DEVELOP_CONNECT_SUB2") % params },
				--},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_food_processing,
				voiceOver = "MISSION_BAGDAD_TASK_DEVELOP_CONNECT_TEXT.wav",
			}
		end,
	})
end
