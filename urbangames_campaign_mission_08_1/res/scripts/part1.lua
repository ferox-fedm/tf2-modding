local taskutil = require "mission.taskutil"
local params = require "params"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local vec3 = require "vec3"
local vehiclestore = require "mission.vehiclestore"
local proposalutil = require "mission.proposalutil"
local polygonutil = require "polygonutil"

return function()
	local getlicencedareas = function()
		local b = taskutil.userstate.boughtlicenses
		local areas = {}
		for i = 1, #b do
			areas[i] = params["area".. b[i]]
		end
		return areas
	end

	local getbuiltareas = function()
		local b = taskutil.userstate.builtareas
		local areas = {}
		for i = 1, #b do
			areas[i] = params["area".. b[i]]
		end
		return areas
	end

	local mainguihandlers = {
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
			self:setProgressNone()
			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_medium_old.lua", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_large_old.lua", false)

			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_medium_new.lua", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_large_new.lua", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_x_large_new.lua", false)

			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_medium_one_way_new.lua", false)
			taskutil:setVisibleAndEnabled("menu.construction.road.streets.item.standard/country_large_one_way_new.lua", false)

			math.randomseed(0)
			for i = 1, 4 do
				taskutil:setZone("zone"..i, { polygon = params["area"..params.licenseid2name[i]], draw = true, drawColor = colors.rgb(math.random(), math.random(), math.random()), buildToolMode = "PROHIBIT" })
			end
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_TASK_DRIVERS_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_DRIVERS_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_trainingcenter,
				voiceOver = "MISSION_TWENTIES_TASK_DRIVERS_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local stations = game.interface.getEntities({pos = params.pos_trainingcenter, radius = 200}, {type = "STATION"})
			local persons = 0
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.PASSENGERS or 0
				persons = persons + s
			end
			self:setProgressCount(persons, params.persons_1a)
			if persons >= params.persons_1a then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_TASK_DRIVERS_TRANSPORT_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_DRIVERS_TRANSPORT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TWENTIES_TASK_DRIVERS_TRANSPORT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_trainingcenter,
				voiceOver = "MISSION_TWENTIES_TASK_DRIVERS_TRANSPORT_TEXT.wav",
			}
		end,
	})

	local oldpositionsbus = {}
	local oldpositionstruck = {}
	local function fn(istruck)
		local filename = "vehicle/bus/usa/schneider_pb2_v2.mdl"
		local oldpositions = oldpositionsbus

		if istruck then
			filename = "vehicle/truck/usa/mack_ac_stake_v2.mdl"
			oldpositions = oldpositionstruck
		end

		local positions = {}
		local vehicles = game.interface.getEntities(params.trainingarea, { type = "VEHICLE" })
		for i = 1, #vehicles do
			local v = game.interface.getEntity(vehicles[i])
			if polygonutil.contains(params.trainingarea_zone, v.position) then
				if v.vehicles[1].fileName == filename then
					positions[v.id] = v.position
					if oldpositions[v.id] ~= nil then
						local x = vec3.new(table.unpack(positions[v.id]))
						local y = vec3.new(table.unpack(oldpositions[v.id]))
						if istruck then
							taskutil.userstate.trainingmeterstruck = taskutil.userstate.trainingmeterstruck + vec3.distance(x, y)
						else
							taskutil.userstate.trainingmetersbus = taskutil.userstate.trainingmetersbus + vec3.distance(x, y)
						end
					end
				end
			end
		end
		if istruck then
			oldpositionstruck = positions
			return math.floor(taskutil.userstate.trainingmeterstruck)
		else
			oldpositionsbus = positions
			return math.floor(taskutil.userstate.trainingmetersbus)
		end

	end

	taskutil:new("1b", {
		onStart = function(self)
			taskutil:setZone("trainingarea", { polygon = params.trainingarea_zone, draw = true, drawColor = colors.BLUE })
			taskutil.userstate.trainingmetersbus = 0
			taskutil.userstate.trainingmeterstruck = 0
		end,
		onUpdate = function(self)
			local bus = fn(false)
			local truck = fn(true)
			self:setSubtaskCompleted(1, bus > 0)
			self:setSubtaskCompleted(2, truck > 0)
			if bus > 0 and truck > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_TASK_DRIVERS_TRACK_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_DRIVERS_TRACK_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TWENTIES_TASK_DRIVERS_TRACK_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_TWENTIES_TASK_DRIVERS_TRACK_SUB1") },
					{ name = _("MISSION_TWENTIES_TASK_DRIVERS_TRACK_SUB2") },
				},
				parentId = "1",
				camera = params.jump_trainingcenter,
				voiceOver = "MISSION_TWENTIES_TASK_DRIVERS_TRACK_TEXT.wav",
			}
		end,
	})

	taskutil:new("1c", {
		onStart = function(self)
			taskutil.userstate.planedata = {}
		end,
		onUpdate = function(self)
			local bus = fn(false)
			local truck = fn(true)

			local buscount = bus / 5000 + params.initialbuscount
			local truckcount = truck / 5000 + params.initialtruckcount

			--local totalvehicles = math.floor(buscount) + math.floor(truckcount)

			local busprogress = 0.01 * math.floor(100 * buscount)
			local truckprogress = 0.01 * math.floor(100 * truckcount)

			local currentbuses = vehiclestore.currentvehicles["vehicle/bus/usa/schneider_pb2_v2.mdl"] or 0
			local currenttrucks = vehiclestore.currentvehicles["vehicle/truck/usa/mack_ac_stake_v2.mdl"] or 0

			local allowedbuses = math.floor(buscount)
			local allowedtrucks = math.floor(truckcount)
			self:setProgressText(math.floor(100 * (busprogress - math.floor(busprogress))).. "%", 1)
			self:setProgressText(math.floor(100 * (truckprogress - math.floor(truckprogress))).. "%", 2)
			self:setProgressCount(allowedbuses - currentbuses, allowedbuses, 3)
			self:setProgressCount(allowedtrucks - currenttrucks, allowedtrucks, 4)

			vehiclestore.setAllowedVehicleCount("vehicle/bus/usa/schneider_pb2_v2.mdl", allowedbuses)
			vehiclestore.setAllowedVehicleCount("vehicle/truck/usa/mack_ac_stake_v2.mdl", allowedtrucks)

			if taskutil.tasks["2"].start ~= nil and (buscount + truckcount >= 10) then
				self:setProgressNone()
				taskutil:startLater("2")
			end
		end,
		onFinish = function(self)
			if taskutil.tasks["2"].start ~= nil then
				taskutil:startLater("2")
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_TASK_DRIVERS_TEACH_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_DRIVERS_TEACH_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TWENTIES_TASK_DRIVERS_TEACH_TASK") % params },
					{ type = "HINT", text = _("MISSION_TWENTIES_TASK_DRIVERS_TEACH_HINT") % params },
				},
				options = { { "Debug: Skip", "advance" } },
				subTasks = {
					{ name = _("MISSION_TWENTIES_TASK_DRIVERS_TEACH_SUB1") },
					{ name = _("MISSION_TWENTIES_TASK_DRIVERS_TEACH_SUB2") },
					{ name = _("MISSION_TWENTIES_TASK_DRIVERS_TEACH_SUB3") },
					{ name = _("MISSION_TWENTIES_TASK_DRIVERS_TEACH_SUB4") },
				},
				parentId = "1",
				camera = params.jump_trainingcenter,
				voiceOver = "MISSION_TWENTIES_TASK_DRIVERS_TEACH_TEXT.wav",
			}
		end,
		guiHandlers = {
			advance = function(self) 
				taskutil:sendScriptFn(self.name, "advance")
			end,
		},
		handlers = {
			advance = function(self) 
				if taskutil.tasks["2"].start ~= nil then
					self:setProgressNone()
					taskutil:startLater("2")
				end 
			end,
		},
	})
end
