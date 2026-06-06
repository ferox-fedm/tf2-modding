//======================================================================================
// native DirectX port of GLSL shader `terrainTess.tesc`
//======================================================================================

#include "../terrain/terrainTess_common.hlsli"

#define NUM_CONTROL_POINTS 1

HSConstantOutput HSConstantDefault(InputPatch<TerrainTessPatch, NUM_CONTROL_POINTS> input, uint patchID
								   : SV_PrimitiveID) {
	HSConstantOutput output;
	int i;
	for (i = 0; i < 4; ++i)
	{
		output.Edges[i] = input[0].tessLevelOuter[i];
	}
	
	for (i = 0; i < 2; ++i)
	{
		output.Inside[i] = input[0].tessLevelInner[i];
	}
	return output;
}

[domain("quad")]
[partitioning("fractional_even")]
[outputtopology("triangle_ccw")]
[outputcontrolpoints(1)]
[patchconstantfunc("HSConstantDefault")]
TerrainTessOutputPatch main(InputPatch<TerrainTessPatch, 1> input,
						uint pointID : SV_OutputControlPointID,
						uint patchID : SV_PrimitiveID)
{
	TerrainTessOutputPatch output;
	output.positionAndHeightMapOffset = input[pointID].positionAndHeightMapOffset;
	return output;
}
