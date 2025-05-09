#pragma header
uniform float iTime;
uniform float density;
//uniform sampler2D iChannel1;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
void mainImage()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    vec2 uv2 = fragCoord/iResolution.xy;
    vec2 distort1 = vec2(cos(iTime + uv2.y * 5.) * 0.05 - cos(iTime) * 0.1, -iTime*0.3);
    vec2 distort2 = vec2(sin(iTime + uv2.y * 2.) * 0.025 - cos(iTime) * 0.1, -iTime*0.5);
	float spark1 = 1.-texture(iChannel0, uv2 + distort1).r;
    float spark2 = 1.-texture(iChannel0, uv2 + distort2).r;
    float brightness = 8.;
    float spark = (pow(spark1, brightness) + pow(spark2, brightness)) * exp(-dot(uv2-0.5, uv-0.5) * 2.);
    vec3 col = vec3(1.0, 0.7, 0.3) * spark * vec3(1.0, spark, spark);
    fragColor = vec4(col,1.0);
}