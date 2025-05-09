#pragma header
uniform float chromaticAmount;
vec4 chromaticEffect(float amount) {
	vec2 uv = openfl_TextureCoordv.xy;
	vec4 color = texture2D(bitmap, uv);
	float r = texture2D(bitmap, uv - vec2(amount, 0.0)).rgb.x;
	float g = texture2D(bitmap, uv).rgb.y;
	float b = texture2D(bitmap, uv + vec2(amount, 0.0)).rgb.z;
	float a = texture2D(bitmap, uv).a;

	return vec4(r, g, b, a);
}

void main(){
	vec4 color = chromaticEffect(chromaticAmount);
    gl_FragColor = color; 
}