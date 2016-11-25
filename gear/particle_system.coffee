class window.WeatherSystem
  constructor: (@scene)->
    @rain_system = new RainSystem(scene)

    counter = 0
    @fog_system = new SpriteParticleSystem
      intensity: 60
      texture: 'images/smoke.png'
      depth: -1
      generate_mesh: ->
        plane = new THREE.PlaneBufferGeometry(10, 10)
        material = new THREE.MeshBasicMaterial
          map: @texture
          blending: THREE.AdditiveBlending
          depthTest: true
          depthWrite: false
        material.transparent = true
        material.opacity = 0.0
        mesh = new THREE.Mesh plane, material
        mesh.elapsed = 0

        mesh.position.z = counter * 0.01
        mesh.rotation.z = Math.random() * Math.PI * 2
        counter += 1
        counter %= @intensity * 10
        if Math.random() >= 0.2
          mesh.speed = 0.1 + Math.random() * 0.2
          mesh.position.x = (Math.random() - 0.5) * 60
          mesh.position.y = (Math.random() - 0.5) * 40
          mesh.sprite_size = Math.exp(Math.random())
          mesh.max_opacity = 0.03
          mesh.velocity = 1
        else
          mesh.speed = 0.1 + Math.random() * 0.2
          mesh.speed /= 3.0
          mesh.position.x = (Math.random() - 0.7) * 90
          mesh.position.y = (Math.random() - 0.5) * 7 - 20
          mesh.sprite_size = Math.exp(Math.random()) * 2
          mesh.max_opacity = 0.03
          mesh.velocity = 2

        mesh

      update_mesh: (mesh, t)->
        mesh.elapsed += t * mesh.speed
        if @is_dead(mesh)
          return false
        s = Math.max(Math.sqrt(mesh.elapsed), 0.001) * mesh.sprite_size
        mesh.scale.set s, s, s
        mesh.position.x += t * mesh.velocity
        mesh.material.opacity = (-Math.cos(mesh.elapsed * Math.PI * 2) / 2 + 0.5) * mesh.max_opacity
        return true
      is_dead: (mesh)->
        mesh.elapsed > 1
    scene.add @fog_system.object

    @star_system = new SpriteParticleSystem
      intensity: 200
      texture: 'images/square1x1.jpg'
      depth: -10
      generate_mesh: ->
        plane = new THREE.PlaneBufferGeometry(0.6, 0.6)
        material = new THREE.MeshBasicMaterial
          map: @texture
          blending: THREE.AdditiveBlending
          color: new THREE.Color(0.90, 1.0, 0.90)
        material.opacity = 0
        mesh = new THREE.Mesh plane, material
        mesh.elapsed = 0
        mesh.speed = 0.03 + Math.random() * 0.3
        mesh.position.x = (Math.random() - 0.5) * 120
        mesh.position.y = (Math.random() - 0.5) * 20 + 35
        mesh.position.z = counter * 0.01
        mesh.rotation.z = Math.PI / 4
        counter += 1
        counter %= @intensity * 10
        mesh.sprite_size = Math.exp(Math.random()) * 0.2
        s = 1e-7
        mesh.scale.set s, s, s
        mesh

      update_mesh: (mesh, t)->
        mesh.elapsed += t * mesh.speed
        if @is_dead(mesh)
          return false
        s = 0.5 - Math.cos(mesh.elapsed * 2 * Math.PI) / 2
        s *= mesh.sprite_size
        mesh.scale.set s, s, s
        return true
      is_dead: (mesh)->
        mesh.elapsed > 1
    scene.add @star_system.object



  set_intensity: (weather, intensity)->
    this[weather + '_system'].set_intensity(intensity)

  update: (t)->
    @rain_system.update(t)
    @fog_system.update(t)
    @star_system.update(t)


