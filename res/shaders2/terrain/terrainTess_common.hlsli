////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// BEGIN: TODO: the following is copy-pasted from terrain.vs.hlsl, should be extracted from generated SPIRV

cbuffer Terrain : register(b11)
{
	float2 u_terrain_terrainStart : packoffset(c0);
	float2 u_terrain_terrainMinMax : packoffset(c0.z);
	float4 u_terrain_terrainTileData1 : packoffset(c1);
	float u_terrain_terrainTileData2 : packoffset(c2);
};

cbuffer View : register(b10)
{
	row_major float4x4 u_view_projView : packoffset(c0);
	row_major float4x4 u_view_projViewInverse : packoffset(c4);
	row_major float4x4 u_view_proj : packoffset(c8);
	row_major float4x4 u_view_projInverse : packoffset(c12);
	row_major float4x4 u_view_view : packoffset(c16);
	row_major float4x4 u_view_viewInverse : packoffset(c20);
	float3 u_view_camPos : packoffset(c24);
	float u_view_lodFactor : packoffset(c24.w);
	float u_view_near : packoffset(c25);
	float u_view_far : packoffset(c25.y);
};

cbuffer Atmosphere : register(b5)
{
	float u_atmosphere_fogDensity : packoffset(c0);
	float2 u_atmosphere_fogDist : packoffset(c0.z);
	float3 u_atmosphere_sunColor : packoffset(c1);
	float3 u_atmosphere_rayleighExtCoeff : packoffset(c2);
	float u_atmosphere_rayleighScaleHeight : packoffset(c2.w);
	float3 u_atmosphere_mieScattCoeff : packoffset(c3);
	float u_atmosphere_mieScaleHeight : packoffset(c3.w);
	float u_atmosphere_phaseG : packoffset(c4);
	float u_atmosphere_viewSamples : packoffset(c4.y);
};

cbuffer Light : register(b6)
{
	float3 u_light_lightDir : packoffset(c0);
	float u_light_lightScale : packoffset(c0.w);
	row_major float4x4 u_light_lightTransf : packoffset(c1);
	row_major float4x4 u_light_lightInvTransf : packoffset(c5);
	float u_light_ambientScale : packoffset(c9);
};


static float4 gl_Position;
static float4 attrPosIndex;
static float4 texCoordtileOffset;
static float3 vpos;
static float3 extFactor;
static float3 inScatt;
static float fogFactor;

struct SPIRV_Cross_Input
{
	float4 attrPosIndex : TEXCOORD0;
};

float2 getTilePos()
{
	return float2(float(int(uint(attrPosIndex.w) % 1024u) - 128), float(int(uint(attrPosIndex.w) / 1024u) - 128));
}

float2 getTexCoord()
{
	return (attrPosIndex.xy / u_terrain_terrainTileData1.x.xx) - getTilePos();
}

float2 getTileOffset()
{
	return float2(uint2(getTilePos() - u_terrain_terrainStart) % uint2(4u, 4u));
}

void exportData()
{
	texCoordtileOffset = float4(getTexCoord(), getTileOffset());
}

float calcFogFactor2(float3 pos)
{
	float3 camPos = float3(u_view_viewInverse[3].xyz);
	float3 weights = 1.0f.xxx;
	float dist = length(weights * (pos - camPos));
	float2 fogDist = u_atmosphere_fogDist * u_view_far;
	float f = clamp((dist - fogDist.x) / fogDist.y, 0.0f, 1.0f);
	return u_atmosphere_fogDensity * pow(f, 6.0f);
}

float RayleightPhase(float cosTheta2)
{
	return 0.5889999866485595703125f * (1.0f + cosTheta2);
}

float HenyeyGreensteinFn(float g, float cosTheta, float cosTheta2)
{
	float g2 = g * g;
	float a = (1.0f - g2) / (2.0f + g2);
	float b = (1.0f + cosTheta2) / pow((1.0f + g2) - ((2.0f * g) * cosTheta), 1.5f);
	return (0.4775169193744659423828125f * a) * b;
}

