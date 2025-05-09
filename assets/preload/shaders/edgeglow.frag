#pragma header
uniform float iTime;
uniform sampler2D iChannel1;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

float d;

float lookup(vec2 p, float dx, float dy)
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    vec2 uv2 = (p.xy + vec2(dx * d, dy * d)) / iResolution.xy;
    vec4 c = texture(iChannel0, uv2.xy);
	
	// return as luma
    return 0.2126*c.r + 0.7152*c.g + 0.0722*c.b + 0.4;
}

void mainImage()
{
    d = sin(iTime * 3.0)*0.5 + 1.5; // kernel offset
    vec2 p = fragCoord.xy;
    
	// simple sobel edge detection
    float gx = 0.0;
    gx += -1.0 * lookup(p, -1.0, -1.0);
    gx += -2.0 * lookup(p, -1.0,  0.0);
    gx += -1.0 * lookup(p, -1.0,  1.0);
    gx +=  1.0 * lookup(p,  1.0, -1.0);
    gx +=  2.0 * lookup(p,  1.0,  0.0);
    gx +=  1.0 * lookup(p,  1.0,  1.0);
    
    float gy = 0.0;
    gy += -1.0 * lookup(p, -1.0, -1.0);
    gy += -2.0 * lookup(p,  0.0, -1.0);
    gy += -1.0 * lookup(p,  1.0, -1.0);
    gy +=  1.0 * lookup(p, -1.0,  1.0);
    gy +=  2.0 * lookup(p,  0.0,  1.0);
    gy +=  1.0 * lookup(p,  1.0,  1.0);
    
	// hack: use g^2 to conceal noise in the video
    float g = gx*gx + gy*gy;
    float g2 = g * (sin(iTime) / 4.0 + 0.5);
    
    vec4 col = texture(iChannel0, p / iResolution.xy);
    col += vec4(0.0, g2/2, g2, 0.0);
    
    fragColor = col;
}