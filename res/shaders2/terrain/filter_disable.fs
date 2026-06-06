#version 150

#pragma optionNV(ifcvt all)

vec2 getTexCoord();
vec2 getTileOffset();
int getOffset(vec2 tileSubPos);
int mapMaterial(int i, int offset);
int getNumMaterials(int offset);
float gauss(float x, float sigma);
int getLevelIndex(vec2 texCoord, vec2 tileSubPos, vec2 offset);
vec3 blendAllMaterials1(vec2 texCoord, vec2 tileSubPos, vec3 dposdx, vec3 dposdy, int maxInd, float maxWeight, out vec3 normal, out vec2 ambientGloss);

vec3 filterAndBlendMaterial(vec3 dposdx, vec3 dposdy, out vec3 normal, out vec2 ambientGloss) {
	vec2 texCoord = getTexCoord();
	vec2 tileSubPos = getTileOffset();
	vec2 fpos = fract(texCoord * 256.0);
	
	int idx = getLevelIndex(texCoord, tileSubPos, vec2(0, 0));
	
	int maxInd;
	float maxWeight;

	int I = getOffset(tileSubPos);
	if (getNumMaterials(I) <= 16) maxInd = mapMaterial(idx, I);
	else maxInd = idx - 1;
	if (maxInd == 254) discard;
	maxWeight = 1.0;
	
	return blendAllMaterials1(texCoord, tileSubPos, dposdx, dposdy, maxInd, maxWeight, normal, ambientGloss);
}
