local params = require "params"
local colors = require "mission.colors"
local util = require "util"

return function(taskutil)
	local tasks = taskutil.tasks

	local mainguihandlers = {
		checkProposal = function(self, id, name, param, isApply)
			if id ~= "trackBuilder" then return true end
			local as = param.proposal.proposal.addedSegments
			for i = 1, #as do
				if as[i].comp.type == "BRIDGE" then
					return _("MISSION_PROPOSAL_FEEDBACK_NO_BRIDGES_ALLOWED")
				end
			end
			return true
		end,
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
			game.interface.upgradeConstruction(params.construction_site_1, "industry/construction_site.con", { productionLevel = 0, })
			game.interface.upgradeConstruction(params.construction_site_2, "industry/construction_site.con", { productionLevel = 0, })
			game.interface.upgradeConstruction(params.construction_site_3, "industry/construction_site.con", { productionLevel = 0, })

			taskutil:enableProposalCheck()
			taskutil:setProposalCheckBlacklist()

			taskutil:setZone("prohibit",     { polygon = params.prohibit_part2, draw = true , drawColor = colors.RED, buildToolMode = "PROHIBIT" })
			taskutil:setZone("prohibitlake", { polygon = params.prohibit_lake,  draw = false, drawColor = colors.RED, buildToolMode = "PROHIBIT" })
			--taskutil:setProposal("nobridge", self.name, "checkProposal")

			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_PREPARE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_PREPARE_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_overviewpos,
				voiceOver = "MISSION_TRANSSIB_TASK_PREPARE_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local goal = {
				{ params.irkutsk, params.port_baykal, "TRAIN" },
				{ params.baykalsk, params.ulanude, "TRAIN" },
				--{ params.port_baykal, params.baykalsk, "SHIP" },
			}

			local count = 0
			local vehicleids = game.interface.getVehicles()
			local vehiclelines = {}
			for i = 1, #vehicleids do
				local v = game.interface.getEntity(vehicleids[i])
				vehiclelines[v.line] = 1
			end

			local function getLinesWithVehicle(station)
				local lines = game.interface.getLines({ stationGroup = game.interface.getEntity(station).stationGroup })
				local result = {}
				for i = 1, #lines do
					local l = lines[i]
					if vehiclelines[l] ~= nil then result[#result + 1] = l end
				end
				return result
			end

			for i = 1, #goal do
				local g = goal[i]
				local frompos = game.interface.getEntity(g[1]).position
				local topos = game.interface.getEntity(g[2]).position

				local stations1 = game.interface.getEntities({pos = frompos, radius = 500}, {type = "STATION"})
				local stations2 = game.interface.getEntities({pos = topos, radius = 500}, {type = "STATION"})
				local foundpath = false
				for k = 1, #stations1 do
					local s1 = stations1[k]
					--local lines1 = getLinesWithVehicle(s1)
					--if #lines1 > 0 and game.interface.getEntity(s1).cargo then
					--if #lines1 > 0 then
						for l = 1, #stations2 do
							local s2 = stations2[l]
							--[[local lines2 = getLinesWithVehicle(s2)
							local hasline = false
							for y = 1, #lines2 do
								for x = 1, #lines1 do
									if lines1[x] == lines2[y] then
										hasline = true
										break
									end
								end
								if hasline then break end
							end]]--
							--if hasline and game.interface.getEntity(s2).cargo then
							--if hasline then
								local path = game.interface.findPath(s1, s2, { [g[3]] = true })
								foundpath = foundpath or (path ~= nil)
								if foundpath then break end
							--end
						end
					--end
					if foundpath then
						count = count + 1
						break
					end
				end
				self:setSubtaskCompleted(i + 1, foundpath)
			end

			local produced = game.interface.getEntity(game.interface.getEntity(params.steel_mill).simBuildings[1]).itemsProduced._sum
			if produced > 0 then
				count = count + 1
				self:setSubtaskCompleted(1)
			end

			if count == 3 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TRANSSIB_TASK_PREPARE_CONNECT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_TRANSSIB_TASK_PREPARE_CONNECT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TRANSSIB_TASK_PREPARE_CONNECT_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_TRANSSIB_TASK_PREPARE_CONNECT_SUB1") % params },
					{ name = _("MISSION_TRANSSIB_TASK_PREPARE_CONNECT_SUB2") % params },
					{ name = _("MISSION_TRANSSIB_TASK_PREPARE_CONNECT_SUB3") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.jump_overviewpos,
				voiceOver = "MISSION_TRANSSIB_TASK_PREPARE_CONNECT_TEXT.wav",
			}
		end,
	})
end
