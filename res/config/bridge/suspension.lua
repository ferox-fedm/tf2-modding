local bridgeutil = require "bridgeutil"

function data()

local dir = "bridge/suspension/"

local pillarTargetDist = 252.0
local pillarMinDist = 12.0
local longTolerance = 45.0
local longMaxCurvature = 1.0 / 400.0 -- 1 / radius [m]

local input = {
	pillarBig = {
		pillarBase = { dir .. "pillar_btm_side.mdl", dir .. "pillar_btm_rep.mdl", dir .. "pillar_btm_side_2.mdl" },
		pillarRepeat = { dir .. "pillar_rep_side.mdl", dir .. "pillar_rep_rep_1.mdl", dir .. "pillar_rep_side_2.mdl" },
		pillarTop = { dir .. "pillar_top_side.mdl", dir .. "pillar_top_rep.mdl", dir .. "pillar_top_side_2.mdl" },
		pillarMain = { dir .. "pillar_main_top_side.mdl", dir .. "pillar_main_top_rep.mdl", dir .. "pillar_main_top_side_2.mdl" },
	},
	pillarBigWide = {
		pillarBase = { dir .. "pillar_btm_side.mdl", dir .. "pillar_btm_rep.mdl", dir .. "pillar_btm_side_2.mdl" },
		pillarRepeat = { dir .. "pillar_rep_side.mdl", dir .. "pillar_rep_rep_2.mdl", dir .. "pillar_rep_side_2.mdl" }, -- rep 2!
		pillarTop = { dir .. "pillar_top_side.mdl", dir .. "pillar_top_rep.mdl", dir .. "pillar_top_side_2.mdl" },
		pillarMain = { dir .. "pillar_main_top_side.mdl", dir .. "pillar_main_top_rep.mdl", dir .. "pillar_main_top_side_2.mdl" },
	},
	pillarSmall = {
		pillarBase = { dir .. "pillar_2_btm_side.mdl", dir .. "pillar_2_btm_rep.mdl", dir .. "pillar_2_btm_side_2.mdl" },
		pillarRepeat = { dir .. "pillar_2_rep_side.mdl", dir .. "pillar_2_rep_rep.mdl", dir .. "pillar_2_rep_side_2.mdl" },
		pillarTop = { dir .. "pillar_2_top_side.mdl", dir .. "pillar_2_top_rep.mdl", dir .. "pillar_2_top_side_2.mdl" },
	},

	railingRepeat1 = {
		dir .. "railing_rep_1_side.mdl",  dir .. "railing_rep_1_side.mdl",  dir .. "railing_rep_1_no_side.mdl",
		dir .. "railing_rep_rep.mdl", dir .. "railing_rep_rep.mdl",
		dir .. "railing_rep_1_side_2.mdl",  dir .. "railing_rep_1_side_2.mdl",  dir .. "railing_rep_1_no_side_2.mdl",
	},
	railingRepeat2 = {
		dir .. "railing_rep_2_side.mdl",  dir .. "railing_rep_2_side.mdl",  dir .. "railing_rep_2_no_side.mdl",
		dir .. "railing_rep_2_rep.mdl", dir .. "railing_rep_2_rep.mdl",
		dir .. "railing_rep_2_side_2.mdl",  dir .. "railing_rep_2_side_2.mdl",  dir .. "railing_rep_2_no_side_2.mdl",
	},

	railingLongBegin = {
		dir .. "railing_start_side.mdl",  dir .. "railing_start_side.mdl",  dir .. "railing_start_side.mdl",
		dir .. "railing_start_rep.mdl", dir .. "railing_start_rep.mdl",
		dir .. "railing_start_side_2.mdl", dir .. "railing_start_side_2.mdl", dir .. "railing_start_side_2.mdl",
	},
	railingLongEnd = {
		dir .. "railing_end_side.mdl",  dir .. "railing_end_side.mdl",  dir .. "railing_end_side.mdl",
		dir .. "railing_end_rep.mdl",  dir .. "railing_end_rep.mdl",
		dir .. "railing_end_side_2.mdl", dir .. "railing_end_side_2.mdl", dir .. "railing_end_side_2.mdl",
	},

	railingLongBeginStop = {
		dir .. "railing_start_stop_side.mdl",  dir .. "railing_start_stop_side.mdl",  dir .. "railing_start_stop_side.mdl",
		dir .. "railing_start_rep.mdl", dir .. "railing_start_rep.mdl",
		dir .. "railing_start_stop_side_2.mdl", dir .. "railing_start_stop_side_2.mdl", dir .. "railing_start_stop_side_2.mdl",
	},
	railingLongEndStop = {
		dir .. "railing_end_stop_side.mdl",  dir .. "railing_end_stop_side.mdl",  dir .. "railing_end_stop_side.mdl",
		dir .. "railing_end_rep.mdl",  dir .. "railing_end_rep.mdl",
		dir .. "railing_end_stop_side_2.mdl", dir .. "railing_end_stop_side_2.mdl", dir .. "railing_end_stop_side_2.mdl",
	},
}

