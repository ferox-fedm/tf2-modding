local taskutil = require "mission.taskutil"
local params = require "params"
local proposalutil = require "mission.proposalutil"
local util = require "util"
local vehiclestore = require "mission.vehiclestore"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"
local polygonutil = require "polygonutil"

return function()

	local mainguihandlers = {
		voiceOverEnded = function(self) taskutil:finish(self.name) end,
	}
	setmetatable(mainguihandlers, { __index = function(self, key)
		local n = #"jump_"
		if key:sub(1, n) == "jump_" then
			game.gui.setAutoCamera(params[key])
		end
	end})

	local function gethandlers()
		local result = {}
		for t = 1, 5 do
			for i = 1, 5 do
				local s = t .. "a" .. i
				result[s] = function()
					taskutil:setMarker(s)
					taskutil:start(s)
				end
			end
		end
		return result
	end
	taskutil:new("1", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount("vehicle/plane/junkers_f_13_v2.mdl", 0)
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_HELLPILOT_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_STARFLIGHT_TASK_HELLPILOT_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
		handlers = gethandlers()
	})

	taskutil:new("1a", {
		onStart = function(self)
			taskutil.userstate.donecount1 = 0
			taskutil:setMarker("1a2", { entity = params.villa,                type = "question" }, "1", "1a2") --3
			taskutil:setMarker("1a3", { entity = params.airfield_bakersfield, type = "question" }, "1", "1a3") --6
			taskutil:setMarker("1a4", { entity = params.losangeles,           type = "question" }, "1", "1a4") --1
		end,
		onUpdate = function(self)
			local planes_goal = params.planes_1 + params.planes_2 + params.planes_3
			vehiclestore.setAllowedVehicleCount("vehicle/plane/junkers_f_13_v2.mdl", taskutil.userstate.donecount1)
			if taskutil.userstate.donecount1 >= planes_goal then self:finish() end

			self:setProgressCount(taskutil.userstate.donecount1, planes_goal) -- 1/3/6 of 10
		end,
		onFinish = function(self)
			util.endchapter(1)
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_HELLPILOT_PLANES_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_PLANES_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_PLANES_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.default_camera,
				voiceOver = "MISSION_STARFLIGHT_TASK_HELLPILOT_PLANES_TEXT.wav",
			}
		end,
	})

	taskutil:new("1a2", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			--TODO: check for an actual connection
			local entities = game.interface.getEntities({ pos = params.pos_villa, radius = 20 }, { type = "BASE_EDGE" })
			for i = 1, #entities do
				local path0 = game.interface.findPath({ pos = params.pos_sanfrancisco, radius = 50 }, entities[i])
				if path0 ~= nil then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.userstate.donecount1 = taskutil.userstate.donecount1 + params.planes_1
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_HELLPILOT_ROAD_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_ROAD_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_ROAD_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_villa,
				voiceOver = "MISSION_STARFLIGHT_TASK_HELLPILOT_ROAD_TEXT.wav",
			}
		end,
	})

	taskutil:new("1a3", {
		onStart = function(self)
			taskutil.userstate.airplanetable = {}
			taskutil.userstate.progress1a3 = 0
		end,
		onUpdate = function(self)
			local t = taskutil.userstate.airplanetable
			local vehicles = game.interface.getVehicles()
			for i = 1, #vehicles do
				local id = vehicles[i]
				local v = game.interface.getEntity(id)
				if v.carrier == "AIR" then
					if v.state == "AT_TERMINAL" then
						if t[id] == 1 then
							taskutil.userstate.progress1a3 = taskutil.userstate.progress1a3 + 1
						end
						t[id] = nil
					else
						local p = v.position
						local z = game.interface.getHeight({p[1], p[2]})
						if p[3] - z > 35 then
							t[id] = 1
						end
					end
				end
			end
			self:setProgressCount(taskutil.userstate.progress1a3, params.takeoffs_hellpilot, 1)
			if taskutil.userstate.progress1a3 >= params.takeoffs_hellpilot then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.donecount1 = taskutil.userstate.donecount1 + params.planes_2
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_HELLPILOT_PERSONNEL_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_PERSONNEL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_PERSONNEL_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_TASK_HELLPILOT_PERSONNEL_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_airfield_bakersfield,
				voiceOver = "MISSION_STARFLIGHT_TASK_HELLPILOT_PERSONNEL_TEXT.wav",
			}
		end,
	})

	taskutil:new("1a4", {
		onStart = function(self)
			local db = math.floor(10 * math.log(game.interface.getTownEmission(params.losangeles) / math.pow(10,-12), 10))
			self:setProgressCount(db, params.noise_hellpilot)
			if db >= params.noise_hellpilot then
				self:setProgressText("")
				taskutil.userstate.emission1a4alreadycompleted = true
				taskutil:invokeLater(self.name, "finish", 15)
			end
		end,
		onUpdate = function(self)
			if taskutil.userstate.emission1a4alreadycompleted then
				return
			end
			local db = math.floor(10 * math.log(game.interface.getTownEmission(params.losangeles) / math.pow(10,-12), 10))
			self:setProgressCount(db, params.noise_hellpilot)
			if db >= params.noise_hellpilot then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.emission1a4alreadycompleted = nil
			taskutil.userstate.donecount1 = taskutil.userstate.donecount1 + params.planes_3
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_HELLPILOT_NOISE_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_NOISE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_NOISE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_losangeles,
				voiceOver = "MISSION_STARFLIGHT_TASK_HELLPILOT_NOISE_TEXT.wav",
			}
		end,
	})

	local polygon_plane = zoneutil.makeCircleZone(params.zone_plane.pos, params.zone_plane.radius)
	taskutil:new("1b", {
		onStart = function(self)
			taskutil:setZone("1b", { polygon = polygon_plane, draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getVehicles({ carrier = "AIR" })
			local count = 0
			for i = 1, #vehicles do
				local v = game.interface.getEntity(vehicles[i])
				if v.vehicles[1].fileName == "vehicle/plane/junkers_f_13_v2.mdl" then
					local planepos = v.position
					if polygonutil.contains(polygon_plane, planepos) then
						local z = game.interface.getHeight({planepos[1], planepos[2]})
						local flying = planepos[3] - z > 35
						if flying then
							count = count + 1
						end
					end
				end
			end
			local n = params.num_planes_flying
			self:setProgressCount(count, n, 1)
			if count >= n then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setZone("1b")
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_TASK_HELLPILOT_SET_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_SET_TEXT") % params },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_SET_TASK") % params },
					{ type = "HINT", text = _("MISSION_STARFLIGHT_TASK_HELLPILOT_SET_HINT") % params },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_TASK_HELLPILOT_SET_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_zone_plane,
				voiceOver = "MISSION_STARFLIGHT_TASK_HELLPILOT_SET_TEXT.wav",
			}
		end,
	})
end
