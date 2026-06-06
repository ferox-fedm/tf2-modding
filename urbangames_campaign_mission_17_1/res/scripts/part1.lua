local taskutil = require "mission.taskutil"
local params = require "params"
local polygonutil = require "polygonutil"
local colors = require "mission.colors"
local zoneutil = require "mission.zone"
local arrivaltracker = require "mission.arrivaltracker"
local util = require "util"

return function()

	local mainguihandlers = {
		voiceOverEnded = function(self) taskutil:finish(self.name) end,
	}

	setmetatable(mainguihandlers, { __index = function(self, key)
		local n = #"jump_"
		if key:sub(1, n) == "jump_" then
			game.gui.setAutoCamera(params[key])
		end
	end})

	taskutil:new("1", {
		onStart = function(self)
			taskutil:setZone("prohibit", { polygon = params.prohibitarea, draw = false, drawColor = colors.RED, buildToolMode = "PROHIBIT" })
			taskutil.userstate.treesatstart = util.counttrees()
			--taskutil.tasks["m1"]:start()
			--taskutil.tasks["m2"]:start()
			--taskutil.tasks["m3"]:start()
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["1a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_PREPARE_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_PREPARE_TEXT") % params }
				},
				camera = params.jump_oilsands,
				voiceOver = "MISSION_OILSANDS_TASK_PREPARE_TEXT.wav",
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
			}
		end,
		guiHandlers = mainguihandlers,
	})

	local function getparams(i)
		return {
			stocks = { },
			input = { { } },
			output = { OIL_SAND = 1 },
			capacity = params["oilsand" .. i .. "output"],
		}
	end

	local radius1a = 150
	taskutil:new("1a", {
		onStart = function(self)
			for i = 1, 3 do
				taskutil:setZone("treezone" .. i, { polygon = zoneutil.makeCircleZone(params["pos_oilsand" .. i], radius1a), draw = true, drawColor = colors.BLUE })
			end
		end,
		onUpdate = function(self)
			local donecount = 0

			local treecount = 0
			local machinesdeliveredcount = 0

			for i = 1, 3 do
				local trees = game.interface.getEntities({ pos = params["pos_oilsand" .. i], radius = radius1a - 30 }, {type = "ASSET_GROUP"})
				for i = 1, #trees do
					local e = game.interface.getEntity(trees[i])
					local mdls = e.models
					for k,v in pairs(mdls) do
						if k:sub(1, 4) == "tree" then
							treecount = treecount + v
						end
					end
				end

				local e = game.interface.getEntity(game.interface.getEntity(params["oilsand" .. i]).simBuildings[1])
				machinesdeliveredcount = machinesdeliveredcount + (e.itemsConsumed.MACHINES or 0)
			end

			self:setProgressCount(machinesdeliveredcount, params.machines_amount, 1)
			self:setSubtaskCompleted(1, machinesdeliveredcount >= params.machines_amount)

			self:setProgressText(treecount .. "", 2)
			self:setSubtaskCompleted(2, treecount == 0)

			if treecount == 0 and  machinesdeliveredcount >= params.machines_amount then self:finish() end
		end,
		onFinish = function(self)
			if taskutil.tasks["1b"].start then taskutil.tasks["1b"]:start() end
			for i = 1, 3 do
				local upgradelock = "oilsand" .. i .. "upgraded"
				if not taskutil.userstate[upgradelock] then
					game.interface.upgradeConstruction(params["oilsand" .. i], "industry/quarry.con", getparams(i))
				end
				taskutil:setZone("treezone" .. i)
			end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_PREPARE_EQUIPMENT_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_PREPARE_EQUIPMENT_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_PREPARE_EQUIPMENT_TASK") % params },
					{ type = "HINT", text = _("MISSION_OILSANDS_TASK_PREPARE_EQUIPMENT_HINT") % params },
				},
				subTasks = {
					{ name = _("MISSION_OILSANDS_TASK_PREPARE_EQUIPMENT_SUB1") % params },
					{ name = _("MISSION_OILSANDS_TASK_PREPARE_EQUIPMENT_SUB2") % params },
					--{ name = _("MISSION_OILSANDS_TASK_PREPARE_EQUIPMENT_SUB3") % params },
					--{ name = _("MISSION_OILSANDS_TASK_PREPARE_EQUIPMENT_SUB4") % params },
					--{ name = _("MISSION_OILSANDS_TASK_PREPARE_EQUIPMENT_SUB5") % params },
					--{ name = _("MISSION_OILSANDS_TASK_PREPARE_EQUIPMENT_SUB6") % params },
				},
				camera = params.jump_oilsands,
				voiceOver = "MISSION_OILSANDS_TASK_PREPARE_EQUIPMENT_TEXT.wav",
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
			}
		end,
	})

	taskutil:new("1b", {
		onStart = function(self)
			arrivaltracker.track("1b", { cargotype = "OIL" })
		end,
		onUpdate = function(self)
			--local e = game.interface.getEntity(game.interface.getEntity(params.refinery).simBuildings[1])
			--local sand = e.itemsConsumed.OIL_SAND or 0
			--local done1 = sand >= params.oilsand_amount

			local oil = arrivaltracker.get("1b")
			local done2 = oil >= params.oil_amount

			--self:setProgressCount(sand, params.oilsand_amount, 1)
			--self:setProgressCount(oil, params.oil_amount, 1)

			--self:setSubtaskCompleted(1, done1)
			self:setSubtaskCompleted(1, done2)

			if done2 then self:finish() end
		end,
		onFinish = function(self)
			arrivaltracker.track("1b")
			taskutil:startLater("2")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_OILSANDS_TASK_PREPARE_SAND_NAME"),
				paragraphs = {
					{ text = _("MISSION_OILSANDS_TASK_PREPARE_SAND_TEXT") % params },
					{ type = "TASK", text = _("MISSION_OILSANDS_TASK_PREPARE_SAND_TASK") % params },
				},
				camera = params.jump_refinery,
				voiceOver = "MISSION_OILSANDS_TASK_PREPARE_SAND_TEXT.wav",
				subTasks = {
					--{ name = _("MISSION_OILSANDS_TASK_PREPARE_SAND_SUB1") % params },
					{ name = _("MISSION_OILSANDS_TASK_PREPARE_SAND_SUB2") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "1",
			}
		end,
	})
end
