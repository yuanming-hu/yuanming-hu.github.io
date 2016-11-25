#pragma optimize(on)
attribute vec3 aVertexNormal, aVertexPosition;
attribute vec4 aVertexColor;

uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;
uniform mat4 uNormalMatrix;

varying vec4 vColor;
varying vec3 vNormal;

mat4 transpose(in mat4 inMatrix) {
    vec4 i0 = inMatrix[0];
    vec4 i1 = inMatrix[1];
    vec4 i2 = inMatrix[2];
    vec4 i3 = inMatrix[3];

    mat4 outMatrix = mat4(
                     vec4(i0.x, i1.x, i2.x, i3.x),
                     vec4(i0.y, i1.y, i2.y, i3.y),
                     vec4(i0.z, i1.z, i2.z, i3.z),
                     vec4(i0.w, i1.w, i2.w, i3.w)
                     );
    return outMatrix;
}

void main(void) {
    gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    mat4 uvNormalMatrix = transpose(uMVMatrix);
    vNormal = vec3(uNormalMatrix * vec4(aVertexNormal, 0.0));
    vColor = vec4(aVertexColor);
}
