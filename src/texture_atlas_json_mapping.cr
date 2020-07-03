require "json"

# TODO: move all these to appropriate places
class TextureAtlasSourceSize
  JSON.mapping(
    w: Int32,
    h: Int32
  )
end

class TextureAtlasAnchor
  JSON.mapping(
    name: String,
    x: Int32,
    y: Int32
  )
end

class TextureAtlasFrame
  JSON.mapping(
    x: Int32,
    y: Int32,
    w: Int32,
    h: Int32
  )
end

class TextureAtlasSprite
  JSON.mapping(
    anchors: { type: Array(TextureAtlasAnchor), nilable: true },
    duration: Int32,
    filename: String,
    frame_order: Int32,
    frame: TextureAtlasFrame,
    layer: String,
    rotated: Bool,
    sourceSize: TextureAtlasSourceSize,
    spriteSourceSize: TextureAtlasFrame,
    tag: String,
    trimmed: Bool
  )
end

class TextureAtlas
  JSON.mapping(
    frames: Array(TextureAtlasSprite)
  )
end