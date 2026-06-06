local params = require "params"
local vec2 = require "vec2"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_CIRCLE")
			self:setProgressNone()
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_MEDAL_STONECIRCLE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_MEDAL_STONECIRCLE_TEXT") % params },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_stone1,
				voiceOver = "MISSION_HIGHLANDS_MEDAL_STONECIRCLE_TEXT.wav",
			}
		end,
		guiHandlers = {
			accept = function(self) taskutil:start("m2a") taskutil:finish(self.name) end,
			decline = function(self)
				taskutil:finish(self.name)
				gui.window_get("missionDisplayWindow"):close()
			end,
		},
	})

	taskutil:new("m2a", {
		onStart = function(self)
			game.interface.setPlayer(params.horse_line, game.interface.getPlayer())

			taskutil.userstate.stoneorder = { 1, 2, 3, 4, 5 }
			taskutil.userstate.stonecursor = 1
		end,
		onUpdate = function(self)
			local order = taskutil.userstate.stoneorder
			local cur = taskutil.userstate.stonecursor

			local horse = game.interface.getEntity(params.horse)
			local p1 = vec2.new(table.unpack(horse.position))
			for i = 1, 5 do
				local stoneid = params["stone" .. i]
				local stone = game.interface.getEntity(stoneid)
				local p2 = vec2.new(table.unpack(stone.position))
				if vec2.distance(p1, p2) < 6 and order[cur] ~= i then
					cur = (cur % 5) + 1
					order[cur] = i
				end
			end
			local doubleorder = ""
			for i = 1, 2 do
				for j = 1, 5 do
					doubleorder = doubleorder .. order[j]
				end
			end
			if doubleorder:find("13524") or doubleorder:find("14253") then
				taskutil:setMedalCompleted("MEDAL_CIRCLE")
				self:finish()
			end
			taskutil.userstate.stonecursor = cur
		end,
		onFinish = function(self)
			local vehicle = api.engine.getComponent(params.horse,api.type.ComponentType.TRANSPORT_VEHICLE)
			game.interface.setPlayer(vehicle.line, taskutil.userstate.aiplayer)
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_MEDAL_STONECIRCLE_SOLVE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_HIGHLANDS_MEDAL_STONECIRCLE_SOLVE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_HIGHLANDS_MEDAL_STONECIRCLE_SOLVE_TASK") % params },
					{ type = "HINT", text = _("MISSION_HIGHLANDS_MEDAL_STONECIRCLE_SOLVE_HINT") % params },
				},
				options = { { "Debug: Skip", "success" } },
				parentId = "m2",
				camera = params.jump_stone1,
				voiceOver = "MISSION_HIGHLANDS_MEDAL_STONECIRCLE_SOLVE_TEXT.wav",
			}
		end,
		handlers = {
			success = function(self) taskutil:setMedalCompleted("MEDAL_CIRCLE") taskutil:finish(self.name) end,
		},
		guiHandlers = {
			success = function(self) taskutil:sendScriptFn(self.name, "success") end,
			failure = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("m2b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_HIGHLANDS_MEDAL_STONECIRCLE_FINISH_NAME") % params,
				paragraphs = { { text = _("MISSION_HIGHLANDS_MEDAL_STONECIRCLE_FINISH_TEXT") % params } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_HIGHLANDS_MEDAL_STONECIRCLE_FINISH_TEXT.wav",
			}
		end,
	})
end
