local taskutil = require "mission.taskutil"
local params = require "params"

return function()
	taskutil:new("m4", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_4")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_CULTURE_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m4a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m4a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_DESICION_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_DESICION_TEXT") },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_DESICION_TASK") },
				},
				options = {
					{ _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_DESICION_OPTION1") % params, "finish1" },
					{ _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_DESICION_OPTION2") % params, "finish2" }
				},
				parentId = "m4",
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_CULTURE_DESICION_TEXT.wav",
			}
		end,
		handlers = {
			finish1 = function(self)
				taskutil:finish(self.name)
				taskutil:start("m4b")
			end,
			finish2 = function(self)
				taskutil:finish(self.name)
				taskutil:start("m4c")
			end,
		},
	})

	local function getTime()
		return game.interface.getGameTime().time
	end
	taskutil:new("m4b", {
		onStart = function(self)
			taskutil.userstate.culture_to_pay = params.culture_pay_months
			taskutil.userstate.culture_time = getTime()
		end,
		onUpdate = function(self)
			local time = getTime()
			if time - taskutil.userstate.culture_time >= 60 then
				taskutil.userstate.culture_time = time
				game.interface.book(-params.culture_pay_amount)
				taskutil.userstate.culture_to_pay = taskutil.userstate.culture_to_pay - 1
				if taskutil.userstate.culture_to_pay == 0 then
					taskutil.userstate.culture_to_pay = nil
					taskutil.userstate.culture_time = nil
					self:finish()
					return
				end
			end
			self:setProgressCount(params.culture_pay_months - taskutil.userstate.culture_to_pay, params.culture_pay_months, 1)
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_4")
			taskutil.tasks["m4d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_RESTAURANT_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_RESTAURANT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_RESTAURANT_TASK") % params },
					{ type = "HINT", text = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_RESTAURANT_HINT") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_RESTAURANT_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m4",
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_CULTURE_RESTAURANT_TEXT.wav",
			}
		end,
	})

	local getEmission = function()
		local emission = 0
		local n = 0
		for _, city in pairs({ params.palma, params.inca, params.sarenal }) do
			emission = emission + (10 * math.log(game.interface.getTownEmission(city) / math.pow(10,-12), 10))
			n = n + 1
		end
		emission = math.floor(emission / n)
		return emission
	end

	taskutil:new("m4c", {
		onStart = function(self)
			local emission = getEmission()
			if emission <= params.culture_emission then
				self:setProgressText("")
				taskutil.userstate.emissionm4calreadycompleted = true
				taskutil:invokeLater(self.name, "finish", 15)
			end
		end,
		onUpdate = function(self)
			if taskutil.userstate.emissionm4calreadycompleted then
				return
			end
			local emission = getEmission()
			self:setProgressCount(emission, params.culture_emission)
			if emission <= params.culture_emission then self:finish() end
		end,
		onFinish = function(self)
			taskutil.userstate.emissionm4calreadycompleted = nil
			taskutil:setMedalCompleted("MEDAL_4")
			taskutil.tasks["m4d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_EMISSION_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_EMISSION_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_EMISSION_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m4",
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_CULTURE_EMISSION_TEXT.wav",
			}
		end,
	})

	taskutil:new("m4d", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_ALLINCLUSIVE_MEDAL_CULTURE_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m4",
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_CULTURE_FINISH_TEXT.wav",
			}
		end,
	})
end
