//======================================================================================
// native DirectX port of GLSL shader `terrainTess.tese`
//======================================================================================

#include "../terrain/terrainTess_common.hlsli"

struct SPIRV_Cross_Output
{
	float4 texCoordtileOffset : TEXCOORD0;
	float3 vpos : TEXCOORD1;
	float fogFactor : TEXCOORD2;
	float3 extFactor : TEXCOORD3;
	float3 inScatt : TEXCOORD4;
	float4 gl_Position : SV_Position;
};

// domain shader to generate actual quad vertices
[domain("quad")]
SPIRV_Cross_Output main(HSConstantOutput input, float2 uv : SV_DomainLocation, const OutputPatch<TerrainTessOutputPatch, 1> patch)
{
	float2 patchPos = patch[0].positionAndHeightMapOffset.xy;
	float2 tilePos = patchPosToTilePos(patchPos);
	
	uv.y = 1 - uv.y;

	float x = patchPos.x + getPatchSize() * uv.x;
	float y = patchPos.y + getPatchSize() * uv.y;
	float z = getHeightAt(patch[0].positionAndHeightMapOffset.zw, uv);

	SPIRV_Cross_Output stage_output;
	stage_output.gl_Position = mul(float4(x, y, z, 1.0f), u_view_projView);
#ifdef RESCALE_Z_POS
	stage_output.gl_Position.z = (0.5f * stage_output.gl_Position.z) + (0.5f * stage_output.gl_Position.w);
#endif
	
	stage_output.texCoordtileOffset = exportData(float2(x, y), patchPos);
	stage_output.vpos = float3(x, y, z);
	
	calcFogFactor(stage_output.vpos);
	stage_output.fogFactor = fogFactor;
	stage_output.extFactor = extFactor;
	stage_output.inScatt = inScatt;
	
	return stage_output;
}
