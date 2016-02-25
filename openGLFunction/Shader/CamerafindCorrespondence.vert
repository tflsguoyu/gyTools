# version 440

uniform mat4 gl_ProjectionMatrix;

layout (location = 0) in vec3 vertexPosition;
layout (location = 1) in vec3 vertexPosition2;
out vec3 position2;

void main()
{	
    position2 = vertexPosition2;
	gl_Position = gl_ProjectionMatrix * vec4(vertexPosition, 1.0);
}