#pragma header
uniform float iTime;
uniform sampler2D iChannel1;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
void mainImage()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    fragColor = vec4(0, 0, 0, 1);
	vec2 uv2 = fragCoord.xy / iResolution.xy;
	vec2 block = floor(fragCoord.xy / vec2(16));
	vec2 uv2_noise = block / vec2(64);
	uv2_noise += floor(vec2(iTime) * vec2(1234.0, 3543.0)) / vec2(64);
	
	float block_thresh = pow(fract(iTime * 1236.0453), 2.0) * 0.2;
	float line_thresh = pow(fract(iTime * 2236.0453), 3.0) * 0.7;
	
	vec2 uv2_r = uv2, uv2_g = uv2, uv2_b = uv2;

	// glitch some blocks and lines
	if (texture(iChannel1, uv2_noise).r < block_thresh ||
		texture(iChannel1, vec2(uv2_noise.y, 0.0)).g < line_thresh) {

		vec2 dist = (fract(uv2_noise) - 0.5) * 0.3;
		uv2_r += dist * 0.1;
		uv2_g += dist * 0.2;
		uv2_b += dist * 0.125;
	}

	fragColor.r = texture(iChannel0, uv2_r).r;
	fragColor.g = texture(iChannel0, uv2_g).g;
	fragColor.b = texture(iChannel0, uv2_b).b;

	// loose luma for some blocks
	if (texture(iChannel1, uv2_noise).g < block_thresh)
		fragColor.rgb = fragColor.ggg;

	// discolor block lines
	if (texture(iChannel1, vec2(uv2_noise.y, 0.0)).b * 3.5 < line_thresh)
		fragColor.rgb = vec3(0.0, dot(fragColor.rgb, vec3(1.0)), 0.0);

	// interleave lines in some blocks
	if (texture(iChannel1, uv2_noise).g * 1.5 < block_thresh ||
		texture(iChannel1, vec2(uv2_noise.y, 0.0)).g * 2.5 < line_thresh) {
		float line = fract(fragCoord.y / 3.0);
		vec3 mask = vec3(3.0, 0.0, 0.0);
		if (line > 0.333)
			mask = vec3(0.0, 3.0, 0.0);
		if (line > 0.666)
			mask = vec3(0.0, 0.0, 3.0);
		
		fragColor.xyz *= mask;
	}
}