local taskutil = require "mission.taskutil"
local params = require "params"

local t = {}

function t.createA(i, p)
	return {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks[i]:start()
		end,
		getInfo = function(self)
			return {
				name = _("unused"), -- Flughafen erweitern
				paragraphs = {
					{ text = _("unused") },
					{ type = "TASK", text = _("unused") % params } --Auswahl:\n- Zweite Piste\n- Passagier-Terminal\n- Cargo-Terminal
				},
				options = {
					{ _("unused"), "finish" }, --Piste
					{ _("unused"), "finish" }, --Passagier
					{ _("unused"), "finish" }, --Cargo
				},
				optionsRightAlign = true,
				parentId = p,
			}
		end,
	}
end

function t.createB(i, p)
	return {
		onStart = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.airportdeliverlocation).simBuildings[1]).itemsConsumed
			taskutil.userstate.progressbsteel = c.STEEL or 0
			taskutil.userstate.progressbconmat = c.CONSTRUCTION_MATERIALS or 0
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.airportdeliverlocation).simBuildings[1]).itemsConsumed
			local x1 = (c.STEEL or 0) - taskutil.userstate.progressbsteel
			local x2 = (c.CONSTRUCTION_MATERIALS or 0) - taskutil.userstate.progressbconmat
			self:setSubtaskCompleted(1, x1 > 0)
			self:setSubtaskCompleted(2, x2 > 0)
			if x1 > 0 and x2 > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks[i]:start()
		end,
		getInfo = function(self)
			return {
				name = _("unused"), -- Material liefern
				paragraphs = {
					{ text = _("unused") },
					{ type = "TASK", text = _("unused") % params }, --X Stahl und X Baumaterial liefern
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("unused") }, --Stahl liefern
					{ name = _("unused") }, --Baumaterial liefern
				},
				parentId = p,
			}
		end,
	}
end

function t.createC(i, p)
	return {
		onStart = function(self)
		end,
		onUpdate = function(self)
		end,
		onFinish = function(self)
			taskutil.tasks[i]:start()
		end,
		getInfo = function(self)
			return {
				name = _("unused"), --Fahrzeuge importieren
				paragraphs = {
					{ text = _("unused") },
					{ type = "TASK", text = _("unused") % params }, -- Auswahl:\n- Busse importieren\n- LKWs importieren\n- Strassenbahnen importieren
				},
				options = {
					{ _("unused"), "finish" }, --Busse
					{ _("unused"), "finish" }, --LKWs
					{ _("unused"), "finish" }, --Strassenbahnen
				},
				optionsRightAlign = true,
				parentId = p,
			}
		end,
	}
end

function t.createD(i, p)
	return {
		onStart = function(self)
			taskutil.userstate.progressdvehicleparts = game.interface.getEntity(game.interface.getEntity(params.vehiclepartsconsumer).simBuildings[1]).itemsConsumed.VEHICLEPARTS or 0
		end,
		onUpdate = function(self)
			local c = game.interface.getEntity(game.interface.getEntity(params.vehiclepartsconsumer).simBuildings[1]).itemsConsumed.VEHICLEPARTS or 0
			c = c - taskutil.userstate.progressdvehicleparts
			if c > 0 then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks[i]:start()
		end,
		getInfo = function(self)
			return {
				name = _("unused"), --Teile liefern
				paragraphs = {
					{ text = _("unused") },
					{ type = "TASK", text = _("unused") % params }, --Fahrzeugteile liefern
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = p,
			}
		end,
	}
end

return t
