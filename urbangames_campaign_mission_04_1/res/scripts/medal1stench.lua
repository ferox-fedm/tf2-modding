local params = require "params"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"
local vehiclestore = require "mission.vehiclestore"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_STENCH")
			self:setProgressNone()
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_MEDAL_TRAM_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_TRAM_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_topolobampo,
				voiceOver = "MISSION_PARADISO_MEDAL_TRAM_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self)
				taskutil:start("m1a")
				taskutil:finish(self.name)
			end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	local radius = 60
	taskutil:new("m1a", {
		onStart = function(self)
			taskutil:setZone("stench1", { polygon = zoneutil.makeCircleZone(game.interface.getEntity(params.hotel).position, radius), draw = true, drawColor = colors.RED })
			--taskutil:setZone("stench2", { polygon = zoneutil.makeCircleZone(game.interface.getEntity(params.library).position, radius), draw = true, drawColor = colors.RED })
			taskutil:setZone("stench3", { polygon = zoneutil.makeCircleZone(game.interface.getEntity(params.hospital).position, radius), draw = true, drawColor = colors.RED })
			taskutil.userstate.cleantransported = 0
		end,
		onUpdate = function(self)
			local stations = game.interface.getEntities({pos = game.interface.getEntity(params.hotel).position, radius = 500}, {type = "STATION"})
			local people = 0
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.PASSENGERS or 0
				people = people + s
			end
			local cleantransported = math.max(people - taskutil.userstate.cleantransported, 0)
			self:setProgressCount(cleantransported, params.tram_smell_people, 1)
			local bad = {
				game.interface.getEntities({pos = game.interface.getEntity(params.hotel).position, radius = radius }, {type = "STATION"}),
				--game.interface.getEntities({pos = game.interface.getEntity(params.library).position, radius = radius }, {type = "STATION"}),
				game.interface.getEntities({pos = game.interface.getEntity(params.hospital).position, radius = radius }, {type = "STATION"}),
			}
			local ok = true
			for i = 1, 2 do
				local b = bad[i]
				local count = 0
				for j = 1, #stations do
					for k = 1, #b do
						if stations[j] == b[k] and game.interface.getEntity(b[k]).carriers["ROAD"] and game.interface.getEntity(b[k]).cargo == false then
							count = count + 1
						end
					end
				end
				self:setSubtaskCompleted(i + 1, count == 0)
				if count > 0 then ok = false end
			end
			if not ok then
				taskutil.userstate.cleantransported = people
			elseif cleantransported >= params.tram_smell_people then
				taskutil.userstate.cleantransported = people
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setZone("stench1")
			taskutil:setZone("stench2")
			taskutil:setZone("stench3")
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_MEDAL_TRAM_SMELL_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_TRAM_SMELL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_MEDAL_TRAM_SMELL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_PARADISO_MEDAL_TRAM_SMELL_SUB1") },
					--{ name = _("MISSION_PARADISO_MEDAL_TRAM_SMELL_SUB2") },
					{ name = _("MISSION_PARADISO_MEDAL_TRAM_SMELL_SUB3") },
					{ name = _("MISSION_PARADISO_MEDAL_TRAM_SMELL_SUB4") },
				},
				parentId = "m1",
				camera = params.jump_topolobampo,
				voiceOver = "MISSION_PARADISO_MEDAL_TRAM_SMELL_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount("vehicle/tram/usa/san_diego_v2.mdl", nil)
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getEntities({pos = game.interface.getEntity(params.hotel).position, radius = 500}, {type = "VEHICLE"})
			local badvehicles = 0
			for i = 1, #vehicles do
				local v = game.interface.getEntity(vehicles[i])
				local x = 5
				if v.carrier == "TRAM" and v.vehicles[1].fileName ~= "vehicle/tram/usa/san_diego_v2.mdl" then
					badvehicles = badvehicles + 1
				end
			end
			self:setSubtaskCompleted(2, badvehicles == 0)

			local stations = game.interface.getEntities({pos = game.interface.getEntity(params.hotel).position, radius = 500}, {type = "STATION"})
			local people = 0
			for i = 1, #stations do
				local s = game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsUnloaded.PASSENGERS or 0
				people = people + s
			end
			local cleantransported = people - taskutil.userstate.cleantransported

			if badvehicles > 0 then
				taskutil.userstate.cleantransported = people
			elseif cleantransported >= params.tram_technology_people then self:finish() end

			self:setProgressCount(cleantransported, params.tram_technology_people, 1)
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_STENCH")
			taskutil.tasks["m1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_MEDAL_TRAM_TECHNOLOGY_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_TRAM_TECHNOLOGY_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_MEDAL_TRAM_TECHNOLOGY_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_PARADISO_MEDAL_TRAM_TECHNOLOGY_SUB1") },
					{ name = _("MISSION_PARADISO_MEDAL_TRAM_TECHNOLOGY_SUB2") },
				},
				parentId = "m1",
				camera = params.jump_topolobampo,
				voiceOver = "MISSION_PARADISO_MEDAL_TRAM_TECHNOLOGY_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_MEDAL_TRAM_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_MEDAL_TRAM_FINISH_TEXT") % params }
				},
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_PARADISO_MEDAL_TRAM_FINISH_TEXT.wav",
			}
		end,
	})
end