void calcFogFactor(float3 pos)
{
	vpos = pos;
	extFactor = 1.0f.xxx;
	inScatt = 0.0f.xxx;
	float3 param = pos;
	fogFactor = calcFogFactor2(param);
	if (u_atmosphere_viewSamples <= 0.0f)
	{
		return;
	}
	float3 camPos = float3(u_view_viewInverse[3].xyz);
	float3 viewVec = camPos - pos;
	bool _258 = camPos.z < 0.0f;
	bool _264;
	if (_258)
	{
		_264 = pos.z >= 0.0f;
	}
	else
	{
		_264 = _258;
	}
	if (_264)
	{
		float t = (-camPos.z) / viewVec.z;
		camPos += (viewVec * t);
	}
	viewVec = camPos - pos;
	float dist = length(viewVec);
	float3 extCoeff = u_atmosphere_rayleighExtCoeff + (u_atmosphere_mieScattCoeff / 0.89999997615814208984375f.xxx);
	float h0 = max(camPos.z, 0.0f);
	float h1 = max(pos.z, 0.0f);
	float rD = 0.0f;
	float mD = 0.0f;
	float _step = dist / u_atmosphere_viewSamples;
	float3 rayleightInScatt = 0.0f.xxx;
	float3 mieInScatt = 0.0f.xxx;
	for (int i = 0; float(i) < u_atmosphere_viewSamples; i++)
	{
		float h = lerp(h0, h1, (float(i) + 0.5f) / u_atmosphere_viewSamples);
		float pr = exp((-h) / u_atmosphere_rayleighScaleHeight) * _step;
		float pm = exp((-h) / u_atmosphere_mieScaleHeight) * _step;
		rD += pr;
		mD += pm;
		extFactor = exp(((-u_atmosphere_rayleighExtCoeff) * rD) - (u_atmosphere_mieScattCoeff * mD));
		rayleightInScatt += (extFactor * pr);
		mieInScatt += (extFactor * pm);
	}
	float cosTheta = clamp(dot(normalize(viewVec), u_light_lightDir), -1.0f, 1.0f);
	float cosTheta2 = cosTheta * cosTheta;
	float param_1 = cosTheta2;
	float3 rayleightScatt = u_atmosphere_rayleighExtCoeff * RayleightPhase(param_1);
	float param_2 = u_atmosphere_phaseG;
	float param_3 = cosTheta;
	float param_4 = cosTheta2;
	float3 mieScatt = u_atmosphere_mieScattCoeff * HenyeyGreensteinFn(param_2, param_3, param_4);
	inScatt = (rayleightInScatt * rayleightScatt) + (mieInScatt * mieScatt);
}

/// END: TODO: the following is copy-pasted from terrain.vs.hlsl, should be extracted from generated SPIRV
////////////////////////////////////////////////////////////////////////////////////////////////////////////

//======================================================================================
// native DirectX port of GLSL shader `terrainTess_common.glsl`
//======================================================================================

cbuffer TerrainTessSettings : register(b7) {
	float3 u_terrainTess_viewEye : packoffset(c0.x);
	float u_terrainTess_patchLevel : packoffset(c0.w);
	float u_terrainTess_gamma : packoffset(c1.x);
	float u_terrainTess_errorThreshold : packoffset(c1.y);
};

struct TerrainTessPatch {
	float4 positionAndHeightMapOffset : TEXCOORD0;
	float4 tessLevelOuter : TEXCOORD1;
	float2 tessLevelInner : TEXCOORD2;
};

struct TerrainTessOutputPatch {
	float4 positionAndHeightMapOffset : Position;
};

struct HSConstantOutput {
	float Edges[4] : SV_TessFactor;
	float Inside[2] : SV_InsideTessFactor;
};

Texture2D<float4> heightmapTex : register(t23);
SamplerState _heightmapTex_sampler : register(s23);

#define TILE_GROUPS 4

int getPatchDim() {
	return 1u << int(u_terrainTess_patchLevel);
}

int getPatchSize() {
	return int(u_terrain_terrainTileData1.x / getPatchDim());
}

float2 addBorderECTess(float2 coord, float2 heightMapOffset, float res, float border) {
	float actualRes = ((res * TILE_GROUPS) + (2.0f * border)) + 1.0f;
	return (((coord + heightMapOffset) * res / getPatchDim()) + 1.5f.xx) / actualRes.xx;
}

float2 patchPosToTilePos(float2 patchPos) {
	return floor(patchPos / 256.0f.xx);
}

float2 getTexCoord(float2 worldCoord, float2 tilePos) {
	return (worldCoord / u_terrain_terrainTileData1.x.xx) - tilePos;
}

float2 getTileOffset(float2 tilePos) {
	return float2(uint2(tilePos - u_terrain_terrainStart) % uint2(4u, 4u));
}

float getHeightAt(float2 heightMapOffset, float2 uv) {
	float2 b = addBorderECTess(uv, heightMapOffset, u_terrain_terrainTileData1.x, u_terrain_terrainTileData2);
	float lod = 0;
	float sampled = heightmapTex.SampleLevel(_heightmapTex_sampler, b, lod).x;
	float h = lerp(u_terrain_terrainMinMax.x, u_terrain_terrainMinMax.y, sampled);
	return h;
}


float4 exportData(float2 worldPos, float2 patchPos) {
	float2 tilePos = patchPosToTilePos(patchPos);

	return float4(getTexCoord(worldPos, tilePos), getTileOffset(tilePos));
}
