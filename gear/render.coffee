to_three_vectors = $.util.to_three_vectors
to_box2d_vectors = $.util.to_box2d_vectors
binary_color = $.util.binary_color
RGB = $.util.RGB

console.log x

init = ->
#  window.audio = new AudioSystem()
#  audio.play('rain')

webGLStart = ->
  init()

  width = 100
#  height = width / window.innerWidth * window.innerHeight
  height = width
  halfSize = 32
  scene = new THREE.Scene()
  camera = new THREE.OrthographicCamera( -halfSize + 3, halfSize + 3, halfSize, -halfSize, -1000, 1000)
  camera.rotateY Math.PI / 4
  camera.updateMatrixWorld()
  camera.matrixAutoUpdate = true

  vec = new THREE.Vector3(1, 0, 0)
  camera.rotateOnAxis(vec, -Math.PI / 180 * 40)

  renderer = new THREE.WebGLRenderer({ antialias: true})
  renderer.setPixelRatio( window.devicePixelRatio)
  size = Math.min(window.innerHeight, window.innerWidth) - 10
  renderer.setSize size, size
#  renderer.autoClear = true
  renderer.setClearColor(binary_color([0.25, 0.8, 0.8]))

  renderer.shadowMapEnabled = true
  renderer.shadowMapSoft = true

#  renderer.shadowCameraNear = 3;
#  renderer.shadowCameraFar = camera.far;
#  renderer.shadowCameraFov = 180

  document.body.appendChild renderer.domElement
  margin = (window.innerWidth - window.innerHeight - 10) / 2
  $(renderer.domElement).css 'margin-left': "#{margin}px"

  directionalLight = new THREE.DirectionalLight 0xffffff, 0.001
  directionalLight.position.set 0, 400, -800
  directionalLight.castShadow = true
#  directionalLight.castShadow = false
  directionalLight.shadowDarkness = 0.3
  directionalLight.shadowCameraRight    =  25
  directionalLight.shadowCameraLeft     = -25
  directionalLight.shadowCameraTop      =  25
  directionalLight.shadowCameraBottom   = -25
  directionalLight.shadowMapWidth = 2048  * 1
  directionalLight.shadowMapHeight = 1024 * 1
  scene.shadowLight = directionalLight
  scene.add directionalLight

  directionalLight = new THREE.DirectionalLight 0xffff88, 0.4
  directionalLight.position.set 400, 400, 0
  scene.add directionalLight

  directionalLight = new THREE.DirectionalLight 0x8888ff, 0.4
  directionalLight.position.set -400, 400, 0
  scene.add directionalLight



  light = new THREE.AmbientLight binary_color (0.6 for i in [0...3])
  scene.add light

#  welcome_scene = new TestScene scene
  welcome_scene = new $.GameScene scene
  start_time = Date.now()

  composer = new THREE.EffectComposer( renderer );
  composer.addPass( new THREE.RenderPass( scene, camera ) );

  effect = new THREE.ShaderPass THREE.DarkCornerShader
  effect.renderToScreen = true
  composer.addPass effect

  ratio = 1
  composer.setSize window.innerWidth * ratio, window.innerHeight * ratio


  stats = new Stats()
  stats.domElement.style.position = 'absolute';
  stats.domElement.style.top = '0px';
  window.stats_window = stats;
#  document.getElementById('body').appendChild( stats.domElement )

  render = ->
    fps += 1
    stats.update()
    requestAnimationFrame(render)
    t = Date.now() - start_time
    welcome_scene.update(t, $.util.keyCode)
#    renderer.render(scene, camera)
#    renderer.render()
    composer.render()
  render()

  fps = 0

#  plane = new THREE.PlaneBufferGeometry(10, 10);
#  material = new THREE.MeshBasicMaterial
#    map: THREE.ImageUtils.loadTexture 'images/smoke.png'
#    blending: THREE.AdditiveBlending
#  material.transparent = true
#  material.opacity = 0.1
#  mesh = new THREE.Mesh plane, material
#  scene.add mesh
#
#  mesh.rotation.y = Math.PI / 4
#  mesh.position.y = 10

#  setInterval ->
#      console.log "FPS#{fps}"
#      fps = 0
#    , 1000

$('body').ready ->
  webGLStart()
  $('body').keyup (event)->
    $.util.keyCode[String.fromCharCode(event.keyCode)] = false
  $('body').keydown (event)->
    $.util.keyCode[String.fromCharCode(event.keyCode)] = true
    if String.fromCharCode(event.keyCode) == 'x'
      stats_window.opacity(0)
