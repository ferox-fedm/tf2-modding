local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"
local zoneutil = require "mission.zone"
local colors = require "mission.colors"

return function()
	taskutil:new("2", {
		onStart = function(self)
			taskutil:setMusicTrack("track2")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_TOURISTS_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			local p1 = table.pack(table.unpack(params.palma_beach.pos))
			local p2 = table.pack(table.unpack(params.inca_hills.pos))
			local p3 = table.pack(table.unpack(params.sarenal_forest.pos))

			p1[3] = game.interface.getHeight(p1)
			p2[3] = game.interface.getHeight(p2)
			p3[3] = game.interface.getHeight(p3)

			taskutil:setMarker("palma_beach",    { pos = p1, type = "question" }, self.name, "palma_beach")
			taskutil:setMarker("inca_hills",     { pos = p2, type = "question" }, self.name, "inca_hills")
			taskutil:setMarker("sarenal_forest", { pos = p3, type = "question" }, self.name, "sarenal_forest")
		end,
		onUpdate = function(self)
			if taskutil:finished("2aa") and taskutil:finished("2ab") and taskutil:finished("2ac") then
				self:finish()
			end

			local done = 0
			if taskutil:finished("2aa") then done = done + 1 end
			if taskutil:finished("2ab") then done = done + 1 end
			if taskutil:finished("2ac") then done = done + 1 end
			self:setProgressCount(done, 3)
		end,
		onFinish = function(self)
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_GUEST_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_GUEST_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_GUEST_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.default_camera,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_TOURISTS_GUEST_TEXT.wav",
			}
		end,
		handlers = {
			palma_beach = function(self) taskutil:setMarker("palma_beach") taskutil:start("2aa") end,
			inca_hills = function(self) taskutil:setMarker("inca_hills") taskutil:start("2ab") end,
			sarenal_forest = function(self) taskutil:setMarker("sarenal_forest") taskutil:start("2ac") end,
		},
	})

	taskutil:new("2aa", {
		onStart = function(self)
			--taskutil:setZone("2aa", { polygon = zoneutil.makeCircleZone(params.palma_beach.pos, params.palma_beach.radius), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local function rocks()
				local assets = game.interface.getEntities(params.palma_beach, {type = "ASSET_GROUP"})
				local count = 0
				for i = 1, #assets do
					local e = game.interface.getEntity(assets[i])
					local mdls = e.models
					for k,v in pairs(mdls) do
						if k:match("rock") then
							count = count + v
						end
					end
				end
				return count
			end
			local r = rocks()
			local done1 = r == 0
			self:setProgressText(r .. "", 1)
			if done1 then self:finish() end
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_GERMAN_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_GERMAN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_GERMAN_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_GERMAN_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_palma_beach,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_TOURISTS_GERMAN_TEXT.wav",
			}
		end,
	})

	taskutil:new("2ab", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local function waypoints()
				local found = 0
				local assets = game.interface.getEntities(params.inca_hills, {type = "ASSET_GROUP"})
				for i = 1, #assets do
					local a = game.interface.getEntity(assets[i])
					for k, v in pairs(a.models) do
						if k:match("hiking_sign") then found = found + 1 end
					end
				end
				return found
			end
			local w = waypoints()
			local done2 = w >= 10
			self:setProgressCount(w, 10, 1)
			if done2 then self:finish() end
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_AUSTRIAN_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_AUSTRIAN_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_AUSTRIAN_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_AUSTRIAN_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_inca_hills,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_TOURISTS_AUSTRIAN_TEXT.wav",
			}
		end,
	})

	taskutil:new("2ac", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local function trees()
				local found = 0
				local assets = game.interface.getEntities(params.sarenal_forest, {type = "ASSET_GROUP"})
				for i = 1, #assets do
					local a = game.interface.getEntity(assets[i])
					for k, v in pairs(a.models) do
						if k:match("tree") then found = found + 1 end
					end
				end
				return found
			end
			local n = 70
			local t = trees()
			local done3 = t >= n
			self:setProgressCount(t, n, 1)
			if done3 then self:finish() end
		end,
		onFinish = function(self)
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_SWISS_NAME"),
				paragraphs = {
					{ text = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_SWISS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_SWISS_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_ALLINCLUSIVE_TASK_TOURISTS_SWISS_SUB1") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "2",
				camera = params.jump_sarenal_forest,
				voiceOver = "MISSION_ALLINCLUSIVE_TASK_TOURISTS_SWISS_TEXT.wav",
			}
		end,
	})

end
