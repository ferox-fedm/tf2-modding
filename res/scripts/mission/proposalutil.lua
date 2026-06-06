local vec2 = require "vec2"
local polygonutil = require "polygonutil"

local builderutil = {}

function builderutil.anglediff(alpha, beta)
	return math.abs((alpha - beta + math.pi) % (2 * math.pi) - math.pi)
end

function builderutil.closeEnough(transf, goal, tol)
	if tol == nil then
		tol = 12
	end

	local pos = vec2.new(transf[13], transf[14])
	local dist = vec2.length(vec2.sub(pos, goal))
	return dist < tol
end

function builderutil.segments2nodes(segments, newnodes)
	local newnodeslookup = {}
	if newnodes ~= nil then
		for i = 1, #newnodes do
			local n = newnodes[i]
			newnodeslookup[n.entity] = n
		end
	end

	local nodes = {}
	for i = 1, #segments do
		local t = { segments[i].comp.node0, segments[i].comp.node1 }
		for i = 1, #t do
			local node = t[i]
			if node >= 0 then
				nodes[node] = game.interface.getEntity(node)
			else
				nodes[node] = newnodeslookup[node].comp
			end
		end
	end
	return nodes
end

function builderutil.collectNodePositions(nodes)
	local t = {}
	for i = 1, #nodes do
		t[#t + 1] = nodes[i].comp.position
	end
	return t
end

function builderutil.table2size(t)
	local count = 0
	for k, v in pairs(t) do
		count = count + 1
	end
	return count
end

function builderutil.checkTrackSignal(trackEntity, id, name, param, isApply, fn)
	local err = _("track signals need to be placed in highlighted area")
	if id ~= "streetTerminalBuilder" then
		return err
	end
	local added = param.proposal.proposal.addedSegments
	local removed = param.proposal.proposal.removedSegments
	if #added ~= 1 or #removed ~= 1 then
		return err
	end
	if removed[1].entity == trackEntity or removed[1].entity == ((-trackEntity)-1) then
		local objects = added[1].comp.objects
		local edgeObjects = param.proposal.proposal.edgeObjectsToAdd
		if #objects ~= 1 or #objects ~= #edgeObjects then
			return err
		end
		if objects[1][2] == api.type.enum.EdgeObjectType.SIGNAL and edgeObjects[1].left == false then
			if isApply then
				fn()
			end
			return true
		else
			return err
		end
	else
		return err
	end
end

function builderutil.checkConstructionBuildOrBulldozeInAreas(areas, buildername)
	local function contains(pos)
		for i = 1, #areas do
			if polygonutil.contains(areas[i], pos) then
				return true
			end
		end
		return false
	end

	return function(id, name, param)
		if id ~= "constructionBuilder" and id ~= "bulldozer" then return false end

		local err =  _("not allowed to do this right now")
		local proposal = param.proposal
		if #proposal.toAdd + #proposal.toRemove == 0 then
			return err
		end

		local pos
		if id == "bulldozer" and #proposal.toRemove > 0 then
			local rem = proposal.toRemove
			if #proposal.proposal.removedSegments > 0 then
				for i = 1, #rem do --don't allow bulldozing streets with town buildings on them
					local e = game.interface.getEntity(rem[i])
					if e ~= nil then
						local tb = e.townBuildings
						if tb ~= nil and #tb > 0 then
							local pos
							pos = e.position
							if e.transf ~= nil then
								pos = { e.transf[13], e.transf[14] }
							end
							if contains(pos) then
								return err
							end
						end
					end
				end
		end
			local e = game.interface.getEntity(rem[1])
			if e == nil then return false end
			pos = e.position
			if e.transf ~= nil then
				pos = { e.transf[13], e.transf[14] }
			end
		elseif id ~= "bulldozer" and #proposal.toAdd > 0 then
			local t = proposal.toAdd[1].transf
			pos = { t[13], t[14] }
		end

		if contains(pos) then return true end

		return _("MISSION_PROPOSAL_FEEDBACK_NOT_ALLOWED_TO_BUILD_OR_BULLDOZE")
	end
end

local function checkTrackOrStreetBuildOrBulldozeInAreas(areas, buildername, sign)
	local function contains(pos)
		for i = 1, #areas do
			if polygonutil.contains(areas[i], pos) then
				return true
			end
		end
		return false
	end
	local function filteredbybuildername(segments)
		local result = {}
		for i = 1, #segments do
			if (segments[i].type == 0 and buildername == "streetBuilder") or (segments[i].type == 1 and buildername == "trackBuilder") then
				result[#result + 1] = segments[i]
			end
		end
		return result
	end
	local function removereplaced(segments, new2oldSegments)
		local result = {}
		for i = 1, #segments do
			if new2oldSegments[segments[i].entity] == nil then result[#result + 1] = segments[i] end
		end
		return result
	end

	return function(id, name, param)
		if id ~= buildername and id ~= "bulldozer" then return false end

		local proposal = param.proposal
		if #proposal.toAdd + #proposal.toRemove > 0 then
			return false
		end


		local streetProposal = proposal.proposal
		local err = _("not allowed to build or bulldoze here")

		local nodes
		if id == buildername then
			nodes = builderutil.segments2nodes(removereplaced(streetProposal.addedSegments, streetProposal.new2oldSegments), streetProposal.addedNodes)
		elseif id == "bulldozer" then
			nodes = builderutil.segments2nodes(filteredbybuildername(streetProposal.removedSegments))
			if next(nodes) == nil then return false end
		end
		for k, v in pairs(nodes) do
			if contains(v.position) == sign then
				return err
			end
		end
		return true
	end
end

function builderutil.checkStreetTerminalBuildOrBulldozeInAreas(areas)
	local function contains(pos)
		for i = 1, #areas do
			if polygonutil.contains(areas[i], pos) then
				return true
			end
		end
		return false
	end

	return function(id, name, param)
		if id ~= "streetTerminalBuilder" and id ~= "bulldozer" then return false end

		local err = _("not allowed to do this right now")
		local proposal = param.proposal
		if #proposal.toAdd + #proposal.toRemove > 0 then
			return err
		end

		local sp = proposal.proposal
		local nodes = builderutil.segments2nodes(sp.addedSegments, sp.addedNodes)
		for k, v in pairs(nodes) do
			if not contains(v.position) then
				return err
			end
		end

		if id == "bulldozer" then
			if #sp.addedNodes + #sp.removedNodes > 0 then return false end
			if #sp.edgeObjectsToAdd < #sp.edgeObjectsToRemove then
				return true
			end
		else
			return true
		end
	end
end

function builderutil.checkStreetModifierInAreas(areas)
	local function contains(pos)
		for i = 1, #areas do
			if polygonutil.contains(areas[i], pos) then
				return true
			end
		end
		return false
	end

	return function(self, id, name, param)
		if id ~= "streetTrackModifier" then return false end

		local sp = param.proposal.proposal
		local nodes = builderutil.segments2nodes(sp.addedSegments, sp.addedNodes)
		for k, v in pairs(nodes) do
			if not contains(v.position) then
				return err
			end
		end
		return true
	end
end

function builderutil.checkTrackBuildOrBulldozeInArea(area)
	return checkTrackOrStreetBuildOrBulldozeInAreas({area}, "trackBuilder", false)
end

function builderutil.checkTrackBuildOrBulldozeInAreaBlacklist(area)
	return checkTrackOrStreetBuildOrBulldozeInAreas({area}, "trackBuilder", true)
end

function builderutil.checkTrackBuildOrBulldozeInAreas(areas)
	return checkTrackOrStreetBuildOrBulldozeInAreas(areas, "trackBuilder", false)
end

function builderutil.checkStreetBuildOrBulldozeInArea(area)
	return checkTrackOrStreetBuildOrBulldozeInAreas({area}, "streetBuilder", false)
end

function builderutil.checkStreetBuildOrBulldozeInAreas(areas)
	return checkTrackOrStreetBuildOrBulldozeInAreas(areas, "streetBuilder", false)
end

return builderutil
