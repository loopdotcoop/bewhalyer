window.addEventListener 'load', ->
  count = 1
  jump = ->
    if 0 == count % 12
      # log 'i jumped ' + count + ' use image ' + (count % (8*12) / 12)
      for shape in s._shapes
        shape.$shape.removeChild shape.$appearance
        shape.$appearance = make 'appearance', { use:'loaded-texture-' + (count % (8*12) / 12) }
        shape.$shape.appendChild shape.$appearance
    count = count + 1
    if 2000 > count then window.requestAnimationFrame jump

  # window.requestAnimationFrame jump

