class Color
  constructor: (opt) ->
    @initObject()        # make sure that the `c` object has been properly defined
    @parseOptions opt    # validate options, and record them as properties
    @recordInstance()    # make this instance avaiable in `c`

    @validateDOM()       # make sure that the page elements exist as expected
    @buildElement()      # create the <TRANSFORM> element, and everything inside it



  # Construct the model
  initObject: ->
    if 'object' != typeof c then throw "Please define a `c` object in application scope, I.E. `c = {}`, before calling `new Color()`"
    c._instances   ?= []
    c._instanceLut ?= {}

  parseOptions: (opt) ->
    @id  = @validId       opt.id
    @r   = @validChannel  opt, 'r'
    @g   = @validChannel  opt, 'g'
    @b   = @validChannel  opt, 'b'
    @hex = @channelsToHex @r, @g, @b

  recordInstance: ->
    c._instances.push @
    c._instanceLut[@id] = @



  # Helpers for `parseOptions()`
  validId: (id) ->
    idrx = /^[O-Z][0-9]$/
    if 'string' != typeof id then throw "Color `id` is type '#{typeof id}', not 'string'"
    if ! idrx.test id        then throw "Color `id` '#{id}' fails #{idrx}"
    if c._instanceLut[id]    then throw "Duplicate Color `id` '#{id}'"
    id

  validChannel: (opt, name) ->
    channel = opt[name]
    if 'undefined' == typeof channel then throw "Channel `#{name}` of Color `#{@id}` is missing"
    if 'number' != typeof channel    then throw "Channel `#{name}` of Color `#{@id}` has type '#{typeof channel}' not 'number'"
    if ! (0 <= channel <= 255)       then throw "Channel `#{name}` of Color `#{@id}` is `#{channel}`, which is out of range (must be 0 to 255)"
    if channel % 1                   then throw "Channel `#{name}` of Color `#{@id}` is `#{channel}`, which is not an integer"
    channel

  channelsToHex: (r, g, b) ->
    '#' + (@channelToHex r) + (@channelToHex g) + (@channelToHex b)

  channelToHex: (channel) ->
    (if 16 >= channel then '0' else '') + channel.toString 16


  # Construct the view
  validateDOM: ->
    if 'complete' != document.readyState then throw "`document.readyState` is currently '#{document.readyState}'. Please wait for 'complete', eg using `window.addEventListener('load', ...)`"
    if ! c._$container # first time `new Color()` is called
      c._$container = $ '#colors'
      if ! c._$container then throw "Cannot find the `#colors` container element on the page. Please add an HTML element like `<group id=\"colors\"></group>`"

  buildElement: ->
    @$a = make 'appearance', { def:@id }
    @$a.appendChild make 'material', 
      diffuseColor: @hex
      # specularColor: "#{@r},#{@g},#{@b}"
      # emissiveColor: "#{@r},#{@g},#{@b}"
    c._$container.appendChild @$a



  destruct: ->
    # log 'destruct ' + @id
    empty @t
    if @t.parentNode == s._$container
      s._$container.removeChild @t
    delete c._instanceLut[@id]

