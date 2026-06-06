local util = {}

local taskutil = require "mission.taskutil"

function util.counttrees()
	taskutil.userstate.treecachecount = taskutil.userstate.treecachecount or 1
	taskutil.userstate.treecachecount = taskutil.userstate.treecachecount - 1
	if taskutil.userstate.treecache and taskutil.userstate.treecachecount > 0 then
		return taskutil.userstate.treecache
	end
	taskutil.userstate.treecachecount = 25
	local count = 0
	local trees = game.interface.getEntities({ radius = 1e100 }, {type = "ASSET_GROUP"})
	for i = 1, #trees do
		local e = game.interface.getEntity(trees[i])
		local mdls = e.models
		for k,v in pairs(mdls) do
			if k:sub(1, 4) == "tree" then
				count = count + v
			end
		end
	end
	taskutil.userstate.treecache = count
	return count
end

return util
