#pragma header
uniform float iTime;
uniform sampler2D iChannel1;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
uniform bool enabled;
uniform float time;
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void mainImage() {
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    if (!enabled) {
        gl_FragColor = flixel_texture2D(bitmap, uv);
        return;
    }
    // Sawtooth calc of time
    float offset = (iTime - floor(iTime)) / iTime;
	float time = iTime * offset;
    // Wave design params
	vec3 waveParams = vec3(.3, 0.8, 0.1 );
    
    
    // Find coordinate, flexible to different resolutions
    float maxSize = max(iResolution.x, iResolution.y);
    vec2 uv2 = fragCoord.xy / iResolution.xy;

    
    // Find center, flexible to different resolutions
    vec2 center = fragCoord.xy / maxSize;

    // Distance to the center
    float dist = distance(uv2, center);
    
    // Original color
	vec4 c = texture(iChannel0, uv2);
    
    // Limit to waves
	if (time > 0. && dist <= time + waveParams.z && dist >= time - waveParams.z) {
      
        // The pixel offset distance based on the input parameters
		float diff = (dist - time);
		float diffPow = (1.0 - pow(abs(diff * waveParams.x), waveParams.y));
		float diffTime = (diff  * diffPow);

        // The direction of the distortion
		vec2 dir = normalize(uv2 - center);
        
        
        // Perform the distortion and reduce the effect over time
		uv2 += ((dir * diffTime) / (time * dist * 80.0)) * dist * 0.2;
        
        // Grab color for the new coord
		c = texture(iChannel0, uv2);

        vec4 red = texture(iChannel0, vec2(uv2.x - (0.2 / (time* dist * 1000.0)), uv2.y)) * vec4(1.0, 0.0, 0.0,1.0);
		vec4 green = texture(iChannel0, vec2(uv2.x + (0.2 / (time* dist * 1000.0)) , uv2.y))
		   * vec4(0.0, 1.00, 0.0,1.0);
		vec4 blue  = texture(iChannel0, vec2(uv2.x, uv2.y)) * vec4(0.0, 0.0, 1.0,1.0);
		c += red + green + blue;
        c /= 2.;
	}
    
	fragColor = c;
    
	fragColor = c;
}