local params = require "params"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"
local vec3 = require "vec3"
local proposalutil = require "mission.proposalutil"
local polygonutil = require "polygonutil"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_DRIVER")
			self:setProgressNone()
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_SCHOOL_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_SCHOOL_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_digesteddriver,
				voiceOver = "MISSION_COLONIALISM_MEDAL_SCHOOL_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m1a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m1a", {
		onStart = function(self)
			taskutil:setZone("digesteddriver", { polygon = zoneutil.makeCircleZone(params.digesteddriver.pos, params.digesteddriver.radius), draw = true, drawColor = colors.BLUE })
			taskutil:setProposal("m1a1", self.name, "checkProposalDriver")
			taskutil:setProposal("m1a2", self.name, "checkProposalDriverDepot")
		end,
		onUpdate = function(self)
			taskutil:setZone("digesteddriver", { polygon = zoneutil.makeCircleZone(params.digesteddriver.pos, params.digesteddriver.radius), draw = true, drawColor = colors.BLUE })
			local stations = game.interface.getEntities(params.digesteddriver, { type = "STATION" })
			local depots = game.interface.getEntities(params.digesteddriver, { type = "VEHICLE_DEPOT" })
			if #stations >= 2 and #depots >= 1 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_SCHOOL_PRACTISE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_SCHOOL_PRACTISE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_MEDAL_SCHOOL_PRACTISE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_digesteddriver,
				voiceOver = "MISSION_COLONIALISM_MEDAL_SCHOOL_PRACTISE_TEXT.wav",
			}
		end,
		guiHandlers = {
			checkProposalDriver = function(self, id, name, param)
				return proposalutil.checkTrackBuildOrBulldozeInArea(zoneutil.makeCircleZone(params.digesteddriver.pos, params.digesteddriver.radius))(id, name, param)
			end,
			checkProposalDriverDepot = function(self, id, name, param, isApply)
				if id == "constructionBuilder" then
					if param.proposal.toAdd[1].fileName == "depot/train_depot_era_a.con"  then
						local zone = zoneutil.makeCircleZone(params.digesteddriver.pos, params.digesteddriver.radius)
						local trf = param.proposal.toAdd[1].transf
						if polygonutil.contains(zone, { trf[13], trf[14] }) then
							return true
						else
							return _("MISSION_PROPOSAL_FEEDBACK_NOT_IN_OUTLINED_AREA")
						end
					end
				end
			end,
		},
	})

	local oldpositions = {}
	taskutil:new("m1b", {
		onStart = function(self)
			taskutil.userstate.digesteddrivermeters = 0
		end,
		onUpdate = function(self)
			local lines = {}
			local stations = game.interface.getEntities(params.digesteddriver, { type = "STATION" })
			for i = 1, #stations do
				local linesi = game.interface.getLines({ stationGroup = game.interface.getEntity(stations[i]).stationGroup })

				for j = i + 1, #stations do
					local linesj = game.interface.getLines({ stationGroup = game.interface.getEntity(stations[j]).stationGroup })

					for x = 1, #linesi do
						for y = 1, #linesj do

							if linesi[x] == linesj[y] then
								lines[linesi[x]] = 1
							end
						end
					end
				end
			end

			local positions = {}
			local vehicles = game.interface.getEntities(params.digesteddriver, { type = "VEHICLE" })
			for i = 1, #vehicles do
				local v = game.interface.getEntity(vehicles[i])
				if lines[v.line] == 1 then
					positions[v.id] = v.position
					if oldpositions[v.id] ~= nil then
						local x = vec3.new(table.unpack(positions[v.id]))
						local y = vec3.new(table.unpack(oldpositions[v.id]))
						taskutil.userstate.digesteddrivermeters = taskutil.userstate.digesteddrivermeters + vec3.distance(x, y)
					end
				end
			end
			oldpositions = positions

			local meters = math.floor(taskutil.userstate.digesteddrivermeters)
			self:setProgressText(meters .. "/" .. params.meter_amount_driver .. " " .. _("meters"))
			if taskutil.userstate.digesteddrivermeters >= params.meter_amount_driver then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("digesteddriver")
			taskutil:setMedalCompleted("MEDAL_DRIVER")
			taskutil.tasks["m1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_MEDAL_SCHOOL_TEST_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_SCHOOL_TEST_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_MEDAL_SCHOOL_TEST_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_digesteddriver,
				voiceOver = "MISSION_COLONIALISM_MEDAL_SCHOOL_TEST_TEXT.wav",
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
				name = _("MISSION_COLONIALISM_MEDAL_SCHOOL_HAPPY_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_MEDAL_SCHOOL_HAPPY_TEXT") % params },
				},
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_COLONIALISM_MEDAL_SCHOOL_HAPPY_TEXT.wav",
			}
		end,
	})
end
