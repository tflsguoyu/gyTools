# version 440

uniform mat4 gl_ModelViewMatrix;
uniform mat4 gl_ProjectionMatrix;
uniform mat4 gl_ModelViewProjectionMatrix;
uniform mat3 gl_NormalMatrix;

struct gl_MaterialParameters {
 vec4 emission;
 vec4 ambient;
 vec4 diffuse;
 vec4 specular;
 float shininess;
};
uniform gl_MaterialParameters gl_FrontMaterial;
uniform gl_MaterialParameters gl_BackMaterial;

struct gl_LightSourceParameters {
 vec4 ambient;
 vec4 diffuse;
 vec4 specular;
 vec4 position;
 vec4 halfVector;
 vec3 spotDirection;
 float spotExponent;
 float spotCutoff;
 float spotCosCutoff;
 float constantAttenuation;
 float linearAttenuation;
 float quadraticAttenuation;
};
uniform gl_LightSourceParameters gl_LightSource[1];

struct gl_LightProducts {
 vec4 ambient;
 vec4 diffuse;
 vec4 specular;
};
uniform gl_LightProducts gl_FrontLightProduct[1];

layout (location = 0) in vec3 vertexPosition;
layout (location = 1) in vec3 vertexNormal;
out vec4 color;


void main()
{
    vec3 ECPosition = vertexPosition;
	vec3 N = normalize(gl_NormalMatrix * vertexNormal);
	vec3 L = normalize(gl_LightSource[0].position.xyz - ECPosition);
	vec3 V = normalize(- ECPosition);
	vec3 H = normalize(V + L);
	vec3 diffuse = vec3(gl_FrontLightProduct[0].diffuse * max(dot(N , L) , 0.0));
	vec3 specular = vec3(gl_FrontLightProduct[0].specular * pow(max(dot(N , H) , 0.0) , gl_FrontMaterial.shininess));
	color = vec4(clamp((diffuse + specular) , 0.0 , 1.0) , 1.0);
	color = color + gl_FrontLightProduct[0].ambient;
	
	gl_Position = gl_ProjectionMatrix * vec4(vertexPosition,1.0);
}