require "gui"

local vec2 = require "vec2"

local selectortooltip = {}

local state = {
	entity = -1,
	lastEntity = -1,
	toolTipComp = nil
}

local defaultNames = {
	_("Oh, what's that?"),
	_("Something mysterious"),
	_("Easter Egg"),
	_("Nothing to see here"),
	_("You didn't see anything..."),
	_("Hello there"),
}

selectortooltip.script = {
	save = function ()
		return { }
	end,
	load = function (state)

	end,
	guiUpdate = function ()
		if not api.engine.entityExists(state.entity)  then
			state.entity = -1
		end

		local containerComp = api.gui.util.getById("toolTipContainer")
		local containerLayout = containerComp:getLayout()

		if state.entity ~= state.lastEntity then
			containerLayout:deleteAll()

			state.toolTipComp = nil

			if state.entity >= 0 then
				local text = nil

				local name = api.engine.getComponent(state.entity, api.type.ComponentType.NAME)
				if name then text = name.name end

				local townBuilding = api.engine.getComponent(state.entity, api.type.ComponentType.TOWN_BUILDING)
				if townBuilding then
					local personCapacity = api.engine.getComponent(townBuilding.personCapacity, api.type.ComponentType.PERSON_CAPACITY)

					if personCapacity.type == 0 then text = _("Residential building") end
					if personCapacity.type == 1 then text = _("Commercial building") end
					if personCapacity.type == 2 then text = _("Industrial building") end
				end

				local baseNode = api.engine.getComponent(state.entity, api.type.ComponentType.BASE_NODE)
				if baseNode then text = _("Double slip switch") end

				local railroadCrossing = api.engine.getComponent(state.entity, api.type.ComponentType.RAILROAD_CROSSING)
				if railroadCrossing then text = _("Railroad crossing") end

				local isBridge = false
				local isTunnel = false
				local typeName = ""
				local parallelStrip = api.engine.getComponent(state.entity, api.type.ComponentType.BASE_PARALLEL_STRIP)
				if parallelStrip then
					local bridgeType = 1
					local tunnelType = 2
					for __, rangeGroup in ipairs(parallelStrip.rangeGroups) do
						for __, range in ipairs(rangeGroup) do
							local edgeEntity = range.edge
							local baseEdge = api.engine.getComponent(edgeEntity, api.type.ComponentType.BASE_EDGE)
							if baseEdge then
								local edgeType = baseEdge.type
								local index = baseEdge.typeIndex
								if edgeType == bridgeType then
									isBridge = true
									local bridgeType = api.res.bridgeTypeRep.get(index)
									typeName = bridgeType.name
								elseif edgeType == tunnelType then
									isTunnel = true
									local tunnelType = api.res.tunnelTypeRep.get(index)
									typeName = tunnelType.name
								end
							end
						end
					end
				end
				if isBridge or isTunnel then text = typeName end

				if text == nil then text = defaultNames[(state.entity % #defaultNames) + 1] end

				local textView = api.gui.comp.TextView.new(text)
				textView:setId("toolTipContainer.toolTip.text")

				local layout = api.gui.layout.BoxLayout.new("VERTICAL")
				layout:setId("toolTipContainer.toolTip.layout")
				layout:addItem(textView)

				--[[local stationGroup = api.engine.getComponent(state.entity, api.type.ComponentType.STATION_GROUP)
				if stationGroup then
					local time = 0
					local thres = 500000
					local stationGroupDisplay = api.gui.StationGroupDisplayComp.new(state.entity)
					stationGroupDisplay:setMinimumSize(api.gui.Size.new(400, 0))
					stationGroupDisplay:onStep(function(totalTime, frameTime)
						if time > 10 * thres then return end

						time = time + frameTime
						
						local height = math.round(time < thres and .0 or (time - thres) / 1000)
						local width = math.clamp(math.round(time < thres and .0 or (time - thres) / 100), 0, 400)

						stationGroupDisplay:setMaximumSize(api.gui.Size.new(width, height))
					end)

					layout:addItem(stationGroupDisplay)
				end]]--

				state.toolTipComp = api.gui.comp.Component.new("ToolTip")
				state.toolTipComp:setId("toolTipContainer.toolTip")
				state.toolTipComp:setLayout(layout)
				state.toolTipComp:setTransparent(true)

				containerLayout:addItem(state.toolTipComp, api.gui.util.Rect.new(0, 0, -1, -1))
			end

			state.lastEntity = state.entity
		end
		
		if state.toolTipComp then
			local mousePosition = game.gui.getMousePos()
			local rect = containerComp:getContentRect()
			containerLayout:setPosition(0, mousePosition[1] - rect.x, mousePosition[2] - rect.y)
		end
	end,
	guiHandleEvent = function (id, name, param)
		if id == "mainView" and name == "hover" then
			state.entity = param
		end
	end
}

return selectortooltip
