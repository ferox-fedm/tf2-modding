local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local util = require "util"

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
				name = _("MISSION_ICE_TASK_BRANCH_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_BRANCH_TEXT") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_BRANCH_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
			util.foralltrainstations(params.cmunicipal, function (con)
				game.interface.setBulldozeable(con.id, true)
			end)
			taskutil:invokeLater(self.name, "showm2", 120)
		end,
		onUpdate = function(self)
			local allowedzone = taskutil.userstate.choice4a == 1 and params.zone_a or params.zone_b
			local count = 0
			for i = 1, #params.cmunicipal do
				local townid = params.cmunicipal[i]
				local town = game.interface.getEntity(townid)
				if polygonutil.contains(allowedzone, town.position) then
					count = count + #game.interface.getStations({ town = townid, carrier = "RAIL" })
				end
			end

			self:setProgressText(tostring(count))
			if count == 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["5b"]:start()
		end,
		getInfo = function(self)
			local text
			if taskutil.userstate.choice4a == 1 then text = _("MISSION_ICE_TASK_BRANCH_REGIONAL_TASK1") end
			if taskutil.userstate.choice4a == 2 then text = _("MISSION_ICE_TASK_BRANCH_REGIONAL_TASK2") end
			local camera
			if taskutil.userstate.choice4a == 1 then camera = params.jump_bw end
			if taskutil.userstate.choice4a == 2 then camera = params.jump_bayern end
			return {
				name = _("MISSION_ICE_TASK_BRANCH_REGIONAL_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_BRANCH_REGIONAL_TEXT") % params },
					{ type = "TASK", text = text },
				},
				camera = camera,
				voiceOver = "MISSION_ICE_TASK_BRANCH_REGIONAL_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				optionsRightAlign = true,
				parentId = "5",
			}
		end,
		handlers = {
			showm2 = function(self)
				if taskutil.tasks["m2"].start ~= nil then
					taskutil.tasks["m2"]:start()
				end
			end,
		},
	})

	taskutil:new("5b", {
		onStart = function(self)
			local time = game.interface.getGameTime().time
			taskutil.userstate.time5b = time
		end,
		onUpdate = function(self)
			local time = game.interface.getGameTime().time
			local income = game.interface.getPlayerJournal(taskutil.userstate.time5b * 1000, time * 1000).income
			local rail = income.rail
			local road = income.road

			self:setProgressText(string.makeMoneyString(rail) .. "/" .. string.makeMoneyString(params.railmoney), 1)
			self:setProgressText(string.makeMoneyString(road) .. "/" .. string.makeMoneyString(params.roadmoney), 2)

			local done1 = rail >= params.railmoney
			local done2 = road >= params.roadmoney

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)

			if done1 and done2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("zone_a")
			taskutil:setZone("zone_b")
			taskutil:setZone("zone_c")
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ICE_TASK_BRANCH_SECTIONS_NAME"),
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_BRANCH_SECTIONS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ICE_TASK_BRANCH_SECTIONS_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ICE_TASK_BRANCH_SECTIONS_SUB1") % params },
					{ name = _("MISSION_ICE_TASK_BRANCH_SECTIONS_SUB2") % params },
				},
				camera = params.jump_default,
				voiceOver = "MISSION_ICE_TASK_BRANCH_SECTIONS_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				optionsRightAlign = true,
				parentId = "5",
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
				name = _("MISSION_ICE_TASK_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_ICE_TASK_FINISH_TEXT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				voiceOver = "MISSION_ICE_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
