window.addEventListener 'load', ->
  log 'Booting...', false

  # Now that the DOM is ready, get some handy element references
  # $el.config       = $ '#config'
  $el.container    = $ '#container'
  $el.colorPalette = $ '#colorPalette'

  # Create a labelled <INPUT> for each `config` item
  # for k,v of config
  #   label = make 'label', {}, k + ':'
  #   v.id = k
  #   input = make 'input', v # nb, `make()` will not add an attribute whose name begins with an underscore, eg '_bind'
  #   for nm,fn of v._bind
  #     input.addEventListener nm, fn
  #   label.appendChild input
  #   $el.config.appendChild label

  # Add the 'Rebuild' button
  # $button = make 'a', { class:'button' }, 'Rebuild'
  # $button.addEventListener 'click', construct
  # $el.config.appendChild $button

  # Run `_boot` functions in `config`
  # for k,v of config
  #   v._boot?() 

  # After booting is complete, build the scene
  construct()


