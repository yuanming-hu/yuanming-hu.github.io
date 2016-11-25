$.util = {}
window.x = 1
$.util.binary_color = (color)->
  color = (Math.floor(c * 255) for c in color)
  (color[0] << 16) + (color[1] << 8) + color[2]

$.util.RGB = (color)->
  [color[0] / 255.0, color[1] / 255.0, color[2] / 255.0]

$.util.to_three_vectors = (vertices)->
  (new THREE.Vector2(vertex[0], vertex[1]) for vertex in vertices)


$.util.to_box2d_vectors = (vertices)->
  (new Box2D.b2Vec2(vertex[0], vertex[1]) for vertex in vertices)

$.util.keyCode = {}

to_three_vectors = $.util.to_three_vectors
to_box2d_vectors = $.util.to_box2d_vectors
binary_color = $.util.binary_color
RGB = $.util.RGB

class $.WelcomeScene
  constructor: (scene)->
    geometry = new THREE.BoxGeometry 1, 1, 1
    material = new THREE.MeshBasicMaterial()
    @w = 30
    @h = 30
    @phase = ((Math.random() * 2 * Math.PI for j in [0...@w]) for i in [0...@h])
    @cube = ((new THREE.Mesh(geometry, material) for j in [0...@w]) for i in [0...@h])
    for i in [0...@h]
      for j in [0...@w]
        @cube[i][j].material = new THREE.MeshPhongMaterial()
        @cube[i][j].position.x += i - @w / 2
        @cube[i][j].position.z += j - @h / 2
        scene.add @cube[i][j]

  update: (t)->
    for i in [0...@h]
      for j in [0...@w]
        @cube[i][j].position.y = Math.sin(@phase[i][j] + t / 300) * 0.2 + 0.3


slice_counter = 0
class $.Slice
  constructor: (@vertice_groups, @scene, @world, @color, option)->
    @id = slice_counter
    slice_counter += 1
    bd = new Box2D.b2BodyDef()
    bd.set_type(Box2D.b2_dynamicBody)
    bd.set_position(new Box2D.b2Vec2(0, 0))
    bd.set_linearDamping(0.3)
    bd.set_angularDamping(0.3)
    body = @world.CreateBody(bd)

    @meshes = []
    for vertice_group in vertice_groups
      height = vertice_group.y
      depth = vertice_group.depth || 1
      vertices = vertice_group.vertices
      color = @color || ((if i == (height + 10000) % 3 then 1 else 0) for i in [0...3])
      three_vertices = to_three_vectors vertices
      shape = new THREE.Shape(three_vertices)
      if option
#        console.log option.uvGenerator
        extrudeSettings =
          amount: depth
          bevelEnabled: false
          UVGenerator: option.uvGenerator
      else
        extrudeSettings =
          amount: depth
          bevelEnabled: false

      geometry = new THREE.ExtrudeGeometry(shape, extrudeSettings)
      if option
#        console.log(option.map)
        material = new THREE.MeshLambertMaterial({map: option.map})
      else
        material = new THREE.MeshLambertMaterial({color: binary_color(color), ambient: binary_color(color)})
      mesh = new THREE.Mesh(geometry, material)
      mesh.position.set(0, 0, 0)
      mesh.castShadow = true
      mesh.receiveShadow = true

      mesh.rotateX(Math.PI / 2)
      scene.add(mesh)
      box2d_vertices = to_box2d_vectors(vertices)
      triangles = THREE.Shape.Utils.triangulateShape(three_vertices, [])
      for triangle in triangles
        shape = createPolygonShape [box2d_vertices[triangle[0]],box2d_vertices[triangle[1]],box2d_vertices[triangle[2]]]
        fixture_def = new Box2D.b2FixtureDef()
        fixture_def.set_shape(shape)
        fixture_def.set_density(1)
        fixture_def.set_friction(0)
        mask = 0
        for h in [Math.floor(height)...Math.ceil(height + depth)]
          mask += (1 << h)
        fixture_def.get_filter().set_categoryBits mask
        fixture_def.get_filter().set_maskBits mask
        body.CreateFixture(fixture_def)
      @meshes.push {mesh: mesh, height: height}
    @body = body

  set_position: (position)->
    pos = new Box2D.b2Vec2(position[0], position[1])
    @body.SetTransform(pos, @body.GetAngle())

  set_angle: (angle)->
    @body.SetTransform(@body.GetPosition(), angle)

  update: ()->
    for slice_mesh in @meshes
      mesh = slice_mesh.mesh
      height = slice_mesh.height
      mesh.position.x = @body.GetPosition().get_x()
      mesh.position.z = -@body.GetPosition().get_y()
      mesh.position.y = height
      mesh.rotation.set(0, 0, 0)
      mesh.rotation.y = @body.GetAngle()
      mesh.rotateX(-Math.PI / 2)
      mesh.needsUpdate = true

