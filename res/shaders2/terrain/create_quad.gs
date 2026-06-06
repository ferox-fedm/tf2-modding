#version 150

layout(triangle_strip, max_vertices = 8) out;

const vec3[8] vertices = vec3[8](
	vec3(0.0, -0.5, 0.0),
	vec3(0.0, 0.5, 0.0),
	
	vec3(0.0, -0.5, 0.3),
	vec3(0.0, 0.5, 0.3),
	
	vec3(0.1, -0.5, 0.6),
	vec3(0.1, 0.5, 0.6),

	vec3(0.3, -0.5, 1.0),
	vec3(0.3, 0.5, 1.0)
);

const vec2[8] texCoords = vec2[8](
	vec2(0.0, 0.0 + 0.025),
	vec2(1.0, 0.0 + 0.025),
	
	vec2(0.0, 0.3),
	vec2(1.0, 0.3),
	
	vec2(0.0, 0.6),
	vec2(1.0, 0.6),

	vec2(0.0, 1.0 - 0.025),
	vec2(1.0, 1.0 - 0.025)
);

void genVertexData(mat2 modelMat, vec3 vposx, vec3 nrml, vec3 tngnt, vec3 vert, vec2 texCoord, int matType, int grassType, float amb);

void createPrimitive(float width, float height, mat2 modelMat, vec3 vposx, vec3 nrml, vec3 tngnt, int matType, int grassType, float amb) {
	const int k = 8;
	for (int i = 0; i < k; ++i) {
		vec3 vert = vec3(vertices[i].x, vertices[i].y * width, vertices[i].z * height);
	
		genVertexData(modelMat, vposx, nrml, tngnt, vert, texCoords[i], matType, grassType, amb);
		
		EmitVertex();
	}
	
	EndPrimitive();
}
