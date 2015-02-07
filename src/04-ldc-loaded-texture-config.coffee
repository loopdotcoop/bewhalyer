window.addEventListener 'load', ->
  loadedTextures = []
  for i in [0..7]
    loadedTextures.push 'shapes/shape-1/shape-1-f' + i + '.png'

  l._waiting = loadedTextures.length
  for src,i in loadedTextures
    new LoadedTexture
      id:  "loaded-texture-#{i}"
      src: src
      width:  128
      height: 128

