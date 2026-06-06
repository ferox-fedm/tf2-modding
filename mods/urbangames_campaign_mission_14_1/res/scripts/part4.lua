local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
	taskutil:new("4", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track4")
		end,
		onFinish = function(self)
			taskutil.tasks["4a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_PLAN_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_PLAN_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_bukarest,
				voiceOver = "MISSION_LEADER_TASK_PLAN_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	local checkfin = function(name)
		return taskutil.tasks[name].start == nil and taskutil.tasks[name].finish == nil
	end
	taskutil:new("4a", {
		onStart = function(self)
			taskutil:setMarker("4b", { entity = params.district1, type = "question" }, self.name, "start4b")
			taskutil:setMarker("4c", { entity = params.district2, type = "question" }, self.name, "start4c")
			taskutil:setMarker("4d", { entity = params.district3, type = "question" }, self.name, "start4d")
		end,
		onUpdate = function(self)
			local done = 0
			if checkfin("4b") then done = done + 1 end
			if checkfin("4c") then done = done + 1 end
			if checkfin("4d") then done = done + 1 end
			self:setProgressCount(done, 3)

			if checkfin("4b") and checkfin("4c") and checkfin("4d") then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("5")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_PLAN_QUARTERS_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_PLAN_QUARTERS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_PLAN_QUARTERS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_bukarest,
				voiceOver = "MISSION_LEADER_TASK_PLAN_QUARTERS_TEXT.wav",
			}
		end,
		handlers = {
			start4b = function(self)
				taskutil:setMarker("4b")
				taskutil:start("4b")
			end,
			start4c = function(self)
				taskutil:setMarker("4c")
				taskutil:start("4c")
			end,
			start4d = function(self)
				taskutil:setMarker("4d")
				taskutil:start("4d")
			end,
		},
	})

	taskutil:new("4b", {
		onStart = function(self)
			arrivaltracker.track("4b1", { cargotype = "STEEL", to = params.district1 })
			arrivaltracker.track("4b2", { cargotype = "PLASTIC", to = params.district1 })
		end,
		onUpdate = function(self)
			local c1 = arrivaltracker.get("4b1")
			local c2 = arrivaltracker.get("4b2")

			self:setProgressCount(c1, params.steel_district_amount, 1)
			self:setProgressCount(c2, params.plastic_district_amount, 2)

			local done1 = c1 >= params.steel_district_amount
			local done2 = c2 >= params.plastic_district_amount

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("4b1")
			arrivaltracker.track("4b2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_PLAN_QUARTERS_EAST_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_PLAN_QUARTERS_EAST_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_PLAN_QUARTERS_EAST_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_LEADER_TASK_PLAN_QUARTERS_EAST_SUB1") % params },
					{ name = _("MISSION_LEADER_TASK_PLAN_QUARTERS_EAST_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_district1,
				voiceOver = "MISSION_LEADER_TASK_PLAN_QUARTERS_EAST_TEXT.wav",
			}
		end,
	})

	local radius = 250
	taskutil:new("4c", {
		onStart = function(self)
			taskutil:enableProposalCheck()
			taskutil:setProposal("bulldoze", self.name, "bulldoze")
			taskutil.userstate.street_district_amount = params.street_district_amount
			taskutil.userstate.house_district_amount = params.house_district_amount
			local polygon = zoneutil.makeCircleZone(params.pos_district2, radius)
			taskutil:setZone("prop4c", { polygon = polygon, draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local c1 = params.house_district_amount - taskutil.userstate.house_district_amount
			local c2 = params.street_district_amount - taskutil.userstate.street_district_amount

			self:setProgressCount(c1, params.house_district_amount, 1)
			self:setProgressCount(c2, params.street_district_amount, 2)

			local done1 = c1 >= params.house_district_amount
			local done2 = c2 >= params.street_district_amount

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("prop4c")
			taskutil:setProposal("bulldoze")
			taskutil:disableProposalCheck()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_PLAN_QUARTERS_CENTER_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_PLAN_QUARTERS_CENTER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_PLAN_QUARTERS_CENTER_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_LEADER_TASK_PLAN_QUARTERS_CENTER_SUB1") % params },
					{ name = _("MISSION_LEADER_TASK_PLAN_QUARTERS_CENTER_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_district2,
				voiceOver = "MISSION_LEADER_TASK_PLAN_QUARTERS_CENTER_TEXT.wav",
			}
		end,
		handlers = {
			bulldozestreet = function(self, id, name, param, isApply)
				taskutil.userstate.street_district_amount = taskutil.userstate.street_district_amount - 1
			end,
			bulldozehouse = function(self, id, name, param, isApply)
				taskutil.userstate.house_district_amount = taskutil.userstate.house_district_amount - 1
			end,
		},
		guiHandlers = {
			bulldoze = function(self, id, name, param, isApply)
				if id == "bulldozer" and isApply then
					for i = 1, #param.proposal.proposal.removedSegments do
						taskutil:sendScriptFn(self.name, "bulldozestreet")
					end
					for i = 1, #param.proposal.toRemove do
						taskutil:sendScriptFn(self.name, "bulldozehouse")
					end
				end
				return true
			end,
		},
	})

	taskutil:new("4d", {
		onStart = function(self)
			taskutil:setZone("prop4d1", { polygon = zoneutil.makeCircleZone(params.zone_street1.pos, params.zone_street1.radius), draw = true, drawColor = colors.BLUE })
			taskutil:setZone("prop4d2", { polygon = zoneutil.makeCircleZone(params.zone_street2.pos, params.zone_street2.radius), draw = true, drawColor = colors.BLUE })
			taskutil:setZone("prop4d3", { polygon = zoneutil.makeCircleZone(params.zone_street3.pos, params.zone_street3.radius), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local path1 = game.interface.findPath(params.zone_street1, params.zone_street2)
			local path2 = game.interface.findPath(params.zone_street1, params.zone_street3)
			if path1 ~= nil and path2 ~= nil then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("prop4d1")
			taskutil:setZone("prop4d2")
			taskutil:setZone("prop4d3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_PLAN_QUARTERS_WEST_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_PLAN_QUARTERS_WEST_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_PLAN_QUARTERS_WEST_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_district3,
				voiceOver = "MISSION_LEADER_TASK_PLAN_QUARTERS_WEST_TEXT.wav",
			}
		end,
	})
end
