#pragma header
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
uniform bool enabled;

vec3 hash33(vec3 p3)
{
	p3 = fract(p3 * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yxz+33.33);
    return fract((p3.xxy + p3.yxx)*p3.zyx);
}
vec2 hash21(float p)
{
	vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx+p3.yz)*p3.zy);
}

void mainImage()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    if (!enabled) {
        gl_FragColor = flixel_texture2D(bitmap, uv);
        return;
    }
    vec2 uv2 = fragCoord/iResolution.xy;

    
    // animation
    float speed = 30.;
    float t = floor(iTime*speed);
    
    // randomness
    vec2 lod = iResolution.xy/hash21(t)/200.;
    vec2 p = floor(uv2*lod);
    vec3 rng = hash33(vec3(p,t));
    
    // displace uv
    vec2 offset = vec2(cos(rng.x*6.283),sin(rng.x*6.283))*rng.y;
    float fade = sin(fract(iTime*speed)*3.14);
    vec2 scale = 50. / iResolution.xy;
    float threshold = step(0.9, rng.z) ;
    uv2 += offset * threshold * fade * scale;
    
    // chromatic abberation
    vec2 rgb = 10./iResolution.xy * fade * threshold;
    fragColor.r = texture(iChannel0, uv2+rgb).r;
    fragColor.g = texture(iChannel0, uv2).g;
    fragColor.b = texture(iChannel0, uv2-rgb).b;
    fragColor.a = flixel_texture2D(bitmap, uv2).a;
    
    // crop
    fragColor.rgb *= step(0.,uv2.x) * step(uv2.x,1.) * step(0.,uv2.y) * step(uv2.y,1.);
    
}