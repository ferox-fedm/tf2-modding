local taskutil = require "mission.taskutil"
local params = require "params"
local vec2 = require "vec2"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_1")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_BEACH_TEXT.wav",
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
		end,
		onUpdate = function(self)
			local v1 = vec2.new(table.unpack(params.inca_beach1))
			local v2 = vec2.new(table.unpack(params.inca_beach2))
			local n = 20
			for i = 0, n do
				local t = i / n
				local v = vec2.lerp(v1, v2, t)
				if game.interface.getHeight({ v.x, v.y }) > 0.2 then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_INCREASE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_INCREASE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_INCREASE_TASK") % params },
					{ type = "HINT", text = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_INCREASE_HINT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_beach,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_BEACH_INCREASE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
			arrivaltracker.track("m1b", { cargotype = "PASSENGERS", from = params.palma, to = params.finca })
		end,
		onUpdate = function(self)
			local tot = arrivaltracker.get("m1b")
			local n = params.finca_party_people
			self:setProgressCount(tot, n, 1)
			if tot >= n then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("m1b")
			taskutil.tasks["m1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_PARTY_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_PARTY_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_PARTY_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_PARTY_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_finca,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_BEACH_PARTY_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1c", {
		onStart = function(self)
			arrivaltracker.track("m1c", { cargotype = "ALCOHOL", to = params.finca })
		end,
		onUpdate = function(self)
			local tot = arrivaltracker.get("m1c")
			local n = params.finca_party_alcohol
			self:setProgressCount(tot, n, 1)
			if tot >= n then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("m1c")
			taskutil:setMedalCompleted("MEDAL_1")
			taskutil.tasks["m1d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_FINCA_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_FINCA_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_FINCA_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_FINCA_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_finca,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_BEACH_FINCA_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1d", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_ALLINCLUSIVE_MEDAL_BEACH_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_BEACH_FINISH_TEXT.wav",
			}
		end,
	})
end
