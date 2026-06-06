#version 150

/*vec3 decodeNormal(vec3 color) {
	return normalize(2.0 * (color - vec3(128.0/255.0)));
}*/

void swap(inout vec3 a, inout vec3 b) {
	vec3 t = a;
	a = b;
	b = t;
}

void swap(inout int a, inout int b) {
	int t = a;
	a = b;
	b = t;
}

void swap(inout float a, inout float b) {
	float t = a;
	a = b;
	b = t;
}

vec3 decodeNormal(vec3 color) {
	if (color.z != 0) {
		return 255.0 / 127.0 * (color - vec3(128.0 / 255.0));
	}

	color = 255.0 / 127.0 * (color - vec3(128.0 / 255.0));

	//return vec3(color, sqrt(1.0 - dot(color, color)));
	return vec3(color.xy, sqrt(1.0 - min(dot(color.rg, color.rg), 1.0)));
}

vec3 decodeNormalScale(vec3 color, float scale) {
	vec3 nrml = decodeNormal(color);
	return normalize(vec3(scale * nrml.xy, nrml.z));
}

vec3 decodeNormal(vec2 color) {
	color = 255.0 / 127.0 * (color - vec2(128.0 / 255.0));

	//return vec3(color, sqrt(1.0 - dot(color, color)));
	return vec3(color, sqrt(1.0 - min(dot(color, color), 1.0)));
}

vec3 decodeNormalScale(vec2 color, float scale) {
	vec3 nrml = decodeNormal(color);
	return normalize(vec3(scale * nrml.xy, nrml.z));
}

vec3 getFaceNormal(vec3 normal_, bool flip) {
	vec3 normal = normalize(normal_);
	if (!gl_FrontFacing && flip) normal = -normal;
	return normal;
}

vec3 getNormalMapped(vec3 texNormal, vec3 normal_, vec3 binormal_, vec3 tangent_, bool flip) {
	mat3 tangentMat = mat3(tangent_, binormal_, normal_);
	vec3 normal = normalize(tangentMat * texNormal);
	
	if (!gl_FrontFacing && flip) normal = -normal;
	return normal;
}

float calcLum(vec3 color) {
	//const vec3 weights = vec3(.3, .59, .11);
	const vec3 weights = vec3(.2126, .7152, .0722);
	return dot(weights, color);
}

float desaturate(vec3 color) {
	//return dot(vec3(.3, .59, .11), color);
	return .5 * (min(color.r, min(color.g, color.b)) + max(color.r, max(color.g, color.b)));
}

vec3 overlay(vec3 col0, vec3 col1) {
	//float gray = desaturate(col0);
	float gray = dot(vec3(0.3, 0.59, 0.11), col0);
	
	if (gray < .5) return 2.0 * col1 * col0;
	return 1.0 - 2.0 * (1.0 - col1) * (1.0 - col0);
}

vec3 overlay(vec4 col0, vec3 col1) {
	return mix(col0.rgb, overlay(col0.rgb, col1), col0.a);
}

float overlay(float col0, float col1) {
	if (col0 < .5) return 2.0 * col1 * col0;
	return 1.0 - 2.0 * (1.0 - col1) * (1.0 - col0);
}

vec3 colorBlend(vec3 color, float mask, float scale, vec3 newColor) {
	if (newColor.r < .0) {
		return color;
	}
	
	//vec3 gray = vec3(scale * desaturate(color));
	vec3 gray = mix(vec3(scale * desaturate(color)), color, mask);
	return mix(clamp(overlay(newColor, gray), vec3(.0), vec3(1.0)), color, mask);
}

vec3 applyOp(vec3 pos, vec3 nrml, vec2 texCoord, sampler2D tex, ivec2 settings, vec2 scale, float opacity, vec3 color) {
	if (settings.x == 0) {					// Op::NO_OP
		return color;
	}

	vec2 tc;

	if (settings.y == 0) {					// Mode::TEXCOORD
		tc = texCoord;
	} else if (settings.y == 1) {			// Mode::WORLD_XY
		tc = pos.xy;
	} else /*if (settings.y == 2)*/ {		// Mode::NORMAL
		vec3 xDir = normalize(cross(vec3(.1411, .0, .99), nrml));
		vec3 yDir = cross(nrml, xDir);
		tc = vec2(dot(pos, xDir), dot(pos, yDir));
	}

	vec4 opCol = texture(tex, scale * tc);

	if (settings.x == 1) {					// Op::MULTIPLICATION
		return color * mix(vec3(1.0), opCol.rgb, opacity);
	}
	
	if (settings.x == 2) {					// Op::OVERLAY
		return overlay(color, mix(vec3(.5), opCol.rgb, opacity));
	}
	
	if (settings.x == 3) {					// Op::LINEAR_BURN
		return color - (vec3(1.0) - mix(vec3(1.0), opCol.rgb, opacity));
	}
	
	return mix(color, opCol.rgb, opCol.a);	// Op::ALPHA_BLEND
}

vec3 getUvPos(vec3 posAmbient, vec3 texCoordAlpha, vec3 normal, vec3 tangent, vec3 binormal, 
		sampler2D tex, int mode, vec2 scale, bool flipNormal) {
	if (mode == 3) { // Tangent-Bitangent
		vec3 xDir = normalize(tangent);
		vec3 yDir = normalize(binormal);

		vec4 checkValueU = texture(tex, vec2(0.25, 0.5)).xyzw;
		vec4 checkValueV = texture(tex, vec2(0.75, 0.5)).xyzw;

		vec4 pos = vec4(
			dot(posAmbient.xyz, xDir), 
			dot(posAmbient.xyz, yDir),
			texCoordAlpha.x,
			texCoordAlpha.y
		);

		return vec3(
			dot(step(0.5, checkValueU), pos) * scale.x,
			dot(step(0.5, checkValueV), pos) * scale.y,
			texCoordAlpha.z
		);
	} else if (mode == 4) { // Tangent-Bitangent
		vec3 xDir = normalize(tangent);
		vec3 yDir = normalize(binormal);
		return vec3(dot(posAmbient.xyz, xDir) * scale.x, dot(posAmbient.xyz, yDir) * scale.y, texCoordAlpha.z);
	} else if (mode == 5) { // Normal-Reference-Axis
		vec3 nrml = getFaceNormal(normal, flipNormal);
		vec3 axis = normalize(texture(tex, vec2(0.25, 0.5)).xyz * (step(0.5, texture(tex, vec2(0.75, 0.5)).xyz) - 0.5));
		vec3 xDir = cross(nrml, axis);
		vec3 yDir = cross(nrml, xDir);
		return vec3(dot(posAmbient.xyz, xDir) * scale.x, dot(posAmbient.xyz, yDir) * scale.y, texCoordAlpha.z);
	} else if (mode == 6) { // World xyz
		vec3 checkValueU = texture(tex, vec2(0.25, 0.5)).xyz;
		vec3 checkValueV = texture(tex, vec2(0.75, 0.5)).xyz;

		return vec3(
			(dot(step(0.75, checkValueU), posAmbient.xyz) + dot(1.0 - step(0.25, checkValueU), texCoordAlpha.xyz)) * scale.x,
			(dot(step(0.75, checkValueV), posAmbient.xyz) + dot(1.0 - step(0.25, checkValueV), texCoordAlpha.xyz)) * scale.y,
			texCoordAlpha.z
		);
	} else if (mode == 6) { // UV
		return vec3(texCoordAlpha.xy * scale, texCoordAlpha.z);
	}
	
	return texCoordAlpha;
}
