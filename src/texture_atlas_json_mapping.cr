require "json"

# TODO: move all these to appropriate places
class TextureAtlasSourceSize
  JSON.mapping(
    w: Int32,
    h: Int32
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
    rotated: Bool,
    trimmed: Bool,
    spriteSourceSize: TextureAtlasFrame,
    sourceSize: TextureAtlasSourceSize,
    duration: Int32
  )
end

class TextureAtlas
  JSON.mapping(
    frames: Array(TextureAtlasSprite)
  )
end