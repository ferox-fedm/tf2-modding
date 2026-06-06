local taskutil = require "mission.taskutil"
local params = require "params"
local arrivaltracker = require "mission.arrivaltracker"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local vec2 = require "vec2"

return function()
	taskutil:new("3", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track3")
		end,
		onFinish = function(self)
			taskutil.tasks["3a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_CHANNEL_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_CHANNEL_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_canalsite,
				voiceOver = "MISSION_LEADER_TASK_CHANNEL_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("3a", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm2", 120)
			arrivaltracker.track("3a1", { cargotype = "STEEL", to = params.canalsite })
			arrivaltracker.track("3a3", { cargotype = "PASSENGERS", to = params.canalsite })
		end,
		onUpdate = function(self)
			local c1 = arrivaltracker.get("3a1")
			local c3 = arrivaltracker.get("3a3")

			local c2 = 0
			local stations = game.interface.getEntities({ pos = params.pos_canalsite, radius = 500 }, { type = "STATION" })
			for i = 1, #stations do
				c2 = c2 + (game.interface.getEntity(game.interface.getEntity(stations[i]).stationGroup).itemsLoaded.STONE or 0)
			end
			self:setProgressCount(c1, params.steel_amount, 1)
			self:setProgressCount(c2, params.stone_amount, 2)
			self:setProgressCount(c3, params.people_canal_amount, 3)

			local done1 = c1 >= params.steel_amount
			local done2 = c2 >= params.stone_amount
			local done3 = c3 >= params.people_canal_amount

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)
			self:setSubtaskCompleted(3, done3)

			if done1 and done2 and done3 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("3a1")
			arrivaltracker.track("3a3")
			taskutil.tasks["3b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_CHANNEL_SITE_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_CHANNEL_SITE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_CHANNEL_SITE_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_LEADER_TASK_CHANNEL_SITE_SUB1") % params },
					{ name = _("MISSION_LEADER_TASK_CHANNEL_SITE_SUB2") % params },
					{ name = _("MISSION_LEADER_TASK_CHANNEL_SITE_SUB3") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_canalsite,
				voiceOver = "MISSION_LEADER_TASK_CHANNEL_SITE_TEXT.wav",
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

	local function sample(corners, n, m)
		local result = {}
		for j = 0, m do
			local a = j / m
			local x0 = vec2.lerp(corners[1], corners[4], a)
			local x1 = vec2.lerp(corners[2], corners[3], a)
			for i = 0, n do
				local x = vec2.lerp(x0, x1, i / n)
				result[#result + 1] = { x.x, x.y }
			end
		end
		return result
	end

	local function getcorners()
		local x0 = vec2.new(table.unpack(params.canal_coord_west))
		local x1 =  vec2.new(table.unpack(params.canal_coord_east))
		local normal = vec2.mul(60, vec2.normalize(vec2.rotate90(vec2.sub(x1, x0))))
		local polygon = {
			vec2.add(x1, normal),
			vec2.add(x0, normal),
			vec2.sub(x0, normal),
			vec2.sub(x1, normal),
		}
		return polygon
	end
	local function unvectorize(v) return { v.x, v.y } end

	taskutil:new("3b", {
		onStart = function(self)
			local corners = getcorners()
			for i = 1, #corners do
				corners[i] = unvectorize(corners[i])
			end
			taskutil:setZone("3b", { polygon = corners, draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local grid = sample(getcorners(), 30, 3)
			local underwatercount = 0
			for i = 1, #grid do
				underwatercount = underwatercount + (game.interface.getHeight(grid[i]) < 0 and 1 or 0)
			end
			taskutil.userstate.initiallyunderwater = taskutil.userstate.initiallyunderwater or underwatercount
			taskutil.userstate.initiallyunderwater = math.min(taskutil.userstate.initiallyunderwater, underwatercount)
			local a = underwatercount - taskutil.userstate.initiallyunderwater
			local b = #grid - taskutil.userstate.initiallyunderwater
			self:setProgressPercent(a / b)
			if a == b then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("3b")
			taskutil:startLater("4")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_LEADER_TASK_CHANNEL_DIG_NAME"),
				paragraphs = {
					{ text = _("MISSION_LEADER_TASK_CHANNEL_DIG_TEXT") % params },
					{ type = "TASK", text = _("MISSION_LEADER_TASK_CHANNEL_DIG_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "3",
				camera = params.jump_canal_mid,
				voiceOver = "MISSION_LEADER_TASK_CHANNEL_DIG_TEXT.wav",
			}
		end,
	})
end
