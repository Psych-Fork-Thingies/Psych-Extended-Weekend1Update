#pragma header

uniform float zoom = 0;

void main() {
    vec2 camPos = getCamPos(openfl_TextureCoordv);

    camPos -= vec2(0.5, 0.5);
    camPos *= pow((sqrt(2) - length(camPos)) * sqrt(2), zoom);
    camPos /= pow(pow(2, zoom), 2);
    camPos += vec2(0.5, 0.5);

    gl_FragColor = textureCam(bitmap, camPos);
}