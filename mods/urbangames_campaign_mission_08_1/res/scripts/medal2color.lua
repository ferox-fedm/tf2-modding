local taskutil = require "mission.taskutil"
local params = require "params"

return function()
	taskutil:new("m2", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_2")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_MEDAL_CORPORATE_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_MEDAL_CORPORATE_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = {-600, -800, 1500},
				voiceOver = "MISSION_TWENTIES_MEDAL_CORPORATE_TEXT.wav",
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

	taskutil:new("m2a", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getVehicles()
			local linecolors = {}

			--collect the colors of all lines into 'linecolors' if all vehicles within the line have equal color
			for i = 1, #vehicles do
				local v = game.interface.getEntity(vehicles[i])
				local l = v.line
				if l >= 0 and l ~= params.tramailine and v.carrier == "ROAD" and (v.allCapacities.PASSENGERS or 0) > 0 then
					local c = v.vehicles[1].color
					if linecolors[l] == nil then
						linecolors[l] = c
					elseif linecolors[l] ~= false then
						local lc = linecolors[l]
						if c[1] ~= lc[1] or c[2] ~= lc[2] or c[3] ~= lc[3] then
							--not all vehicles on this line have equal color
							linecolors[l] = false
						end
					end
				end
			end

			--count the number of distinct colors in 'linecolors'
			local colorsfound = 0
			local r2g2b = {}
			local count = 0
			for _, color in pairs(linecolors) do
				if color ~= false then
					r2g2b[color[1]] = r2g2b[color[1]] or {}
					local g2b = r2g2b[color[1]]

					g2b[color[2]] = g2b[color[2]] or {}
					local b = g2b[color[2]]

					b[color[3]] = (b[color[3]] or 0) + 1
					local count = b[color[3]]

					if count == 1 then
						colorsfound = colorsfound + 1
					end
				end
			end

			--self:setProgressText(_("MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR1_PROGRESS1")) -- nicht genügend Fahrzeuge
			--self:setProgressText(_("MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR1_PROGRESS2") % { x = colorsfound })
			self:setProgressCount(colorsfound, params.distinct_colors, 1)
			if colorsfound >= params.distinct_colors then self:finish() end
		end,
		onFinish = function(self)
			taskutil.tasks["m2b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR1_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR1_TEXT") },
					{ type = "TASK", text = _("MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR1_TASK") % params },
				},
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR1_SUB1") % params },
				},
				parentId = "m2",
				camera = {-600, -800, 1500},
				voiceOver = "MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR1_TEXT.wav",
			}
		end,
	})

	taskutil:new("m2b", {
		onStart = function(self)
		end,
		onUpdate = function(self)
			local vehicles = game.interface.getVehicles()

			local n = 0
			local rgb
			for i = 1, #vehicles do
				local v = game.interface.getEntity(vehicles[i])
				if v.line ~= params.tramailine and v.carrier == "ROAD" and (v.allCapacities.PASSENGERS or 0) > 0 then
					n = n + 1
					local color = v.vehicles[1].color
					if rgb == nil then
						rgb = color
					else
						for j = 1, 3 do
							if rgb[j] ~= color[j] then
								self:setProgressText(_("MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR2_PROGRESS")) --nicht alle Fahrzeuge sind gleichfarbig
								return
							end
						end
					end
				end
			end
			if n < 10 then
				self:setProgressText(_("MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR1_PROGRESS")) --nicht genügend Fahrzeuge
			else
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_2")
			taskutil.tasks["m2c"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR2_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR2_TEXT") },
					{ type = "TASK", text = _("MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR2_TASK") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m2",
				camera = {-600, -800, 1500},
				voiceOver = "MISSION_TWENTIES_MEDAL_CORPORATE_BUS_COLOR2_TEXT.wav",
			}
		end,
	})

	taskutil:new("m2c", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_MEDAL_CORPORATE_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_TWENTIES_MEDAL_CORPORATE_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m2",
				camera = {-600, -800, 1500},
				voiceOver = "MISSION_TWENTIES_MEDAL_CORPORATE_FINISH_TEXT.wav",
			}
		end,
	})
end
