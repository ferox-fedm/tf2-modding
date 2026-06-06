local missionutil = { }

missionutil.colors = { }
missionutil.colors.RED = { .9, .0, .0, .7 }
missionutil.colors.GREEN = { .0, .85, .0, .7 }
missionutil.colors.BLUE = { .0, .0, .85, .7 }
missionutil.colors.YELLOW = { .9, .85, .05, .7 }
missionutil.colors.WHITE = { .8, .8, .8, .7 }

function missionutil.makeCircleZone(pos, radius, num)
	num = num or 24

	local result = { }
	for i = 1, num do
		local s = 2.0 * math.pi * (i - 1) / num
		result[i] = { pos[1] + radius * math.cos(s), pos[2] + radius * math.sin(s) }
	end
	return result
end

function missionutil.makeTask(info)
	if info.visible == nil then info.visible = true end

	local options2 = { }
	local key2handler = { }

	for i = 1, info.options and #info.options or 0 do
		local opt = info.options[i]
		local key = tostring(i)
		options2[i] = { opt[1], key }
		key2handler[key] = opt[2]
	end

	info.options = options2

	local task = {
		info = info,
		state = {
			progress = {
				optionsAvailable = true,
				unavailableOptions = { },
				medals = { },
				indicator = { completed = false, type = "BOOL" },
				subIndicators = { }
			},
			userState = { },
			result = { },
		}
	}
	
	for i = 1, info.subTasks and #info.subTasks or 0 do
		task.state.progress.subIndicators[#task.state.progress.subIndicators + 1] = { completed = false, type = "BOOL" }
	end

	local function getProgressIndicator(subTask)
		if subTask then
			return task.state.progress.subIndicators[subTask]
		end

		return task.state.progress.indicator
	end

	local eventHandlers = {
		event = { }
	}

	local function addHandler(name, fn)
		local handlers = eventHandlers[name]
		handlers[#handlers + 1] = fn
	end

	local function callHandlers(name, ...)
		local handlers = eventHandlers[name]
		for i = 1, #handlers do
			handlers[i](table.unpack({...}))
		end
	end

	task.fn = {
		init = function (data)

		end,

		save = function ()
			return task.state
		end,

		load = function (data)
			task.state = data

			if not task.state.progress.unavailableOptions then
				task.state.progress.unavailableOptions = { }
			end
		end,

		update = function (taskManager)

		end,

		getInfo = function ()
			return task.info
		end,

		getProgress = function ()
			return task.state.progress
		end,

		handleEvent = function (taskManager, event)
			if event.type == "OPTION" then
				if not task.state.progress.indicator.completed and task.state.progress.optionsAvailable then
					task.state.result.optionValue = event.params.value

					local result = key2handler[event.params.value](taskManager, task.fn)

					if not result then
						task.state.progress.optionsAvailable = false
					end
				end
			end
		end,

		handleEventNew = function (name, param)
			callHandlers("event", name, param)
		end,


		isCompleted = function (subTask)
			return getProgressIndicator(subTask).completed
		end,

		setCompleted = function (subTask)
			getProgressIndicator(subTask).completed = true
		end,

		setProgressNone = function (subTask)
			local indicator = getProgressIndicator(subTask)
			indicator.type = "NONE"
			indicator.params = nil
		end,

		setProgressBool = function (subTask)
			local indicator = getProgressIndicator(subTask)
			indicator.type = "BOOL"
			indicator.params = nil
		end,

		setProgressText = function (value, subTask)
			local indicator = getProgressIndicator(subTask)

			if indicator.type ~= "TEXT" then
				indicator.type = "TEXT"
				indicator.params = { }
			end
			
			indicator.params.value = value
		end,

		setProgressPercent = function (value, subTask)
			local indicator = getProgressIndicator(subTask)

			if indicator.type ~= "PERCENT" then
				indicator.type = "PERCENT"
				indicator.params = { }
			end
			
			indicator.params.value = value
		end,

		setProgressCount = function (count, total, subTask)
			local indicator = getProgressIndicator(subTask)

			if indicator.type ~= "COUNT" then
				indicator.type = "COUNT"
				indicator.params = { }
			end
			
			indicator.params.count = count
			indicator.params.total = total
		end,

		setOptionsAvailable = function (value)
			task.state.progress.optionsAvailable = value
		end,

		setOptionAvailable = function (index, value)
			task.state.progress.unavailableOptions[index] = not value or nil
		end,

		hasMedal = function (medalId)
			return task.state.progress.medals[medalId] == true
		end,

		addMedal = function (medalId)
			task.state.progress.medals[medalId] = true
		end,

		getUserState = function ()
			return task.state.userState
		end,

		getResult = function ()
			return task.state.result
		end,

		onEvent = function (fn)
			addHandler("event", fn)
		end
	}

	return task.fn
end

function missionutil.makeMissionInterface(tm)
	local eventHandlers = {
		init = { },
		initGui = { },
		load = { },
		update = { },
		markerEvent = { }
	}

	local callbacks = {

	}

	local function addHandler(name, fn)
		local handlers = eventHandlers[name]
		handlers[#handlers + 1] = fn
	end

	local function callHandlers(name, data)
		local handlers = eventHandlers[name]
		for i = 1, #handlers do
			handlers[i](data)
		end
	end

	local numTasksAdded = 0
	local prevState

	local script = {
		update = function ()
			tm:update()

			callHandlers("update")

			game.interface.setMissionState(tm:getState())
		end,
		handleEvent = function (src, id, name, param)
			if id == "__taskEvent__" then
				local task = tm:getById(param.taskId)
				task.handleEventNew(name, param.param)
			end
		end,
		init = function ()
			assert(false)
		end,
		save = function ()
			return tm:save()
		end,
		load = function (state)
			if state == nil then
				callHandlers("init")
			else
				tm:load(state)
				callHandlers("load")
			end
		end,
		guiInit = function ()
			tm:initGui()
			callHandlers("initGui")
		end,
		guiUpdate = function ()
			--tm:guiUpdate()

			--callHandlers("guiUpdate")

			local state = tm:getState()
			local taskIds = tm:getTaskIds()

			if state == "COMPLETED" and prevState == "RUNNING" then
				local medals = { }
				for i = 1, #taskIds do
					local t = tm:getById(taskIds[i])
					local prog = t.getProgress()
					for k, v in pairs(prog.medals) do
						medals[k] = v
					end
				end

				game.gui.setMissionComplete(medals)
			end

			prevState = state


			for i = numTasksAdded + 1, #taskIds do
				local t = tm:getById(taskIds[i])
				game.gui.addTask(taskIds[i], t.getInfo())
			end

			numTasksAdded = #taskIds

			for i = 1, #taskIds do
				local t = tm:getById(taskIds[i])
				game.gui.setTaskProgress(taskIds[i], t.getProgress())
			end
		end,
		guiHandleEvent = function (id, name, param)
			if id == "__missionEvent__" then
				if param.type == "OPTION" then
					local task = tm:getById(param.params.taskId)
					task.handleEvent(tm, param)
				elseif param.type == "MARKER" then
					callHandlers("markerEvent", param.params)
				end
			elseif id == "__missionCallback__" then
				local callback = callbacks[name]
				if callback then return callback(param) end
			end
		end
	}

	return {
		onInit = function (fn)
			addHandler("init", fn)
		end,
		
		onInitGui = function (fn)
			addHandler("initGui", fn)
		end,

		onLoad = function (fn)
			addHandler("load", fn)
		end,

		onUpdate = function (fn)
			addHandler("update", fn)
		end,

		onMarkerEvent = function (fn)
			addHandler("markerEvent", fn)
		end,

		setCallback = function (type, fn)
			callbacks[type] = fn
		end,

		script = script
	}
end

function missionutil.sendEvent(taskManager, task, name, param)
	game.interface.sendScriptEvent("__taskEvent__", name, { taskId = taskManager:getId(task), param = param })
end

function missionutil.addTask(taskName, data, taskId)
	return function (taskManager) taskManager:add(taskName, data, taskId) end
end

function missionutil.checkTownsConnected(towns, carrier, transportModes)
	local stations0 = game.interface.getStations({ town = towns[1], townRadius = 500.0, carrier = carrier })
	
	for k = 2, #towns do
		local stations1 = game.interface.getStations({ town = towns[k], townRadius = 500.0, carrier = carrier })
		
		local reachedStations = { }
		
		for i = 1, #stations0 do
			for j = 1, #stations1 do
				local path = game.interface.findPath(stations0[i], stations1[j], transportModes)
					
				if path then
					reachedStations[#reachedStations + 1] = stations1[j]
				end
			end
		end
		
		if  #reachedStations == 0 then return false end
		
		stations0 = reachedStations
	end
	
	return true
end

function missionutil.getConstructionNextToConstruction(constr, radius, type, testFn)
	local constrData = game.interface.getEntity(constr)
	local candidates = game.interface.getEntities({ pos = constrData.position, radius = radius }, { type = type })
	for i = 1, #candidates do
		local o = game.interface.getEntity(candidates[i])
		if (testFn(o)) then
			return o
		end
	end
	return nil
end

function missionutil.makeMessageTask(title, message, voiceOver, doneFn)
	local function fn(taskManager, task)
		task.setCompleted()
	end

	local info = {
		name = title,
		description = message,
		voiceOver = voiceOver,
		options = { { _("MISSONUTIL_MAKEMESSAGETASK_OPTION"), fn } }, --Schliessen
	}

	info.optionsRightAlign = true
	local task = missionutil.makeTask(info)
	task.setProgressNone()
	
	return task
end

function missionutil.completeAllTasks(taskManager)
	local allTasks = taskManager.tasks
	for i=1, #allTasks do
		taskManager:getById(allTasks[i].id).setCompleted()
	end
end

function missionutil.startTaskIfCompleted(taskManager, nextTask, requirements)
	local allDone = true
	for i=1, #requirements do
		local task = taskManager:getById(requirements[i])
		if task ~= nil then
			if not task.isCompleted() then
				allDone = false
			end
		end
	end
	if allDone then
		missionutil.startTask(taskManager, nextTask)
	end
end

function missionutil.isCompleted(taskManager, id)
	local task = taskManager:getById(id)
	if (task ~= nil) then
		return task.isCompleted()
	end
	return false
end

function missionutil.startTask(taskManager, name, data, key)
	if (taskManager:getById(key or name) == nil) then
		taskManager:add(name, data, key)
	end
end

function missionutil.days(date)
	local ref = { d=date.day, m=date.month, y=date.year }
    if ref.m <= 2 then
      ref.y = ref.y - 1
      ref.m = ref.m + 9
    else
      ref.m = ref.m - 3
    end
    local era = math.floor(ref.y/400)
    local yoe = ref.y - era * 400                                       
    local doy = math.modf((153*ref.m + 2)/5) + ref.d-1                  
    local doe = yoe * 365 + math.modf(yoe/4) - math.modf(yoe/100) + doy 
    return era * 146097 + doe - 719468
end


function missionutil.isPastDate(date)
	local now = game.interface.getGameTime().date
	local other = {}
	other.year = date.year
	other.month = date.month or 1
	other.day = date.day or 1
	
	if (other.year < now.year) then
		return true
	elseif (other.year == now.year) then
		if (other.month < now.month) then
			return true
		elseif (other.month == now.month) then
			if (other.day < now.day) then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function missionutil.shuffleTable( t )
    local rand = math.random 
    assert( t, "shuffleTable() expected a table, got nil" )
    local iterations = #t
    local j
    
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

function missionutil.makeMoneyString(num)
	local str = tostring(math.floor(num))
	local pos = -1
	local res = ""
	while string.len(str)+pos+1 > 3 do
		res = string.sub(str, pos-2, pos) .. res
		pos = pos-3
		if string.len(str)+pos+1 > 0 then
			res = "'" .. res
		end
	end
	res = string.sub(str, 1, pos) .. res
	return res
end

function missionutil.makeReadableNumber(num)
	local str = tostring(num)
	local pos = -1
	local res = ""
	while string.len(str)+pos+1 > 3 do
		res = string.sub(str, pos-2, pos) .. res
		pos = pos-3
		if string.len(str)+pos+1 > 0 then
			res = " " .. res
		end
	end
	res = string.sub(str, 1, pos) .. res
	return res
end

function missionutil.makeMissionCompleteTask(info, fn)
	local task = missionutil.makeTask(info)
	
	task.update = function (taskManager)
		if task.isCompleted() then return end
		
		if not task.getUserState().completed then
			task.getUserState().completed = true
		else
			fn(taskManager, task)
		end
	end
	
	task.setProgressNone()

	return task
end

function missionutil.makeTaskMoneyOffer(taskParams)

	local info = {
		title = _("MISSONUTIL_MAKEMONEYTASKOFFER_TITLE"), --Geld fast aufgebraucht
		name = _("MISSONUTIL_MAKEMONEYTASKOFFER_TEXT"), --Kredit aufnehmen
		paragraphs = {
			{ text = taskParams.message }
        },
		voiceOver = taskParams.voiceOver,
		options = {
			{ _("MISSONUTIL_MAKEMONEYTASKOFFER_OPTION") % { credit = taskParams.credit }, --Kredit aufnehmen (${credit})
				function (taskManager, task) 
					game.interface.book(taskParams.credit, true)
					task.setCompleted() 
					local taskMoneyUserState = taskManager:getById("taskMoney").getUserState()
					taskMoneyUserState.current = taskMoneyUserState.current + 1
					taskMoneyUserState.standingOffer = false
				end 
			}, 
		},
	}

	local task = missionutil.makeTask(info)

	task.setProgressNone()
	
	return task
end

function missionutil.makeTaskMoneyFinal(taskParams)

	local info = {
		title = _("MISSONUTIL_MAKEMONEYTASKFINAL_TITLE"), --Geld aufgebraucht
		name = _("MISSONUTIL_MAKEMONEYTASKFINAL_NAME"), --Geld aufgebraucht
		paragraphs = {
			{ text = taskParams.message }
        },
		voiceOver = taskParams.voiceOver,
		options = {
			{ _("MISSONUTIL_MAKEMONEYTASKFINAL_OPTION"), --Das ist bedauerlich!
				function (taskManager, task) 
					task.setCompleted() 
					taskManager:getById("taskMoney").getUserState().current = taskManager:getById("taskMoney").getUserState().current + 1
					taskManager:getById("taskMoney").getUserState().standingOffer = false	
				end 
			}, 
		},
	}

	local task = missionutil.makeTask(info)

	task.setProgressNone()
	
	return task
end

function missionutil.makeTaskMoney(taskParams)

	local info = {
		name = "Hidden Money Task",
		visible = false
	}

	local task = missionutil.makeTask(info)
		
	task.init = function (taskManager, data)
		task.getUserState().current = 1
		task.getUserState().standingOffer = false
		game.interface.clearJournal()
		game.interface.book(taskParams.startBudget, true)
		game.interface.setMinimumLoan(game.interface.getPlayer(), 100000000)
	end
			
	task.update = function (taskManager)
		game.interface.setMaximumLoan(game.interface.getPlayer(), 0)
	
		if task.isCompleted() then return end
		if task.getUserState().standingOffer then return end
			
		local balance = game.interface.getEntity(game.interface.getPlayer()).balance
		local current = task.getUserState().current 
		
		if balance <= 0 and current == taskParams.stages then
			task.getUserState().standingOffer = true
			taskManager:add("taskMoneyFinal")
		end
				
		if balance < taskParams.loanTrigger and current < taskParams.stages then
			task.getUserState().standingOffer = true
			taskManager:add("taskMoneyOffer"..current)
		end
		
	end

	return task
end

function missionutil.registerMoneyTask(tm, taskMoneyOverride, taskMoneyOfferOverride)

	local taskMoney = taskMoneyOverride or
	{
		startBudget = 2000000,
		loanTrigger = 250000,
		loanFactor = 1
	}
	
	local taskMoneyOffer = taskMoneyOfferOverride or {
		{
			credit = 2000000 * taskMoney.loanFactor,
			message = _("MISSONUTIL_MONEY01_MESSAGE"), --Das Geld zerrinnt uns zwischen den Fingern – wir sind demnächst pleite. Aber wenn wir bereit sind, unterwürfigst zu betteln, lassen unsere Geldgeber einen kleinen Überbrückungskredit springen...
			voiceOver = "money_01.wav",
		},
		{
			credit = 1000000 * taskMoney.loanFactor,
			message = _("MISSONUTIL_MONEY02_MESSAGE"), --Grundgütiger, das Geld geht weg wie warme Semmeln. Ausnahmsweise würden unsre Geldgeber beide Augen zudrücken und uns ein weiteres Mal aushelfen. Das ist aber definitiv das letzte Mal!
			voiceOver = "money_02.wav",
		},
		{
			credit = 0,
			message = _("MISSONUTIL_MONEY03_MESSAGE"), --Ende Gelände. Es hilft kein Bitten und Betteln. Unsere Financiers weigern sich, auch nur noch einen weiteren Cent in unser Projekt zu stecken. Verdammt!
			voiceOver = "money_03.wav",
		}
	}
	
	taskMoney.stages = #taskMoneyOffer
	
	tm:register("taskMoney", 					missionutil.makeTaskMoney, 					taskMoney)
	for i = 1, taskMoney.stages - 1 do
		tm:register("taskMoneyOffer" .. i,				missionutil.makeTaskMoneyOffer, 			taskMoneyOffer[i])
	end
	tm:register("taskMoneyFinal",				missionutil.makeTaskMoneyFinal, 			taskMoneyOffer[taskMoney.stages])

end

return missionutil
