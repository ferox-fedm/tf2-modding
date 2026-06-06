local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"

return function()
	taskutil:new("4", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track4")
		end,
		onFinish = function(self)
			taskutil.tasks["4a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_SHOW_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_SHOW_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_scoutlocator,
				voiceOver = "MISSION_VICECOUNTY_TASK_SHOW_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	local allsubtasks = { "4b", "4c", "4d", "4e", "4f" }
	taskutil:new("4a", {
		onStart = function(self)
			--for i = 1, #allsubtasks do
			--	taskutil.tasks[allsubtasks[i]]:start()
			--end
			taskutil:setMarker("start4b", { entity = params.harbor_everglades, type = "question" }, self.name, "start4b")
			taskutil:setMarker("start4c", { entity = params.keywest, type = "question" }, self.name, "start4c")
			taskutil:setMarker("start4d", { entity = params.miami, type = "question" }, self.name, "start4d")
			taskutil:setMarker("start4e", { entity = params.miami_airport, type = "question" }, self.name, "start4e")
			taskutil:setMarker("start4f", { entity = params.catering, type = "question" }, self.name, "start4f")
		end,
		onUpdate = function(self)
			local done = 0
			for i = 1, #allsubtasks do
				if taskutil.tasks[allsubtasks[i]].start == nil and taskutil.tasks[allsubtasks[i]].finish == nil then
					done = done + 1
				end
			end
			self:setProgressCount(done, 5)
			if done >= 5 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("5")
			
			taskutil:setMarker("start4b")
			taskutil:setMarker("start4c")
			taskutil:setMarker("start4d")
			taskutil:setMarker("start4e")
			taskutil:setMarker("start4f")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_SHOW_SCOUT_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_SHOW_SCOUT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_SHOW_SCOUT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_scoutlocator,
				voiceOver = "MISSION_VICECOUNTY_TASK_SHOW_SCOUT_TEXT.wav",
			}
		end,
		handlers = {
			start4b = function(self) taskutil:setMarker("start4b") taskutil:start("4b") end,
			start4c = function(self) taskutil:setMarker("start4c") taskutil:start("4c") end,
			start4d = function(self) taskutil:setMarker("start4d") taskutil:start("4d") end,
			start4e = function(self) taskutil:setMarker("start4e") taskutil:start("4e") end,
			start4f = function(self) taskutil:setMarker("start4f") taskutil:start("4f") end,
		},
	})

	taskutil:new("4b", {
		onStart = function(self)
			taskutil:setZone("4b", { polygon = zoneutil.makeCircleZone(params.race_area.pos, params.race_area.radius), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local count = 0
			local entities = game.interface.getEntities(params.race_area, { type = "VEHICLE" } )
			for i = 1, #entities do
				local e = game.interface.getEntity(entities[i])
				if e.vehicles[1].fileName == "vehicle/ship/srn6_v2.mdl" then
					count = count + 1
				end
			end
			if count >= 2 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("4b")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_SHOW_HOVER_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_SHOW_HOVER_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_SHOW_HOVER_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_race_area,
				voiceOver = "MISSION_VICECOUNTY_TASK_SHOW_HOVER_TEXT.wav",
			}
		end,
	})

	taskutil:new("4c", {
		onStart = function(self)
			taskutil:enableProposalCheck()
			taskutil:setProposal("bulldoze", self.name, "bulldoze")
			taskutil.userstate.timestamps = {}
			taskutil.userstate.time4c = 0
			self:setProgressCount(0, params.destroy_amount)
		end,
		onUpdate = function(self)
			taskutil.userstate.time4c = taskutil.userstate.time4c + 0.2

			local n = #taskutil.userstate.timestamps + 1
			local counter = 0
			for i = 0, params.destroy_amount do
				if taskutil.userstate.time4c - (taskutil.userstate.timestamps[n - i] or -100) < params.destroy_seconds then counter = counter + 1 end
			end
			self:setProgressCount(counter, params.destroy_amount)
		end,
		onFinish = function(self)
			taskutil:setProposal("bulldoze")
			taskutil:disableProposalCheck()
			taskutil.userstate.timestamps = nil
			taskutil.userstate.time4c = nil
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_SHOW_BRIDGE_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_SHOW_BRIDGE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_SHOW_BRIDGE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_bridgelocator,
				voiceOver = "MISSION_VICECOUNTY_TASK_SHOW_BRIDGE_TEXT.wav",
			}
		end,
		handlers = {
			bulldoze = function(self, id, name, param, isApply)
				local n = #taskutil.userstate.timestamps + 1
				taskutil.userstate.timestamps[n] = taskutil.userstate.time4c

				if taskutil.userstate.timestamps[n] - (taskutil.userstate.timestamps[n - params.destroy_amount + 1] or -100) < params.destroy_seconds then
					taskutil:finish(self.name)
				end
			end,
		},
		guiHandlers = {
			bulldoze = function(self, id, name, param, isApply)
				if not isApply then return true end

				local bridge = false
				local segments = param.proposal.proposal.removedSegments;
				for i = 1, #segments do
					local s = segments[i]
					if s.comp.type == 1 then
						bridge = true
						break
					end
				end

				if bridge then
					taskutil:sendScriptFn(self.name, "bulldoze")
				end
				return true
			end,
		},
	})

	taskutil:new("4d", {
		onStart = function(self)
			taskutil:setZone("4d", { polygon = zoneutil.makeCircleZone(params.blockade_area.pos, params.blockade_area.radius), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local playerentities = game.interface.getEntities(params.blockade_area, { type = "VEHICLE" } )
			local simentities = game.interface.getEntities(params.blockade_area, { type = "SIM_PERSON" } )
			if #playerentities + #simentities == 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("4d")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_SHOW_BLOCKADE_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_SHOW_BLOCKADE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_SHOW_BLOCKADE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_blockade_area,
				voiceOver = "MISSION_VICECOUNTY_TASK_SHOW_BLOCKADE_TEXT.wav",
			}
		end,
	})

	taskutil:new("4e", {
		onStart = function(self)
			local polygon = zoneutil.makeCircleZone(params.airplane_area.pos, params.airplane_area.radius)
			taskutil:setZone("4e", { polygon = polygon, draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil:setZone("4e")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_SHOW_STUNT_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_SHOW_STUNT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_SHOW_STUNT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_airplane_area,
				voiceOver = "MISSION_VICECOUNTY_TASK_SHOW_STUNT_TEXT.wav",
			}
		end,
		guiHandlers = {
			guiHandleEvent = function(self, id, name, param)
				if id == "mainView" and name == "select" then
					local e =  game.interface.getEntity(param)
					if e == nil then
						return
					end

					if e.carrier == "AIR" and e.type == "VEHICLE" then
						local polygon = zoneutil.makeCircleZone(params.airplane_area.pos, params.airplane_area.radius)
						if polygonutil.contains(polygon, e.position) then
							taskutil:finish(self.name)
						end
					end
				end
			end
		},
	})

	taskutil:new("4f", {
		onStart = function(self)
			arrivaltracker.track("4f", { cargotype = "FOOD", to = params.catering })
		end,
		onUpdate = function(self)
			local c1 = arrivaltracker.get("4f")

			local n1 = params.food_amount

			self:setProgressCount(c1, n1)

			if c1 >= n1 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("4f")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_VICECOUNTY_TASK_SHOW_CATERING_NAME"),
				paragraphs = {
					{ text = _("MISSION_VICECOUNTY_TASK_SHOW_CATERING_TEXT") % params },
					{ type = "TASK", text = _("MISSION_VICECOUNTY_TASK_SHOW_CATERING_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "4",
				camera = params.jump_catering,
				voiceOver = "MISSION_VICECOUNTY_TASK_SHOW_CATERING_TEXT.wav",
			}
		end,
	})
end
