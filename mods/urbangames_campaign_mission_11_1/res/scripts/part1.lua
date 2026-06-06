local taskutil = require "mission.taskutil"
local calendar = require "mission.calendar"
local params = require "params"
local util = require "util"
local streetutil = require "streetutil"
local vec3 = require "vec3"
local apputil = require "apputil"

return function()

	local mainguihandlers = {
		voiceOverEnded = function(self) taskutil:finish(self.name) end,
	}

	setmetatable(mainguihandlers, { __index = function(self, key)
		local n = #"jump_"
		if key:sub(1, n) == "jump_" then
			game.gui.setAutoCamera(params[key])
		end
	end})

	local function edgeLength(p0, p1, t0, t1)
		local p0 = vec3.new(table.unpack(p0))
		local p1 = vec3.new(table.unpack(p1))
		local t0 = vec3.new(table.unpack(t0))
		local t1 = vec3.new(table.unpack(t1))
		local dist = vec3.distance(p0, p1)
		local arg = vec3.dot(t0, t1) / (vec3.length(t0) * vec3.length(t1))
		arg = math.min(math.max(arg, -1), 1) --avoids numeric issues close to -1 and 1
		local alpha = math.acos(arg)
		local len = streetutil.calcScale(dist, alpha)
		return len
	end

	local function countTracks()
		local entities = game.interface.getEntities({ radius = 1e100 }, { type = "BASE_EDGE" })
		local calcScale = streetutil.calcScale
		local total = 0
		for i = 1, #entities do
			local e = game.interface.getEntity(entities[i])
			if e.track then
				total = total + edgeLength(e.node0pos, e.node1pos, e.node0tangent, e.node1tangent)
			end
		end
		return total
	end

	local function createhandlers()
		local result = {}
		result.reset = function(self, s)
			game.interface.upgradeConstruction(params[s], "industry/constructionsite.con" , { productionLevel = 0 })
			taskutil.userstate[s .. "into"] = nil
			taskutil.userstate[s .. "indparams"] = nil
		end
		result.build = function(self, s, y)
			game.interface.upgradeConstruction(params[s], "industry/constructionsite.con" , { productionLevel = 0, active = true })
			taskutil.userstate[s .. "delivered"] = game.interface.getEntity(game.interface.getEntity(params[s]).simBuildings[1]).itemsConsumed.STEEL or 0
			taskutil.userstate[s .. "into"] = "industry/" .. taskutil.userstate.options[y][2]
			taskutil.userstate[s .. "indparams"] = taskutil.userstate.options[y][3] or {}
		end
		result.counttracks = function(self)
			taskutil.userstate.currenttrackmeters = countTracks()
		end
		return result
	end
	local function createguihandlers()
		local result = {}
		for i = 1, params.numconsites do
			local s = "consite" ..i
			result[s] = function(self)
				local windowname = s .. "window"
				if util.windows[windowname] ~= nil then return end
				local boxlayout = gui.boxLayout_create(s .. "boxlayout", "VERTICAL")
				local tv = gui.textView_create(s .. "tv" , _("MISSION_REDSTAR_INDSUTRYBUILDER_TEXT")) --Welche Industrie soll hier gebaut werden?
				boxlayout:addItem(tv)

				local tv0 = gui.textView_create(s .. "tv0" , _("None"))
				local button0 = gui.button_create(s .. "button0" , tv0)
				button0:setStyleClassList({"missionOption"})
				boxlayout:addItem(button0)

				local options = taskutil.userstate.options
				for i = 1, #options do
					local tv = gui.textView_create(s .. "tv" .. i , options[i][1])
					local button = gui.button_create(s .. "button" .. i , tv)
					button:setStyleClassList({"missionOption"})
					boxlayout:addItem(button)
				end
				util.windows[windowname] = gui.window_create(windowname, _("MISSION_REDSTAR_INDSUTRYBUILDER_WINDOW_NAME"), boxlayout) --Industry umbauen
				util.windows[windowname]:addNavigation()
				if apputil.isCouchUiMode() then
					local windowCRect = game.gui.getContentRect(util.windows[windowname].id)
					local screenCRect = game.gui.getContentRect("mainView")
					local x = screenCRect[3] - windowCRect[3] - (screenCRect[3] * 0.36)
					local y = windowCRect[2] -- y pos
					game.gui.window_setPosition(util.windows[windowname].id, x, y)
				end
			end
		end
		result.guiHandleEvent = function(self, id, name, param)
			if name == "button.click" and id:match("consite%d+button%d+") then
				local i = tonumber(id:match("e%d+"):sub(2))
				local y = tonumber(id:match("n%d+"):sub(2))
				local windowname = "consite" .. i .. "window"
				local s = "constructionsite" .. i
				if y == 0 then
					taskutil:sendScriptFn(self.name, "reset", { s })
				else
					taskutil:sendScriptFn(self.name, "build", { s, y })
				end
				util.windows[windowname]:close()
				util.windows[windowname] = nil
			end
			if id:match("consite%d+window") and name:match("destroy") then
				local i = tonumber(id:match("e%d+"):sub(2))
				local windowname = "consite" .. i .. "window"
				util.windows[windowname] = nil
			end
		end
		result.trackcount = function(self, id, name, param, isApply)
			if isApply then
				taskutil:sendScriptFn(self.name, "counttracks")
				return true
			elseif id == "trackBuilder" then
				local total = 0
				local segments = param.proposal.proposal.addedSegments
				local rsegments = param.proposal.proposal.removedSegments
				local nodes = param.proposal.proposal.addedNodes
				local function nodePos(id)
					if id < 0 then
						local nodeid
						for i = 1, #nodes do
							if nodes[i].entity == id then
								nodeid = i
								break
							end
						end
						assert(nodeid ~= nil)
						return nodes[nodeid].comp.position
					else
						return game.interface.getEntity(id).position
					end
				end
				for i = 1, #segments do
					local e = segments[i]
					local p0 = nodePos(e.comp.node0)
					local p1 = nodePos(e.comp.node1)
					total = total + edgeLength(p0, p1, e.comp.tangent0, e.comp.tangent1)
				end
				for i = 1, #rsegments do
					local e = rsegments[i]
					local p0 = nodePos(e.comp.node0)
					local p1 = nodePos(e.comp.node1)
					total = total - edgeLength(p0, p1, e.comp.tangent0, e.comp.tangent1)
				end
				--print(taskutil.userstate.allowedtrackmeters, taskutil.userstate.currenttrackmeters, total)
				if taskutil.userstate.allowedtrackmeters - (taskutil.userstate.currenttrackmeters + total) < 0 then
					return _("MISSION_PROPOSAL_FEEDBACK_NOT_ENOUGH_TRACKS_AVAILABLE")
				end
				return true
			end
		end
		return result
	end
	taskutil:new("helper", {
		onUpdate = function(self)
			for i = 1, params.numconsites do
				local s0 = "constructionsite" .. i
				local s1 = s0 .. "into"
				local s2 = s0 .. "indparams"
				local into = taskutil.userstate[s1]
				local indparams = taskutil.userstate[s2]
				if into ~= nil then
					local c = game.interface.getEntity(game.interface.getEntity(params["constructionsite" .. i]).simBuildings[1]).itemsConsumed.STEEL or 0
					c = c - taskutil.userstate["constructionsite" .. i .. "delivered"]
					if c >= 0 then -- instant upgrade
						local stage2goods = taskutil.tasks["3"].start == nil
						game.interface.upgradeConstruction(params["constructionsite" .. i], into, indparams)
						taskutil.userstate[s1] = nil
						taskutil.userstate[s2] = nil
					end
				end
			end

			local vehicles = game.interface.getVehicles()
			local time = game.interface.getGameTime().time
			local dt = time - (taskutil.userstate.updatetime or 0)
			taskutil.userstate.updatetime = time
			taskutil.userstate.trainpositions = taskutil.userstate.trainpositions or {}
			taskutil.userstate.metersXcargo = taskutil.userstate.metersXcargo or 0
			taskutil.userstate.resettime = taskutil.userstate.resettime or 0
			local postable = taskutil.userstate.trainpositions
			if dt > 0 then
				local metersXcargo = 0
				for i = 1, #vehicles do
					local v = game.interface.getEntity(vehicles[i])
					if v.carrier == "RAIL" then
						local numitems = 0
						for k, v in pairs(v.cargoLoad) do
							if k ~= "PASSENGERS" then
								numitems = numitems + v
							end
						end
						local newpos = vec3.new(table.unpack(v.position))
						if postable[vehicles[i]] ~= nil then
							local dist = vec3.distance(postable[vehicles[i]], newpos)
							metersXcargo = metersXcargo + numitems * dist
						end
						postable[vehicles[i]] = newpos
					end
				end
				if time - taskutil.userstate.resettime > calendar.secondspermonthif(params.millisperday) then
					taskutil:invokeLater("4c", "monthwasreset", 0)
					taskutil.userstate.metersXcargo = 0
					taskutil.userstate.resettime = time
				end
				taskutil.userstate.metersXcargo = taskutil.userstate.metersXcargo + metersXcargo
			end
		end,
		getInfo = function(self)
			return {
				visible = false,
			}
		end,
		handlers = createhandlers(),
		guiHandlers = createguihandlers(),
	})

	taskutil:new("1", {
		onStart = function(self)
			taskutil.userstate.options = {}
			taskutil.userstate.options[#taskutil.userstate.options + 1] = { _("Farm"), "farm.con" }
			taskutil.tasks["helper"]:start()

			--taskutil.tasks["m2"]:start()
			--taskutil.tasks["m3"]:start()
			--taskutil.tasks["m4"]:start()

			for i = 1, params.numconsites do
				taskutil:setMarker("consite" .. i, { entity = params["constructionsite" .. i], type = "question" }, "helper", "consite" .. i)
			end
			taskutil.userstate.currenttrackmeters = countTracks()
			taskutil.userstate.allowedtrackmeters = params.trackstart
			--taskutil:setProposal("trackcount", "helper", "trackcount")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_REBUILD_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_REBUILD_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_REBUILD_TEXT.wav",
			}
		end,
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.trackindustry).simBuildings[1]).itemsConsumed._sum or 0
			self:setProgressCount(c,params.tracksteelgoal,1)

			local path_found = false

			local pos1 = params.pos_chengdu
			local stations1 = game.interface.getEntities({pos = pos1, radius = 500}, {type = "STATION"})

			local pos2 = params.pos_chongqing
			local stations2 = game.interface.getEntities({pos = pos2, radius = 500}, {type = "STATION"})
			for i = 1, #stations1 do
				for j = 1, #stations2 do
					local path = game.interface.findPath(stations1[i], stations2[j], { TRAIN = true })
					if path ~= nil then
						path_found = true
					end
				end
			end

			self:setSubtaskCompleted(1, c >= params.tracksteelgoal)
			self:setSubtaskCompleted(2, path_found == true)

			if c >= params.tracksteelgoal and path_found == true then
				self:finish()
			end

		end,
		onFinish = function(self)
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_REBUILD_STEEL_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_REBUILD_STEEL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_REDSTAR_TASK_REBUILD_STEEL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				subTasks = {
					{ name = _("MISSION_REDSTAR_TASK_REBUILD_STEEL_SUB1") },
					{ name = _("MISSION_REDSTAR_TASK_REBUILD_STEEL_SUB2") },
				},
				camera = params.jump_trackindustry,
				voiceOver = "MISSION_REDSTAR_TASK_REBUILD_STEEL_TEXT.wav",
			}
		end,
		handlers = {
			advance = function(self) 
				if taskutil.tasks["1b"].start ~= nil then
					self:setProgressNone()
					taskutil.tasks["1b"]:start()
				end 
			end,
		},
	})

	taskutil:new("1b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local count = 0
			for i = 1, params.numconsites do
				local e = game.interface.getEntity(params["constructionsite" .. i])
				if e.fileName == "industry/farm.con" then
					count = count + 1
				end
			end
			if count >= 1 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_REBUILD_GRAIN_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_REBUILD_GRAIN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_REDSTAR_TASK_REBUILD_GRAIN_TASK") % params },
					{ type = "HINT", text = _("MISSION_REDSTAR_TASK_REBUILD_GRAIN_HINT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				camera = params.default_camera,
				voiceOver = "MISSION_REDSTAR_TASK_REBUILD_GRAIN_TEXT.wav",
			}
		end,
	})

	taskutil:new("1c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.machinesimport).simBuildings[1]).itemsConsumed.GRAIN or 0
			local c2 = game.interface.getEntity(game.interface.getEntity(params.machinesimport2).simBuildings[1]).itemsConsumed.GRAIN or 0
			local c3 = game.interface.getEntity(game.interface.getEntity(params.machinesimport3).simBuildings[1]).itemsConsumed.GRAIN or 0
			if c + c2 + c3 > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["2"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_REDSTAR_TASK_REBUILD_MACHINES_NAME"),
				paragraphs = {
					{ text = _("MISSION_REDSTAR_TASK_REBUILD_MACHINES_TEXT") % params },
					{ type = "TASK", text = _("MISSION_REDSTAR_TASK_REBUILD_MACHINES_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
				subTasks = {
					{ name = _("MISSION_REDSTAR_TASK_REBUILD_MACHINES_SUB1") },
				},
				voiceOver = "MISSION_REDSTAR_TASK_REBUILD_MACHINES_TEXT.wav",
				camera = params.jump_machinesimport,
			}
		end,
	})

end
