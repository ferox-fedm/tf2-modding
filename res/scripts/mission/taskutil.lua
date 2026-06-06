local tasks = {}
local taskOrder = {} -- order in which tasks were added during the mission
local state = {
	medals = { },
	markers = {},
	zones = {},
	proposals = {},
	proposalCheckActive = false,
	proposalCheckWhitelist = false, --blacklist is default
	music = {},
	gui = {},
	counter = 0, -- counts all updates
	invokeLater = {}, -- functions to be called later
}

local eventHandlers = {
	guiInit = function() end,
}

local privateTaskData = {

}

local taskutil = {
	tasks = tasks,
	userstate = {},
	onGuiInit = function(fn) eventHandlers.guiInit = fn end,
	setCompleted = function(self, taskname)
		assert(game.gui == nil)
		state.missioncompleted = true
		state.missionendtask = taskname or "end"
		game.interface.setMissionState("COMPLETED")
	end,
	settings = {
		delayBetweenTasks = 2, --seconds
		mainTask = "1", --name of main task (where handlers for link klicks are found)
	},
}

local guiState = {
	voiceover = {
		taskcaused = nil,
		active = false,
	},
	numtasksadded = 0,
	finishedtasks = {},
	lastmusictrack = nil,
	missioncompleted = nil,
}

