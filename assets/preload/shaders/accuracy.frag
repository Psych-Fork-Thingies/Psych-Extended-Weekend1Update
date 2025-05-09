#pragma header

uniform float accuracy;
uniform vec3 accColor;

float offset = 62.0 / 335.0;
float pi = radians(180.0);

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    if (accuracy < 0.1) {
        vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
        float mid = (color.r + color.g + color.b) / 3.0;
        gl_FragColor = vec4(color.r + color.g + color.b, color.r + color.g + color.b, color.r + color.g + color.b, color.a);
    } else {
        vec2 pos = openfl_TextureCoordv + vec2(-offset * (openfl_TextureCoordv.y - 0.5), 0);
        pos -= vec2(0.5, 0.5);

        float heading = mod(atan(-pos.y, -pos.x) - (pi * 0.7), pi * 2.0) - pi;
        float angle = (accuracy * pi * 2.0) - (pi);
        vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

        if (heading >= angle) {
            vec4 newColor = vec4(1.0 * color.a, 1.0 * color.a, 1.0 * color.a, color.a);
            gl_FragColor = mix(newColor, vec4(color.r + color.g + color.b, color.r + color.g + color.b, color.r + color.g + color.b, color.a), 0.5);
        } else {
            vec3 hsvColor = rgb2hsv(color.rgb);
            hsvColor.r = 0.17 * float(accuracy); // Cast accuracy to float
            gl_FragColor = vec4(mix(hsv2rgb(hsvColor), color.rgb, accuracy), color.a);
        }
    }
}