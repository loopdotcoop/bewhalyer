class Shape
  constructor: (opt) ->
    @initSObject()       # make sure that the `s` object has been properly defined
    @parseOptions opt    # validate options, and record them as properties
    @recordInstance()    # make this instance available in `s`

    @validateDOM()       # make sure that the page elements exist as expected
    @buildElement()      # create the <TRANSFORM> element, and everything inside it



  # Construct the model
  initSObject: ->
    if 'object' != typeof s then throw "Please define an `s` object in application scope, I.E. `s = {}`, before calling `new Shape()`"
    s._shapes   ?= []
    s._shapeLut ?= {}

  parseOptions: (opt) ->
    @x  = @validCoord opt, 'x'
    @y  = @validCoord opt, 'y'
    @z  = @validCoord opt, 'z'
    @id = @validId "#{@x}-#{@y}-#{@z}"

  recordInstance: ->
    s._shapes.push @
    s._shapeLut[@id] = @



  # Helpers for `parseOptions()`
  validCoord: (opt, name) ->
    coord = opt[name]
    if 'undefined' == typeof coord then throw "Coord `#{name}` is missing"
    if 'number' != typeof coord then throw "Coord `#{name}` has type '#{typeof coord}' not 'number'"
    coord

  validId: (id) ->
    if s._shapeLut[id] then throw "Duplicate Shape `id` '#{id}'"
    id



  # Construct the view
  validateDOM: ->
    if 'complete' != document.readyState then throw "`document.readyState` is currently '#{document.readyState}'. Please wait for 'complete', eg using `window.addEventListener('load', ...)`"
    if ! s._$container # first time `new Shape()` is called
      s._$container = $ '#shapes'
      if ! s._$container then throw "Cannot find the `#shapes` container element on the page. Please add an HTML element like `<transform id=\"shapes\"></transform>`"

  buildElement: ->
    x = @x + if @y % 2 then .5 else 0
    y = @y
    z = @z

    @t = make 'transform', { translation:"#{x} #{y} #{z}" }

    @$shape = make 'shape', { onclick:"window.shapes._shapeLut['#{@x}-#{@y}-#{@z}'].clicked()" }
      # onmouseover:"window.shapes[#{@x}][#{@y}][#{@z}].mouseovered()"
    # shapeTag = ['cone','cylinder','sphere','torus','box'][Math.floor Math.random() * 5 * (@x / config.xExtent)]
    # @colorIndex = (Math.floor Math.random() * config.diffusePalette.value.length * ((@x / config.xExtent.value) + (@z / config.zExtent.value)) / 2)
    if ! c._instances
      log "`c._instances` does not exist!"
    else
      @colorIndex = (Math.floor Math.random() * l._instances.length * ((@x / p.xExtent) + (@z / p.zExtent)) / 2) - 1
      @colorIndex = 0
      @$appearance = make 'appearance', { use:'loaded-texture-' + @colorIndex }
      @$shape.appendChild @$appearance
      # @colorUse = c._instances[(@x + @y + @z) % c._instances.length].id
      # if $ "appearance[def='#{@colorUse}']"
      #   s1.appendChild make 'appearance', { use:@colorUse }
      # else
      #   log "#{@colorUse} does not exist!"
    @$shape.appendChild make 'plane', { use:'small-plane' }

    bb = make 'billboard', { axisofrotation:'0 0 0' }
    bb.appendChild @$shape
    @t.appendChild bb
    s._$container.appendChild @t


  count: 0
  clicked: =>
    # log 'i jumped ' + @count + ' use image ' + (@count % (8*12) / 12)
    if 0 == @count % p.speed
      @$shape.removeChild @$appearance
      @$appearance = make 'appearance', { use:'loaded-texture-' + (@count % (8*p.speed) / p.speed) }
      @$shape.appendChild @$appearance
    @count = @count + 1
    if p.duration > @count then window.requestAnimationFrame @clicked else @count = 0


  destruct: ->
    # log 'destruct ' + @id
    empty @t
    if @t.parentNode == s._$container
      s._$container.removeChild @t
    delete s._shapeLut[@id]

