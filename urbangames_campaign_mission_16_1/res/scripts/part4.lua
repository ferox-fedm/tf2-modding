local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local calendar = require "mission.calendar"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local util = require "util"

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
				name = _("MISSION_ICE_TASK_REGIO_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_REGIO_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_REGIO_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("4a", {
		onStart = function(self)
			taskutil:setZone("zone_a", { polygon = params.zone_a, draw = true, drawColor = colors.BLUE })
			taskutil:setZone("zone_b", { polygon = params.zone_b, draw = true, drawColor = colors.YELLOW })
			taskutil:setZone("zone_c", { polygon = params.zone_c, draw = true, drawColor = colors.RED })
			taskutil:invokeLater(self.name, "showm3", 120)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["4c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_TASK_REGIO_DECISION_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_REGIO_DECISION_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ICE_TASK_REGIO_DECISION_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_REGIO_DECISION_TEXT.wav",
				options = { { _("MISSION_ICE_TASK_REGIO_DECISION_OPTION1"), "option1" },
				            { _("MISSION_ICE_TASK_REGIO_DECISION_OPTION2"), "option2" } },
				optionsRightAlign = true,
				parentId = "4",
			}
		end,
		handlers = {
			option1 = function(self)
				taskutil.userstate.choice4a = 1
				taskutil:finish(self.name)
			end,
			option2 = function(self)
				taskutil.userstate.choice4a = 2
				taskutil:finish(self.name)
			end,
			showm3 = function(self)
				if taskutil.tasks["m3"].start ~= nil then
					taskutil.tasks["m3"]:start()
				end
			end,
		},
		guiHandlers = {
			option1 = function(self)
				taskutil:sendScriptFn(self.name, "option1")
			end,
			option2 = function(self)
				taskutil:sendScriptFn(self.name, "option2")
			end,
		},
	})

	--taskutil:new("4b", {
	--	onStart = function(self)
	--	end,
	--	onUpdate = function(self)
	--		local forbiddenzone = taskutil.userstate.choice4a == 1 and params.zone_b or params.zone_a
	--		local badlines = {}

	--		for i = 1, #params.cregional do
	--			local townid = params.cregional[i]
	--			local town = game.interface.getEntity(townid)
	--			if polygonutil.contains(forbiddenzone, town.position) then
	--				local stations = game.interface.getStations({ town = townid, carrier = "RAIL" })
	--				for j = 1, #stations do
	--					local stationGroup = game.interface.getEntity(stations[j]).stationGroup
	--					local lines = game.interface.getLines({ stationGroup = stationGroup })
	--					for k = 1, #lines do
	--						badlines[lines[k]] = 1
	--					end
	--				end
	--			end
	--		end

	--		local count = 0
	--		for _, _ in pairs(badlines) do count = count + 1 end

	--		self:setProgressText(tostring(count))

	--		if count == 0 then self:finish() end
	--	end,
	--	onFinish = function(self)
	--		taskutil.tasks["4c"]:start()
	--	end,
	--	getInfo = function(self)
	--		local text
	--		if taskutil.userstate.choice4a == 1 then text = _("MISSION_ICE_TASK_REGIO_REMOVE_TASK1") end
	--		if taskutil.userstate.choice4a == 2 then text = _("MISSION_ICE_TASK_REGIO_REMOVE_TASK2") end
	--		local camera
	--		if taskutil.userstate.choice4a == 1 then camera = params.jump_bayern end
	--		if taskutil.userstate.choice4a == 2 then camera = params.jump_bw end
	--		return {
	--			name = _("MISSION_ICE_TASK_REGIO_REMOVE_NAME"),
	--			paragraphs = {
	--				{ text = _("MISSION_ICE_TASK_REGIO_REMOVE_TEXT") % params },
	--				{ type = "TASK", text = text },
	--			},
	--			camera = camera,
	--			voiceOver = "MISSION_ICE_TASK_REGIO_REMOVE_TEXT.wav",
	--			options = { { "Debug: Skip", "finish" } },
	--			parentId = "4",
	--		}
	--	end,
	--})

	local function time2month(time)
		return math.floor(time / calendar.secondspermonthif(params.millisperday)) % 12 + 1
	end

	local timelast

	local checks = {
		function(self)
			local timenow = game.interface.getGameTime().time
			if taskutil.userstate.data4c[1] == nil then
				taskutil.userstate.data4c[1] = {}
				local allowedzone = taskutil.userstate.choice4a == 1 and params.zone_a or params.zone_b
				local data = taskutil.userstate.data4c[1]
				local towns = util.collecttowns(allowedzone)
				for i = 1, #towns do
					data[towns[i]] = timenow - calendar.secondsperyearif(params.millisperday) - 1
				end
			end

			local data = taskutil.userstate.data4c[1]

			util.collecttownsfromregionaltrains(function(townid)
				if data[townid] then data[townid] = timenow end
			end)

			local count = 0
			local n = 0
			for town, time in pairs(data) do
				n = n + 1
				if timenow - time <= calendar.secondsperyearif(params.millisperday) then count = count + 1 end
			end
			self:setProgressCount(count, n, 1)
			self:setSubtaskCompleted(1, count == n)
			return count == n
		end,
		function(self)
			local timenow = game.interface.getGameTime().time
			if taskutil.userstate.data4c[2] == nil then
				taskutil.userstate.data4c[2] = {}
				local forbiddenzone = taskutil.userstate.choice4a == 1 and params.zone_b or params.zone_a
				local data = taskutil.userstate.data4c[2]
				local towns = util.collecttowns(forbiddenzone)
				for i = 1, #towns do
					data[towns[i]] = timenow - calendar.secondspermonthif(params.millisperday) - 1
				end
			end

			local data = taskutil.userstate.data4c[2]

			util.collecttownsfromregionaltrains(function(townid)
				if data[townid] then data[townid] = timenow end
			end)

			local count = 0
			local n = 0
			for town, time in pairs(data) do
				n = n + 1
				if timenow - time <= calendar.secondspermonthif(params.millisperday) then count = count + 1 end
			end
			self:setSubtaskCompleted(2, count == 0)
			return count == 0
		end,
		function(self)
			local count = 0
			local trains = game.interface.getVehicles({ carrier = "RAIL" })
			for i = 1, #trains do
				local v = game.interface.getEntity(trains[i])
				if v.vehicles[1].fileName ~= params.icetrain then
					count = count + 1
				end
			end
			local n = params.regionalcount
			self:setProgressCount(count, n, 3)
			self:setSubtaskCompleted(3, count >= n)
			return count >= n
		end,
		function(self)
			local timenow = game.interface.getGameTime().time
			if timelast == nil then timelast = timenow end
			if taskutil.userstate.data4c[4] == nil then
				taskutil.userstate.data4c[4] = { }
			end

			local data = taskutil.userstate.data4c[4]

			local monthnow = time2month(timenow)
			local monthlast = time2month(timelast)
			timelast = timenow

			if monthnow ~= monthlast then
				data[monthnow] = 0
			end

			data[monthnow] = (data[monthnow] or 0) + (taskutil.userstate.regionalpassengers4c or 0)
			taskutil.userstate.regionalpassengers4c = 0

			local passengers = 0
			for i = 1, 12 do
				passengers = passengers + (data[i] or 0)
			end

			self:setProgressCount(passengers, params.regionalpassengers, 4)
			self:setSubtaskCompleted(4, passengers >= params.regionalpassengers)
			return passengers >= params.regionalpassengers
		end
	}

	taskutil:new("4c", {
		onStart = function(self)
			taskutil.userstate.data4c = {}
		end,
		onUpdate = function(self)
			local data = taskutil.userstate.data4c

			--local forbiddenzone = taskutil.userstate.choice4a == 1 and params.zone_b or params.zone_a

			local all = true
			for i = 1, #checks do
				local done = checks[i](self)
				self:setSubtaskCompleted(i, done)
				if not done then all = false end
			end

			if all then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.data4c = nil

			for i = 1, #params.call do
				arrivaltracker.track("4c" .. i)
			end

			taskutil:startLater("5")
		end,
		getInfo = function(self)
			local camera
			if taskutil.userstate.choice4a == 1 then camera = params.jump_bw end
			if taskutil.userstate.choice4a == 2 then camera = params.jump_bayern end
			return {
				name = _("MISSION_ICE_TASK_REGIO_TRIAL_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_REGIO_TRIAL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ICE_TASK_REGIO_TRIAL_TASK") % params },
					{ type = "HINT", text = _("MISSION_ICE_TASK_REGIO_TRIAL_HINT") % params },
				},
				camera = camera,
				voiceOver = "MISSION_ICE_TASK_REGIO_TRIAL_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_ICE_TASK_REGIO_TRIAL_SUB1") % { zone = params.zone_names[taskutil.userstate.choice4a]} },
					{ name = _("MISSION_ICE_TASK_REGIO_TRIAL_SUB2") % { zone = params.zone_names_not[taskutil.userstate.choice4a]} },
					{ name = _("MISSION_ICE_TASK_REGIO_TRIAL_SUB3") % params },
					{ name = _("MISSION_ICE_TASK_REGIO_TRIAL_SUB4") % params },
					--{ name = _("MISSION_ICE_TASK_REGIO_TRIAL_SUB5") % params },
				},
				parentId = "4",
			}
		end,
		handlers = {
			handleEvent = function(self, id, name, param)
				if id == "__missionCallback__" and name == "JOURNAL_ENTRY" then
					local unloaded = param.params.cargoUnloaded
					local amount = param.amount
					if param.type ~= "VEHICLE_INCOME" then return end
					if next(unloaded) == nil then return end
					if unloaded.PASSENGERS ~= nil then
						local e = game.interface.getEntity(param.params.entity)
						if e.carrier ~= "RAIL" then return end
						for i = 1, #e.vehicles do
							if e.vehicles[i].fileName == params.icetrain then
								return
							end
						end
						taskutil.userstate.regionalpassengers4c = (taskutil.userstate.regionalpassengers4c or 0) + unloaded.PASSENGERS
					end
				end
			end,
		},
	})
end
