#pragma header

void main() {
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

    color.r *= 0.4;
    color.g *= 0.4;
    color.b *= 0.7;

    gl_FragColor = color;
}