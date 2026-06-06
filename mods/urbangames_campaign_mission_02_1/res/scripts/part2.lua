local params = require "params"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"
local proposalutil = require "mission.proposalutil"
local arrivaltracker = require "mission.arrivaltracker"
local guidesystem = require "guidesystem"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("2", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track2")
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_EXPORT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_EXPORT_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_surabaya,
				voiceOver = "MISSION_COLONIALISM_TASK_EXPORT_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_townwindow"] = guidesystem.getTime()
			taskutil:setEnabled("menu.construction.roadmenu", true)
			taskutil:setEnabled("menu.construction.road.passenger", false)
			taskutil:setZone("blue1", { polygon = zoneutil.makeCircleZone(params.zone_plant.pos, params.zone_plant.radius), draw = true, drawColor = colors.BLUE })
			taskutil:setZone("blue2", { polygon = zoneutil.makeCircleZone(params.zone_town.pos, params.zone_town.radius), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local function check(stations)
				for i = 1, #stations do
					local e = game.interface.getEntity(stations[i])
					if e.carriers.ROAD and e.cargo then return true end
				end
				return false
			end
			local stations1 = game.interface.getEntities(params.zone_plant, { type = "STATION" })
			local stations2 = game.interface.getEntities(params.zone_town, { type = "STATION" })
			if check(stations1) and check(stations2) then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_townwindow"] = nil
			taskutil:setZone("blue1")
			taskutil:setZone("blue2")
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_EXPORT_TRUCK_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_EXPORT_TRUCK_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_EXPORT_TRUCK_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_surabaya,
				voiceOver = "MISSION_COLONIALISM_TASK_EXPORT_TRUCK_TEXT.wav",
			}
		end,
	})

	taskutil:new("2b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local function get(stations)
				local result = {}
				for i = 1, #stations do
					local e = game.interface.getEntity(stations[i])
					if e.carriers.ROAD and e.cargo then result[#result + 1] = e end
				end
				return result
			end
			local stations1 = get(game.interface.getEntities(params.zone_plant, { type = "STATION" }))
			local stations2 = get(game.interface.getEntities(params.zone_town, { type = "STATION" }))

			if #stations1 == 0 or #stations2 == 0 then return end

			local vehicles = game.interface.getVehicles({ carrier = "ROAD" })
			local lines = {}
			for j = 1, #stations1 do
				local morelines = game.interface.getLines({ stationGroup = stations1[j].stationGroup })
				for k = 1, #morelines do
					lines[morelines[k]] = 1
				end
			end
			for id, _ in pairs(lines) do
				local l = game.interface.getEntity(id)

				local hasvehicle = false
				for v = 1, #vehicles do
					local vehicle = game.interface.getEntity(vehicles[v])
					if vehicle.line == id and ((vehicle.allCapacities.PASSENGERS or 0) == 0) then
						hasvehicle = true
						break
					end
				end
				if hasvehicle then
					local has1 = false
					local has2 = false
					for k = 1, #stations1 do
						for j = 1, #l.stops do
							if l.stops[j] == stations1[k].stationGroup then has1 = true break end
						end
					end
					for k = 1, #stations2 do
						for j = 1, #l.stops do
							if l.stops[j] == stations2[k].stationGroup then has2 = true break end
						end
					end
					if has1 and has2 then
						self:finish()
						return
					end
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_EXPORT_DELIVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_EXPORT_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_EXPORT_DELIVER_TASK") % params },
					{ type = "HINT", text = _("MISSION_COLONIALISM_TASK_EXPORT_DELIVER_HINT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_surabaya,
				voiceOver = "MISSION_COLONIALISM_TASK_EXPORT_DELIVER_TEXT.wav",
			}
		end,
	})

	taskutil:new("2c", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm1", 30)
			arrivaltracker.track("2c", { cargotype = "COFFEEBEANS" })

			--starting from here, street connectivity is no longer a must for constructions
			taskutil:setProposal("p1a3_streetconnectivity")
			taskutil:setProposal("p2c", self.name, "checkProposalConstructions")
		end,
		onUpdate = function(self)
			local c = arrivaltracker.get("2c")
			if c > 0 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("2c")
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_EXPORT_FACTORY_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_EXPORT_FACTORY_TEXT") % params  },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_EXPORT_FACTORY_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				--subTasks = {
				--	{ name = _("Produktion für Wachstum erfüllt") },
				--	{ name = _("Lieferung für Wachstum erfüllt") },
				--	{ name = _("Transport für Wachstum erfüllt") },
				--},
				parentId = "2",
				camera = params.jump_surabaya,
				voiceOver = "MISSION_COLONIALISM_TASK_EXPORT_FACTORY_TEXT.wav",
			}
		end,
		handlers = {
			showm1 = function(self) 
				if taskutil.tasks["m1"].start ~= nil then
					taskutil.tasks["m1"]:start()
				end
			end,
		},
		guiHandlers = {
			checkProposalConstructions = function(self, id, name, param, isApply)
				if id == "constructionBuilder" then
					if param.proposal.toAdd[1].fileName ~= "depot/train_depot_era_a.con"  then
						return true
					end
				end
			end,
		}
	})

end
