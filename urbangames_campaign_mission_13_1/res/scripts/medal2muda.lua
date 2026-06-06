local taskutil = require "mission.taskutil"
local params = require "params"

return function()
	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_2")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_MUDA_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_MEDAL_MUDA_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_MEDAL_MUDA_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m2a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	local industries = { params.stonepile, params.steelmill, params.conmatplant, params.foodprocessing, params.ranch }
	local mudas = {
		function (self)
			--muda 1
			local produced = 0
			local shipped = 0
			for _, v in pairs(industries) do
				produced = produced + game.interface.getIndustryProduction(v)
				shipped = shipped + game.interface.getIndustryShipping(v)
			end
			produced = produced / #industries
			shipped = shipped / #industries
			local score = produced > 10 and shipped / produced or 0
			local done = score >= params.industryshippedrating,
			self:setProgressPercent(score, 1)
			self:setSubtaskCompleted(1, done)
			return done
		end,
		function (self)
			--muda 2
			local arrived = 0
			local sent = 0
			for _, town in pairs({params.tokio, params.nagoya, params.osaka}) do
				local transportsamples = game.interface.getTownTransportSamples(town)
				arrived = arrived + transportsamples[1]
				sent = sent + transportsamples[2]
			end
			sent = math.max(sent, 100)
			local transportrating = arrived / sent
			local done = transportrating >= params.transportratingmuda
			self:setProgressPercent(1 - transportrating, 2)
			self:setSubtaskCompleted(2, done)
			return done
		end,
		function (self)
			--muda 3
			local done = true
			local vehicles = game.interface.getVehicles({ carrier = "RAIL" })
			for i = 1, #vehicles do
				local v = game.interface.getEntity(vehicles[i])
				local cap = v.capacities
				local cload = v.cargoLoad
				for k,v in pairs(cap) do
					if (cload[k] or 0) < 0.5 * v then
						done = false
						break
					end
				end
			end
			self:setSubtaskCompleted(3, done)
			return done
		end,
		function (self)
			--muda 4
			local transported = 0
			local n = 0
			for _, v in pairs(industries) do
				local t = game.interface.getIndustryTransportRating(v)
				if t > 0 then
					transported = transported + t
					n = n + 1
				end
			end
			if n == 0 then
				self:setProgressPercent(transported, 4)
				self:setSubtaskCompleted(4, false)
				return false
			end
			transported = transported / n
			local done = transported >= params.industryrating,
			self:setProgressPercent(transported, 4)
			self:setSubtaskCompleted(4, done)
			return done
		end,
		function (self)
			--muda 5 -- anzahl weichen
			if taskutil.userstate.muda5counter == 0 or taskutil.userstate.muda5counter == nil then
				taskutil.userstate.muda5counter = 20
			else
				taskutil.userstate.muda5counter = taskutil.userstate.muda5counter - 1
				return
			end
			local done = true
			local entities = game.interface.getEntities({ radius = 1e100 }, { type = "BASE_EDGE" })
			local tracks = {}
			for i = 1, #entities do
				local e = game.interface.getEntity(entities[i])
				if e.track then tracks[#tracks + 1] = e end
			end
			local nodecount = {}
			for i = 1, #tracks do
				local t = tracks[i]
				nodecount[t.node0] = (nodecount[t.node0] or 0) + 1
				nodecount[t.node1] = (nodecount[t.node1] or 0) + 1
			end
			local numswitches = 0
			for k, v in pairs(nodecount) do
				if v > 2 then numswitches = numswitches + 1 end
			end
			done = numswitches <= params.numswitches
			self:setProgressCount(numswitches, params.numswitches, 5)
			self:setSubtaskCompleted(5, done)
			return done
		end,
		function (self)
			--muda 6 -- nur mehr zis_150_tipper oder zis_150_universal
			local done = true
			local vehicles = game.interface.getVehicles({ carrier = "ROAD" })
			for i = 1, #vehicles do
				local v = game.interface.getEntity(vehicles[i])
				if v.vehicles[1].fileName:match("gaz_") then
					done = false
				end
			end
			self:setSubtaskCompleted(6, done)
			return done
		end,
		function (self)
			--muda 7 -- Zustand Züge?
			local vehicles = game.interface.getVehicles({ carrier = "RAIL" })
			local good = 0
			for i = 1, #vehicles do
				local condition = 0
				local e = game.interface.getEntity(vehicles[i])
				for j = 1, #e.vehicles do
					condition = condition + e.vehicles[j].condition
				end
				condition = condition / #e.vehicles
				if condition > params.goodcondition then good = good + 1 end
			end
			local done = good == #vehicles
			self:setProgressCount(good, #vehicles, 7)
			self:setSubtaskCompleted(7, done)
			return done
		end,
	}

	taskutil:new("m2a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local done = true
			for i = 1, #mudas do
				done = mudas[i](self) and done
			end
			if done then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_2")
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_MUDA_AVOID_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_MEDAL_MUDA_AVOID_TEXT") },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_MEDAL_MUDA_AVOID_TASK") },
				},
				subTasks = {
					{ name = _("MISSION_SHINKANSEN_MEDAL_MUDA_AVOID_SUB1") },
					{ name = _("MISSION_SHINKANSEN_MEDAL_MUDA_AVOID_SUB2") },
					{ name = _("MISSION_SHINKANSEN_MEDAL_MUDA_AVOID_SUB3") },
					{ name = _("MISSION_SHINKANSEN_MEDAL_MUDA_AVOID_SUB4") },
					{ name = _("MISSION_SHINKANSEN_MEDAL_MUDA_AVOID_SUB5") },
					{ name = _("MISSION_SHINKANSEN_MEDAL_MUDA_AVOID_SUB6") },
					{ name = _("MISSION_SHINKANSEN_MEDAL_MUDA_AVOID_SUB7") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_MEDAL_MUDA_AVOID_TEXT.wav",
			}
		end,
	})

	taskutil:new("m2b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_MEDAL_MUDA_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_SHINKANSEN_MEDAL_MUDA_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_SHINKANSEN_MEDAL_MUDA_FINISH_TEXT.wav",
			}
		end,
	})
end
