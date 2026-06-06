local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local vec3 = require "vec3"
local arrivaltracker = require "mission.arrivaltracker"
local util = require "util"

return function()
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
				name = _("MISSION_FUTURECITY_TASK_2_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_2_TEXT") % params }
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_TASK_2_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_TASK_2_DECIDE_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_2_DECIDE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_TASK_2_DECIDE_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_TASK_2_DECIDE_TEXT.wav",
				options = { { _("MISSION_FUTURECITY_TASK_2_DECIDE_OPTION1"), "option1" },
				            { _("MISSION_FUTURECITY_TASK_2_DECIDE_OPTION2"), "option2" } },
				parentId = "2",
			}
		end,
		handlers = {
			option1 = function(self)
				taskutil.userstate.choice2a = 1
				taskutil:finish(self.name)
			end,
			option2 = function(self)
				taskutil.userstate.choice2a = 2
				taskutil:finish(self.name)
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

	local function countroads()
			local entities = game.interface.getEntities({ radius = 1e100 }, { type = "BASE_EDGE" })
			local meters = 0
			for i = 1, #entities do
				local e = game.interface.getEntity(entities[i])
				if not e.track then
					if e.streetType == "standard/country_small_one_way_new.lua"
					or e.streetType == "standard/country_medium_one_way_new.lua"
					or e.streetType == "standard/country_large_one_way_new.lua"
					then
						local p0 = vec3.new(table.unpack(e.node0pos))
						local p1 = vec3.new(table.unpack(e.node1pos))
						local dist = vec3.distance(p0, p1)
						meters = meters + dist
					end
				end
			end
			return meters
	end
	taskutil:new("2b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local done1
			local done2
			if taskutil.userstate.choice2a == 1 then
				if taskutil.userstate.timer2b == 0 or taskutil.userstate.timer2b == nil then
					taskutil.userstate.timer2b = 20
					taskutil.userstate.meters2b = math.floor(countroads())
					taskutil.userstate.initial = taskutil.userstate.initial or taskutil.userstate.meters2b
					taskutil.userstate.initial = math.min(taskutil.userstate.initial, taskutil.userstate.meters2b)
				else
					taskutil.userstate.timer2b = taskutil.userstate.timer2b - 1
				end

				local meters = taskutil.userstate.meters2b - taskutil.userstate.initial

				local private = 0
				for i = 1, #params.cities do
					local c = game.interface.getTownReachability(params.cities[i])
					private = private + c[1]
				end

				local goals = params["choice2_" .. taskutil.userstate.choice2a]

				self:setProgressCount(meters, goals.highwaymeters, 1)
				self:setProgressCount(private, goals.private, 2)

				done1 = meters >= goals.highwaymeters
				done2 = private >= goals.private

				self:setSubtaskCompleted(1, done1)
				self:setSubtaskCompleted(2, done2)
			else
				local public = 0
				for i = 1, #params.cities do
					local c = game.interface.getTownReachability(params.cities[i])
					public = public + c[2]
				end

				local bustransported = util.getItemsUnloaded("ROAD", "PASSENGERS")
				local tramtransported = util.getItemsUnloaded("TRAM", "PASSENGERS")
				local shiptransported = util.getItemsUnloaded("WATER", "PASSENGERS")
				local tot = bustransported + tramtransported + shiptransported

				local goals = params["choice2_" .. taskutil.userstate.choice2a]

				self:setProgressCount(public, goals.public, 1)
				self:setProgressCount(tot, goals.persons, 2)

				done1 = public >= goals.public
				done2 = tot >= goals.persons

				self:setSubtaskCompleted(1, done1)
				self:setSubtaskCompleted(2, done2)
			end

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			local sub1
			local sub2
			if taskutil.userstate.choice2a == 1 then
				sub1 = _("MISSION_FUTURECITY_TASK_2_IMPLEMENT_SUB1")
				sub2 = _("MISSION_FUTURECITY_TASK_2_IMPLEMENT_SUB2")
			else
				sub1 = _("MISSION_FUTURECITY_TASK_2_IMPLEMENT_SUB3")
				sub2 = _("MISSION_FUTURECITY_TASK_2_IMPLEMENT_SUB4")
			end
			return {
				name = _("MISSION_FUTURECITY_TASK_2_IMPLEMENT_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_2_IMPLEMENT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_TASK_2_IMPLEMENT_TASK") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_FUTURECITY_TASK_2_IMPLEMENT_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = sub1 },
					{ name = sub2 },
				},
				parentId = "2",
			}
		end,
	})
end
