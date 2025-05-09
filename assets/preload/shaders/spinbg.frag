#pragma header
uniform float iTime;
uniform float density;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

mat2 rot(float a){
  return mat2(cos(a), -sin(a),
              sin(a), cos(a));
}

float sphere(vec3 p, float radius){
  return length(p)-radius;
}

float map(vec3 p)
{
  float radius = 0.25;
  vec3 q = fract(p) * 1.5 - 0.5;
  
  return sphere(q, radius);
}

float trace(vec3 origin, vec3 r) 
{
  float t = 0.0;
  for (int i = 0; i < 128; ++i) {
    vec3 p = origin + r * t;
    float d = map(p);
    t += d * 0.5;
  }
  return t;
}

void mainImage()
{
  vec2 uv = openfl_TextureCoordv.xy;
  vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
  vec2 iResolution = openfl_TextureSize;
  
  vec2 uv2 = fragCoord/iResolution.xy;
  
  uv2 = uv2 *2.-2.; 
  uv2.x *= iResolution.x/iResolution.y;
  
  vec3 color = vec3(sin(iTime), cos(iTime), 0.7);
  
  float FOV = 3.;
  vec3 ray = normalize(vec3(uv2, FOV));
  
  // Rotate Y towards Z
  ray.yz *= rot(iTime*1.1);
  ray.zx *= rot(iTime*1.1);
  
  vec3 origin = vec3(0.0, 0.0, iTime);
  float t = trace(origin, ray);
  
  float linearFog = 2.0 / (1.0 - t*0.2);
  float expFog = 3. / (t*t*0.1);
  
  vec3 fc = vec3(expFog);
  
  fragColor = vec4(fc,0.5);
  
  fragColor = vec4((fc+color),3.0);
  fragColor = vec4(cos(fc+color),sin(iTime));
  
}