#pragma header

uniform vec4 color;
uniform float shadowLength;
uniform bool flipped;

bool inFrame(vec2 pos) {
    vec2 camPos = (pos);
    return !(camPos.x < 0.0 || camPos.x > 1.0 || camPos.y < 0.0 || camPos.y > 1.0);
}

vec4 getColorSafe(vec2 pos) {
    if (inFrame(pos))
        return flixel_texture2D(bitmap, pos);
}

void main() {
    if (!inFrame(openfl_TextureCoordv)) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }

    float intensity = 1.0;
    for(int i = 0; float(i) < shadowLength; ++i) {
        intensity = 1.0 - (float(i) / (shadowLength - 1.0));
        if (getColorSafe(openfl_TextureCoordv + vec2(float(i) / openfl_TextureSize.x * (flipped ? -1.0 : 1.0))).a < 0.1)
            break;
    }

    vec4 col = getColorSafe(openfl_TextureCoordv);
    gl_FragColor = vec4(mix(col.rgb, color.rgb * col.a, color.a * intensity), col.a);
}