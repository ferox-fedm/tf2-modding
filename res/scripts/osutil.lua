local osutil = {}

function osutil.getConsoleGen()
	local result
	local os = getBuildOS();
	if ((os == "OS_PS4") or (os == "OS_XBOX_ONE")) then result = 1        
	elseif ((os == "OS_PS5") or (os == "OS_XBOX_SERIES")) then result = 2 
	else result = 3 end
	return result
end

return osutil
