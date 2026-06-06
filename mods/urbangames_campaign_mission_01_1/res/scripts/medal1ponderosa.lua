local params = require "params"
local util = require "util"
local proposalutil = require "mission.proposalutil"
local vec2 = require "vec2"
local guidesystem = require "guidesystem"
local vehiclestore = require "mission.vehiclestore"
local arrivaltracker = require "mission.arrivaltracker"
local gui = require "gui"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_PONDEROSA")
			self:setProgressNone()
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_MEDAL_PONDEROSA_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_MEDAL_PONDEROSA_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_forestCarson,
				voiceOver = "MISSION_SILVERCITY_MEDAL_PONDEROSA_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m1a") taskutil:finish(self.name) end,
			decline = function(self)
				gui.window_get("missionDisplayWindow"):close()
				taskutil:finish(self.name)
			end,
		},
	})

	taskutil:new("m1a", {
		onStart = function(self)
			--taskutil.userstate.guidesystemkeys["guides_street"] = guidesystem.getTime()
			taskutil:setProposal("pm1a", self.name, "checkProposal")
			vehiclestore.setAllowedVehicleCount(params.modelNames.trainName, nil)
			vehiclestore.setAllowedVehicleCount(params.modelNames.cargoWagonName, nil)
			taskutil:setEnabled("menu.construction.terrain", true)
			taskutil:setEnabled("menu.lineManager", true)
			taskutil:setEnabled("menu.bulldozer", true)
			taskutil:setEnabled("menu.moduleBulldozer", true)

			taskutil:setEnabled("menu.construction.roadmenu", true)
			taskutil:setEnabled("menu.construction.road.streets", true)
			taskutil:setEnabled("menu.construction.road.road-buildings", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.depot/road_depot_era_a.con", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.station/road/small_cargo.mdl", true)
			taskutil:setVisibleAndEnabled("menu.construction.road.road-buildings.item.depot", true)
			arrivaltracker.track("m1a", { cargotype = "LOGS", to = params.woodProcessingMill })
		end,
		onUpdate = function(self)
			if arrivaltracker.get("m1a") > params.woodmillconsumption then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setProposal("pm1a")
			arrivaltracker.track("m1a")
			taskutil:setMedalCompleted("MEDAL_PONDEROSA")
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_MEDAL_PONDEROSA_DELIVER_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_MEDAL_PONDEROSA_DELIVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SILVERCITY_MEDAL_PONDEROSA_DELIVER_TASK") % params },
				},
				options = {
					{ "Debug: Skip", "finish" },
				},
				parentId = "m1",
				camera = params.jump_forestCarson,
				voiceOver = "MISSION_SILVERCITY_MEDAL_PONDEROSA_DELIVER_TEXT.wav",
			}
		end,
		guiHandlers = {
			checkProposal = function(self, id, name, param, isApply)
				if id == "constructionBuilder" or id == "streetBuilder" then
					local as = param.proposal.proposal.addedSegments
					for i = 1, #as do
						if as[i].type == 1 then return false end
					end
					local nodes = proposalutil.collectNodePositions(param.proposal.proposal.addedNodes)
					local p = vec2.new(params.railStationCarsonCityZone.pos[1], params.railStationCarsonCityZone.pos[2])
					local r = 110
					for i = 1, #nodes do
						local n = vec2.new(nodes[i][1], nodes[i][2])
						if vec2.distance(p, n) < r then
							return _("MISSION_PROPOSAL_FEEDBACK_TO_CLOSE_TO_CARSONCITY") % params, 10 --too close to center of ${name_carsonCity}
						end
					end
					return true
				end
				if id == "bulldozer" then
					local rs = param.proposal.proposal.removedSegments
					for i = 1, #rs do
						if rs[i].type == 1 then return false end
					end
					return true
				end
				return false
			end,
		},
	})

	taskutil:new("m1b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onUpdate = function(self)
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SILVERCITY_MEDAL_PONDEROSA_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_SILVERCITY_MEDAL_PONDEROSA_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_SILVERCITY_MEDAL_PONDEROSA_FINISH_TEXT.wav",
			}
		end,
	})
end
