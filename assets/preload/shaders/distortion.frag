#pragma header
uniform float iTime;
uniform float density;
//uniform sampler2D iChannel1;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main


vec3 draw(vec2 uv) {
    return vec3(texture(iChannel0,vec2(uv.x,uv.y)).rgb);
}

float terrain(float x) {
    float v = 0.; 
    x *= 3.;
    #define l 13.
    for (float n = 0.; n < l; n++) {
        v += ((sin((x*sin(n/2.142))+(n/1.41)))/l)*3.;
    }
    return pow(v,3.);
}

void mainImage()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    float time = iTime;
    vec2 uv2 = fragCoord.xy / iResolution.xy;
    vec3 dist_texture = vec3(draw(uv2+(terrain((uv.y*20.)+(time*30.))/200.)).r,draw(uv2+(terrain((uv.y*22.)+(time*30.))/201.)).g,draw(uv2+(terrain((uv.y*14.)+(time*30.))/202.)).b);
    fragColor = vec4(dist_texture,flixel_texture2D(bitmap, uv).a);
}