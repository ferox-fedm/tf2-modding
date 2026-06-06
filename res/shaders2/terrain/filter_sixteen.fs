#version 150

#pragma optionNV(ifcvt all)

const int N = 5;
const int N1 = N - 1;
const float sigma = N == 1 ? 1.0 : (N - 1) / 4.0;

const int maxNumIndices = 16;
#define NUMSUMS 4
const int numSums = NUMSUMS;

vec2 getTexCoord();
vec2 getTileOffset();
int getNumMaterials(int offset);
int getOffset(vec2 tileSubPos);
float gauss(float x, float sigma);
int getLevelIndex(vec2 texCoord, vec2 tileSubPos, vec2 offset);
int mapMaterial(int i, int offset);
vec3 blendAllMaterials(vec2 texCoord, vec2 tileSubPos, vec3 dposdx, vec3 dposdy, ivec4 maxInd, vec4 maxWeight, out vec3 normal, out vec2 ambientGloss);

vec3 filterAndBlendMaterial(vec3 dposdx, vec3 dposdy, out vec3 normal, out vec2 ambientGloss) {
	vec2 texCoord = getTexCoord();
	vec2 tileSubPos = getTileOffset();
	vec2 fpos = fract(texCoord * 256.0);
	
	float temp2sum[maxNumIndices + 1]; // Workaround for old Intel Mac
	for (int i = 0; i < maxNumIndices; ++i) { temp2sum[i] = .0; }
	
	int I = getOffset(tileSubPos);
	{
		float sy = 0;
		float wy = gauss(-fpos.y + sy + 0.5, sigma);
		{
			float sx = 0;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx = getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			// if (mapMaterial(idx, I) == 254) discard;
			temp2sum[idx] += w;
		}
		{
			float sx = -2;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx = getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = -1;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 1;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 2;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
	} {
		float sy = -2;
		float wy = gauss(-fpos.y + sy + 0.5, sigma);
		{
			float sx = -1;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 0;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 1;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
	} {
		float sy = -1;
		float wy = gauss(-fpos.y + sy + 0.5, sigma);
		{
			float sx = -2;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = -1;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 0;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 1;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 2;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
	} {
		float sy = 1;
		float wy = gauss(-fpos.y + sy + 0.5, sigma);
		{
			float sx = -2;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = -1;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 0;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 1;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 2;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
	} {
		float sy = 2;
		float wy = gauss(-fpos.y + sy + 0.5, sigma);
		{
			float sx = -1;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 0;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
		{
			float sx = 1;
			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;
			int idx =  getLevelIndex(texCoord, tileSubPos, vec2(sx, sy));
			temp2sum[idx] += w;
		}
	}
	
	int numIndices = getNumMaterials(I);

	ivec4 maxInd = ivec4(-1);
	vec4 maxWeight = vec4(.0);

	for (int i = 0; i < min(16, numIndices); ++i) {
		if (temp2sum[i] > maxWeight.x) {
			maxInd.xyzw = ivec4(mapMaterial(i, I), maxInd.xyz);
			maxWeight.xyzw = vec4(temp2sum[i], maxWeight.xyz);
		}
		else if (temp2sum[i] > maxWeight.y) {
			maxInd.yzw = ivec3(mapMaterial(i, I), maxInd.yz);
			maxWeight.yzw = vec3(temp2sum[i], maxWeight.yz);
		}
		else if (temp2sum[i] > maxWeight.z) {
			maxInd.zw = ivec2(mapMaterial(i, I), maxInd.z);
			maxWeight.zw = vec2(temp2sum[i], maxWeight.z);
		}
		else if (temp2sum[i] > maxWeight.w) {
			maxInd.w = mapMaterial(i, I);
			maxWeight.w = temp2sum[i];
		}
	}
	
	return blendAllMaterials(texCoord, tileSubPos, dposdx, dposdy, maxInd, maxWeight, normal, ambientGloss);
}