function taskutil:new(name, t)
	local task = {}
	privateTaskData[name] = {}
	local ptd = privateTaskData[name]
	task.name = name

	local handlers = t.handlers
	if handlers == nil then handlers = {} end
	local guiHandlers = t.guiHandlers
	if guiHandlers == nil then guiHandlers = {} end

	local onStart  = t.onStart  if onStart  == nil then onStart  = function() end end
	local onUpdate = t.onUpdate if onUpdate == nil then onUpdate = function() end end
	local onFinish = t.onFinish if onFinish == nil then onFinish = function() end end

	local onGuiStart  = t.onGuiStart  if onGuiStart  == nil then onGuiStart  = function() end end
	local onGuiUpdate = t.onGuiUpdate if onGuiUpdate == nil then onGuiUpdate = function() end end
	local onGuiFinish = t.onGuiFinish if onGuiFinish == nil then onGuiFinish = function() end end

	local loaded = false

	local progress = {
		optionsAvailable = true,
		unavailableOptions = { },
		medals = { },
		visibleMedals = { },
		indicator = { completed = false, type = "BOOL" },
		subIndicators = { }
	}
	local info

	local function run(self)
		for i = 1, #taskOrder do
			if taskOrder[i] == name then return end
		end
		taskOrder[#taskOrder + 1] = name
		info = t.getInfo(task)

		if info.paragraphs then
			for i = 1, #info.paragraphs do
				info.paragraphs[i].text = info.paragraphs[i].text:gsub("\n\n", "\n")
				info.paragraphs[i].text = info.paragraphs[i].text:gsub("\n", "\n\n")
			end
		end

		if info.visible == nil then info.visible = true end

		if not loaded then
			for i = 1, info.subTasks and #info.subTasks or 0 do
				progress.subIndicators[#progress.subIndicators + 1] = { completed = false, type = "BOOL" }
			end
		end

		self.start = nil
		handlers.start = nil
		if not self:isCompleted() then
			function task:finish()
				if game.gui == nil then
					assert(handlers.finish ~= nil)
					handlers.finish(self)
				else
					taskutil:sendScriptFn(self.name, "finish")
				end
				task.finish = nil
			end

			assert(handlers.finish == nil)
			handlers.finish = function(self)
				assert(game.gui == nil)
				task.finish = nil
				handlers.finish = nil
				progress.indicator.completed = true
				onFinish(task)
			end
		else
			guiState.finishedtasks[name] = true
		end

		guiHandlers.finish = guiHandlers.finish or function(self)
			taskutil:sendScriptFn(name, "finish")
		end

		if game.gui ~= nil then
			onGuiStart(self)
		end

		if not loaded then
			assert(game.gui == nil)
			onStart(self)
		end
	end

	ptd.load = function(self, data)
		progress = data.progress
		loaded = true
		run(task)
	end

	ptd.getProgress = function()
		return progress
	end

	ptd.getInfo = function()
		return info
	end

	ptd.handle = function(self, key, params)
		local handlers = game.gui == nil and handlers or guiHandlers
		local h = handlers[key]
		if h == nil then
			if game.gui ~= nil then
				taskutil:sendScriptFn(name, key)
			end
			return
		end
		if params then
			return h(self, table.unpack(params))
		else
			return h(self)
		end
	end

	ptd.removeFinish = function(self)
		assert(game.gui ~= nil)
		guiHandlers.finish = nil
		self.finish = nil
	end

	task.start = function()
		if game.gui == nil then
			run(task)
		else
			taskutil:sendScriptFn(task.name, "start")
			task.start = nil
		end
	end
	assert(handlers.start == nil)
	handlers.start = task.start

	ptd.update = function(self)
		onUpdate(self)
	end

	ptd.guiUpdate = function(self)
		onGuiUpdate(self)
	end

	ptd.onGuiFinish = onGuiFinish

	local function getProgressIndicator(subTask)
		if subTask then
			return progress.subIndicators[subTask]
		end

		return progress.indicator
	end

	function task:setOptionUnavailable(idx)
		progress.unavailableOptions[idx] = 0 -- idx is saved inside unordered_set in cpp (0 ignored)
	end

	function task:isCompleted(subTask)
		local indicator = getProgressIndicator(subTask)
		return indicator.completed
	end

	function task:setSubtaskCompleted(subTask, state)
		assert(game.gui == nil)
		if state == nil then state = true end
		getProgressIndicator(subTask).completed = state
	end

	function task:setProgressNone(subTask)
		assert(game.gui == nil)
		local indicator = getProgressIndicator(subTask)
		indicator.type = "NONE"
		indicator.params = nil
	end

	function task:setProgressBool(subTask)
		assert(game.gui == nil)
		local indicator = getProgressIndicator(subTask)
		indicator.type = "BOOL"
		indicator.params = nil
	end

	function task:setProgressText(value, subTask)
		assert(game.gui == nil)
		local indicator = getProgressIndicator(subTask)

		if indicator.type ~= "TEXT" then
			indicator.type = "TEXT"
			indicator.params = { }
		end

		indicator.params.value = value
	end

	function task:setProgressPercent(value, subTask)
		assert(game.gui == nil)
		local indicator = getProgressIndicator(subTask)

		if indicator.type ~= "PERCENT" then
			indicator.type = "PERCENT"
			indicator.params = { }
		end

		indicator.params.value = value
	end

	function task:setProgressCount(count, total, subTask)
		assert(game.gui == nil)
		local indicator = getProgressIndicator(subTask)

		if indicator.type ~= "COUNT" then
			indicator.type = "COUNT"
			indicator.params = { }
		end

		indicator.params.count = count
		indicator.params.total = total
	end

	tasks[name] = task
	return task
end

function taskutil:setMedalVisible(medalId)
	assert(game.gui == nil)
	state.medals[medalId] = "VISIBLE"
	local ptd = privateTaskData[taskutil.settings.mainTask]
	local progress = ptd.getProgress()
	progress.visibleMedals[medalId] = true
end

function taskutil:setMedalCompleted(medalId)
	assert(game.gui == nil)
	state.medals[medalId] = "COMPLETED"
	local ptd = privateTaskData[taskutil.settings.mainTask]
	local progress = ptd.getProgress()
	progress.medals[medalId] = true
end

function taskutil:setStreetSegmentsForConstructionsTownBuildingsBulldozable(constructionEntity, isBulldozable)
	local construction = game.interface.getEntity(constructionEntity)
	if (construction ~= nil and construction.townBuildings ~= nil) then
		for i, townBuildingEntity in pairs(construction.townBuildings) do
			local townBuilding = game.interface.getEntity(townBuildingEntity)
			if (townBuilding ~= nil and townBuilding.parcels ~= nil) then
				for j, parcelEntity in pairs(townBuilding.parcels) do
					local parcelComp = api.engine.getComponent(parcelEntity, api.type.ComponentType.PARCEL)
					if (parcelComp ~= nil and parcelComp.streetSegment) then
							game.interface.setBulldozeable(parcelComp.streetSegment, isBulldozable)
					end
				end
			end
		end
	end

end

function taskutil:setMarker(key, marker, taskName, fnName)
	assert(game.gui == nil)
	if taskName == nil then
		state.markers[key] = -1
	else
		state.markers[key] = {
			handler = function()
				local task = tasks[taskName]
				privateTaskData[taskName].handle(task, fnName)
			end,
			marker = marker,
			taskName = taskName,
			fnName = fnName,
		}
		
	end
end

function taskutil:setZone(key, zone)
	assert(game.gui == nil)
	state.zones[key] = zone or -1
end

function taskutil:setProposal(key, taskName, fnName, iswarning)
	assert(game.gui == nil)
	if taskName == nil then
		state.proposals[key] = nil
	else
		state.proposals[key] = {
			taskName = taskName,
			fnName = fnName,
			iswarning = iswarning,
		}
	end
end

function taskutil:enableProposalCheck()       assert(game.gui == nil) state.proposalCheckActive = true end
function taskutil:disableProposalCheck()      assert(game.gui == nil) state.proposalCheckActive = false end
function taskutil:setProposalCheckBlacklist() assert(game.gui == nil) state.proposalCheckWhitelist = false end
function taskutil:setProposalCheckWhitelist() assert(game.gui == nil) state.proposalCheckWhitelist = true end

function taskutil:setEnabled(id, enabled)
	assert(game.gui == nil)
	if not state.gui[id] then state.gui[id] = { } end
	state.gui[id].enabled = enabled
end

function taskutil:setVisible(id, visible)
	assert(game.gui == nil)
	if not state.gui[id] then state.gui[id] = { } end
	state.gui[id].visible = visible
end

function taskutil:setVisibleAndEnabled(id, visibleAndEnabled)
	assert(game.gui == nil)
	if not state.gui[id] then state.gui[id] = { } end
	state.gui[id].visible = visibleAndEnabled
	state.gui[id].enabled = visibleAndEnabled
end

local function handleProposalHelper(id, name, param, matchCreate, matchApply, whitelist)
	local err
	local iswarning
	local maxpriority
	for k,v in pairs(state.proposals) do
		local task = tasks[v.taskName]
		local result, priority = privateTaskData[v.taskName].handle(task, v.fnName, { id, name, param, matchApply ~= nil })
		if whitelist and result == true then return true end
		if type(result) == "string" then
			if maxpriority == nil or (priority ~= nil and priority > maxpriority) then
				maxpriority = priority
				err = result
				if v.iswarning then
					iswarning = true
				else
					iswarning = nil
				end
			end
		end
	end
	return err, iswarning
end

local function handleProposalWhitelist(id, name, param, matchCreate, matchApply)
	local err, iswarning = handleProposalHelper(id, name, param, matchCreate, matchApply, true)

	if err == true then return end

	if not err then
		err = _("MISSION_PROPOSAL_FEEDBACK_NOT_ALLOWED")
	end

	if iswarning then
		return { warnings = { err } }
	else
		return { errorMessages = { err } }
	end
end

local function handleProposalBlacklist(id, name, param, matchCreate, matchApply)
	local err, iswarning = handleProposalHelper(id, name, param, matchCreate, matchApply, false)

	if err then
		if iswarning then
			return { warnings = { err } }
		else
			return { errorMessages = { err } }
		end
	end
end

local function handleProposal(id, name, param)
	local matchCreate = name:match("builder.proposalCreate")
	local matchApply = name:match("builder.apply")
	if matchCreate == nil and matchApply == nil then
		return
	end

	local result
	if state.proposalCheckWhitelist then
		result = handleProposalWhitelist(id, name, param, matchCreate, matchApply)
	else
		result = handleProposalBlacklist(id, name, param, matchCreate, matchApply)
	end

	if result == nil then return end

	if result.warnings == nil then
		result.warnings = {}
	else
		assert(result.errorMessages == nil)
		result.errorMessages = {}
	end
	return result
end

function taskutil:setMusicTrack(track)
	assert(game.gui == nil)
	state.music.track = track
end

function taskutil:invokeLater(taskName, fnName, seconds)
	assert(game.gui == nil)
	state.invokeLater[#state.invokeLater + 1] = {
		taskName = taskName,
		fnName = fnName,
		numSteps = seconds * 5,
		started = state.counter,
	}
end

function taskutil:start(taskName)
	local task = taskutil.tasks[taskName]
	if task.start then task:start() end
end

function taskutil:started(taskName)
	return taskutil.tasks[taskName].start == nil
end

function taskutil:finish(taskName)
	local task = taskutil.tasks[taskName]
	if task.finish then task:finish() end
end

function taskutil:finished(taskName)
	local task = taskutil.tasks[taskName]
	return task.start == nil and task.finish == nil
end

function taskutil:startLater(taskName)
	taskutil:invokeLater(taskName, "start", taskutil.settings.delayBetweenTasks)
end

function taskutil:sendScriptFn(taskname, fnname, param)
	assert(game.gui ~= nil)
	game.interface.sendScriptEvent("__taskEvent__", "scriptfn", { taskname = taskname, fnname = fnname, param = param })
end

taskutil.script = {
	update = function ()
		for i = 1, #taskOrder do
			local name = taskOrder[i]
			local task = tasks[name]
			local ptd = privateTaskData[name]
			if not task:isCompleted() then
				ptd.update(task)
			end
		end

		local invokeLater = state.invokeLater
		local n = #invokeLater
		for i = n, 1, -1 do
			local entry = invokeLater[i]
			local due = entry.started + entry.numSteps
			assert(due >= state.counter)
			if due == state.counter then
				local task = tasks[entry.taskName]
				privateTaskData[entry.taskName].handle(task, entry.fnName)
				table.remove(invokeLater, i)
			end
		end

		state.counter = state.counter + 1
	end,
	guiUpdate = function ()
		--add tasks
		for i = guiState.numtasksadded + 1, #taskOrder do
			local name = taskOrder[i]
			local ptd = privateTaskData[name]
			game.gui.addTask(name, ptd.getInfo())
			game.gui.setTaskProgress(name, ptd.getProgress())
			if not tasks[name]:isCompleted() then
				game.gui.showTask(name)
				guiState.voiceover.taskcaused = name
			end
		end
		guiState.numtasksadded = #taskOrder

		--update tasks
		for i = 1, #taskOrder do
			local name = taskOrder[i]
			local task = tasks[name]
			local ptd = privateTaskData[name]
			if task:isCompleted() then
				ptd.removeFinish(task) -- ensure finish handler and finish function gets set to nil also in gui
			else
				ptd.guiUpdate(task)
			end
		end

		--update progress
		for i = 1, #taskOrder do
			local name = taskOrder[i]
			local ptd = privateTaskData[name]
			local progress = ptd.getProgress()
			local justfinished = guiState.finishedtasks[name] == nil and progress.indicator.completed == true
			if justfinished then
				ptd.onGuiFinish(tasks[name])
				guiState.finishedtasks[name] = true
			end
			game.gui.setTaskProgress(name, progress)
		end

		--update enabled/visible
		for id, v in pairs(state.gui) do
			if v.enabled ~= nil then
				game.gui.setEnabled(id, v.enabled)
			end
			if v.visible ~= nil then
				game.gui.setVisible(id, v.visible)
			end
		end

		--update zones
		local zones = state.zones
		for key, zone in pairs(zones) do
			game.interface.setZone(key, zone ~= -1 and zone or nil)
		end

		--update markers
		local markers = state.markers
		for key, v in pairs(markers) do
			game.interface.setMarker(key, v ~= -1 and v.marker or nil)
		end

		--update music
		local track = state.music.track
		if track ~= guiState.lastmusictrack then
			guiState.lastmusictrack = track
			if track ~= nil then
				game.gui.playTrack(track, 0.0)
			end
		end

		game.gui.setMedalsCompletion(state.medals)
		if guiState.missioncompleted == nil and state.missioncompleted == true then
			guiState.missioncompleted = true
			game.gui.setMissionComplete(state.missionendtask)
		end
	end,
	guiInit = function ()
		eventHandlers.guiInit()
	end,
	save = function ()
		local taskstate = {}
		for i = 1, #taskOrder do
			local name = taskOrder[i]
			local task = tasks[name]
			taskstate[#taskstate + 1] = { name = name, progress = privateTaskData[name].getProgress() }
		end
		return { state = state, userstate = taskutil.userstate, taskstate = taskstate }
	end,
	load = function (allState)
		if allState == nil then
			return
		end

		state = allState.state
		taskutil.userstate = allState.userstate

		local taskstate = allState.taskstate
		for i = 1, #taskstate do
			local name = taskstate[i].name
			local task = tasks[name]
			local ptd = privateTaskData[name]
			ptd.load(task, { progress = taskstate[i].progress })

			--handle subtasks added/removed
			local progress = ptd.getProgress()
			local info = ptd.getInfo()
			local ninfo = #(info.subTasks or {})
			local nprogress = #progress.subIndicators
			if ninfo < nprogress then
				for i = ninfo + 1, nprogress do
					progress.subIndicators[i] = nil
				end
			elseif ninfo > nprogress then
				for i = nprogress + 1, ninfo do
					progress.subIndicators[i] = progress.indicator
				end
			end
		end
	end,
	handleEvent = function (src, id, name, param)
		if id == "__taskEvent__" then
			if name == "scriptfn" then
				local taskname = param.taskname
				local fnname = param.fnname
				local p = param.param
				local task = tasks[taskname]
				privateTaskData[taskname].handle(task, fnname, p)
			end
		end

		local result
		for i = 1, #taskOrder do
			local taskname = taskOrder[i]
			local task = tasks[taskname]
			if not task:isCompleted() then
				local ptd = privateTaskData[taskname]
				result = ptd.handle(task, "handleEvent", { id, name, param }) or result
			end
		end
		return result
	end,
	guiHandleEvent = function (id, name, param)
		if name == "visibilityChange" and game.gui ~= nil then
            --update enabled/visible
            for pid, v in pairs(state.gui) do
                if pid == id then
                    if v.enabled ~= nil then
                        game.gui.setEnabled(id, v.enabled)
                    end
                    if v.visible ~= nil then
                        game.gui.setVisible(id, v.visible)
                     end
                end
            end
        end
		if state.proposalCheckActive then
			local messages = handleProposal(id, name, param)
			if messages ~= nil then return messages end
		end

		if id == "mainView" and name == "select" then
			local markers = state.markers
			for k, v in pairs(markers) do
				if v ~= -1 then
					local handleEvent = false;
					local conEntity = game.interface.getConstructionEntity(param)
					if v.marker.entity == param or v.marker.entity == conEntity then
						handleEvent = true
					else
						local entity = game.interface.getEntity(param)
						if entity ~= nil and entity.town ~= nil then -- entity is a townBuilding
							if entity.town == v.marker.entity then
								handleEvent = true
							end
						elseif entity ~= nil and entity.stations then
							for k, w in pairs(entity.stations) do
								if game.interface.getConstructionEntity(w) == v.marker.entity or w == v.marker.entity then
									handleEvent = true
									break
								end
							end
						end
					end

					if handleEvent then
						local name = v.taskName
						local ptd = privateTaskData[name]
						local task = tasks[name]
						ptd.handle(task, v.fnName)
					end
				end
			end
		elseif id == "__missionEvent__" then
			if param.type == "OPTION" then
				local task = tasks[param.params.taskId]
				privateTaskData[param.params.taskId].handle(task, param.params.value)
			elseif param.type == "MARKER" then
				local m = state.markers[param.params.key]
				local name = m.taskName
				local ptd = privateTaskData[name]
				local task = tasks[name]
				ptd.handle(task, m.fnName)
			end
		elseif id == "__missionCallback__" then
		elseif id == "musicPlayer" and name == "trackEnded" then
			if state.music.track ~= nil then
				game.gui.playTrack(state.music.track, 0.0)
			end
		elseif id == "mainView" and name == "link.click" then
			local task = tasks[taskutil.settings.mainTask]
			privateTaskData[taskutil.settings.mainTask].handle(task, param)
		elseif id == "voiceover" then
			local vo = guiState.voiceover
			if name == "end" then
				if vo.active then
					vo.active = false
					if vo ~= nil then
						local name = vo.taskcaused
						vo.taskcaused = nil

						if name ~= nil then
							local task = tasks[name]
							local ptd = privateTaskData[name]
							ptd.handle(task, "voiceOverEnded")
						end
					end
				end
			elseif name == "start" then
				vo.active = true
			end
		elseif name == "button.click" and id:sub(1, #"tasklist.") == "tasklist." then
			game.gui.setHighlighted(id, false)
			guiState.voiceover.taskcaused = id:sub(#"tasklist." + 1)
		end

		local result
		for i = 1, #taskOrder do
			local taskname = taskOrder[i]
			local task = tasks[taskname]
			if not task:isCompleted() then
				local ptd = privateTaskData[taskname]
				result = ptd.handle(task, "guiHandleEvent", { id, name, param }) or result
			end
		end
		return result
	end,
}

return taskutil
