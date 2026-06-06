local taskutil = require "mission.taskutil"
local params = require "params"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"
local vehiclestore = require "mission.vehiclestore"
local arrivaltracker = require "mission.arrivaltracker"

return function()

	local mainguihandlers = {
		trackspeed = function(self, id, name, param, isApply)
			if id ~= "trackBuilder" or name ~= "builder.proposalCreate" then return true end

			local entity2type = {} -- 0 = street, 1 = rail
			--only check high speed tracks
			local addedSegments = param.proposal.proposal.addedSegments
			for i = 1, #addedSegments do
				local s = addedSegments[i]
				if s.params.trackType == 1 then return true end
				entity2type[s.entity] = s.type
			end

			local minspeed = 1000
			local transportnetworks = param.data.entity2tn
			for k, v in pairs(transportnetworks) do
				if entity2type[k] == 1 then
					local edges = v.edges
					for i = 1, #edges do
						local e = edges[i]
						minspeed = math.min(minspeed, math.min(e.speedLimit, e.curveSpeedLimit))
					end
				end
			end
			if minspeed > 200 / 3.6 then return true end
			return _("MISSION_PROPOSAL_FEEDBACK_TOOSLOW")
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
			taskutil:enableProposalCheck()
			taskutil:setProposal("trackspeed", self.name, "trackspeed", true)
			--taskutil.tasks["m1"]:start()
			--taskutil.tasks["m2"]:start()
			--taskutil.tasks["m5"]:start()
			self:setProgressNone()
			taskutil:setEnabled("menu.construction.airmenu", false)
			taskutil:setEnabled("menu.construction.watermenu", false)

			vehiclestore.setAllowedVehicleCount("vehicle/train/asia/shinkansen_0s_front_dryellow_v2.mdl", 0)
			vehiclestore.setAllowedVehicleCount("vehicle/train/asia/shinkansen_0s_front_v2.mdl", 0)
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_PLAN_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_PLAN_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_PLAN_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1a", {
		onStart = function(self)
			taskutil:setMarker("1aa", { entity = params.stonepile, type = "question" }, self.name, "1aa")
			taskutil:setMarker("1ab", { entity = params.constmatdump, type = "question" }, self.name, "1ab")
			--taskutil:setMarker("1ac", { entity = params.nagoya,    type = "question" }, self.name, "1ac")
		end,
		onUpdate = function(self)
			local function completed(name)
				return taskutil.tasks[name].start == nil and taskutil.tasks[name].finish == nil
			end
			
			local done = 0
			if completed("1aa") then done = done + 1 end
			if completed("1ab") then done = done + 1 end
			--if completed("1ac") then done = done + 1 end
			self:setProgressCount(done, 2)

			if done >= 2 then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_PLAN_PARTS_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_PLAN_PARTS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_PLAN_PARTS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_PLAN_PARTS_TEXT.wav",
			}
		end,
		handlers = {
			["1aa"] = function(self)
				taskutil:start("1aa")
				taskutil:setMarker("1aa")
			end,
			["1ab"] = function(self)
				taskutil:start("1ab")
				taskutil:setMarker("1ab")
			end,
			["1ac"] = function(self)
				taskutil:start("1ac")
				taskutil:setMarker("1ac")
			end,
		},
	})

	taskutil:new("1aa", {
		onStart = function(self)
			arrivaltracker.track("1aa", { cargotype = "STONE", to = params.stonedump })
		end,
		onUpdate = function(self)
			local x = arrivaltracker.get("1aa")
			self:setProgressCount(x, params.deliver_stone, 1)
			if x >= params.deliver_stone then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("1aa")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_PLAN_FUJI_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_PLAN_FUJI_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_PLAN_FUJI_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_SHINKANSEN_TASK_PLAN_FUJI_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_stonepile,
				voiceOver = "MISSION_SHINKANSEN_TASK_PLAN_FUJI_TEXT.wav",
			}
		end,
	})

	taskutil:new("1ab", {
		onStart = function(self)
			arrivaltracker.track("1ab", { cargotype = "CONSTRUCTION_MATERIALS", to = params.constmatdump })
		end,
		onUpdate = function(self)
			local x = arrivaltracker.get("1ab")
			self:setProgressCount(x, params.deliver_constmat, 1)
			if x >= params.deliver_constmat then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("1ab")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_PLAN_HAMANA_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_PLAN_HAMANA_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_PLAN_HAMANA_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_SHINKANSEN_TASK_PLAN_HAMANA_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_constmatdump,
				voiceOver = "MISSION_SHINKANSEN_TASK_PLAN_HAMANA_TEXT.wav",
			}
		end,
	})

	taskutil:new("1ac", {
		onStart = function(self)
			taskutil:setZone("zone_a1c", { polygon = zoneutil.makeCircleZone(params.zone_avoid.pos, params.zone_avoid.radius), draw = true, drawColor = colors.RED })
		end,
		onUpdate = function(self)
			local stations = game.interface.getEntities({ pos = params.zone_avoid.pos, radius = params.zone_avoid.radius }, { type = "STATION" })
			local n = #stations
			self:setProgressText(tostring(n) .. _(" stations left"))
			if n == 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("zone_a1c")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_PLAN_KYOTO_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_PLAN_KYOTO_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_PLAN_KYOTO_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_zone_avoid,
				voiceOver = "MISSION_SHINKANSEN_TASK_PLAN_KYOTO_TEXT.wav",
			}
		end,
	})
end
