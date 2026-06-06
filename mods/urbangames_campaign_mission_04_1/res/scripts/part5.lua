local params = require "params"

return function(taskutil)
	local tasks = taskutil.tasks

	taskutil:new("5", {
		onStart = function(self)
			taskutil:setMusicTrack("track5")
			self:setProgressNone()
		end,
		onFinish = function(self)
			taskutil.tasks["5a"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_RETREAT_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_RETREAT_TEXT") % params },
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = params.jump_topolobampo,
				voiceOver = "MISSION_PARADISO_TASK_RETREAT_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	taskutil:new("5a", {
		onStart = function(self)
			--game.interface.upgradeConstruction(game.interface.getEntity(params.distillery).stockList,    "industry/distillery.con",    { productionLevel = 0, cargo ="CONSTRUCTION_MATERIALS" })
			--game.interface.upgradeConstruction(game.interface.getEntity(params.sawmill).stockList,       "industry/saw_mill.con",      { productionLevel = 0, cargo ="CONSTRUCTION_MATERIALS" })
			--game.interface.upgradeConstruction(game.interface.getEntity(params.spoon_factory).stockList, "industry/spoon_factory.con", { productionLevel = 0, cargo ="CONSTRUCTION_MATERIALS" })
			--game.interface.upgradeConstruction(params.hospital,                                          "industry/hospital.con",      { productionLevel = 0, cap = 10, cargo = "produce" })
			--game.interface.upgradeConstruction(params.hotel,                                             "industry/hotel.con",         { productionLevel = 0, cap = 10, cargo = "produce" })
			--game.interface.upgradeConstruction(params.library,                                           "industry/library.con",       { productionLevel = 0, cap = 10, cargo = "produce" })
			game.interface.upgradeConstruction(params.sale,                                              "industry/sale.con",          { productionLevel = 0, cargo = true })
			--game.interface.upgradeConstruction(params.sugar_factory,                                     "industry/sugar_factory.con", { productionLevel = 0, cargo = true })
		end,
		onUpdate = function(self)
			local p = game.interface.getEntity(game.interface.getEntity(params.sale).simBuildings[1]).itemsConsumed._sum or 0

			self:setProgressCount(p, params.retreat_sell_material)

			if p >= params.retreat_sell_material then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil.tasks["5b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_RETREAT_SELL_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_RETREAT_SELL_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_RETREAT_SELL_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_sale,
				voiceOver = "MISSION_PARADISO_TASK_RETREAT_SELL_TEXT.wav",
			}
		end,
	})

	local function getheightmap(pos)
		local heightmap = {}
		local d = 50
		for j = -10, 10 do
			for i = -10, 10 do
				local p = { pos[1] - i * d, pos[2] - j * d }
				heightmap[#heightmap + 1] = game.interface.getHeight(p)
			end
		end
		return heightmap
	end

	taskutil:new("5b", {
		onStart = function(self)
			local topo = game.interface.getEntity(params.topolobampo)
			local pos = topo.position
			taskutil.userstate.state5b = game.interface.getEntities({pos = pos, radius = 500})
			taskutil.userstate.name5b = topo.name
			taskutil.userstate.heightmap5b = getheightmap(pos)
		end,
		onUpdate = function(self)
			local topo = game.interface.getEntity(params.topolobampo)
			local pos = topo.position
			local t = game.interface.getEntities({pos = pos, radius = 500})
			local entities = {}
			for i = 1, #t do
				entities[t[i]] = 1
			end
			local origentities = taskutil.userstate.state5b
			local found = 0
			local count = #origentities
			if count == 0 then self:finish() end
			for i = 1, count do
				if entities[origentities[i]] == 1 then found = found + 1 end
			end

			local progress = 4 * (1 - found / count)
			if topo.name ~= taskutil.userstate.name5b then progress = progress + 0.6 end
			local diff = 0
			local origheightmap = taskutil.userstate.heightmap5b
			local heightmap = getheightmap(pos)
			for i = 1, #heightmap do
				diff = diff + math.abs(heightmap[i] - origheightmap[i])
			end
			progress = progress + diff / 800

			self:setProgressPercent(progress)
			if progress >= 1 then self:finish() end
		end,
		onFinish = function(self)
			taskutil:startLater("end")
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_PARADISO_TASK_RETREAT_TRACKS_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_RETREAT_TRACKS_TEXT") % params },
					{ type = "TASK", text = _("MISSION_PARADISO_TASK_RETREAT_TRACKS_TASK") % params }
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				camera = params.jump_topolobampo,
				voiceOver = "MISSION_PARADISO_TASK_RETREAT_TRACKS_TEXT.wav",
			}
		end,
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
				name = _("MISSION_PARADISO_TASK_FINISH_NAME") % params,
				paragraphs = {
					{ text = _("MISSION_PARADISO_TASK_FINISH_TEXT") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "5",
				voiceOver = "MISSION_PARADISO_TASK_FINISH_TEXT.wav",
			}
		end,
	})

end
