#pragma optimize(on)

precision mediump float;

varying vec4 vColor;
varying vec3 vNormal;

void main(void) {
    const vec3 lightSource = vec3(0, 1, -1);
    vec3 normalized_normal = normalize(vNormal);
    gl_FragColor = vec4(clamp((0.5 + 0.5 * clamp(dot(normalized_normal, lightSource), 0.0, 1.0)) * vec3(vColor), 0.0, 1.0), vColor.w);
}
