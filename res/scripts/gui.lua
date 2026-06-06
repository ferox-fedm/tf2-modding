gui = { }

gui.buttoncallbacks = { }

gui.windowcallbacks = { }

local componentMetatable = { __index = {
	setLayout = function(self, layout)
		game.gui.component_setLayout(self.id, layout.id)
	end,
	setToolTip = function(self, toolTip)
		game.gui.component_setToolTip(self.id, toolTip)
	end,
	setStyleClassList = function(self, list)
		game.gui.component_setStyleClassList(self.id, list)
	end,
	setTransparent = function(self, transparent)
		game.gui.component_setTransparent(self.id, transparent)
	end,
	addNavigation = function (self)
		game.gui.component_addNavigation(self.id)
	end,
} }

local windowMetatable = { __index = {
	close = function (self)
		game.gui.window_close(self.id)
	end,
	setTitle = function (self, title)
		game.gui.window_setTitle(self.id, title)
	end,
	setIcon = function (self, icon)
		game.gui.window_setIcon(self.id, icon)
	end,
	onClose = function (self, fn)
		gui.windowcallbacks[self.id] = fn
	end,
} }

local absoluteLayoutMetatable = { __index = {
	addItem = function (self, child)
		game.gui.absoluteLayout_addItem(self.id, child.id)
	end,
	deleteAll = function (self)
		game.gui.absoluteLayout_deleteAll(self.id)
	end,
	setPosition = function (self, idx, x, y)
		game.gui.absoluteLayout_setPosition(self.id, idx, x, y)
	end,
} }

local boxLayoutMetatable = { __index = {
	addItem = function (self, child)
		game.gui.boxLayout_addItem(self.id, child.id)
	end,
} }

local textViewMetatable = { __index = {
	setText = function (self, text, width)
		game.gui.textView_setText(self.id, text, width)
	end
} }

local imageViewMetatable = { __index = {
	setImage = function (self, path)
		game.gui.imageView_setImage(self.id, path)
	end
} }

local buttonMetatable = { __index = {
	onClick = function (self, fn)
		gui.buttoncallbacks[self.id] = fn
	end,
} }

local tableMetatable = { __index = {
	addRow = function (self, items)
		local items2 = {}
		for _,v in pairs(items) do items2[#items2 + 1] = v.id end
		game.gui.table_addRow(self.id, items2)
	end
} }

local scrollAreaMetatable = { __index = {

} }

setmetatable(windowMetatable.__index, componentMetatable)
setmetatable(textViewMetatable.__index, componentMetatable)
setmetatable(imageViewMetatable.__index, componentMetatable)
setmetatable(buttonMetatable.__index, componentMetatable)
setmetatable(tableMetatable.__index, componentMetatable)
setmetatable(scrollAreaMetatable.__index, componentMetatable)

function gui.window_create(id, title, child)
	game.gui.window_create(id, title, child.id)
	return gui.window_get(id)
end

function gui.window_get(id)
	local window = {
		id = id,
	}
	setmetatable(window, windowMetatable)
	return window
end

function gui.boxLayout_create(id, orientation)
	game.gui.boxLayout_create(id, orientation)
	return gui.boxLayout_get(id)
end

function gui.boxLayout_get(id, orientation)
	local boxLayout = {
		id = id,
	}
	setmetatable(boxLayout, boxLayoutMetatable)
	return boxLayout
end

function gui.absoluteLayout_get(id)
	local absoluteLayout = {
		id = id,
	}
	setmetatable(absoluteLayout, absoluteLayoutMetatable)
	return absoluteLayout
end

function gui.component_create(id, name)
	game.gui.component_create(id, name)
	return gui.component_get(id)
end

function gui.component_get(id)
	local component = {
		id = id,
	}
	setmetatable(component, componentMetatable)
	return component
end

function gui.textView_create(id, text, width, iaHintSupport)
	game.gui.textView_create(id, text, width, iaHintSupport)
	return gui.textView_get(id)
end

function gui.textView_get(id)
	local textView = {
		id = id,
	}
	setmetatable(textView, textViewMetatable)
	return textView
end

function gui.imageView_create(id, path)
	game.gui.imageView_create(id, path)
	return gui.imageView_get(id)
end

function gui.imageView_get(id, path)
	local imageView = {
		id = id,
	}
	setmetatable(imageView, imageViewMetatable)
	return imageView
end

function gui.button_create(id, content)
	game.gui.button_create(id, content.id)
	return gui.button_get(id)
end

function gui.button_get(id, content)
	local button = {
		id = id,
	}
	setmetatable(button, buttonMetatable)
	return button
end

function gui.table_create(id, name, nrows)
	game.gui.table_create(id, name, nrows)
	return gui.table_get(id)
end

function gui.table_get(id, content)
	local table = {
		id = id,
	}
	setmetatable(table, tableMetatable)
	return table
end

function gui.scrollArea_create(id, content)
	game.gui.scrollArea_create(id, content.id)
	return gui.scrollArea_get(id)
end

function gui.scrollArea_get(id, content)
	local scrollArea = {
		id = id,
	}
	setmetatable(scrollArea, scrollAreaMetatable)
	return scrollArea
end

return gui
