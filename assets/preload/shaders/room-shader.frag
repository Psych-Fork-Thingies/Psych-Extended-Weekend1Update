#pragma header

uniform vec2 topLeft;
uniform vec2 topRight;
uniform vec2 bottomLeft;
uniform vec2 bottomRight;
uniform vec2 hologramSize;

float remapToRange(float value, float start1, float stop1, float start2, float stop2)
{
    return start2 + (value - start1) * ((stop2 - start2) / (stop1 - start1));
}
vec2 remapToRange(vec2 value, vec2 start1, vec2 stop1, vec2 start2, vec2 stop2)
{
    return start2 + (value - start1) * ((stop2 - start2) / (stop1 - start1));
}
void main() {
    
    vec2 textureCoord = getCamPos(openfl_TextureCoordv);
    vec2 tl = topLeft / hologramSize;
    vec2 tr = topRight / hologramSize;
    vec2 bl = bottomLeft / hologramSize;
    vec2 br = bottomRight / hologramSize;
    vec4 box = vec4(min(tl.x, bl.x), min(tl.y, tr.y), max(tr.x, br.x), max(bl.y, br.y));

    vec2 pos = vec2(
        remapToRange(textureCoord.x,
                    mix(tl, bl, textureCoord.y).x,
                    mix(tr, br, textureCoord.y).x, 0.0, 1.0),
        remapToRange(textureCoord.y,
                    mix(tl, tr, textureCoord.x).y,
                    mix(bl, br, textureCoord.x).y, 0.0, 1.0));

    if (pos.x < 0.0 || pos.x > 1.0 || pos.y < 0.0 || pos.y > 1.0) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
        gl_FragColor = textureCam(bitmap, pos);
    }
}