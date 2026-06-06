local params = require "params"
local vehiclestore = require "mission.vehiclestore"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local guidesystem = require "guidesystem"
local vec2 = require "vec2"

local function vulcanozoneclear()
	local x = vec2.new(table.unpack(params.vulcano_zone.pos))
	local r = params.vulcano_zone.radius
	local baseedges = game.interface.getEntities(params.vulcano_zone, {type = "BASE_EDGE"})
	for i = 1, #baseedges do
		local e = game.interface.getEntity(baseedges[i])
		local p0 = vec2.new(table.unpack(e.node0pos))
		local p1 = vec2.new(table.unpack(e.node1pos))
		if e.track and (vec2.distance(x, p0) < r or vec2.distance(x, p1) < r) then
			return false
		end
	end
	return true
end

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("5", {
		onStart = function(self)
			self:setProgressNone()
			taskutil:setMusicTrack("track5")
		end,
		onFinish = function(self)
			tasks["5a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_VULCANO_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_VULCANO_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_vulcano_zone,
				voiceOver = "MISSION_COLONIALISM_TASK_VULCANO_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
			taskutil:setZone("red", { polygon = zoneutil.makeCircleZone(params.vulcano_zone.pos, params.vulcano_zone.radius, 128), draw = true, drawColor = colors.RED })
		end,
		onUpdate = function(self)
			local stations = game.interface.getEntities({pos = params.pos_coffee_farm, radius = 300}, {type = "STATION"})

			local stationgroups = {}
			for i = 1, #stations do
				local e = game.interface.getEntity(stations[i])
				stationgroups[e.stationGroup] = 1
			end

			local lines = game.interface.getLines()
			for i = 1, #lines do
				local l = game.interface.getEntity(lines[i])
				for j = 1, #l.stops do
					if stationgroups[l.stops[j]] then
						return
					end
				end
			end

			self:finish()
		end,
		onFinish = function(self)
			tasks["5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_VULCANO_LINE_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_VULCANO_LINE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_VULCANO_LINE_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_coffee_farm,
				voiceOver = "MISSION_COLONIALISM_TASK_VULCANO_LINE_TEXT.wav",
			}
		end,
	})

	taskutil:new("5b", {
		onStart = function(self)
			taskutil.userstate.guidesystemkeys["guides_bulldoze"] = guidesystem.getTime()
		end,
		onUpdate = function(self)
			self:setSubtaskCompleted(1, false)
			if vulcanozoneclear() == false then return end
			self:setSubtaskCompleted(1)

			local pos1 = params.pos_coffee_farm
			local stations1 = game.interface.getEntities({pos = pos1, radius = 500}, {type = "STATION"})

			local pos2 = params.pos_coffee_processing
			local stations2 = game.interface.getEntities({pos = pos2, radius = 500}, {type = "STATION"})
			for i = 1, #stations1 do
				if game.interface.getEntity(stations1[i]).cargo then
					for j = 1, #stations2 do
						if game.interface.getEntity(stations2[j]).cargo then
							local path = game.interface.findPath(stations1[i], stations2[j], { TRAIN = true })
							if path ~= nil then
								self:finish()
								return
							end
						end
					end
				end
			end
		end,
		onFinish = function(self)
			taskutil.userstate.guidesystemkeys["guides_bulldoze"] = nil
			tasks["5c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_VULCANO_TRACKS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_VULCANO_TRACKS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_VULCANO_TRACKS_TASK") % params },
				},
				subTasks = {
					{ name = _("MISSION_COLONIALISM_TASK_VULCANO_TRACKS_SUB1") % params },
					{ name = _("MISSION_COLONIALISM_TASK_VULCANO_TRACKS_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_coffee_farm,
				voiceOver = "MISSION_COLONIALISM_TASK_VULCANO_TRACKS_TEXT.wav",
			}
		end,
	})

	local function gettransportedbeans()
		local e = game.interface.getEntity(game.interface.getEntity(params.coffee_processing).simBuildings[1])
		return e.itemsConsumed.COFFEE or 0
	end

	taskutil:new("5c", {
		onStart = function(self)
			taskutil:invokeLater(self.name, "showm5", 30)
			taskutil.userstate.gettransportedbeans = gettransportedbeans()
		end,
		onUpdate = function(self)
			local progress = gettransportedbeans()
			local n = params.coffeefruit_amount
			if vulcanozoneclear() == false then
				taskutil.userstate.gettransportedbeans = progress
				self:setProgressCount(progress - taskutil.userstate.gettransportedbeans, n)
				return
			end
			if progress >= taskutil.userstate.gettransportedbeans + n then
				self:finish()
			end
			self:setProgressCount(progress - taskutil.userstate.gettransportedbeans, n)
		end,
		onFinish = function(self)
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_COLONIALISM_TASK_VULCANO_TRANSPORT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_VULCANO_TRANSPORT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_COLONIALISM_TASK_VULCANO_TRANSPORT_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_coffee_processing,
				voiceOver = "MISSION_COLONIALISM_TASK_VULCANO_TRANSPORT_TEXT.wav",
			}
		end,
		handlers = {
			showm5 = function(self) 
				if taskutil.tasks["m5"].start ~= nil then
					taskutil.tasks["m5"]:start()
				end
			end,
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
				name = _("MISSION_COLONIALISM_TASK_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_COLONIALISM_TASK_FINISH_TEXT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				voiceOver = "MISSION_COLONIALISM_TASK_FINISH_TEXT.wav",
			}
		end,
	})

end
