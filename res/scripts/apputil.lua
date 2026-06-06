local apputil = {}

function apputil.isCouchUiMode()
	return api.util ~= nil and api.util.getAppConfig ~= nil and api.util.getUiMode() == api.type.enum.UiMode.Couch
end

function apputil.getClassicOrCouch(classic, couch)
	if apputil.isCouchUiMode() then
		return couch
	end

	return classic
end

function apputil.isGamepadInputMode()
	return api.gui ~= nil and api.gui.util.getInputMode ~= nil and api.gui.util.getInputMode() == api.type.enum.InputMode.Gamepad
end

function apputil.getMouseOrGamepad(mouse, gamepad)
	if apputil.isGamepadInputMode() then
		return gamepad
	end

	return mouse
end

return apputil
