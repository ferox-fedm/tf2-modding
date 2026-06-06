local params = require "params"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"
local proposalutil = require "mission.proposalutil"
local vehiclestore = require "mission.vehiclestore"
local guidesystem = require "guidesystem"


return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("3", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track3")
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			--local e = game.interface.getEntity(params.surabaya_processing)
			return {
				name = _("MISSION_COLONIALISM_TASK_CAPACITY_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_CAPACITY_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_coffee_processing,
				voiceOver = "MISSION_COLONIALISM_TASK_CAPACITY_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
			taskutil:setProposal("p3a", self.name, "checkProposal")
			taskutil:setZone("yellow1", { polygon = zoneutil.makeCircleZone(game.interface.getEntity(params.snap_node1).position, 10), draw = true, drawColor = colors.YELLOW })
			taskutil:setZone("yellow2", { polygon = zoneutil.makeCircleZone(game.interface.getEntity(params.snap_node2).position, 10), draw = true, drawColor = colors.YELLOW })
		end,
		onFinish = function(self)
			taskutil:setProposal("p3a")
			taskutil:setZone("yellow1")
			taskutil:setZone("yellow2")
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_CAPACITY_SWITCH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_CAPACITY_SWITCH_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_CAPACITY_SWITCH_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "3",
				camera = params.jump_snap_node1,
				voiceOver = "MISSION_COLONIALISM_TASK_CAPACITY_SWITCH_TEXT.wav",
			}
		end,
		guiHandlers = {
			checkProposal = function(self, id, name, param, isApply)
				if id ~= "trackBuilder" then return false end
				local nodes = proposalutil.segments2nodes(param.proposal.proposal.addedSegments, param.proposal.proposal.addedNodes)
				local goal1 = nodes[params.snap_node1] ~= nil
				local goal2 = nodes[params.snap_node2] ~= nil
				if goal1 and goal2 then
					if isApply then
						taskutil:finish(self.name)
					end
					return true
				elseif goal1 or goal2 then
					return _("MISSION_PROPOSAL_FEEDBACK_CONNECT_TO_OTHER_YELLOW_CIRCLE"), 10
				else
					return _("MISSION_PROPOSAL_FEEDBACK_CONNECT_WITH_SAME_COLOR_CIRCLE")
				end
			end,
		},
	})

	taskutil:new("3b", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_signals"] = guidesystem.getTime()
			taskutil.userstate.signal3b = 2

			taskutil:setProposal("p3b1", self.name, "checkProposal1")
			taskutil:setProposal("p3b2", self.name, "checkProposal2")

			local polyB = zoneutil.makeCircleZone(params.circle_signal_task1.pos, 10)
			local polyG = zoneutil.makeCircleZone(params.circle_signal_task2.pos, 10)
			local zoneB = { polygon = polyB, draw = true, drawColor = colors.BLUE }
			local zoneG = { polygon = polyG, draw = true, drawColor = colors.GREEN }

			taskutil:setZone("blue", zoneB)
			taskutil:setZone("green", zoneG)
		end,
		onUpdate = function(self)
			if taskutil.userstate.signal3b == 0 then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_signals"] = nil
			taskutil:setProposal("p3b1")
			taskutil:setProposal("p3b2")
			taskutil:setZone("green")
			taskutil:setZone("blue")
			taskutil.tasks["3c"]:start()
		end,
		onGuiFinish = function(self)
			game.gui.stopAction()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_CAPACITY_SIGNAL_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_CAPACITY_SIGNAL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_CAPACITY_SIGNAL_TASK") % params },
					{ type = "HINT", text = _("MISSION_COLONIALISM_TASK_CAPACITY_SIGNAL_HINT") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				subTasks = {
					{ name = _("MISSION_COLONIALISM_TASK_CAPACITY_SIGNAL_SUB1") },
					{ name = _("MISSION_COLONIALISM_TASK_CAPACITY_SIGNAL_SUB2") },
				},
				parentId = "3",
				camera = params.jump_circle_signal_task1,
				voiceOver = "MISSION_COLONIALISM_TASK_CAPACITY_SIGNAL_TEXT.wav",
			}
		end,
		handlers = {
			h1 = function(self)
				taskutil:setProposal("p3b1")
				taskutil:setZone("blue")
				taskutil.userstate.signal3b = taskutil.userstate.signal3b - 1
				self:setSubtaskCompleted(1)
			end,
			h2 = function(self)
				taskutil:setProposal("p3b2")
				taskutil:setZone("green")
				taskutil.userstate.signal3b = taskutil.userstate.signal3b - 1
				self:setSubtaskCompleted(2)
			end,
		},
		guiHandlers = {
			checkProposal1 = function(self, id, name, param, isApply)
				local e = params.segments_3b[1]
				return proposalutil.checkTrackSignal(e, id, name, param, isApply, function()
					taskutil:sendScriptFn(self.name, "h1")
				end)
			end,
			checkProposal2 = function(self, id, name, param, isApply)
				local e = params.segments_3b[2]
				return proposalutil.checkTrackSignal(e, id, name, param, isApply, function()
					taskutil:sendScriptFn(self.name, "h2")
				end)
			end,
		}
	})

	taskutil:new("3c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local v = vehiclestore.currentvehicles
			if (v[params.modelnames.train1] or 0) + (v[params.modelnames.train2] or 0) + (v[params.modelnames.train3] or 0) >= params.trains_2c and
					(v[params.modelnames.goodswagon] or 0) >= 2 * params.num_wagons then
				local vehicles = game.interface.getVehicles({ carrier = "RAIL" })
				local lines = {}
				for i = 1, #vehicles do
					local l = game.interface.getEntity(vehicles[i]).line
					if l >= 0 and lines[l] ~= nil then
						self:finish()
						return
					else
						lines[l] = 1
					end
				end
			end
		end,
		onFinish = function(self)
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_CAPACITY_TRAIN_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_CAPACITY_TRAIN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_CAPACITY_TRAIN_TASK") % params },
					},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_buildingarea_processing_center,
				voiceOver = "MISSION_COLONIALISM_TASK_CAPACITY_TRAIN_TEXT.wav",
			}
		end,
	})
end
