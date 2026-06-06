#version 150

layout(triangle_strip, max_vertices = 4) out;

const vec3[4] vertices = vec3[4](
	vec3(0.0, -0.5, 0.0),
	vec3(0.0, 0.5, 0.0),

	vec3(0.3, -0.5, 1.0),
	vec3(0.3, 0.5, 1.0)
);

const vec2[4] texCoords = vec2[4](
	vec2(0.0, 0.0 + 0.025),
	vec2(1.0, 0.0 + 0.025),

	vec2(0.0, 1.0 - 0.025),
	vec2(1.0, 1.0 - 0.025)
);

void genVertexData(mat2 modelMat, vec3 vposx, vec3 nrml, vec3 tngnt, vec3 vert, vec2 texCoord, int matType,  int grassType, float amb);

void createPrimitive(float width, float height, mat2 modelMat, vec3 vposx, vec3 nrml, vec3 tngnt, int matType, int grassType, float amb) {
	for (int i = 0; i < 4; ++i) {
		vec3 vert = vec3(vertices[i].x, vertices[i].y * width, vertices[i].z * height);
	
		genVertexData(modelMat, vposx, nrml, tngnt, vert, texCoords[i], matType, grassType, amb);
		
		EmitVertex();
	}
	
	EndPrimitive();
}