window.get_wall_uvgen = ()->
  uvgen = {}
  uvgen.generateTopUV = (geometry, indexA, indexB, indexC)->
      vertices = geometry.vertices
      max_x = -1e100
      min_x = 1e100
      max_y = -1e100
      min_y = 1e100
      for vec in vertices
        max_x = Math.max(vec.x, max_x)
        min_x = Math.min(vec.x, min_x)
        max_y = Math.max(vec.y, max_y)
        min_y = Math.min(vec.y, min_y)
      a = vertices[indexA]
      b = vertices[indexB]
      c = vertices[indexC]
      m = (vec)->
        vec = new THREE.Vector2(vec.x, vec.y)
        vec.x = (vec.x - min_x) / (max_x - min_x)
        vec.y = (vec.y - min_y) / (max_y - min_y)
        vec
      ret = [m(a), m(b), m(c)]
      ret

  uvgen.generateSideWallUV = (geometry, indexA, indexB, indexC, indexD)->
    vertices = geometry.vertices
    a = vertices[indexA]
    b = vertices[indexB]
    c = vertices[indexC]
    d = vertices[indexD]
    [
      new THREE.Vector2(0, 0)
      new THREE.Vector2(0, 0)
      new THREE.Vector2(0, 0)
      new THREE.Vector2(0, 0)
    ]
  uvgen

add_ground = (vertices, scene, world, slices, y)->

  n = vertices.length
  for i in [0...n]
#    console.log 'vertices', vertices
    u = vertices[i]
    v = vertices[(i + 1) % n]
    w = vertices[(i + 2) % n]
    dx1 = w[0] - v[0]
    dy1 = w[1] - v[1]
    dx2 = v[0] - u[0]
    dy2 = v[1] - u[1]
    delta = 0
    cross = dx1 * dy2 - dx2 * dy1
    border = 1
    if cross > 0
      delta = 1
    if cross < 0
      delta = -1
    sgn = (x)->
      if x == 0
        return 0
      if x < 0
        return 1
      return -1
    nx = sgn(dx2)
    ny = sgn(dy2)
    v = [v[0] + border * nx * delta, v[1] + border * ny * delta]
    vec = [u, [u[0] - ny * border, u[1] + nx * border], [v[0] - ny * border, v[1] + nx * border], v]

    texture = THREE.ImageUtils.loadTexture('images/grass-green.jpg')
#    console.log(texture.repeat)
    texture.wrapS = texture.wrapT = THREE.RepeatWrapping
    texture.repeat.set(Math.abs(dx2), Math.abs(dy2))

    slice = new $.Slice([{vertices: vec, y: y, depth: 1.25}], scene, world, [], {
      map: texture
      uvGenerator: get_wall_uvgen()
    })
    slices.push slice
    slice.body.SetType(Box2D.b2_staticBody)


  max_x = -1e100
  min_x = 1e100
  max_y = -1e100
  min_y = 1e100
  for vec in vertices
    max_x = Math.max(vec[0], max_x)
    min_x = Math.min(vec[0], min_x)
    max_y = Math.max(vec[1], max_y)
    min_y = Math.min(vec[1], min_y)

  texture = THREE.ImageUtils.loadTexture('images/restaurant.jpg')
  texture.wrapS = texture.wrapT = THREE.RepeatWrapping
  texture.repeat.set((max_x - min_x) / 8, (max_y - min_y) / 8)

  slice = new $.Slice([{vertices: vertices, y: y, depth: 1}], scene, world, [], {
    map: texture
    uvGenerator: get_wall_uvgen()
  })
  slice.body.SetType(Box2D.b2_staticBody)
  slices.push slice
  slice


