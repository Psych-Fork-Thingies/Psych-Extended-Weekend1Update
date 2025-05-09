#pragma header
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

int sampleCount = 50;
float blur = 0.25; 
float falloff = 6.5; 

// use iChannel0 for video, iChannel1 for test grid
#define INPUT iChannel0

void mainImage()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
	vec2 destCoord = fragCoord.xy / iResolution.xy;

	vec2 direction = normalize(destCoord - 0.5); 
	vec2 velocity = direction * blur * pow(length(destCoord - 0.5), falloff);
	float inverseSampleCount = 0.05 / float(sampleCount); 
	
    vec2 offset1 = velocity * inverseSampleCount;
    vec2 offset2 = velocity * 2.0 * inverseSampleCount;
    vec2 offset3 = velocity * 4.0 * inverseSampleCount;

	vec3 accumulator = vec3(0);
	
	for (int i = 0; i < sampleCount; i++) {
		accumulator.r += texture(INPUT, destCoord + offset1.xy).r; 
		accumulator.g += texture(INPUT, destCoord + offset2.xy).g; 
		accumulator.b += texture(INPUT, destCoord + offset3.xy).b; 
		
		offset1 -= velocity;
    offset2 -= velocity;
    offset3 -= velocity;
	}

	fragColor = vec4(accumulator / float(sampleCount), 1.0);
}