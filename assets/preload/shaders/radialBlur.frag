#pragma header

uniform float cx; //center x (0.0 - 1.0)
uniform float cy; //center y (0.0 - 1.0)
uniform float blurWidth; // blurAmount 

const int nsamples = 15; //samples
	
void main() {
	vec2 uv = openfl_TextureCoordv.xy;
	vec4 color = texture2D(bitmap, uv);
	vec2 center = vec2(cx, cy);

	float precompute = 1.0 / float(nsamples - 1);
	uv -= center;
	
	for(int i = 0; i < nsamples; i++) {
		float scale = 1.0 - blurWidth * (float(i) * precompute);
		color += texture2D(bitmap, uv * scale + center);
	}
	color /= float(nsamples);
	gl_FragColor = color; 
}