#pragma header
uniform float iTime;
uniform float density;
//uniform sampler2D iChannel1;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
uniform bool uEnabled;

#define SPEED 3.0

#define RAYS 10.0

#define RING_PERIOD 80.0

#define TWIST_FACTOR 2.0

float getColorComponent(float dist, float angle) {
    return
        pow((
            (
            	cos(
                    (angle * RAYS)
            		+ pow(
                        dist * 2.0,
                		(sin(iTime * SPEED) * TWIST_FACTOR)
            		) * 20.0
        		) + sin(
            		dist * RING_PERIOD
        		)
        	) + 2.0
        ) / 2.0, 10.0);
}

void mainImage() {
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    vec2 delta = (fragCoord -.5 * iResolution.xy) / iResolution.y;
    float dist = length(delta),
    angle = atan(delta.x, delta.y);
    fragColor = vec4(
        getColorComponent(dist, angle),
        getColorComponent(dist * 1.03, angle),        
        getColorComponent(dist * 1.06, angle),
        0.09
    );
}

