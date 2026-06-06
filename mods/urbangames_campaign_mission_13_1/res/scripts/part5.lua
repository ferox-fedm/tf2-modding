local taskutil = require "mission.taskutil"
local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("5", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track5")
		end,
		onFinish = function(self)
			taskutil.tasks["5a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_SUCCESS_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_SUCCESS_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_SUCCESS_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	local payments = params.payments

	local function count(city)
		local stations = game.interface.getEntities({pos = params["pos_" .. city], radius = 500}, {type = "STATION"})
		local persons = 0
		for i = 1, #stations do
			local station = game.interface.getEntity(stations[i])
			if station.carriers.RAIL then
				local s = game.interface.getEntity(station.stationGroup).itemsUnloaded.PASSENGERS or 0

				persons = persons + s
			end
		end
		return persons
	end

	taskutil:new("5a", {
		onStart = function(self)
			taskutil.userstate.requiredpayments = payments
			taskutil.userstate.initialpassengers = count("tokio") + count("nagoya") + count("osaka")
			taskutil:invokeLater(self.name, "showm2", 120)
		end,
		onUpdate = function(self)
			self:setSubtaskCompleted(1, taskutil.userstate.requiredpayments <= 0)
			self:setProgressCount(payments - taskutil.userstate.requiredpayments, payments, 1)

			local c = count("tokio") + count("nagoya") + count("osaka") - taskutil.userstate.initialpassengers
			local n = params.passengers
			self:setProgressCount(c, n, 2)
			self:setSubtaskCompleted(2, c >= n)

			if c >= n and taskutil.userstate.requiredpayments <= 0 then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.userstate.requiredpayments = nil
			taskutil.tasks["5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_SUCCESS_TRANSPORT_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_SUCCESS_TRANSPORT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_SUCCESS_TRANSPORT_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_SHINKANSEN_TASK_SUCCESS_TRANSPORT_SUB1") },
					{ name = _("MISSION_SHINKANSEN_TASK_SUCCESS_TRANSPORT_SUB2") },
				},
				options = { { "Debug: Skip", "finish" }, { _("MISSION_SHINKANSEN_TASK_SUCCESS_TRANSPORT_OPTION1") % params, "pay" } },
				optionsRightAlign = true,
				parentId = "5",
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_SUCCESS_TRANSPORT_TEXT.wav",
			}
		end,
		handlers = {
			pay = function(self)
				if not taskutil.userstate.requiredpayments or taskutil.userstate.requiredpayments <= 0 then
					return
				end
				local cost = params.cost
				if game.interface.getEntity(game.interface.getPlayer()).balance > cost then
					game.interface.book(-cost)
					taskutil.userstate.requiredpayments = taskutil.userstate.requiredpayments - 1
					
					if taskutil.userstate.requiredpayments <= 0 then
						self:setOptionUnavailable(2)
					end
				end
			end,
			showm2 = function(self)
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
				end
			end,
		}
	})

	taskutil:new("5b", {
		onStart = function(self)
			local productionLevel = game.interface.getEntity(params.hq).params.productionLevel
			game.interface.upgradeConstruction(params.hq, "industry/hq.con", {
				stocks = { "CONSTRUCTION_MATERIALS", "STEEL", "FOOD", "FISH", },
				input = { { 1, 0, 0, 0 }, { 0, 1, 0, 0 }, { 0, 0, 1, 0 }, { 0, 0, 0, 1 } },
				output = { },
				capacity = 100,
				commercialCapacity = 50,
				productionLevel = productionLevel,
			})
			arrivaltracker.track("5b", { cargotype = "FOOD", to = params.hq })
		end,
		onUpdate = function(self)
			local x = arrivaltracker.get("5b")
			self:setProgressCount(x, params.deliver_food, 1)

			local freq = 0
			local vehicles = vehiclestore.currentvehicles
			--local upgraded = vehicles["vehicle/train/asia/shinkansen_0s_front.mdl"] == nil and (vehicles["vehicle/train/asia/shinkansen_0ls_front.mdl"] or 0) > 0
			local lines = game.interface.getLines()
			for i = 1, #lines do
				local l = game.interface.getEntity(lines[i])
				for j = 1, #l.stops do
					local stationid = game.interface.getEntity(l.stops[j]).stations[1]
					if stationid ~= nil then
						local s = game.interface.getEntity(stationid)
						if s.carriers["RAIL"] then
							freq = freq + l.frequency
							break
						end
					end
				end
			end

			local arrived = 0
			local sent = 0
			for _, town in pairs({params.tokio, params.nagoya, params.osaka}) do
				local transportsamples = game.interface.getTownTransportSamples(town)
				arrived = arrived + transportsamples[1]
				sent = sent + transportsamples[2]
			end
			sent = math.max(sent, 100)
			local transportrating = arrived / sent
			local done3 = transportrating >= params.transportrating
			self:setProgressPercent(1 - transportrating, 2)

			local goalinvfreq = params.goalinvfreq
			local invfreq
			local done4 = false
			if freq > 0 then
				invfreq = 1 / freq
				done4 = invfreq <= goalinvfreq
			end
			self:setProgressText(tostring(math.ceil(invfreq or 999)) .. "/" .. params.goalinvfreq, 3)

			self:setSubtaskCompleted(1, x > params.deliver_food)
			--self:setSubtaskCompleted(2, upgraded)
			self:setSubtaskCompleted(2, done3)
			self:setSubtaskCompleted(3, done4)

			if x > 0 and done3 and done4 and taskutil.userstate.completed4a then
				self:finish()
			end
		end,
		onFinish = function(self)
			arrivaltracker.track("5b")
			taskutil.tasks["end"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_SUCCESS_CUSTOMERS_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_SUCCESS_CUSTOMERS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_SUCCESS_CUSTOMERS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_SHINKANSEN_TASK_SUCCESS_CUSTOMERS_SUB1") },
					--{ name = _("MISSION_SHINKANSEN_TASK_SUCCESS_CUSTOMERS_SUB2") },
					{ name = _("MISSION_SHINKANSEN_TASK_SUCCESS_CUSTOMERS_SUB3") },
					{ name = _("MISSION_SHINKANSEN_TASK_SUCCESS_CUSTOMERS_SUB4") },
				},
				parentId = "5",
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_SUCCESS_CUSTOMERS_TEXT.wav",
			}
		end,
	})

	taskutil:new("end", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setCompleted()
			taskutil:invokeLater(self.name, "finish", 0.6)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_FINISH_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_FINISH_TEXT") % params },
				},
				parentId = "5",
				voiceOver = "MISSION_SHINKANSEN_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
