class LoadedTexture
  constructor: (opt) ->
    @initObject()        # make sure that the `l` object has been properly defined
    @parseOptions opt    # validate options, and record them as properties
    @recordInstance()    # make this instance available in `l`

    @validateDOM()       # make sure that the page elements exist as expected
    @buildElement()      # create the <APPEARANCE> element, and everything inside it
    @beginLoad()         # create the <IMAGE> element, which will load the image-file



  # Construct the model
  initObject: ->
    if 'object' != typeof l then throw "Please define an `l` object in application scope, I.E. `l = {}`, before calling `new LoadedTexture()`"
    l._instances   ?= []
    l._instanceLut ?= {}

  parseOptions: (opt) ->
    @id     = @validId       opt.id
    @src    = @validSrc      opt.src
    @width  = @validExtent   opt, 'width'
    @height = @validExtent   opt, 'height'

  recordInstance: ->
    l._instances.push @
    l._instanceLut[@id] = @



  # Helpers for `parseOptions()`
  validId: (id) ->
    idrx = /^[a-z][-a-z0-9]+$/
    if 'string' != typeof id then throw "LoadedTexture `id` is type '#{typeof id}', not 'string'"
    if ! idrx.test id        then throw "LoadedTexture `id` '#{id}' fails #{idrx}"
    if l._instanceLut[id]    then throw "Duplicate LoadedTexture `id` '#{id}'"
    id

  validSrc: (src) ->
    srcrx = /^[a-z][-/a-z0-9]+\.png$/
    if 'undefined' == typeof src then throw "`src` of LoadedTexture `#{@id}` is missing"
    if 'string' != typeof src    then throw "`src` of LoadedTexture `#{@id}` has type '#{typeof src}' not 'string'"
    if ! srcrx.test src          then throw "LoadedTexture `src` '#{src}' fails #{srcrx}"
    src

  validExtent: (opt, name) -> # http://www.skorks.com/2010/10/write-a-function-to-determine-if-a-number-is-a-power-of-2/
    extent = opt[name]
    if 'undefined' == typeof extent then throw "`#{name}` of LoadedTexture `#{@id}` is missing"
    if 'number' != typeof extent    then throw "`#{name}` of LoadedTexture `#{@id}` has type '#{typeof extent}' not 'number'"
    if extent % 1                   then throw "`#{name}` of LoadedTexture `#{@id}` is `#{extent}`, which is not an integer"
    if 1 > extent                   then throw "`#{name}` of LoadedTexture `#{@id}` is " + (if 0 == extent then 'zero' else 'negative')
    if extent & (extent - 1)        then throw "`#{name}` of LoadedTexture `#{@id}` is `#{extent}`, which is not a power of two (must be 1, 2, 4 ... 256, etc)"
    extent



  # Construct the view
  validateDOM: ->
    if 'complete' != document.readyState then throw "`document.readyState` is currently '#{document.readyState}'. Please wait for 'complete', eg using `window.addEventListener('load', ...)`"
    if ! l._$container # first time `new LoadedTexture()` is called
      l._$container = $ '#loaded-textures'
      if ! l._$container then throw "Cannot find the `#loaded-textures` container element on the page. Please add an HTML element like `<group id=\"loaded-textures\"></group>`"

  buildElement: ->
    @$a = make 'appearance', { def:@id }
    @$t = make 'texture'   , { hideChildren:'true' }
    @$c = make 'canvas'    ,
      width:  @width
      height: @height
      # id:     @id
    @ctx = @$c.getContext '2d'
    @$t.appendChild @$c
    @$a.appendChild @$t
    l._$container.appendChild @$a

  beginLoad: ->
    @$s = new Image()
    @$s.addEventListener 'load', =>
      log @src + ' is loaded'
      @ctx.drawImage @$s, 0, 0
      # @$t._x3domNode.invalidateGLObject()
      l._waiting--
      if ! l._waiting then log 'all done!'; window.dispatchEvent( new Event 'textures-ready' )
    @$s.src = @src



  destruct: ->
    log 'destruct ' + @id
    # empty @t
    # if @t.parentNode == s._$container
    #   s._$container.removeChild @t
    # delete c._instanceLut[@id]
