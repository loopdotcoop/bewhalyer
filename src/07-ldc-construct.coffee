amendColors = ->
  # Remove superfluous colors
  if c._instances # true before the first `Color` has been instantiated
    i = c._instances.length
    while --i
      c._instances[i].destruct()
      c._instances.splice i, 1
  # Add missing colors
  for [r,g,b,id] in c._defaults
    new Color { r:r, g:g, b:b, id:id }
  # Rebuild dependencies
  # @todo

amendShapes = ->
  # Remove superfluous shapes
#  log "amendShapes(): currently #{s._shapes?.length}, will be #{p.xExtent * p.yExtent * p.zExtent}"
  if s._shapes # false before the first `Shape` has been instantiated
    i = s._shapes.length
    while --i
      shape = s._shapes[i]
      [x,y,z] = shape.id.split '-'
      if x >= p.xExtent or y >= p.yExtent or z >= p.zExtent
        shape.destruct()
        s._shapes.splice i, 1
  # Add missing shapes
  for x in [0..p.xExtent-1]
    for y in [0..p.yExtent-1]
      for z in [0..p.zExtent-1]
        if ! s._shapeLut?[x + '-' + y + '-' + z] then new Shape { x:x, y:y, z:z }
  if s._$container # false before the first `Shape` has been instantiated
    s._$container.setAttribute 'translation', "-#{p.xExtent / 2} -#{p.yExtent / 2} -#{p.zExtent / 2}"


# After booting is complete, build the scene and begin animation
construct = ->
  log 'Constructing...'

  # $a = make 'appearance', { def:"flat-0" }
  # $a.appendChild make 'material', 
  #   diffuseColor:  'cyan'
  # $el.colorPalette.appendChild $a

  amendColors()
  amendShapes()

  # Rebuild the audio buffer
  # buffer = []
  # for colorIndex in [0..2]
  #   buffer[colorIndex] = []
  #   for noteNum in [0..config.yExtent]
  #     renderAudio noteNum, colorIndex

  # Build (or rebuild) the color palette
  # empty $el.colorPalette
  # for color,i in p.diffusePalette
  #   $a = make 'appearance', { def:"flat-#{i}" }
  #   $a.appendChild make 'material', 
  #     diffuseColor:  color
  #     specularColor: p.specularPalette[i] or 'black'
  #     emissiveColor: p.emissivePalette[i] or 'black'
  #   $el.colorPalette.appendChild $a


  # Build (or rebuild) the interactive elements
  # for x,j in shapes
  #   for y,k in x
  #     for z,l in y
  #       delete y[l]
  #     delete x[k]
  #   delete shapes[j]
  # empty $el.container
  # window.shapes = [] # @todo why does this break interactivity?
  # window.queue  = [] # @todo why does this break interactivity?
  # window.future = [] # @todo why does this break interactivity?

#  reset()

  # $('html').style.backgroundColor = config.backgroundBottom
  # $('body').style.backgroundImage = "linear-gradient(0deg, #{config.backgroundTop}, #{config.backgroundBottom})"
  # $('body').style.backgroundRepeat = "no-repeat"
  # $container.setAttribute 'translation', "-#{config.xExtent * config.xGap / 2} -#{config.yExtent * config.yGap / 2} -#{config.zExtent * config.zGap / 2}"
  # $container.setAttribute 'rotation'   , config.containerAxis + ' ' + (config.containerDegrees * 0.01745329251)
  # $container.setAttribute 'center'     , "#{config.xExtent * config.xGap / 2} #{config.yExtent * config.yGap / 2} #{config.zExtent * config.zGap / 2}"

  # $('fog').setAttribute 'visibilityRange', (Math.max config.xExtent, config.yExtent, config.zExtent) * 4
  # $('fog').setAttribute 'color', config.background
 

  # # Build (or rebuild) the interactive elements
  # for x in [0..p.xExtent-1]
  #   for y in [0..p.yExtent-1]
  #     shapes[x] ?= []
  #     shapes[x][y] = new Shape $el.container,x,y

  # window.requestAnimationFrame step