local check = function(interval)
	return interval.lanes[1].type == 0 and interval.lanes[#interval.lanes].type == 0 and interval.curvature < longMaxCurvature
end

local updateFn = function(params)
	local modelData = params.state.models

	local longBeginLen = modelData[input.railingLongBegin[1]].max[1] - longTolerance
	local longEndLen = modelData[input.railingLongEnd[1]].max[1] - longTolerance

	local repeat2Len = modelData[input.railingRepeat2[1]].max[1]

	local pillarBigWideRepSideWidth = modelData[input.pillarBigWide.pillarRepeat[1]].max[3]
	local pillarBigWideRepRepWidth = modelData[input.pillarBigWide.pillarRepeat[2]].max[3]

	local intervalData = { }
	for i = 1, #params.railingIntervals do
		local interval = params.railingIntervals[i]

		intervalData[i] = {
			railingBegin = interval.hasPillar[1] >= 0 and input.railingRepeat1 or { },
			railingRepeat = input.railingRepeat1,
			railingEnd = interval.hasPillar[2] >= 0 and input.railingRepeat1 or { },

			longBegin = false,
			longEnd = false
		}
	end

	-- check for double -/|\-/|\-
	for i = 2, #params.railingIntervals - 1 do
		local interval0 = params.railingIntervals[i - 1]
		local interval1 = params.railingIntervals[i]
		local interval2 = params.railingIntervals[i + 1]

		if interval1.hasPillar[1] >= 0 and interval1.hasPillar[2] >= 0 and
				not intervalData[i - 1].longEnd and not intervalData[i].longBegin and
				not intervalData[i].longEnd and not intervalData[i + 1].longBegin and
				check(interval0) and check(interval1) and check(interval2) then

				local remLen0 = interval0.length - (intervalData[i - 1].longBegin and longBeginLen or 0)
				local remLen1 = interval1.length
				local remLen2 = interval2.length - (intervalData[i + 1].longEnd and longEndLen or 0)

				if remLen0 >= longEndLen and remLen1 >= longBeginLen + longEndLen and remLen2 >= longBeginLen then
					intervalData[i - 1].railingEnd = input.railingLongEnd
					intervalData[i].railingBegin = input.railingLongBegin
					intervalData[i].railingEnd = input.railingLongEnd
					intervalData[i + 1].railingBegin = input.railingLongBegin

					intervalData[i - 1].longEnd = true
					intervalData[i].longBegin = true
					intervalData[i].longEnd = true
					intervalData[i + 1].longBegin = true
				end
		end
	end

	-- check for single -/|\-
	for i = 1, #params.railingIntervals - 1 do
		local interval0 = params.railingIntervals[i]
		local interval1 = params.railingIntervals[i + 1]

		if interval0.hasPillar[2] >= 0 and not intervalData[i].longEnd and not intervalData[i + 1].longBegin and
				check(interval0) and check(interval1) then

			local remLen0 = interval0.length - (intervalData[i].longBegin and longBeginLen or 0)
			local remLen1 = interval1.length - (intervalData[i + 1].longEnd and longEndLen or 0)

			if remLen0 >= longEndLen and remLen1 >= longBeginLen then
				intervalData[i].railingEnd = input.railingLongEnd
				intervalData[i + 1].railingBegin = input.railingLongBegin

				intervalData[i].longEnd = true
				intervalData[i + 1].longBegin = true
			end
		end
	end

	-- decide whether to repeat and/or need long stop-elements
	for i = 1, #params.railingIntervals do
		local interval = params.railingIntervals[i]
		local data = intervalData[i]

		local remLen = interval.length
		local tolerance = .0

		if data.longBegin then
			remLen = remLen - longBeginLen
			tolerance = tolerance + 2.0 * longTolerance
		end

		if data.longEnd then
			remLen = remLen - longEndLen
			tolerance = tolerance + 2.0 * longTolerance
		end

		if remLen < interval.length and remLen <= tolerance then data.railingRepeat = { }
		elseif remLen >= 2.0 * repeat2Len then data.railingRepeat = input.railingRepeat2 end

		if data.longBegin and (not data.longEnd or #data.railingRepeat > 0) then data.railingBegin = input.railingLongBeginStop end
		if data.longEnd and (not data.longBegin or #data.railingRepeat > 0) then data.railingEnd = input.railingLongEndStop end
	end
		
	local configurePillar = function(modelData, params, i, height, width)
		local pillarType = input.pillarSmall

		if intervalData[bridgeutil.getRailingIntervalIdx(params, i, true)].longEnd or
				intervalData[bridgeutil.getRailingIntervalIdx(params, i, false)].longBegin then

			pillarType = width >= 2.0 * pillarBigWideRepRepWidth and input.pillarBigWide or input.pillarBig
		end
		
		local pillarModels = {
			pillarType.pillarBase, pillarType.pillarRepeat, pillarType.pillarTop
		}

		if pillarType.pillarMain then table.insert(pillarModels, pillarType.pillarMain) end

		return bridgeutil.configurePillar(modelData, pillarModels, height, width)
	end

	local configureRailing = function(modelData, params, interval, i, length, width)
		local railingModels = { intervalData[i].railingBegin, intervalData[i].railingRepeat, intervalData[i].railingEnd }

		return bridgeutil.configureRailing(modelData, interval, railingModels, length, width)
	end

	local result = { }
	result.pillarModels = { }
	result.railingModels = { }
	
	local pillarWidth = params.railingWidth
	
	for i = 1, #params.pillarHeights do
		local pillarConfig = configurePillar(modelData, params, i, params.pillarHeights[i], pillarWidth)
		local pillarResult = bridgeutil.repeat2D(modelData, pillarConfig)
		
		table.insert(result.pillarModels, pillarResult)
	end
	
	for i = 1, #params.railingIntervals do
		local interval = params.railingIntervals[i]
		local railingConfig = configureRailing(modelData, params, interval, i, interval.length, params.railingWidth)
		local intervalResult = bridgeutil.repeat2D(modelData, railingConfig)
		
		table.insert(result.railingModels, intervalResult)
	end
	
	return result
end

return {
	name = _("Suspension Bridge"),

	yearFrom = 1940,
	yearTo = 0,

	autoGeneration = false,

	carriers = { "RAIL" , "ROAD"},

	speedLimit = 180 / 3.6,
	
	pillarLen = 4.8,
	
	pillarMinDist = .5 * pillarTargetDist - longTolerance,
	pillarMaxDist = pillarTargetDist + 2.0 * longTolerance,
	pillarTargetDist = pillarTargetDist,

	cost = 600.0,
	costFactors = { 10.0, 1.76, 4.0 },
	
	pillarGroundTexture = "shared/dirt.gtex.lua",
	pillarGroundTextureOffset = 2.0,

	noParallelStripSubdivision = true,
	ignoreWaterCollision = true,
	
	materialsToReplace = {	
		streetPaving = {
			name = "street/country_new_medium_paving.mtl",
		},
		streetLane = {
			name = "street/new_medium_lane.mtl",
		},
		crossingLane = {
			name = "street/new_medium_lane.mtl",
		},
		sidewalkPaving = {
			name = "street/new_medium_sidewalk.mtl",
		},
		sidewalkBorderInner = {
			name = "street/new_medium_sidewalk_border_inner.mtl",		
			size = { 3, 0.6 }
		},
	},
	
	updateFn = updateFn
}
end
