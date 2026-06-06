--[[local TaskManager = {
	tasks = { },
	reg = { }
}

function TaskManager:new(o)
	o = o or { }	-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end]]

local TaskManager = { }
TaskManager.__index = TaskManager

function TaskManager.new()
	local tm = {
		reg = { },
		tasks = { },
		taskIds = { },
		state = {
			userState = { },

			zones = { },
			markers = { },
			gui = { }
		}
	}
	setmetatable(tm, TaskManager)
	return tm
end

function TaskManager:register(taskName, fn, ...)
	assert(self.reg[taskName] == nil)

	local args = {...}

	self.reg[taskName] = function () return fn(table.unpack(args)) end
end

function TaskManager:gen(taskName, taskId)
	taskId = taskId or taskName

	assert(self.taskIds[taskId] == nil)

	local task = self.reg[taskName]()
	self.tasks[#self.tasks + 1] = { name = taskName, task = task, id = taskId }
	self.taskIds[taskId] = task
	return task
end

function TaskManager:add(taskName, data, taskId)
	local task = self:gen(taskName, taskId)
	task.init(self, data)
	return task
end

--[[function TaskManager:get(index)
	return self.tasks[index].task
end]]

--[[function TaskManager:getId(index)
	return self.tasks[index].id
end]]

function TaskManager:getId(task)
	for k, v in pairs(self.taskIds) do
		if v == task then
			return k
		end
	end
	return nil
end

function TaskManager:getById(id)
	return self.taskIds[id]
end

function TaskManager:save()
	local result = { }

	for i = 1, #self.tasks do
		local t = self.tasks[i]
		result[#result + 1] = { name = t.name, id = t.id, data = t.task.save() }
	end

	return { self.state, result }
end

function TaskManager:load(state2)
	self.tasks = { }
	self.taskIds = { }

	self.state = state2[1]
	local state = state2[2]

	for i = 1, #state do
		local task = self:gen(state[i].name, state[i].id)
		task.load(state[i].data)
	end

	if self.state.buildInPauseModeAllowed == false then
		game.interface.setBuildInPauseModeAllowed(false)
	end

	for key, zone in pairs(self.state.zones) do
		game.interface.setZone(key, zone)
	end

	for key, marker in pairs(self.state.markers) do
		game.interface.setMarker(key, marker)
	end
end

function TaskManager:update()
	for i = 1, #self.tasks do
		local t = self.tasks[i].task
		if not t.isCompleted() then
			t.update(self)
		end
	end
end

function TaskManager:getState()
	if self.state.state then return self.state.state end

	for i = 1, #self.tasks do
		local t = self.tasks[i]
		local info = t.task.getInfo()

		if info.visible and not t.task.isCompleted() then
			return "RUNNING"
		end
	end

	return "COMPLETED"
end

function TaskManager:getTaskIds()
	local result = { }

	for i = 1, #self.tasks do
		local t = self.tasks[i]
		result[#result + 1] = t.id
	end

	return result
end

function TaskManager:setState(state)
	self.state.state = state
end

function TaskManager:getUserState()
	return self.state.userState
end

function TaskManager:setBuildInPauseModeAllowed(allowed)
	self.state.buildInPauseModeAllowed = allowed

	game.interface.setBuildInPauseModeAllowed(allowed)
end

function TaskManager:setZone(key, zone)
	self.state.zones[key] = zone

	game.interface.setZone(key, zone)
end

function TaskManager:setMarker(key, marker)
	self.state.markers[key] = marker

	game.interface.setMarker(key, marker)
end

function TaskManager:initGui()
	assert(game.gui ~= nil)

	for id, props in pairs(self.state.gui) do
		if props.enabled ~= nil then game.gui.setEnabled(id, props.enabled) end
		if props.visible ~= nil then game.gui.setVisible(id, props.visible) end
		if props.highlighted ~= nil then game.gui.setHighlighted(id, props.highlighted) end
	end
end

function TaskManager:guiSetEnabled(id, enabled)
	if not self.state.gui[id] then self.state.gui[id] = { } end
	self.state.gui[id].enabled = enabled

	if game.gui then game.gui.setEnabled(id, enabled) end
end

function TaskManager:guiSetVisible(id, visible)
	if not self.state.gui[id] then self.state.gui[id] = { } end
	self.state.gui[id].visible = visible

	if game.gui then game.gui.setVisible(id, visible) end
end

function TaskManager:guiSetHighlighted(id, highlighted)
	if not self.state.gui[id] then self.state.gui[id] = { } end
	self.state.gui[id].highlighted = highlighted

	if game.gui then game.gui.setHighlighted(id, highlighted) end
end

return TaskManager
