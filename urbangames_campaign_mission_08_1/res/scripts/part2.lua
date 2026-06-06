local taskutil = require "mission.taskutil"
local params = require "params"
local util = require "util"
local gui = require "gui"
local apputil = require "apputil"

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
				name = _("MISSION_TWENTIES_TASK_LICENCE_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_LICENCE_TEXT") % params }
				},
				options = { { _("Continue"), "finish" } },
				optionsRightAlign = true,
				camera = {-600, -800, 1500},
				voiceOver = "MISSION_TWENTIES_TASK_LICENCE_TEXT.wav",
			}
		end,
		guiHandlers = {
			voiceOverEnded = function(self) taskutil:finish(self.name) end,
		},
	})

	local function createhandlers()
		local result = {}
		result.buy = function(self, i)
			local name = params.licenseid2name[i]
			local cost = params.licensecost[name]
			game.interface.book(-cost)
			local b = taskutil.userstate.boughtlicenses
			b[#b + 1] = name
			taskutil:setMarker("marker2a"..i)
			taskutil:setZone("zone"..i)
		end
		return result
	end
	local function createguihandlers()
		local result = {}
		for i = 1, 4 do
			result["license"..i] = function(self)
				local s = "license" ..i
				local windowname = s .. "window"
				if util.windows[windowname] ~= nil then return end
				local boxlayout = gui.boxLayout_create(s .. "boxlayout", "VERTICAL")
				local tv = gui.textView_create(s .. "tv" , _("MISSION_TWENTIES_TASK_LICENCE_BUY_INFO") % { n = params["name_" .. params.licenseid2name[i]], x = params.licensecost[params.licenseid2name[i]] }) --Lizenz für die Region ${n} für ${x} erwerben.
				local tv0 = gui.textView_create(s .. "tv0" , _("MISSION_TWENTIES_TASK_LICENCE_BUY_OPTION1")) --Jetzt erwerben
				local tv1 = gui.textView_create(s .. "tv1" , _("MISSION_TWENTIES_TASK_LICENCE_BUY_OPTION2")) --Später erwerben
				local button0 = gui.button_create(s .. "button0" , tv0)
				local button1 = gui.button_create(s .. "button1" , tv1)
				button0:onClick(function()
					taskutil:sendScriptFn(self.name, "buy", { i })
					util.windows[windowname]:close()
				end)
				button1:onClick(function()
					util.windows[windowname]:close()
				end)
				boxlayout:addItem(tv)
				boxlayout:addItem(button0)
				boxlayout:addItem(button1)

				button0:setStyleClassList({"missionOption"})
				button1:setStyleClassList({"missionOption"})

				util.windows[windowname] = gui.window_create(windowname, _("MISSION_TWENTIES_TASK_LICENCE_BUY_WINDOW"), boxlayout) --Lizenz erwerben
				util.windows[windowname]:onClose(function()
					util.windows[windowname] = nil
				end)
				util.windows[windowname]:addNavigation()
				if apputil.isCouchUiMode() then
					local windowCRect = game.gui.getContentRect(util.windows[windowname].id)
					local screenCRect = game.gui.getContentRect("mainView")
					local x = screenCRect[3] - windowCRect[3] - (screenCRect[3] * 0.36)
					local y = windowCRect[2] -- y pos
					game.gui.window_setPosition(util.windows[windowname].id, x, y)
				end
			end
		end
		return result
	end
	taskutil:new("2a", {
		onStart = function(self)
			for i = 1, 4 do
				taskutil:setMarker("marker2a" .. i, { entity = params[params.licenseid2name[i]], type = "question" }, self.name, "license" .. i)
			end
		end,
		onUpdate = function(self)
			local bought = #taskutil.userstate.boughtlicenses

			local count = 0
			local t = { "minneapolis" }
			for i = 1, 4 do
				t[#t + 1] = params.licenseid2name[i]
			end

			local passengerstotal = 0

			for i = 1, 5 do
				local stations = game.interface.getStations({ town = params[t[i]], carrier = "ROAD" })
				local passengerstations = {}
				for j = 1, #stations do
					local e = game.interface.getEntity(stations[j])
					if e.cargo == false then
						if t[i] ~= "minneapolis" then
							passengerstotal = passengerstotal + (game.interface.getEntity(game.interface.getEntity(stations[j]).stationGroup).itemsLoaded.PASSENGERS or 0)
						end
						count = count + 1
						break
					end
				end
			end

			count = count - 1

			self:setProgressCount(count, params.goal_licence, 1)
			self:setProgressCount(passengerstotal, params.goal_passengers, 2)

			if count >= params.goal_licence then self:setSubtaskCompleted(1) end
			if passengerstotal >= params.goal_passengers then self:setSubtaskCompleted(2) end

			if count >= params.goal_licence and passengerstotal >= params.goal_passengers then
				self:finish()
			end
		end,
		onFinish = function(self)
			if taskutil.tasks["3"].start ~= nil then taskutil.tasks["3"]:start() end
		end,
		getInfo = function(self)
			return {
				name = _("MISSION_TWENTIES_TASK_LICENCE_BUSLINE_NAME"),
				paragraphs = {
					{ text = _("MISSION_TWENTIES_TASK_LICENCE_BUSLINE_TEXT") % params },
					{ type = "TASK", text = _("MISSION_TWENTIES_TASK_LICENCE_BUSLINE_TASK") % params },
					{ type = "HINT", text = _("MISSION_TWENTIES_TASK_LICENCE_BUSLINE_HINT") % params },
				},
				parentId = "2",
				options = { { "Debug: Skip", "finish" } },
				subTasks = {
					{ name = _("MISSION_TWENTIES_TASK_LICENCE_BUSLINE_SUB1") }, --Fernbusstation gebaut
					{ name = _("MISSION_TWENTIES_TASK_LICENCE_BUSLINE_SUB2") }, --Passagiere zugestiegen
				},
				camera = {-600, -800, 1500},
				voiceOver = "MISSION_TWENTIES_TASK_LICENCE_BUSLINE_TEXT.wav",
			}
		end,
		handlers = createhandlers(),
		guiHandlers = createguihandlers(),
	})

end