Slice = $.Slice

class $.GameScene
  constructor: (scene)->

    @scene = scene

    lavaTexture = THREE.ImageUtils.loadTexture( 'images/background.jpg' )
    lavaTexture.wrapS = lavaTexture.wrapT = THREE.RepeatWrapping
    lavaTexture.repeat.set(1, 1)
    lavaMaterial = new THREE.MeshBasicMaterial( { map: lavaTexture } )
    lavaBall = new THREE.Mesh(new THREE.PlaneGeometry(96 * 1.2, 72 * 1.2, 0, 0), lavaMaterial )
    lavaBall.rotateY(Math.PI / 4)
    lavaBall.position.z = -40
    lavaBall.position.x = -40
    lavaBall.position.y = -47
    scene.add(lavaBall)


    @weather_system = new WeatherSystem(scene)
    @particle_system = new ParticleSystem
      texture: 'images/square.jpg'
      intensity: 50
      generate_from: ->
        x = (Math.random() - 0.5) * 10
        y = Math.random() / 5
        z = (Math.random() - 0.5) * 10
        particle = new THREE.Vector3 x, y, z
        particle.dy = Math.random() + 0.3
        particle
      update_particle: (particle, t)->
        particle.y += particle.dy * t * 0.3
      is_dead: (particle)->
        particle.y > 15

    @slices = []
    @joints = {}
    gravity = new Box2D.b2Vec2(0.0, 0.0)
    @world = new Box2D.b2World(gravity)
    @last_t = undefined
    create_gear = (r, d)->
      pol = (t, a)->
        [Math.cos(t) * a, Math.sin(t) * a]
      n = Math.floor(r * Math.PI / d)
      D = d
      result = []
      angle = 2 * Math.PI / n
      for i in [0...n]
        result.push pol angle * i, r
        result.push pol angle * i + angle * 0.4, r
        result.push pol angle * i + angle * 0.6, r + D
        result.push pol angle * i + angle * 0.8, r + D
      result
    create_box = (x, y, r)->
      [
        [x - r, y - r]
        [x + r, y - r]
        [x + r, y + r]
        [x - r, y + r]
      ]
    create_polygon = (x, y, r, n)->
      pol = (t, a)->
        [Math.cos(t) * a, Math.sin(t) * a]
      ([x + r * Math.cos(Math.PI * 2 / n * i), y + r * Math.sin(Math.PI * 2 / n * i)] for i in [0...n])
      ([x + r * Math.cos(Math.PI * 2 / n * i), y + r * Math.sin(Math.PI * 2 / n * i)] for i in [0...n])


    vertices = [
      {vertices: create_gear(1, 0.5), y:0}
    ]
    for i in [0...10]
      vertices.push
        vertices: create_polygon(0, 0, (10 - i) / 10, 8)
        y:1 + 0.3 * i
        depth : 0.3
    vertices.push
      vertices: create_polygon(0, 0, 1, 4)
      y:4
      depth : 0.5
    player = new Slice(vertices, scene, @world, [1.0, 0.75, 0.72])
    @slices.push player
    player.body.SetBullet(true)
    player.set_position(-10, 0)

    vertices = [
      [30, -40]
      [30, -30]
      [40, -30]
      [40, 0]
      [0, 0]
      [0, 40]

      [-40, 40]
      [-40, -20]
      [-20, -20]
      [-20, -40]

    ]
    for vertex in vertices
      vertex[0] *= 0.5
      vertex[1] *= 0.5
    @ground = add_ground vertices, scene, @world, @slices, -1

