local taskutil = require "mission.taskutil"
local params = require "params"
local vec3 = require "vec3"
local arrivaltracker = require "mission.arrivaltracker"
local vehiclestore = require "mission.vehiclestore"

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
				name = _("MISSION_SHINKANSEN_TASK_PREPARE_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_PREPARE_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_PREPARE_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount("vehicle/train/asia/shinkansen_0s_front_dryellow_v2.mdl", nil)
			taskutil.userstate.trains3a = {}
			taskutil.userstate.trainsintokio = {}
			taskutil.userstate.trainsinosaka = {}
			taskutil.userstate.drive3acomplete = false
			taskutil.userstate.tunnelmeters = 0
			taskutil.userstate.bridgemeters = 0
		end,
		onUpdate = function(self)
			local trains = game.interface.getVehicles({ carrier = "RAIL" })
			local n = #trains
			for i = 1, n do
				local e = game.interface.getEntity(trains[i])
				if e.vehicles[1].fileName == "vehicle/train/asia/shinkansen_0s_front_dryellow_v2.mdl" then
					local x = vec3.new(table.unpack(e.position))
					local prevpos = taskutil.userstate.trains3a[trains[i]]
					if prevpos ~= nil then
						local dz = e.position[3] - game.interface.getHeight(e.position)
						local y = vec3.new(table.unpack(prevpos))
						if dz > 8 then
							taskutil.userstate.bridgemeters = taskutil.userstate.bridgemeters + vec3.distance(x, y)
						elseif dz < 0 then
							taskutil.userstate.tunnelmeters = taskutil.userstate.tunnelmeters + vec3.distance(x, y)
						end
					end

					if not taskutil.userstate.drive3acomplete then
						if vec3.distance(x, vec3.new(table.unpack(params.pos_tokio))) < 500 then
							taskutil.userstate.trainsintokio[trains[i]] = 1
						end
						if vec3.distance(x, vec3.new(table.unpack(params.pos_osaka))) < 500 then
							taskutil.userstate.trainsinosaka[trains[i]] = 1
						end
						for k, _ in pairs(taskutil.userstate.trainsinosaka) do
							if taskutil.userstate.trainsintokio[k] then
								taskutil.userstate.drive3acomplete = true
							end
						end
					end
				end
				taskutil.userstate.trains3a[trains[i]] = e.position
			end
			local drive3acomplete = taskutil.userstate.drive3acomplete
			local tm = taskutil.userstate.tunnelmeters
			local bm = taskutil.userstate.bridgemeters
			local tmg = params.tmg
			local bmg = params.bmg
			self:setProgressCount(tm, tmg, 2)
			self:setProgressCount(bm, bmg, 3)
			self:setSubtaskCompleted(1, drive3acomplete)
			self:setSubtaskCompleted(2, tm >= tmg)
			self:setSubtaskCompleted(3, bm >= bmg)
			if drive3acomplete and tm >= tmg and bm >= bmg then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["3b"]:start()
			taskutil.userstate.trains3a = nil
			taskutil.userstate.trainsintokio = nil
			taskutil.userstate.trainsinosaka = nil
			taskutil.userstate.drive3acomplete = nil
			taskutil.userstate.tunnelmeters = nil
			taskutil.userstate.bridgemeters = nil
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_PREPARE_MEASURE_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_PREPARE_MEASURE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_PREPARE_MEASURE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_SHINKANSEN_TASK_PREPARE_MEASURE_SUB1") },
					{ name = _("MISSION_SHINKANSEN_TASK_PREPARE_MEASURE_SUB2") },
					{ name = _("MISSION_SHINKANSEN_TASK_PREPARE_MEASURE_SUB3") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_PREPARE_MEASURE_TEXT.wav",
			}
		end,
	})

	taskutil:new("3b", {
		onStart = function(self)
			taskutil.userstate.index3b = 1
			taskutil.userstate.trains3b = {}
			taskutil.userstate.lastgametime = game.interface.getGameTime().time
			vehiclestore.setAllowedVehicleCount("vehicle/train/asia/shinkansen_0s_front_v2.mdl", nil)
		end,
		onUpdate = function(self)
			local function getdecimal(number)
				return number - math.floor(number)
			end

			local d1 = getdecimal(game.interface.getGameTime().time)
			local d2 = getdecimal(taskutil.userstate.lastgametime)
			taskutil.userstate.lastgametime = game.interface.getGameTime().time
			if d1 >= d2 then
				return
			end

			local trains = game.interface.getVehicles({ carrier = "RAIL" })
			local n = #trains
			local fasttrains = {}
			local nf = 0
			for i = 1, n do
				local e = game.interface.getEntity(trains[i])
				local isshinkansen = e.vehicles[1] and e.vehicles[1].fileName == "vehicle/train/asia/shinkansen_0s_front_v2.mdl"
				if isshinkansen and 3.6 * e.speed > params.goalspeed then
					fasttrains[trains[i]] = 1
					nf = nf + 1
				end
			end
			local idx = taskutil.userstate.index3b
			taskutil.userstate.trains3b[idx] = fasttrains
			taskutil.userstate.index3b = (idx + 1) % 20

			local goalnf =  params.goalnf

			local stopped = 0
			local data = taskutil.userstate.trains3b
			local data2 = {}
			for i = 1, #data do
				for k, _ in pairs(data[i]) do
					data2[k] = 1
				end
			end
			for k, _ in pairs(data2) do
				local e = game.interface.getEntity(k)
				if e and (e.speed == 0) then
					stopped = stopped + 1
				end
			end

			--print(stopped)
			self:setProgressCount(nf, goalnf, 1)
			self:setSubtaskCompleted(1, nf >= goalnf)
			self:setProgressCount(stopped, goalnf, 2)
			self:setSubtaskCompleted(2, stopped >= goalnf)

			if stopped >= goalnf then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["3c"]:start()
			taskutil.userstate.index3b = nil
			taskutil.userstate.trains3b = nil
			taskutil.userstate.lastgametime = nil
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_PREPARE_BREAKTEST_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_PREPARE_BREAKTEST_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_PREPARE_BREAKTEST_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_SHINKANSEN_TASK_PREPARE_BREAKTEST_SUB1") },
					{ name = _("MISSION_SHINKANSEN_TASK_PREPARE_BREAKTEST_SUB2") },
				},
				parentId = "3",
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_PREPARE_BREAKTEST_TEXT.wav",
			}
		end,
	})

	taskutil:new("3c", {
		onStart = function(self)
			local cparams = game.interface.getEntity(params.hq).params
			cparams.commercialCapacity = 50
			cparams.seed = nil
			game.interface.upgradeConstruction(params.hq, "industry/hq.con", cparams)
			arrivaltracker.track("3c", { cargotype = "PASSENGERS", to = params.hq })
		end,
		onUpdate = function(self)
			local persons = arrivaltracker.get("3c")
			local n = params.workers
			self:setProgressCount(persons, n)
			if persons >= n then
				self:finish()
			end
		end,
		onFinish = function(self)
			arrivaltracker.track("3c")
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_PREPARE_CREW_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_PREPARE_CREW_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_PREPARE_CREW_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_hq,
				voiceOver = "MISSION_SHINKANSEN_TASK_PREPARE_CREW_TEXT.wav",
			}
		end,
	})
end
