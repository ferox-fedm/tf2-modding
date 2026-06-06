local taskutil = require "mission.taskutil"
local params = require "params"

return function()
	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_1")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_GOLF_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_GOLF_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.jump_golfcourse,
				voiceOver = "MISSION_STARFLIGHT_MEDAL_GOLF_TEXT.wav",
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
			game.interface.upgradeConstruction(params.golfcourse, "industry/golfcourse.con", { productionLevel = 0, people_active = true, cargo_active = true })
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.golfcourse).simBuildings[1]).itemsConsumed
			local x0 = c.SAND or 0
			if x0 > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_GOLF_COURSE_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_GOLF_COURSE_TEXT") },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_MEDAL_GOLF_COURSE_TASK") },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_MEDAL_GOLF_COURSE_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_golfcourse,
				voiceOver = "MISSION_STARFLIGHT_MEDAL_GOLF_COURSE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
			taskutil.userstate.golfcoursestarttrees = 0
			local trees = game.interface.getEntities({ pos = params.golfcourse_locator.pos, radius = params.golfcourse_locator.radius }, { type = "ASSET_GROUP" })
			local count = 0
			for i = 1, #trees do
				local e = game.interface.getEntity(trees[i])
				local mdls = e.models
				for k,v in pairs(mdls) do
					if k:sub(1, 4) == "tree" then
						taskutil.userstate.golfcoursestarttrees = taskutil.userstate.golfcoursestarttrees + v
					end
				end
			end
		end,
		onUpdate = function(self)
			local trees = game.interface.getEntities({ pos = params.golfcourse_locator.pos, radius = params.golfcourse_locator.radius }, { type = "ASSET_GROUP" })
			local count = 0
			for i = 1, #trees do
				local e = game.interface.getEntity(trees[i])
				local mdls = e.models
				for k,v in pairs(mdls) do
					if k:sub(1, 4) == "tree" then
						count = count + v
					end
				end
			end
			local n = params.num_trees_at_golfcourse
			taskutil.userstate.golfcoursestarttrees = math.min(count, taskutil.userstate.golfcoursestarttrees)
			self:setProgressCount(count - taskutil.userstate.golfcoursestarttrees, n)
			if count - taskutil.userstate.golfcoursestarttrees >= n then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m1c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_GOLF_DECORATE_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_GOLF_DECORATE_TEXT") },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_MEDAL_GOLF_DECORATE_TASK") },
				},
				subTasks = {
					{ name = _("MISSION_STARFLIGHT_MEDAL_GOLF_DECORATE_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_golfcourse,
				voiceOver = "MISSION_STARFLIGHT_MEDAL_GOLF_DECORATE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1c", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local cons = game.interface.getEntities({ pos = params.pos_golfcourse, radius = params.airfield_distance_to_golfcourse }, { type = "CONSTRUCTION" })
			for i = 1, #cons do
				local c = game.interface.getEntity(cons[i])
				if c.fileName == "station/air/airfield.con" then
					self:finish()
					return
				end
			end
		end,
		onFinish = function(self)
			taskutil.tasks["m1d"]:start()
			taskutil:setMedalCompleted("MEDAL_1")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_STARFLIGHT_MEDAL_GOLF_AIRFIELD_NAME"),
				paragraphs = {
					{ text = _("MISSION_STARFLIGHT_MEDAL_GOLF_AIRFIELD_TEXT") },
					{ type = "TASK", text = _("MISSION_STARFLIGHT_MEDAL_GOLF_AIRFIELD_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.jump_golfcourse,
				voiceOver = "MISSION_STARFLIGHT_MEDAL_GOLF_AIRFIELD_TEXT.wav",
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
				name = _("MISSION_STARFLIGHT_MEDAL_GOLF_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_STARFLIGHT_MEDAL_GOLF_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_STARFLIGHT_MEDAL_GOLF_FINISH_TEXT.wav",
			}
		end,
	})
end
