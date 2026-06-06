#version 150

#pragma optionNV(ifcvt all)

const int N = 3;
const int N1 = N - 1;
const float sigma = N == 1 ? 1.0 : (N - 1) / 4.0;
const int S = N*N;

vec2 getTexCoord();
vec2 getTileOffset();
float gauss(float x, float sigma);
int getLevelIndex(vec2 texCoord, vec2 tileSubPos, vec2 offset);
vec3 blendAllMaterials2(vec2 texCoord, vec2 tileSubPos, vec3 dposdx, vec3 dposdy, ivec2 maxInd, vec2 maxWeight, out vec3 normal, out vec2 ambientGloss);

vec3 filterAndBlendMaterial(vec3 dposdx, vec3 dposdy, out vec3 normal, out vec2 ambientGloss) {
	vec2 texCoord = getTexCoord();
	vec2 tileSubPos = getTileOffset();
	vec2 fpos = fract(texCoord * 256.0);

	const int maxNumIndices = 9;
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
	
	ivec2 maxInd = ivec2(-1);
	vec2 maxWeight = vec2(.0);

	for (int i = 0; i < min(numIndices, maxNumIndices); ++i) {
		if (temp2sum[i] > maxWeight.x) {
			maxInd.xy = ivec2(temp2idx[i], maxInd.x);
			maxWeight.xy = vec2(temp2sum[i], maxWeight.x);
		}
		else if (temp2sum[i] > maxWeight.y) {
			maxInd.y = temp2idx[i];
			maxWeight.y = temp2sum[i];
		}
	}
	
	return blendAllMaterials2(texCoord, tileSubPos, dposdx, dposdy, maxInd, maxWeight, normal, ambientGloss);
}
