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
    filename: String,
    frame: TextureAtlasFrame,
    tag: String,
    frame_order: Int32,
    rotated: Bool,
    trimmed: Bool,
    spriteSourceSize: TextureAtlasFrame,
    sourceSize: TextureAtlasSourceSize,
    duration: Int32,
    anchors: { type: Array(TextureAtlasAnchor), nilable: true }
  )
end

class TextureAtlas
  JSON.mapping(
    frames: Array(TextureAtlasSprite)
  )
end