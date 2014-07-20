local shaders = {
	shader = {},
	matrix = {}
}

shaders.shader.convolution3x3 = {
	pixelcode = [[
		uniform vec2 offset[9];
		uniform number kernel[9];

		vec4 effect(vec4 col, Image tex, vec2 tc, vec2 sc) {
			vec4 sum = vec4(0);
			int i;
			for(i = 0; i < 9; i++) {
				vec4 c = col * Texel(tex, tc+offset[i]);
				sum += c * kernel[i];
			}
			return sum;
		}
	]]

}

shaders.matrix.sharpen3x3 = {
	 0, -1,  0,
	-1,  5, -1,
	 0, -1,  0
}

shaders.generateOffsets3x3 = function(w, h)
	local xoff = 1 / w
	local yoff = 1 / h
	return {
		{-xoff, yoff},	{0, yoff},	{xoff, yoff},
		{-xoff, 0},		{0,0},		{xoff, 0},
		{-xoff, -yoff},	{0, -yoff},	{xoff, -yoff}
	}
end


return shaders
