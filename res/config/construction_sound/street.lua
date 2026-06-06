function data()
return {
	--gain = .7,

	--dragStart = "construction/street/drag_start.wav",
	--dragStart = { name = "construction/street/drag_start.wav", gain = .5 },

	dragStart = "construction/street/drag_start.wav",
	drag = {
		"construction/street/drag_1.wav",
		"construction/street/drag_2.wav",
		"construction/street/drag_3.wav",
		"construction/street/drag_4.wav",
		"construction/street/drag_5.wav"
	},
	dragBridge = {
		"construction/street/drag_bridge_1.wav",
		"construction/street/drag_bridge_2.wav",
		"construction/street/drag_bridge_3.wav"
	},
	dragTunnel = {
		"construction/street/drag_tunnel_1.wav",
		"construction/street/drag_tunnel_2.wav",
		"construction/street/drag_tunnel_3.wav"
	},
	dragEnd = "construction/street/drag_end.wav",
	dragOffset = -.1,

	fixedSlopeOn = "construction/fixed_slope_on.wav",
	fixedSlopeOff = "construction/fixed_slope_off.wav",
	slopeUp = "construction/slope_up.wav",
	slopeDown = "construction/slope_down.wav",

	build = "construction/build.wav",
	cancel = "construction/cancel.wav"
}
end
