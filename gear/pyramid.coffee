initBuffers = ->
  pyramidVertexPositionBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, pyramidVertexPositionBuffer
  vertices = [
    # Front face
    0.0
    1.0
    0.0
    -1.0
    -1.0
    1.0
    1.0
    -1.0
    1.0

    # Right face
    0.0
    1.0
    0.0
    1.0
    -1.0
    1.0
    1.0
    -1.0
    -1.0

    # Back face
    0.0
    1.0
    0.0
    1.0
    -1.0
    -1.0
    -1.0
    -1.0
    -1.0

    # Left face
    0.0
    1.0
    0.0
    -1.0
    -1.0
    -1.0
    -1.0
    -1.0
    1.0
  ]
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW
  pyramidVertexPositionBuffer.itemSize = 3
  pyramidVertexPositionBuffer.numItems = 12


  pyramidVertexColorBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, pyramidVertexColorBuffer
  colors = [

    # Front face
    1.0
    0.0
    0.0
    1.0
    0.0
    1.0
    0.0
    1.0
    0.0
    0.0
    1.0
    1.0

    # Right face
    1.0
    0.0
    0.0
    1.0
    0.0
    0.0
    1.0
    1.0
    0.0
    1.0
    0.0
    1.0

    # Back face
    1.0
    0.0
    0.0
    1.0
    0.0
    1.0
    0.0
    1.0
    0.0
    0.0
    1.0
    1.0

    # Left face
    1.0
    0.0
    0.0
    1.0
    0.0
    0.0
    1.0
    1.0
    0.0
    1.0
    0.0
    1.0
  ]
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW
  pyramidVertexColorBuffer.itemSize = 4
  pyramidVertexColorBuffer.numItems = 12

  cubeVertexPositionBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, cubeVertexPositionBuffer
  vertices = [

    # Front face
    -1.0
    -1.0
    1.0
    1.0
    -1.0
    1.0
    1.0
    1.0
    1.0
    -1.0
    1.0
    1.0

    # Back face
    -1.0
    -1.0
    -1.0
    -1.0
    1.0
    -1.0
    1.0
    1.0
    -1.0
    1.0
    -1.0
    -1.0

    # Top face
    -1.0
    1.0
    -1.0
    -1.0
    1.0
    1.0
    1.0
    1.0
    1.0
    1.0
    1.0
    -1.0

    # Bottom face
    -1.0
    -1.0
    -1.0
    1.0
    -1.0
    -1.0
    1.0
    -1.0
    1.0
    -1.0
    -1.0
    1.0

    # Right face
    1.0
    -1.0
    -1.0
    1.0
    1.0
    -1.0
    1.0
    1.0
    1.0
    1.0
    -1.0
    1.0

    # Left face
    -1.0
    -1.0
    -1.0
    -1.0
    -1.0
    1.0
    -1.0
    1.0
    1.0
    -1.0
    1.0
    -1.0
  ]
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW
  cubeVertexPositionBuffer.itemSize = 3
  cubeVertexPositionBuffer.numItems = 24

  cubeVertexColorBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, cubeVertexColorBuffer
  colors = [
    [# Front face
      1.0
      0.0
      0.0
      1.0
    ]
    [# Back face
      1.0
      1.0
      0.0
      1.0
    ]
    [# Top face
      0.0
      1.0
      0.0
      1.0
    ]
    [# Bottom face
      1.0
      0.5
      0.5
      1.0
    ]
    [# Right face
      1.0
      0.0
      1.0
      1.0
    ]
    [# Left face
      0.0
      0.0
      1.0
      1.0
    ]
  ]
  unpackedColors = []
  for i of colors
    color = colors[i]
    j = 0

    while j < 4
      unpackedColors = unpackedColors.concat(color)
      j++
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(unpackedColors), gl.STATIC_DRAW
  cubeVertexColorBuffer.itemSize = 4
  cubeVertexColorBuffer.numItems = 24
  cubeVertexIndexBuffer = gl.createBuffer()
  gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, cubeVertexIndexBuffer
  cubeVertexIndices = [
    0 # Front face
    1
    2
    0
    2
    3
    4 # Back face
    5
    6
    4
    6
    7
    8 # Top face
    9
    10
    8
    10
    11
    12 # Bottom face
    13
    14
    12
    14
    15
    16 # Right face
    17
    18
    16
    18
    19
    20 # Left face
    21
    22
    20
    22
    23
  ]
  gl.bufferData gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(cubeVertexIndices), gl.STATIC_DRAW
  cubeVertexIndexBuffer.itemSize = 1
  cubeVertexIndexBuffer.numItems = 36


  initBuffers = ->
  cubeVertexPositionBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, cubeVertexPositionBuffer
  vertices = [
    # Front face
    -1.0
    -1.0
    1.0
    1.0
    -1.0
    1.0
    1.0
    1.0
    1.0
    -1.0
    1.0
    1.0

    # Back face
    -1.0
    -1.0
    -1.0
    -1.0
    1.0
    -1.0
    1.0
    1.0
    -1.0
    1.0
    -1.0
    -1.0

    # Top face
    -1.0
    1.0
    -1.0
    -1.0
    1.0
    1.0
    1.0
    1.0
    1.0
    1.0
    1.0
    -1.0

    # Bottom face
    -1.0
    -1.0
    -1.0
    1.0
    -1.0
    -1.0
    1.0
    -1.0
    1.0
    -1.0
    -1.0
    1.0

    # Right face
    1.0
    -1.0
    -1.0
    1.0
    1.0
    -1.0
    1.0
    1.0
    1.0
    1.0
    -1.0
    1.0

    # Left face
    -1.0
    -1.0
    -1.0
    -1.0
    -1.0
    1.0
    -1.0
    1.0
    1.0
    -1.0
    1.0
    -1.0
  ]
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW
  cubeVertexPositionBuffer.itemSize = 3
  cubeVertexPositionBuffer.numItems = 24

  cubeVertexColorBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, cubeVertexColorBuffer
  colors = [
    [# Front face
      1.0
      0.0
      0.0
      1.0
    ]
    [# Back face
      1.0
      1.0
      0.0
      1.0
    ]
    [# Top face
      0.0
      1.0
      0.0
      1.0
    ]
    [# Bottom face
      1.0
      0.5
      0.5
      1.0
    ]
    [# Right face
      1.0
      0.0
      1.0
      1.0
    ]
    [# Left face
      0.0
      0.0
      1.0
      1.0
    ]
  ]
  unpackedColors = []
  for color in colors
    for j in [0...4]
      unpackedColors = unpackedColors.concat(color)
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(unpackedColors), gl.STATIC_DRAW
  cubeVertexColorBuffer.itemSize = 4
  cubeVertexColorBuffer.numItems = 24

  cubeVertexIndexBuffer = gl.createBuffer()
  gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, cubeVertexIndexBuffer
  cubeVertexIndices = [
    0 # Front face
    1
    2
    0
    2
    3
    4 # Back face
    5
    6
    4
    6
    7
    8 # Top face
    9
    10
    8
    10
    11
    12 # Bottom face
    13
    14
    12
    14
    15
    16 # Right face
    17
    18
    16
    18
    19
    20 # Left face
    21
    22
    20
    22
    23
  ]
  gl.bufferData gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(cubeVertexIndices), gl.STATIC_DRAW
  cubeVertexIndexBuffer.itemSize = 1
  cubeVertexIndexBuffer.numItems = 36

  normals = []
  for k in [0...cubeVertexIndices.length / 3]
    vec = []
    for i in [0...3]
      vec.push vec3.fromValues vertices[cubeVertexIndices[k * 3 + i] * 3], vertices[cubeVertexIndices[k * 3 + i] * 3 + 1], vertices[cubeVertexIndices[k * 3 + i] * 3 + 2]
    vec3.subtract(vec[1], vec[1], vec[0])
    vec3.subtract(vec[2], vec[2], vec[0])
    normal = vec3.create()
    vec3.cross(normal, vec[1], vec[2])
    vec3.normalize(normal, normal)
    for i in [0...3]
      normals[cubeVertexIndices[k * 3 + i]] = normal
      normals[cubeVertexIndices[k * 3 + i]] = normal
      normals[cubeVertexIndices[k * 3 + i]] = normal
  normal_values = []
  for i of normals
    normal_values.push(normals[i][0], normals[i][1], normals[i][2])
  console.log(normal_values.length)
  console.log(vertices.length)
  normals = normal_values

  cubeVertexNormalBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, cubeVertexNormalBuffer
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW
  cubeVertexNormalBuffer.itemSize = 3
  cubeVertexNormalBuffer.numItems = 24