class window.RainSystem
  update_particles: (t)->
    positions = []
    for position in @positions
      position.x += 10 * t * @velocity.x
      position.y += 10 * t * @velocity.y
      position.z += 10 * t * @velocity.z
      if position.y > -@range
        positions.push position
    positions.sort ->
      Math.random() - 0.5
    positions = positions[0...@particle_intensity]
    while positions.length < @particle_intensity
      positions.push({x : @range * (2 * Math.random() - 1), y: @range * (0.8 + Math.random() * 0.4),  z: 0})
    @positions = positions
    @update_geometry()

  update_geometry: ->
    segments = @positions.length
    positions = new Float32Array(segments * 6)
    colors = new Float32Array(segments * 8)
    dx = @velocity.x
    dy = @velocity.y
    dz = @velocity.z
    for i in [0...segments]
      x = @positions[i].x
      y = @positions[i].y
      z = @positions[i].z
      positions[i * 6 + 0] = x
      positions[i * 6 + 1] = y
      positions[i * 6 + 2] = z
      positions[i * 6 + 3] = x + dx
      positions[i * 6 + 4] = y + dy
      positions[i * 6 + 5] = z + dz
      r = 1
      g = 1
      b = 0.5
      colors[i * 8 + 0] = 0
      colors[i * 8 + 1] = 0
      colors[i * 8 + 2] = 0
      colors[i * 8 + 3] = 0

      colors[i * 8 + 4] = r / 4
      colors[i * 8 + 5] = g / 4
      colors[i * 8 + 6] = b / 4
      colors[i * 8 + 7] = 1
    indices_array = []
    for i in [0...segments]
      indices_array.push(i, i + 1)
    @geometry.addAttribute 'position', new (THREE.BufferAttribute)(positions, 3)
    @geometry.addAttribute 'color', new (THREE.BufferAttribute)(colors, 4)
    @geometry.computeBoundingSphere()


  constructor: (@scene)->
    @howl = new Howl urls: ["sound/rain.wav"], loop: true, volume: 0.01
    @howl.play()

    @geometry = new THREE.BufferGeometry
    material = new THREE.LineBasicMaterial
      vertexColors: THREE.VertexColors
      transparent: true
      linewidth: 0.01
      opacity: 0.9
      blending: THREE.AdditiveBlending
    @positions = []
    @range = 60
    r = @range
    @set_intensity(0.0, true)
    for i in [0...@particle_intensity]
      x = (Math.random() * 2 - 1) * r
      y = (Math.random() * 2 - 1) * r
      z = 0
      @positions.push {x: x, y: y, z: z}
    @velocity = new THREE.Vector3 -1, -7, 0
    @update_particles(0)
    mesh = new THREE.Line @geometry, material, THREE.LinePieces
    mesh.rotation.y = Math.PI / 4
    mesh.position.x = 20
    mesh.position.z = 20
    mesh.position.y = 25
    scene.add mesh

  set_current_intensity: (intensity)->
    @current_intensity = intensity
    if intensity < 0.01
        intensity = -1000
    @particle_intensity = Math.floor(Math.exp(intensity * 9))
    @howl.volume(Math.exp(-(1 - intensity) * 8))

  set_intensity: (@intensity, immediate)->
    if immediate
      @set_current_intensity @intensity

  update: (t)->
    t /= 2
    @set_current_intensity(@intensity - (@intensity - @current_intensity) * Math.exp(-t * 3))
    @update_particles(t)


class window.ParticleSystem
  constructor: (options)->
    @texture = options.texture
    @generate_from = options.generate_from
    @update_particle = options.update_particle
    @is_dead = options.is_dead
    @intensity = options.intensity
    @elapsed = 0
    particles = new THREE.Geometry
    particles.dynamic = true
    pMaterial = new THREE.PointCloudMaterial
      color: 0x004422,
      size: 15
      sizeAttenuation: false
      map: THREE.ImageUtils.loadTexture @texture
      transparent: true
      blending: THREE.AdditiveBlending
      depthTest: false
    for p in [0...@intensity]
      particles.vertices.push @generate_particle()

    @particles = particles
    point_cloud = new THREE.PointCloud particles, pMaterial
    @object = point_cloud

  generate_particle: ->
    particle = @generate_from()
    particle

  update: (t)->
    t *= 10
    @elapsed += t
#    console.log @intensity
    particles = []
    for particle in @particles.vertices
      @update_particle(particle, t)
      if not @is_dead particle
        particles.push particle
    while particles.length < @intensity
      particles.push @generate_particle()
    particles = particles[0...@intensity]
    @particles.vertices = particles
    @particles.verticesNeedUpdate = true

class window.SpriteParticleSystem
  constructor: (options)->
    @texture = THREE.ImageUtils.loadTexture options.texture
    @generate_mesh = options.generate_mesh
    @update_mesh = options.update_mesh
    @is_dead = options.is_dead
    @intensity = options.intensity
    @depth = options.depth
    if @depth == undefined
      @depth = -1
    @elapsed = 0

    @object = new THREE.Object3D()
    if @front
      @object.position.x = 20
      @object.position.z = 20
      @object.position.y = 25
    else
      @object.position.x = -20
      @object.position.z = -20
      @object.position.y = -25
    @object.rotation.y = Math.PI / 4

  replace_mesh: (old_mesh, new_mesh)->
    @object.remove old_mesh
    @object.add new_mesh

  update: (t)->
    @elapsed += t
    sprites = @object.children.slice(0)
    for mesh in sprites
      if not @update_mesh(mesh, t)
        @object.remove mesh
    while @object.children.length < @intensity
      @object.add @generate_mesh()