#    @ground = new Slice([{vertices: vertices, y : -3, depth:3}], scene, @world, RGB([199, 240, 209]), {
#      map: texture
#      uvGenerator: uvgen
#    })
#    @slices.push @ground
#    @ground.body.SetType(Box2D.b2_staticBody)


    vertices = [
      [-20, -20]
      [0, -20]
      [0, 0]
      [-20, 0]
    ]
    for vertex in vertices
      vertex[0] *= 0.4
      vertex[1] *= 0.4
    ground2 = new Slice([{vertices: vertices, y : 3, depth:1}], scene, @world, RGB([199, 240, 209]))
    @slices.push ground2
    ground2.set_position(-20, 0)

    vertices = [
      [0, 0]
      [3, 0]
      [3, 2]
      [2, 2]
      [2, 1]
      [1, 1]
      [1, 2]
      [0, 2]
    ]
    for vertex in vertices
      vertex[0] *= 3
      vertex[1] *= 3

    gear = new Slice(
      [
        {vertices:create_gear(4, 0.5),y:0}
        {vertices:create_gear(3, 0.5),y:1}
        {vertices:create_gear(2, 0.4),y:2}
      ], scene, @world, [1.0, 0.6, 0.8])
    @slices.push gear
    gear.set_position([5, -10])
    gear.set_angle(0.01)
    @pin_to_ground(gear)

    gear = new Slice(
      [
        {vertices:create_gear(6, 0.5),y:0, depth:2}
        {vertices:create_gear(4, 0.5),y:2, depth:1}
        {vertices:create_gear(3, 0.5),y:4, depth:1}
        {vertices:create_polygon(0, 0, 3, 5),y:5, depth:6}
      ], scene, @world, [0.6, 0.95, 0.6])
#      ], scene, @world, [1, 1, 1])
    @slices.push gear
    gear.set_position([-10, 10])
    gear.set_angle(0.04)
    @gear2 = gear
    @pin_to_ground(gear)

    vertices =
      [
        {vertices:create_gear(3, 0.5), y:1, depth:0.5}
        {vertices:create_polygon(0, 0, 3, 8), y:1.5, depth:0.5}
        {vertices:create_polygon(0, 2.7, 0.2, 10), y:2, depth: 5}
        {vertices:create_polygon(0, -2.7, 0.2, 10), y:2, depth: 5}
        {vertices:create_polygon(-2.7, 0, 0.2, 10), y:2, depth: 5}
        {vertices:create_polygon(2.7, 0, 0.2, 10), y:2, depth: 5}
      ]
    for i in [0...10]
      vertices.push
        vertices: create_polygon(0, 0, (11 - i) / 10.0 * 3, 12 - i)
        y: 7 + 0.5 * i
        depth: 0.5

    gear = new Slice(vertices, scene, @world, [0.9, 0.7, 1.0])
    @slices.push gear
    gear.set_position([11.6, -10])
    @gear1 = gear
    @pin_to_ground(gear)
#    @unpin(gear)

#    add_ground([
#      [0, 0]
#      [6, 0]
#      [6, 3]
#      [3, 3]
#      [3, 6]
#      [6, 6]
#      [6, 9]
#      [0, 9]
#    ], scene, @world, @slices, 9)
    tree = new Tree(7, 1, @scene)
    @tree = tree
    tree_ground_geometry = new THREE.TableGeometry(10, 20, 10)
    tree_ground_material = new THREE.MeshLambertMaterial
      color: 0xffaa66
      shading: THREE.FlatShading
      map: THREE.ImageUtils.loadTexture('images/table.png')
      transparent: true


    tree_ground_geometry.uvsNeedUpdate = true
    tree_ground_mesh = new THREE.Mesh tree_ground_geometry, tree_ground_material
    @tree_and_ground = new THREE.Object3D()
    @tree_and_ground.add tree.object
    tree_ground_mesh.receiveShadow = true
    tree_ground_mesh.position.y = -9.5
    @tree_and_ground.add tree_ground_mesh
    @tree_and_ground.add @particle_system.object

    @scene.add @tree_and_ground

  pin_to_ground: (slice)->
    jointDef = new Box2D.b2RevoluteJointDef()
    jointDef.set_bodyA(slice.body)
    jointDef.set_bodyB(@ground.body)
    jointDef.set_localAnchorA(new Box2D.b2Vec2(0.0, 0.0))
    jointDef.set_localAnchorB(slice.body.GetPosition())
    jointDef.set_collideConnected(false)
    @joints[slice.id] = Box2D.castObject(@world.CreateJoint(jointDef), Box2D.b2WheelJoint)

  unpin: (slice)->
    @world.DestroyJoint @joints[slice.id]
    delete @joints[slice.id]

  update: (t, keyCode)->
    if @last_t == undefined
      @last_t = t / 1000
    for slice in @slices
      slice.update()
    t /= 1000
    @weather_system.update(t - @last_t)
    @particle_system.update(t - @last_t)
