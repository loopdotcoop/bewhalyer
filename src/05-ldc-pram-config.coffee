window.addEventListener 'textures-ready', ->
  new Pram
    id:      'bgStart'
    type:    'color'
    default: '#7bec71'
    update: (evt) ->
      # log 'update bgStart' + p.bgStart + $('body')
      $('body').style.backgroundImage = "linear-gradient(180deg, #{p.bgStart}, #{p.bgEnd})"
  new Pram
    id:      'bgEnd'
    type:    'color'
    default: '#0d834a'
    update: ->
      $('body').style.backgroundImage = "linear-gradient(180deg, #{p.bgStart}, #{p.bgEnd})"

  new Pram
    id:      'xExtent'
    type:    'range'
    min:     1
    max:     30
    default: 2
    update: amendShapes
#    update: -> if c._instances then amendShapes() # @todo more elegant way of ensuring colours are defined before shapes
      # log 'xExtent: ' + @value

  new Pram
    id:      'yExtent'
    type:    'range'
    min:     1
    max:     30
    default: 2
    update: amendShapes
#    update: -> if c._instances then amendShapes() # @todo more elegant way of ensuring colours are defined before shapes

  new Pram
    id:      'zExtent'
    type:    'range'
    min:     1
    max:     30
    default: 1
    update: amendShapes

  new Pram
    id:      'speed'
    type:    'range'
    min:     1
    max:     30
    default: 12
    update: ->

  new Pram
    id:      'duration'
    type:    'range'
    min:     100
    max:     2000
    default: 500
    update: ->
#    update: -> if c._instances then amendShapes() # @todo more elegant way of ensuring colours are defined before shapes
      # log 'yExtent: ' + @value

#   xExtent:
#     type:  'range'
#     min:   1
#     max:   5
#     value: 1
#   yExtent:
#     type:  'range'
#     min:   1
#     max:   5
#     value: 1


# # Config (you can modify these)
# config =

#     # $('body').style.backgroundImage = "linear-gradient(180deg, #{config.backgroundTop}, #{config.backgroundBottom})"


#   backgroundTop:
#     type:  'text'
#     value: '#000066'
#     _bind:
#       input: ->
#         # $el.body.style.backgroundImage = "linear-gradient(180deg, #{$el.backgroundTop.value}, #{$el.backgroundBottom.value})"
#         updateHash @.id
#     _boot: ->
#       $el.body ?= $ 'body'
#       $el.backgroundTop ?= $ '#backgroundTop'
#       $el.backgroundBottom ?= $ '#backgroundBottom'
#       config.backgroundTop._bind.input()
#   backgroundBottom:
#     type:  'text'
#     value: 'black'
#     _bind:
#       input: ->
#         # $el.body.style.backgroundImage = "linear-gradient(180deg, #{$el.backgroundTop.value}, #{$el.backgroundBottom.value})"
#         updateHash @.id
#     _boot: ->
#       $el.body ?= $ 'body'
#       $el.backgroundTop ?= $ '#backgroundTop'
#       $el.backgroundBottom ?= $ '#backgroundBottom'
#       config.backgroundTop._bind.input()

#   diffusePalette:
#     type:  'text'
#     value: 'green,cyan,red,cyan,red,cyan,red'
#   specularPalette:
#     type:  'text'
#     value: 'green,#66ff99,yellow'
#   emissivePalette:
#     type:  'text'
#     value: '#001103,#00ff11,#110011'

#   cameraPercentX:
#     type:  'range'
#     min:   0
#     max:   200
#     value: 50
#     _bind:
#       input: -> # @todo is this working?
#         $style = $el.perspective.style
#         po = 'perspectiveOrigin'; poArray = $style[po].split '%'
#         $style[po] = @.value + '% ' + poArray[1] + '%'
#         # $style['-webkit-perspective-origin'] = @.value + '% ' + poArray[1] + '%'
#     # _boot: ->
#     #   $el.perspective = $('.perspective')
#     #   $el.perspective.style.perspectiveOrigin = config.cameraPercentX.value + '% ' + config.cameraPercentY.value + '%'
#   cameraPercentY:
#     type:  'range'
#     min:   0
#     max:   200
#     value: 50
#     _bind:
#       input: ->
#         $style = $el.perspective.style
#         po = 'perspectiveOrigin'; poArray = $style[po].split '%'
#         $style[po] = poArray[0] + '% ' + @.value + '%'
#   cameraAngle:
#     type:  'range'
#     min:   10
#     max:   500
#     value: 250
#     _bind:
#       input: -> $('.perspective').style.perspective = @.value + 'px'
#       # input: -> $('.perspective').style['-webkit-perspective'] = @.value + 'px'
#     # _boot: ->
#     #   $el.perspective.style.perspective = config.cameraAngle.value + 'px'
#   xExtent:
#     type:  'range'
#     min:   1
#     max:   5
#     value: 1
#   yExtent:
#     type:  'range'
#     min:   1
#     max:   5
#     value: 1
#   zExtent:
#     type:  'range'
#     min:   1
#     max:   5
#     value: 1
#   containerRotation:
#     type:  'range'
#     min:   0
#     max:   360
#     value: 90
#     # _bind:
#     #   input: ->
#     #     $el.container.style.transform = 'rotate3d(1,0,1,' + @.value + 'deg)'
#     #     document.title = @.value
#     # _boot: ->
#     #   $el.container.style.transform = 'rotate3d(1,0,1,' + config.containerRotation.value + 'deg) translate3d(1em,1em,1em)'
#     #   $el.container.style.transformOrigin = '-50% -50% 50%'


# # v.onkeypress = "if (event.which == 13 || event.keyCode == 13) { construct() }"


# # 
# for k,v of config
#   config[k].default = v.value


# # Parse the query string for config overrides
# for kv in (window.location.hash.substr 1).split '&' # `substr 1` removes the leading '?'
#   [k,v] = kv.split '_'
#   k = decodeURIComponent k
#   if config[k] then config[k].value = decodeURIComponent v


# # Calculated from `config` (don't modify these, let the program work them out)
# calcConfig = ->
#   # config.clickPowerDiffDivider = config.clickDuration.value / config.clickPower.value
#   # config.propagationRate.value = parseInt config.propagationRate.value, 10
#   # config.spaceScatter.value    = parseFloat config.spaceScatter.value
#   # config.timeScatter.value     = parseFloat config.timeScatter.value
#   config.diffusePalette.value  = config.diffusePalette .value.split ','
#   config.specularPalette.value = config.specularPalette.value.split ','
#   config.emissivePalette.value = config.emissivePalette.value.split ','
#   # for k,v of config
#   #   v.default = v.value


# calcConfig()


