THREE.get_alpha_color_shader = ()->
  {
    vertexShader:
      "
      varying vec2 vUv;
      void main() {
        vUv = uv;
        gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

      }"

    fragmentShader:
      "
      varying vec2 vUv;
      void main() {
        gl_FragColor = vec4(1.0, 1.0, 0, vUv.y);
      }
      "
    transparent: true

    UVGenerator: get_wall_uvgen()
  }