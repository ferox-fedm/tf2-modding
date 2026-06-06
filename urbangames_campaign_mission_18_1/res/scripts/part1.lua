local taskutil = require "mission.taskutil"
local params = require "params"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local arrivaltracker = require "mission.arrivaltracker"
local util = require "util"

local mainguihandlers = { }

	local mainguihandlers = {
		voiceOverEnded = function(self) taskutil:finish(self.name) end,
	}

setmetatable(mainguihandlers, { __index = function(self, key)
	local n = #"jump_"
	if key:sub(1, n) == "jump_" then
		game.gui.setAutoCamera(params[key])
	end
end})

return function()
	taskutil:new("1", {
		onStart = function(self)
			self:setProgressNone()
			--taskutil.tasks["m1"]:start()
			--taskutil.tasks["m2"]:start()
			--taskutil.tasks["m3"]:start()
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_TASK_1_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_1_TEXT") % params }
				},
				camera = params.jump_shanghai,
				voiceOver = "MISSION_FUTURECITY_TASK_1_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = mainguihandlers,
	})

	taskutil:new("1a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks["1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_FUTURECITY_TASK_1_DECIDE_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_1_DECIDE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_TASK_1_DECIDE_TASK") % params },
				},
				camera = params.jump_shanghai,
				voiceOver = "MISSION_FUTURECITY_TASK_1_DECIDE_TEXT.wav",
				options = { { _("MISSION_FUTURECITY_TASK_1_DECIDE_OPTION1"), "option1" },
				            { _("MISSION_FUTURECITY_TASK_1_DECIDE_OPTION2"), "option2" } },
				parentId = "1",
			}
		end,
		handlers = {
			option1 = function(self)
				taskutil.userstate.choice1a = 1
				taskutil:finish(self.name)
			end,
			option2 = function(self)
				taskutil.userstate.choice1a = 2
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

	taskutil:new("1b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local done1
			local done2
			local done3
			if taskutil.userstate.choice1a == 1 then
				local airports = util.getConstructionsWithCarrier("AIR")
				local airplanes = game.interface.getVehicles({ carrier = "AIR" })
				local airtransported = util.getItemsUnloaded("AIR", "PASSENGERS")

				local airplaneswithlines = {}
				for i = 1, #airplanes do
					local id = airplanes[i]
					local e = game.interface.getEntity(id)
					if e.line >= 0 then airplaneswithlines[#airplaneswithlines + 1] = id end
				end

				local goals = params["choice1_" .. taskutil.userstate.choice1a]

				self:setProgressCount(#airports, goals.numairports, 1)
				self:setProgressCount(#airplaneswithlines, goals.numplanes, 2)
				self:setProgressCount(airtransported, goals.numpassengersair, 3)

				done1 = #airports >= goals.numairports
				done2 = #airplaneswithlines >= goals.numplanes
				done3 = airtransported >= goals.numpassengersair

				self:setSubtaskCompleted(1, done1)
				self:setSubtaskCompleted(2, done2)
				self:setSubtaskCompleted(3, done3)
			else
				local trainstations = util.getConstructionsWithCarrier("RAIL")
				local trains = game.interface.getVehicles({ carrier = "RAIL" })
				local traintransported = util.getItemsUnloaded("RAIL", "PASSENGERS")

				local trainswithlines = {}
				for i = 1, #trains do
					local id = trains[i]
					local e = game.interface.getEntity(id)
					if e.line >= 0 then trainswithlines[#trainswithlines + 1] = id end
				end

				local goals = params["choice1_" .. taskutil.userstate.choice1a]

				self:setProgressCount(#trainstations, goals.numtrainstations, 1)
				self:setProgressCount(#trainswithlines, goals.numtrains, 2)
				self:setProgressCount(traintransported, goals.numpassengersrail, 3)

				done1 = #trainstations >= goals.numtrainstations
				done2 = #trainswithlines >= goals.numtrains
				done3 = traintransported >= goals.numpassengersrail

				self:setSubtaskCompleted(1, done1)
				self:setSubtaskCompleted(2, done2)
				self:setSubtaskCompleted(3, done3)
			end

			if done1 and done2 and done3 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			local sub1
			local sub2
			local sub3
			if taskutil.userstate.choice1a == 1 then
				sub1 = _("MISSION_FUTURECITY_TASK_1_IMPLEMENT_SUB1") % params
				sub2 = _("MISSION_FUTURECITY_TASK_1_IMPLEMENT_SUB2") % params
				sub3 = _("MISSION_FUTURECITY_TASK_1_IMPLEMENT_SUB3") % params
			else
				sub1 = _("MISSION_FUTURECITY_TASK_1_IMPLEMENT_SUB4") % params
				sub2 = _("MISSION_FUTURECITY_TASK_1_IMPLEMENT_SUB5") % params
				sub3 = _("MISSION_FUTURECITY_TASK_1_IMPLEMENT_SUB6") % params
			end
			return {
				name = _("MISSION_FUTURECITY_TASK_1_IMPLEMENT_NAME"),
				paragraphs = {
					{ text = _("MISSION_FUTURECITY_TASK_1_IMPLEMENT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_FUTURECITY_TASK_1_IMPLEMENT_TASK") % params },
				},
				camera = params.jump_shanghai,
				voiceOver = "MISSION_FUTURECITY_TASK_1_IMPLEMENT_TEXT.wav",
				subTasks = {
					{ name = sub1 },
					{ name = sub2 },
					{ name = sub3 },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
			}
		end,
	})
end
