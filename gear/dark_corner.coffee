THREE.DarkCornerShader = {
  uniforms: {
    "tDiffuse": {type: "t", value: null },
  }
  vertexShader:
    "
    varying vec2 vUv;
    void main() {
      vUv = uv;
      gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
    }"
  ,
  fragmentShader:
    "
    uniform sampler2D tDiffuse;
    varying vec2 vUv;
    void main() {
      vec4 color = texture2D(tDiffuse, vUv);
      float x = min(vUv.x, 1.0 - vUv.x);
      float y = min(vUv.y, 1.0 - vUv.y);
      float index = 0.4;
      float darkness = pow(x, index) + pow(y, index);
      darkness = 1.0 - min(darkness, 1.0);
      float alpha = 0.2;
      vec4 dark_color = vec4(darkness, darkness, darkness, 0.0);
      gl_FragColor = -dark_color * alpha + color;
    }
    "
}