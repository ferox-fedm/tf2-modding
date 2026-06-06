local taskutil = require "mission.taskutil"
local params = require "params"
local vehiclestore = require "mission.vehiclestore"

return function()
	taskutil:new("m1", {
		onStart = function(self)
			taskutil:setMedalVisible("MEDAL_1")
			self:setProgressNone()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_MEDAL_CHURCHILL_NAME"),
				paragraphs = {
					{ text = _("MISSION_SWISSMADE_MEDAL_CHURCHILL_TEXT") },
				},
				options = {
					{ _("Accept"), "accept" },
					{ _("Decline"), "decline" },
				},
				optionsRightAlign = true,
				isMedal = true,
				camera = params.churchill_camera,
				voiceOver = "MISSION_SWISSMADE_MEDAL_CHURCHILL_TEXT.wav",
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

	local function isarrowincity(city)
		local allVehicles = game.interface.getEntities({ pos = params["pos_" .. city], radius = 400 }, { type="VEHICLE" })
		for i = 1, #allVehicles do
			local e = game.interface.getEntity(allVehicles[i])
			for w = 1, #e.vehicles do
				if e.vehicles[w].fileName == "vehicle/train/roterpfeil_v2.mdl" then
					return true
				end
			end
		end
		return false
	end
	taskutil:new("m1a", {
		onStart = function(self)
			vehiclestore.setAllowedVehicleCount("vehicle/train/roterpfeil_v2.mdl", 1) 
		end,
		onUpdate = function(self)
			if isarrowincity("zurich") then
				taskutil.userstate.arrowz = true
				self:setSubtaskCompleted(1)
			end
			if isarrowincity("stgallen") then
				self:setSubtaskCompleted(2)
				taskutil.userstate.arrows = true
			end
			if taskutil.userstate.arrowz and taskutil.userstate.arrows then
				self:finish()
			end
		end,
		onFinish = function(self)
			taskutil:setMedalCompleted("MEDAL_1")
			taskutil.tasks["m1b"]:start()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_MEDAL_CHURCHILL_DRIVE_NAME"),
				paragraphs = {
					{  text = _("MISSION_SWISSMADE_MEDAL_CHURCHILL_DRIVE_TEXT") },
					{ type = "TASK", text = _("MISSION_SWISSMADE_MEDAL_CHURCHILL_DRIVE_TASK") },
				},
				subTasks = {
					{ name = _("MISSION_SWISSMADE_MEDAL_CHURCHILL_DRIVE_SUB1") },
					{ name = _("MISSION_SWISSMADE_MEDAL_CHURCHILL_DRIVE_SUB2") },
				},
				options = { { "Debug: Skip", "finish" } },
				parentId = "m1",
				camera = params.churchill_camera,
				voiceOver = "MISSION_SWISSMADE_MEDAL_CHURCHILL_DRIVE_TEXT.wav",
			}
		end,
	})

	taskutil:new("m1b", {
		onStart = function(self)
			self:setProgressNone()
		end,
		onGuiFinish = function(self)
			gui.window_get("missionDisplayWindow"):close()
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_SWISSMADE_MEDAL_CHURCHILL_FINISH_NAME"),
				paragraphs = { { text = _("MISSION_SWISSMADE_MEDAL_CHURCHILL_FINISH_TEXT") } },
				options = { { _("Ok!"), "finish" } },
				optionsRightAlign = true,
				parentId = "m1",
				voiceOver = "MISSION_SWISSMADE_MEDAL_CHURCHILL_FINISH_TEXT.wav",
			}
		end,
	})
end
