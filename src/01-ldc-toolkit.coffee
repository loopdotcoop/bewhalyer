# Display logs
log = (html, append=true) ->
  $pre = $ '#log'
  if $pre and html
    if append then $pre.innerHTML += '\n' + html else $pre.innerHTML = html
    $pre.scrollTop = $pre.scrollHeight
    console.log html


# Various DOM Helpers (jQuery would be overkill for this simple app)

$  = document.querySelector.bind document # http://stackoverflow.com/a/12637169
$$ = document.querySelectorAll.bind document

make = (tag, attr, inner) ->
  el = document.createElement tag
  for k,v of attr
    if '_' != k.substr 0, 1 # do not add an attribute whose name begins with an underscore, eg '_bind'
      el.setAttribute k, v
  if inner then el.innerHTML = inner
  return el

empty = (node) ->
  while node.hasChildNodes()
    node.removeChild node.lastChild


# Parse the URL hash into a JSON object
fragmentObj = ->
  fragment = {}
  for kv in (window.location.hash.substr 1).split '&' # `substr 1` removes the leading '#'
    [k,v] = kv.split '_'
    # k = decodeURIComponent k
    if pram[k] then fragment[k] = decodeURIComponent v
  fragment


updateHash = (id) ->
  if ! config[id] then return # @todo why is `updateHash()` called with null id?
  hash = {}
  defaultVal = config[id].value
  currentVal = $el[id].value

  # Parse the URL hash into a JSON object
  for kv in (window.location.hash.substr 1).split '&' # `substr 1` removes the leading '#'
    [k,v] = kv.split '_'
    k = decodeURIComponent k
    if config[k] then hash[k] = decodeURIComponent v

  # Update the JSON object
  if defaultVal == currentVal
    delete hash[id]
  else
    hash[id] = $el[id].value
  log hash
  # Output the JSON object to the URL hash
  out = []
  for k,v of hash
    out.push encodeURIComponent k + '_' + encodeURIComponent v
  window.location.hash = out.join '&'

  # log hash#config[id].value + $el[id].value


