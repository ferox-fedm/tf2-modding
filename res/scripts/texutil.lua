local texutil = { }

function texutil.makeTexture(type, fileName, magFilter, minFilter, wrapS, wrapT, mipmapAlphaScale,
		compressionAllowed, redGreen, scaleDownAllowed)
	return {
		type = type or "TWOD",
		fileName = fileName,
		magFilter = magFilter,
		minFilter = minFilter,
		wrapS = wrapS,
		wrapT = wrapT,
		mipmapAlphaScale = mipmapAlphaScale,
		compressionAllowed = compressionAllowed,
		redGreen = redGreen or false,
		scaleDownAllowed = scaleDownAllowed or false
	}
end

function texutil.makeMaterialIndexTexture(fileName, wrapS, wrapT)
	return texutil.makeTexture("TWOD", fileName, "NEAREST", "NEAREST", wrapS, wrapT, .0,
			true, false, false)
end

function texutil.makeTextureLinearNearest(fileName, compressionAllowed, scaleDownAllowed, redGreen, type)
	return texutil.makeTexture(type, fileName, "NEAREST", "NEAREST", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE", .0,
			compressionAllowed, redGreen, scaleDownAllowed)
end

function texutil.makeTextureLinearClamp(fileName, compressionAllowed, scaleDownAllowed, redGreen, type)
	return texutil.makeTexture(type, fileName, "LINEAR", "LINEAR", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE", .0,
			compressionAllowed, redGreen, scaleDownAllowed)
end

function texutil.makeTextureMipmapRepeat(fileName, compressionAllowed, scaleDownAllowed, redGreen, type)
	return texutil.makeTexture(type, fileName, "LINEAR", "LINEAR_MIPMAP_LINEAR", "REPEAT", "REPEAT", .0,
			compressionAllowed, redGreen, scaleDownAllowed)
end

function texutil.makeTextureMipmapClamp(fileName, compressionAllowed, scaleDownAllowed, redGreen, type)
	return texutil.makeTexture(type, fileName, "LINEAR", "LINEAR_MIPMAP_LINEAR", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE", .0,
			compressionAllowed, redGreen, scaleDownAllowed)
end

function texutil.makeTextureMipmapClampVertical(fileName, compressionAllowed, scaleDownAllowed, redGreen, type)
	return texutil.makeTexture(type, fileName, "LINEAR", "LINEAR_MIPMAP_LINEAR", "REPEAT", "CLAMP_TO_EDGE", .0,
			compressionAllowed, redGreen, scaleDownAllowed)
end

return texutil
