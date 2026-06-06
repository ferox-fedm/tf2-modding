local taskutil = require "mission.taskutil"
local params = require "params"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local vec2 = require "vec2"

return function()
	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_2")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_TEXT.wav",
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

	local maxTime = 120
	local function getTime()
		return game.interface.getGameTime().time
	end

	local function checkArea(entities, pos, radius)
		for i = 1, #entities do
			local p = vec2.new(table.unpack(game.interface.getEntity(entities[i]).position))
			local q = vec2.new(table.unpack(pos))
			if vec2.distance(p, q) < radius then
				taskutil.userstate.clockstart = getTime()
			end
		end
	end

	taskutil:new("m2a", {
		onStart = function(self)
			taskutil:setZone("m2a", { polygon = zoneutil.makeCircleZone(params.sea_area.pos, params.sea_area.radius), draw = true, drawColor = colors.RED })
			taskutil.userstate.clockstart = getTime()
		end,
		onUpdate = function(self)
			local entities = game.interface.getVehicles({ carrier = "WATER" })
			checkArea(entities, params.sea_area.pos, params.sea_area.radius)
			local time = getTime() - taskutil.userstate.clockstart
			self:setProgressCount(time, maxTime, 1)
			if time >= maxTime then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("m2a")
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_SEA_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_SEA_TEXT") },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_SEA_TASK") },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_SEA_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_sea_area,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_SEA_TEXT.wav",
			}
		end,
	})


	taskutil:new("m2b", {
		onStart = function(self)
			taskutil:setZone("m2b", { polygon = zoneutil.makeCircleZone(params.bird_area.pos, params.bird_area.radius), draw = true, drawColor = colors.RED })
			taskutil.userstate.clockstart = getTime()
		end,
		onUpdate = function(self)
			local entities = game.interface.getVehicles({ carrier = "AIR" })
			checkArea(entities, params.bird_area.pos, params.bird_area.radius)
			local time = getTime() - taskutil.userstate.clockstart
			self:setProgressCount(time, maxTime, 1)
			if time >= maxTime then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("m2b")
			taskutil.tasks["m2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_BIRDS_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_BIRDS_TEXT") },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_BIRDS_TASK") },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_BIRDS_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_bird_area,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_BIRDS_TEXT.wav",
			}
		end,
	})


	taskutil:new("m2c", {
		onStart = function(self)
			taskutil:setZone("m2c", { polygon = zoneutil.makeCircleZone(params.reptile_area.pos, params.reptile_area.radius), draw = true, drawColor = colors.RED })
			taskutil.userstate.clockstart = getTime()
		end,
		onUpdate = function(self)
			local entities = game.interface.getVehicles({ carrier = "ROAD" })
			checkArea(entities, params.reptile_area.pos, params.reptile_area.radius)
			local time = getTime() - taskutil.userstate.clockstart
			self:setProgressCount(time, maxTime, 1)
			if time >= maxTime then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("m2c")
			taskutil:setMedalCompleted("MEDAL_2")
			taskutil.tasks["m2d"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_REPTILE_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_REPTILE_TEXT") },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_REPTILE_TASK") },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_REPTILE_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = params.jump_reptile_area,
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_REPTILE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m2d", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				voiceOver = "MISSION_ALLINCLUSIVE_MEDAL_WILDLIFE_FINISH_TEXT.wav",
			}
		end,
	})
end
