#version 150

#pragma optionNV(ifcvt all)

const int N = 5;
const int N1 = N - 1;
const float sigma = N == 1 ? 1.0 : (N - 1) / 4.0;
const int S = N*N-4;

vec2 getTexCoord();
vec2 getTileOffset();
float gauss(float x, float sigma);
int getLevelIndex(vec2 texCoord, vec2 tileSubPos, vec2 offset);
vec3 blendAllMaterials(vec2 texCoord, vec2 tileSubPos, vec3 dposdx, vec3 dposdy, ivec4 maxInd, vec4 maxWeight, out vec3 normal, out vec2 ambientGloss);

vec3 filterAndBlendMaterial(vec3 dposdx, vec3 dposdy, out vec3 normal, out vec2 ambientGloss) {
	vec2 texCoord = getTexCoord();
	vec2 tileSubPos = getTileOffset();
	vec2 fpos = fract(texCoord * 256.0);

	const int maxNumIndices = 16;
	int numIndices = 0;
	
	int temp2idx[S];
	float temp2sum[S];
	for (int I = 0; I < S; ++I) { temp2idx[I] = -1; temp2sum[I] = -1.0; }
		
	for (int y = 0; y < N; ++y) {
		float sy = y - .5 * N1;

		float wy = gauss(-fpos.y + sy + 0.5, sigma);
		for (int x = 0; x < N; ++x) {
			
			float sx = x - .5 * N1;

			float wx = gauss(-fpos.x + sx + 0.5, sigma);
			float w = wx * wy;

			int idx = getLevelIndex(texCoord, tileSubPos, vec2(sx, sy)) - 1;
			if (abs(y - (N-1)/2) == 2 && abs(x - (N-1)/2) == 2) continue;
			// if (y == 2 && x == 2 && idx == 255) discard;
			//if (idx == 255) continue;
			
			bool found = false;
			for (int I = 0; I < min(numIndices, maxNumIndices); ++I) {
				if (temp2idx[I] == idx) {
					temp2sum[I] += w;
					found = true;
					break;
				}
			}
			if (!found) {
				temp2idx[numIndices] = idx;
				temp2sum[numIndices] = w;
				++numIndices;
			}
		}
	}
	
	ivec4 maxInd = ivec4(-1);
	vec4 maxWeight = vec4(.0);

	for (int i = 0; i < min(numIndices, maxNumIndices); ++i) {
		if (temp2sum[i] > maxWeight.x) {
			maxInd.xyzw = ivec4(temp2idx[i], maxInd.xyz);
			maxWeight.xyzw = vec4(temp2sum[i], maxWeight.xyz);
		} else if (temp2sum[i] > maxWeight.y) {
			maxInd.yzw = ivec3(temp2idx[i], maxInd.yz);
			maxWeight.yzw = vec3(temp2sum[i], maxWeight.yz);
		} else if (temp2sum[i] > maxWeight.z) {
			maxInd.zw = ivec2(temp2idx[i], maxInd.z);
			maxWeight.zw = vec2(temp2sum[i], maxWeight.z);
		} else if (temp2sum[i] > maxWeight.w) {
			maxInd.w = temp2idx[i];
			maxWeight.w = temp2sum[i];
		}
	}
	
	return blendAllMaterials(texCoord, tileSubPos, dposdx, dposdy, maxInd, maxWeight, normal, ambientGloss);
}
