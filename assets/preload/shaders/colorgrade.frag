#pragma header
uniform float iTime;
uniform sampler2D iChannel1;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

const float GRADING_INTENSITY = .3;
uniform float topr;
uniform float topg;
uniform float topb;
uniform float botr;
uniform float botg;
uniform float botb;

void mainImage() {
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    vec2 uv2 = fragCoord / iResolution.xy;
    vec3 color = texture(iChannel0, uv2).rgb;
    vec3 topGrading = vec3(
        1. - sin(topr * 1.1) * GRADING_INTENSITY,
        1. - sin(topg * 1.2) * GRADING_INTENSITY,
        1. - sin(topb * 1.3) * GRADING_INTENSITY
    );
    vec3 bottomGrading = vec3(
        1. + cos(botr * 1.4) * GRADING_INTENSITY,
        1. - cos(botg * 1.5) * GRADING_INTENSITY,
        1. - cos(botb * 1.6) * GRADING_INTENSITY
    );
    vec3 colorGrading = mix(topGrading, bottomGrading, fragCoord.y / iResolution.y);
    color = pow(color, colorGrading);
    fragColor = vec4(color, 0.3);
}
