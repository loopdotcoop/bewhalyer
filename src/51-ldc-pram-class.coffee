class Pram
  constructor: (opt) ->
    @initPObject()       # make sure that the `p` object has been properly defined
    @parseOptions opt    # validate options, and record them as properties
    @recordInstance()    # make this instance available in `p`
    @overrideDefault()   # the URL fragment can override the default value
    @update()            # apply the value to the scene, and call custom `update()` functions

    @validateDOM()       # make sure that the page elements exist as expected
    @buildResetAllBtn()  # create a master reset button, if not already present
    @buildElement()      # create the <LABEL> element, and everything inside it



  # Construct the model
  initPObject: ->
    if 'object' != typeof p then throw "Please define a `p` object in application scope, I.E. `p = {}`, before calling `new Pram()`"
    p._prams   ?= []
    p._pramLut ?= {}

  parseOptions: (opt) ->
    @id      = @validId      opt.id
    @type    = @validType    opt.type
    @min     = @validMinmax  opt.min
    @max     = @validMinmax  opt.max
    @default = @validValue   opt.default
    @update  = @validUpdate  opt.update
    # @before  = @validActions opt.before
    # @after   = @validActions opt.after

  recordInstance: ->
    p._prams.push @
    p._pramLut[@id] = @
    Object.defineProperty p, @id, { get:@valueOf } # eg `p.bgStart` cannot be modified or deleted (nb, the `configurable` descriptor is `false` by default)

  overrideDefault: -> # @todo validate fragment value
    @set if fragValue = @parseFragment()[@id] then fragValue else @default



  # Helpers for `parseOptions()`
  types:
    color: /^#[a-f0-9]{6}$/i
    text:  /^[a-z]{0,24}$/
    range: /^[0-9.]+$/
    id:    /^[a-z][A-Za-z0-9]{0,11}$/

  validId: (id) ->
    if 'string' != typeof id then throw "`id` is type '#{typeof id}', not 'string'"
    if ! @types.id.test id   then throw "`id` '#{id}' fails #{@types.id.test}"
    if p[id]                 then throw "Duplicate `id` '#{id}'"
    id

  validType: (type) ->
    if 'string' != typeof type then throw "`type` is type '#{typeof type}', not 'string'"
    if ! @types[type]          then throw "`type` '#{type}' not recognized"
    type

  validMinmax: (minmax) ->
    if 'range' != @type then return null
    if 'number' != typeof minmax then throw "`min` or `max` is type '#{typeof minmax}', not 'number'"
    minmax

  validValue: (value) ->
    value += '' # coerce the value to a string
    if ! @types[@type].test value then throw "value '#{value}' fails #{@types[@type]}"
    value

  validUpdate: (update) ->
    if 'function' != typeof update then throw "`update` is type '#{typeof update}', not 'function'"
    update

  # actionNames: [
  #   'ready'
  #   'update'
  #   'reset'
  # ]
  # validActions: (actions) ->
  #   actions ?= {} # create an empty `actions` object, if falsey
  #   for actionName in @actionNames
  #     if 'undefined' == typeof actions[actionName] then actions[actionName] = ->
  #     if 'function'  != typeof actions[actionName] then throw "`#{actionName}` is type '#{typeof actionName}', not 'function'"
  #   actions



  # Construct the view
  validateDOM: ->
    if 'complete' != document.readyState then throw "`document.readyState` is currently '#{document.readyState}'. Please wait for 'complete', eg using `window.addEventListener('load', ...)`"
    if ! p._$container # first time `new Pram()` is called
      p._$container = $ '#pram'
      if ! p._$container then throw "Cannot find the `#pram` container element on the page. Please add an HTML element like `<fieldset id=\"pram\"></fieldset>`"
    if $ '#' + @id then throw "An element with id '\##{@id}' already exists on the page. Please remove the element, or change the id string '#{@id}' to something else"

  buildResetAllBtn: ->
    if ! p._$resetAll # first time `new Pram()` is called
      p._$resetAll = make 'a', { class:'button' }, 'Reset All'
      p._$resetAll.addEventListener 'click', -> parameter.reset() for parameter in p._prams
      p._$container.appendChild p._$resetAll

  buildElement: ->
    attr =
      value: @value
      type:  @type
    if null != @min then attr.min = @min
    if null != @max then attr.max = @max
    @$label = make 'label', {}, "<b>#{@id}</b>"
    @$value = make 'span', {}, @value
    @$default = make 'a', {}, @default
    @$default.addEventListener 'click', @reset
    @$input = make 'input', attr
    @$input.addEventListener 'input', (evt) =>
      @set evt.target.value
      @setFragment()
      @$value.innerHTML = @value
      @update()
    @$label.appendChild @$value
    @$label.appendChild @$default
    @$label.appendChild @$input
    p._$container.appendChild @$label



  # Fragment Helpers
  parseFragment: -> # parse the URL fragment into a JSON object
    fragment = {}
    for kv in (window.location.hash.substr 1).split '&' # `substr 1` removes the leading '#'
      [k,v] = kv.split '_'
      # k = decodeURIComponent k
      if p._pramLut[k] then fragment[k] = decodeURIComponent v
    fragment

  setFragment: ->
    return # @todo don’t fill up the browser history!
    obj = @parseFragment()
    if @default == @value
      delete obj[@id]
    else
      obj[@id] = @value
    out = for k,v of obj
      do -> "#{k}_#{v}"
    window.location.hash = out.join '&'



  # Define methods to be run at specific times
  reset: (evt) => # called when the 'Reset All' button or `@$default` link is clicked
    @set @default
    @$input.value = @default
    @setFragment()
    @update()
    evt?.preventDefault()



  # Getters and Setters
  set: (value) ->
    @value = @validValue value
  # toString: -> @value
  valueOf: => @value # note => not ->



