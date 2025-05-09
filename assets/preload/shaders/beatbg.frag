#pragma header
uniform float iTime;
uniform float density;
//uniform sampler2D iChannel1;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
float noise(float s)
{
	return fract(cos(s*11345.123)*123113.123);
}

float texturef(vec2 p) // this produces a repeating star texture - that moves in a different dir for each row
{
	vec3 c=vec3(0);
	float m=noise(p.x);
	float q=floor(p.x*10.);
	p.y+=(floor(noise(q)*1.7)*1.5-1.)*iTime*0.2;
	p=mod(p+floor(m*10.)/10.,0.1)-0.05;
	float l=pow(1.-length(p),111.93)*1.21;
	
	return l;
}


void mainImage()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
	vec2 p = fragCoord.xy / iResolution.xy-0.5;
	p=tan(p*cos(iTime*0.2)*13.4); // this creates the white tattoo effect - comment out for standard tunnel
	vec3 c=vec3(0);
	// standard tunnel length - p*p = rounded rect instead of a circle
	float d=.01/length(p*p); 

	d=cos(iTime*0.5+d)-tan(d); // this moves the tunnel back and forth

	p.x+=0.12*cos(d*50.1+iTime); // warp the tunnels position
	p.y+=0.13*sin(d*50.1+iTime); // warp the tunnels position coment out for standard tunnel
	// the rest is standard tunnel code = atan for angle e.t.c.
	float a=(atan(p.x,p.y)*0.23)+iTime*0.05;
	// multi layers for rgb channels
	c.x=texturef(vec2(a+iTime*0.,d))*(15.*length(p)*length(p));
	c.y=texturef(vec2(a*2.1+iTime*-0.,d*3.3))*(5.*length(p)*length(p));
	c.z=texturef(vec2(a*3.1+iTime*0.,d*5.3))*(20.*length(p)*length(p));
	// warp up the RGB so gives better non standard looking hues
	c+=vec3(c.z+c.y,c.z+c.x,c.y+c.x)*0.2;
	fragColor = vec4( c, 1.0 );
	
	
}