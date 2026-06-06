local environmentutil = { }

function environmentutil.rayleighExtinctionCoeff(mult)
	return { mult * 5.8 * 1e-6, mult * 13.5 * 1e-6, mult * 33.1 * 1e-6 }
end

function environmentutil.mieScatteringCoeff(mult)
	return { mult * 2.0 * 1e-5, mult * 2.0 * 1e-5, mult * 2.0 * 1e-5 }
end

return environmentutil