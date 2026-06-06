local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
	taskutil:new("3", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track3")
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_BOOM_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_BOOM_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_decisionlocater,
				voiceOver = "MISSION_VICECOUNTY_TASK_BOOM_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_BOOM_DECISION_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_BOOM_DECISION_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_BOOM_DECISION_TASK") % params },
				},
				options = { { _("MISSION_VICECOUNTY_TASK_BOOM_DECISION_OPTION1"), "option1" },
				            { _("MISSION_VICECOUNTY_TASK_BOOM_DECISION_OPTION2"), "option2" } },
				parentId = "3",
				camera = params.jump_decisionlocater,
				voiceOver = "MISSION_VICECOUNTY_TASK_BOOM_DECISION_TEXT.wav",
			}
		end,
		handlers = {
			option1 = function(self)
				taskutil.userstate.choice3a = 1
				taskutil:finish(self.name)
				taskutil:start("3b")
			end,
			option2 = function(self)
				taskutil.userstate.choice3a = 2
				taskutil:finish(self.name)
				taskutil:start("3c")
			end,
		},
	})

	taskutil:new("3b", {
		onStart = function(self)
			arrivaltracker.track("3b1", { cargotype = "CONSTRUCTION_MATERIALS", to = params.fortmyers })
			arrivaltracker.track("3b2", { cargotype = "CIGARS", to = params.fortmyers })
		end,
		onUpdate = function(self)
			local c1 = arrivaltracker.get("3b1")
			local c2 = arrivaltracker.get("3b2")

			local n1 = params.conmat_amount_myers
			local n2 = params.cigars_amount_myers

			local done1 = c1 >= n1
			local done2 = c2 >= n2

			self:setProgressCount(c1, n1, 1)
			self:setProgressCount(c2, n2, 2)

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("3b1")
			arrivaltracker.track("3b2")
			taskutil.tasks["3d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_BOOM_BUILDA_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_BOOM_BUILDA_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_BOOM_BUILDA_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_TASK_BOOM_BUILDA_SUB1") % params },
					{ name = _("MISSION_VICECOUNTY_TASK_BOOM_BUILDA_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_fortmyers,
				voiceOver = "MISSION_VICECOUNTY_TASK_BOOM_BUILDA_TEXT.wav",
			}
		end,
	})

	taskutil:new("3c", {
		onStart = function(self)
			arrivaltracker.track("3c1", { cargotype = "CONSTRUCTION_MATERIALS", to = params.westpalmbeach })
			arrivaltracker.track("3c2", { cargotype = "RUM", to = params.westpalmbeach })
		end,
		onUpdate = function(self)
			local c1 = arrivaltracker.get("3c1")
			local c2 = arrivaltracker.get("3c2")

			local n1 = params.conmat_amount_palm
			local n2 = params.rum_amount_palm

			local done1 = c1 >= n1
			local done2 = c2 >= n2

			self:setProgressCount(c1, n1, 1)
			self:setProgressCount(c2, n2, 2)

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("3c1")
			arrivaltracker.track("3c2")
			taskutil.tasks["3d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_BOOM_BUILDB_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_BOOM_BUILDB_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_BOOM_BUILDB_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_TASK_BOOM_BUILDB_SUB1") % params },
					{ name = _("MISSION_VICECOUNTY_TASK_BOOM_BUILDB_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_westpalmbeach,
				voiceOver = "MISSION_VICECOUNTY_TASK_BOOM_BUILDB_TEXT.wav",
			}
		end,
	})

	local function legalCargo(area)
		local entities = game.interface.getEntities(area, { type = "VEHICLE" } )
		for i = 1, #entities do
			local e = game.interface.getEntity(entities[i])
			for k, _ in pairs(e.cargoLoad) do
				if k == "RUM" or k == "CIGARS" then
					return false
				end
			end
		end
		return true
	end

	local function getArea()
		if taskutil.userstate.choice3a == 1 then
			return params.pos_fortmyers
		else
			return params.pos_westpalmbeach
		end
	end

	taskutil:new("3d", {
		onStart = function(self)
			taskutil:setZone("3d", { polygon = zoneutil.makeCircleZone(getArea(), params.police_road_area.radius), draw = true, drawColor = colors.RED })
			taskutil.userstate.starttime3 = game.interface.getGameTime().time
		end,
		onUpdate = function(self)
			local time = game.interface.getGameTime().time
			local timepassed = time - taskutil.userstate.starttime3
			if timepassed > params.police_road_seconds then
				if legalCargo(getArea()) then
					taskutil.tasks["4"]:start()
				else
					taskutil.userstate.caught = true
					taskutil.tasks["3e"]:start()
				end
				if taskutil.tasks["m1a"].finish ~= nil then taskutil.tasks["m1a"]:finish() end
				self:finish()
			end
			self:setProgressText(tostring(params.police_boat_seconds - math.floor(timepassed)), 1)
		end,
		onFinish = function(self)
			taskutil:setZone("3d")
			taskutil.userstate.starttime3 = nil
		end,
		getInfo = function(self)
			local area = getArea()
			area[3] = 250
			return {
				name = _("MISSION_VICECOUNTY_TASK_BOOM_POLICE_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_BOOM_POLICE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_BOOM_POLICE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_VICECOUNTY_TASK_BOOM_POLICE_SUB1") % params },
				},
				options = { { "Debug: Skip", "skip" } },
				parentId = "3",
				camera = area,
				voiceOver = "MISSION_VICECOUNTY_TASK_BOOM_POLICE_TEXT.wav",
			}
		end,
		guiHandlers = {
			skip = function(self)
				taskutil:finish(self.name)
				taskutil:start("3e")
			end,
		},
	})

	taskutil:new("3e", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			local area = getArea()
			area[3] = 250
			return {
				name = _("MISSION_VICECOUNTY_TASK_BOOM_CAUGHT_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_BOOM_CAUGHT_TEXT") % params },
				},
				options = { { "Ok", "finish" } },
				parentId = "3",
				camera = area,
				voiceOver = "MISSION_VICECOUNTY_TASK_BOOM_CAUGHT_TEXT.wav",
			}
		end,
	})
end