#    @ground.set_position([t / 10, 0])
    @body = @slices[0].body
    speed = 2.9
    slice = @slices[0]
    rotate = (keyCode['E'] or keyCode['Q'])
    @scene.shadowLight.position.z = -800 * Math.cos(@gear2.body.GetAngle())
    if keyCode['A']
      @body.ApplyLinearImpulse(new Box2D.b2Vec2(-speed, -speed), @body.GetPosition())
    if keyCode['D']
      @body.ApplyLinearImpulse(new Box2D.b2Vec2(speed, speed), @body.GetPosition())
    if keyCode['W']
      @body.ApplyLinearImpulse(new Box2D.b2Vec2(-speed, speed), @body.GetPosition())
    if keyCode['S']
      @body.ApplyLinearImpulse(new Box2D.b2Vec2(speed, -speed), @body.GetPosition())

    if rotate
      @body.SetLinearDamping(1.0)
      mass_data = new Box2D.b2MassData()
      @body.GetMassData(mass_data)
      mass_data.set_mass(1e9)
      @body.SetMassData(mass_data)
    else
      @body.SetLinearDamping(0.3)
      @body.ResetMassData()

    if rotate
      if keyCode['E']
        @body.ApplyAngularImpulse(speed * 1)
      if keyCode['Q']
        @body.ApplyAngularImpulse(-speed * 1)

    @world.Step(10 * (t - @last_t), 8, 8)

    tree_angle = @gear1.body.GetAngle() * 4
    intensity = Math.abs((Math.floor(tree_angle / Math.PI + 6 + 0.25) % 12 + 12) % 12 - 6) + 1
    @weather_system.set_intensity('rain', intensity / 10)
    @tree.rebuild(intensity)
    @particle_system.intensity = 50
    @tree_and_ground.rotation.y = tree_angle
    @tree_and_ground.position.x = 15
    @tree_and_ground.position.z = -15

    @last_t = t


class window.TestScene
  constructor: (scene)->
    @scene = scene
    @slices = []
    @joints = {}
    gravity = new Box2D.b2Vec2(0.0, 0.0)
    @world = new Box2D.b2World(gravity)
    @last_t = undefined
    create_gear = (r, d)->
      pol = (t, a)->
        [Math.cos(t) * a, Math.sin(t) * a]
      n = Math.floor(r * Math.PI / d)
      D = d
      result = []
      angle = 2 * Math.PI / n
      for i in [0...n]
        result.push pol angle * i, r
        result.push pol angle * i + angle * 0.4, r
        result.push pol angle * i + angle * 0.6, r + D
        result.push pol angle * i + angle * 0.8, r + D
      result
    create_box = (x, y, r)->
      [
        [x - r, y - r]
        [x + r, y - r]
        [x + r, y + r]
        [x - r, y + r]
      ]
    create_polygon = (x, y, r, n)->
      pol = (t, a)->
        [Math.cos(t) * a, Math.sin(t) * a]
      ([x + r * Math.cos(Math.PI * 2 / n * i), y + r * Math.sin(Math.PI * 2 / n * i)] for i in [0...n])
      ([x + r * Math.cos(Math.PI * 2 / n * i), y + r * Math.sin(Math.PI * 2 / n * i)] for i in [0...n])


    vertices = [
      {vertices: create_gear(1, 0.5), y:0}
    ]
    for i in [0...10]
      vertices.push
        vertices: create_polygon(0, 0, (10 - i) / 10, 8)
        y:1 + 0.3 * i
        depth : 0.3
    vertices.push
      vertices: create_polygon(0, 0, 1, 4)
      y:4
      depth : 0.5
    player = new Slice vertices, scene, @world, [1.0, 0.75, 0.72]
    @slices.push player
    player.body.SetBullet(true)
    player.set_position(-10, 0)

    vertices = [
      [30, -40]
      [30, -30]
      [40, -30]
      [40, 0]
      [0, 0]
      [0, 40]
      [-40, 40]
      [-40, -20]
      [-20, -20]
      [-20, -40]
    ]
    for vertex in vertices
      vertex[0] *= 0.5
      vertex[1] *= 0.5
    @ground = add_ground vertices, scene, @world, @slices, -1

