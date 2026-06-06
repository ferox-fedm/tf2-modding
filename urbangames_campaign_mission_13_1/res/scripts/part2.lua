local taskutil = require "mission.taskutil"
local params = require "params"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local arrivaltracker = require "mission.arrivaltracker"

return function()
	taskutil:new("2", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track2")
		end,
		onFinish = function(self)
			taskutil.tasks["2a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_BUILD_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_BUILD_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_BUILD_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("2a", {
		onStart = function(self)
			local productionLevel = game.interface.getEntity(params.hq).params.productionLevel
			game.interface.upgradeConstruction(params.hq, "industry/hq.con", {
				stocks = { "CONSTRUCTION_MATERIALS", "STEEL" },
				input = { { 1, 0 }, { 0, 1 }, },
				output = { },
				capacity = 100,
				productionLevel = productionLevel,
			})
			arrivaltracker.track("2a_steel", { cargotype = "STEEL", to = params.hq })
			arrivaltracker.track("2a_conmat", { cargotype = "CONSTRUCTION_MATERIALS", to = params.hq })
			taskutil:invokeLater(self.name, "showm1", 120)
		end,
		onUpdate = function(self)
			local x1 = arrivaltracker.get("2a_steel")
			local x2 = arrivaltracker.get("2a_conmat")

			self:setProgressCount(x1, params.deliver_steel, 1)
			self:setProgressCount(x2, params.deliver_constmat, 2)

			if x1 >= params.deliver_steel and x1 >= params.deliver_constmat then self:finish() end
			if x1 >= params.deliver_steel then self:setSubtaskCompleted(1) end
			if x2 >= params.deliver_constmat then self:setSubtaskCompleted(2) end
		end,
		onFinish = function(self)
			arrivaltracker.track("2a_steel")
			arrivaltracker.track("2a_conmat")
			taskutil.tasks["2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_BUILD_MATERIAL_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_BUILD_MATERIAL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_BUILD_MATERIAL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_SHINKANSEN_TASK_BUILD_MATERIAL_SUB1") },
					{ name = _("MISSION_SHINKANSEN_TASK_BUILD_MATERIAL_SUB2") },
				},
				parentId = "2",
				camera = params.jump_hq,
				voiceOver = "MISSION_SHINKANSEN_TASK_BUILD_MATERIAL_TEXT.wav",
			}
		end,
		handlers = {
			showm1 = function(self)
				if taskutil.tasks["m1"].start ~= nil then
					taskutil.tasks["m1"]:start()
				end
			end,
		},
	})

	taskutil:new("2b", {
		onStart = function(self)
			taskutil:setZone("2b_tunnel", { polygon = zoneutil.makeCircleZone(params.tunnel_zone.pos, params.tunnel_zone.radius), draw = true, drawColor = colors.BLUE })
			taskutil:setZone("2b_bridge", { polygon = zoneutil.makeCircleZone(params.bridge_zone.pos, params.bridge_zone.radius), draw = true, drawColor = colors.BLUE })
		end,
		onUpdate = function(self)
			local done1 = false
			local done2 = false
			local done3 = false

			local stations1 = game.interface.getEntities({pos = params.pos_tokio, radius = 500}, {type = "STATION"})
			local stations2 = game.interface.getEntities({pos = params.pos_osaka, radius = 500}, {type = "STATION"})
			for k = 1, #stations1 do
				local s1 = stations1[k]
				for l = 1, #stations2 do
					local s2 = stations2[l]
					if game.interface.findPath(s1, s2, { TRAIN = true }) then
						done1 = true
						break
					end
				end
				if done1 then break end
			end

			local bridgetracks = game.interface.getEntities(params.bridge_zone, { type = "BASE_EDGE" })
			for i = 1, #bridgetracks do
				local t = game.interface.getEntity(bridgetracks[i])
				local pos0 = t.node0pos
				local pos1 = t.node1pos
				local z0 = game.interface.getHeight(pos0)
				local z1 = game.interface.getHeight(pos1)
				if t.track and (pos0[3] - z0 > 5 or pos1[3] - z1 > 5) then
					done2 = true
					break
				end
			end

			local tunneltracks = game.interface.getEntities(params.tunnel_zone, { type = "BASE_EDGE" })
			for i = 1, #tunneltracks do
				local t = game.interface.getEntity(tunneltracks[i])
				local pos0 = t.node0pos
				local pos1 = t.node1pos
				local z0 = game.interface.getHeight(pos0)
				local z1 = game.interface.getHeight(pos1)
				if t.track and (z0 - pos0[3] > 5 or z1 - pos1[3] > 5) then
					done3 = true
					break
				end
			end

			self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(2, done2)
			self:setSubtaskCompleted(3, done3)
			if done1 and done2 and done3 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:setZone("2b_tunnel")
			taskutil:setZone("2b_bridge")
			taskutil:startLater("3")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SHINKANSEN_TASK_BUILD_TRACKS_NAME"),
				paragraphs = {
					{ text = _("MISSION_SHINKANSEN_TASK_BUILD_TRACKS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_SHINKANSEN_TASK_BUILD_TRACKS_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_SHINKANSEN_TASK_BUILD_TRACKS_SUB1") },
					{ name = _("MISSION_SHINKANSEN_TASK_BUILD_TRACKS_SUB2") },
					{ name = _("MISSION_SHINKANSEN_TASK_BUILD_TRACKS_SUB3") },
				},
				parentId = "2",
				camera = params.jump_default,
				voiceOver = "MISSION_SHINKANSEN_TASK_BUILD_TRACKS_TEXT.wav",
			}
		end,
	})
end
