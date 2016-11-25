class window.Tree
  constructor: (@size, @max_depth, @scene)->
    @depth = @size * 0.1
    @tree = undefined
    @object = new THREE.Object3D()
    @rebuild @max_depth
    @scene.add @object

  rebuild: (max_depth)->
    first_build = @tree == undefined
    if max_depth == @max_depth and not first_build
      return
    if not first_build
      if max_depth == 7
        deltas = [-1, 0, 1, 0, undefined, 1]
      else
        deltas = [-1]
      for delta, i in deltas
#        if delta !=
        do (delta, i)->
          if delta == undefined
            return
          setTimeout ->
            howl = new Howl
              urls: ["sound/nan/sound#{max_depth + 1 + delta}a.wav"]
              volume: Math.pow(max_depth / 10, 3)
            howl.play()
          , i * 300
#      setTimeout ->
#        howl = new Howl
#          urls: ["sound/base.wav"]
#          volume: 0.01
#        howl.play()
#      , 300

    @max_depth = max_depth
    unless first_build
      @object.remove @tree
    @tree = @build @size, 0
    @object.add @tree

  generate_box: (size, color)->
    geometry = new THREE.BoxGeometry size * 0.1, size, @depth
    material = new THREE.MeshPhongMaterial
      color: color
      shininess: 0
      ambient: color
    mesh = new THREE.Mesh geometry, material
    mesh.castShadow = true
    box = new THREE.Object3D
    box.add mesh
    mesh.position.y = size / 2
    box

  build: (size, depth)->
    ratio = 1.0 * depth / @max_depth / 2 + 0.5
    parent = @generate_box size, new THREE.Color(0.5, 1.0 * ratio, 0.4 * ratio)

    if depth + 1 < @max_depth
      for i in [0...2]
        child = @build size / 1.6, depth + 1
        parent.add child

        child.rotation.z = Math.PI * (-0.25 + i / 2)
        child.position.y = size

    parent