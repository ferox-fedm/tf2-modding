local taskutil = require "mission.taskutil"
local params = require "params"
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
				name = _("MISSION_TWENTIES_TASK_COMPETITION_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_COMPETITION_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_minneapolis,
				voiceOver = "MISSION_TWENTIES_TASK_COMPETITION_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	local function getplayertransported()
		local transported = 0
		local lines = game.interface.getLines()
		for i = 1, #lines do
			if lines[i] ~= params.tramailine then
				local line = game.interface.getEntity(lines[i])
				transported = transported + (line.itemsTransported.PASSENGERS or 0)
			end
		end
		if taskutil.userstate.playertransported == nil then
			taskutil.userstate.playertransported = transported
			return 0
		else
			return transported - taskutil.userstate.playertransported
		end
	end

	local function getaitransported()
		local dt = game.interface.getGameTime().time - taskutil.userstate.aistarttime
		return math.floor(0.30 * dt) + 600
	end

	local function tramlosspercentage(transported, opponent)
		if opponent == 0 then return 0 end
		return transported / (opponent * 0.6)
	end

	taskutil:new("5a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showmedal3", 120)
			taskutil.userstate.aistarttime = game.interface.getGameTime().time
		end,
		onUpdate = function(self)
			local opponent = getaitransported()
			local player = getplayertransported()
			local p = tramlosspercentage(player, opponent)
			self:setProgressPercent(p)
			if p >= 1 then self:finish() end
		end,
		onFinish = function(self)
			if taskutil.tasks["1c"].finish ~= nil then
				taskutil.tasks["1c"]:finish()
			end
			taskutil.tasks["end"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_TASK_COMPETITION_TRAM_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_COMPETITION_TRAM_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TWENTIES_TASK_COMPETITION_TRAM_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_minneapolis,
				voiceOver = "MISSION_TWENTIES_TASK_COMPETITION_TRAM_TEXT.wav",
			}
		end,
		handlers = {
			showmedal3 = function(self) taskutil:start("m3") end,
		},
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
				name = _("MISSION_TWENTIES_TASK_FINISH_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_FINISH_TEXT") % params },
				},
				parentId = "5",
				camera = params.jump_minneapolis,
				voiceOver = "MISSION_TWENTIES_TASK_FINISH_TEXT.wav",
			}
		end,
	})
end