#    gear = new Slice(
#      [
#        {vertices:create_gear(4, 0.5),y:0}
#        {vertices:create_gear(3, 0.5),y:1}
#        {vertices:create_gear(2, 0.4),y:2}
#      ], scene, @world, [1.0, 0.6, 0.8])
#    @slices.push gear
#    gear.set_position([5, -10])
#    gear.set_angle(0.01)
#    @pin_to_ground(gear)

    gear = new Slice(
      [
        {
          vertices:
            [
              [-0.6, -6]
              [0.6, -6]
              [0.6, 6]
              [-0.6, 6]
            ]
          y:0
        }
      ], scene, @world, [1.0, 0.6, 0.8])
    @slices.push gear
    gear.set_position([5, -10])
    gear.body.SetAngularDamping(0.5)
    @block = gear
    @pin_to_ground(gear)


  pin_to_ground: (slice)->
    jointDef = new Box2D.b2RevoluteJointDef()
    jointDef.set_bodyA(slice.body)
    jointDef.set_bodyB(@ground.body)
    jointDef.set_localAnchorA(new Box2D.b2Vec2(0.0, 0.0))
    jointDef.set_localAnchorB(slice.body.GetPosition())
    jointDef.set_collideConnected(false)
    @joints[slice.id] = Box2D.castObject(@world.CreateJoint(jointDef), Box2D.b2WheelJoint)

  unpin: (slice)->
    @world.DestroyJoint @joints[slice.id]
    delete @joints[slice.id]

  update: (t, keyCode)->
    delta_angle = ((@block.body.GetAngle() / Math.PI * 4 % 2.0) + 2) % 2 - 1
    eps = 0.05
    if delta_angle > 0
      delta_angle = Math.max(0, delta_angle - eps)
    else
      delta_angle = Math.min(0, delta_angle + eps)
    @block.body.ApplyAngularImpulse(-delta_angle * 5)
    if @last_t == undefined
      @last_t = t / 1000
    for slice in @slices
      slice.update()
    t /= 1000
    @body = @slices[0].body
    speed = 2.9
    slice = @slices[0]
    rotate = (keyCode['E'] or keyCode['Q'])
    if keyCode['A']
      @body.ApplyLinearImpulse(new Box2D.b2Vec2(-speed, -speed), @body.GetPosition())
    if keyCode['D']
      @body.ApplyLinearImpulse(new Box2D.b2Vec2(speed, speed), @body.GetPosition())
    if keyCode['W']
      @body.ApplyLinearImpulse(new Box2D.b2Vec2(-speed, speed), @body.GetPosition())
    if keyCode['S']
      @body.ApplyLinearImpulse(new Box2D.b2Vec2(speed, -speed), @body.GetPosition())

    if rotate
      @body.SetLinearDamping(1.0)
      mass_data = new Box2D.b2MassData()
      @body.GetMassData(mass_data)
      mass_data.set_mass(1e9)
      @body.SetMassData(mass_data)
    else
      @body.SetLinearDamping(0.3)
      @body.ResetMassData()

    if rotate
      if keyCode['E']
        @body.ApplyAngularImpulse(speed * 9)
      if keyCode['Q']
        @body.ApplyAngularImpulse(-speed * 9)

    @world.Step(10 * (t - @last_t), 8, 8)
    @last_t = t
