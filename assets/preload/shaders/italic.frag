#pragma header

uniform float skew;

void main() {
    vec2 pos = vec2((skew * (openfl_TextureCoordv.y - 0.5)) + (openfl_TextureCoordv.x * (1.0 + abs(skew * 2.0))), openfl_TextureCoordv.y);
    if (pos.x < float(0) || pos.x > float(1))
        gl_FragColor = vec4(0, 0, 0, 0);
    else
        gl_FragColor = flixel_texture2D(bitmap, pos);
}
