require "json"

module Red
  # TODO: move all these to appropriate places
  class TextureAtlasSourceSize
    include JSON::Serializable

    property w : Int32
    property h : Int32
  end

  class TextureAtlasAnchor
    include JSON::Serializable

    property x : Int32
    property y : Int32
    property name : String
  end

  class TextureAtlasFrame
    include JSON::Serializable

    property x : Int32
    property y : Int32
    property w : Int32
    property h : Int32
  end

  class TextureAtlasSprite
    include JSON::Serializable

    property anchors : Array(TextureAtlasAnchor) | Nil
    property duration : Int32
    property filename : String
    property frame_order : Int32
    property frame : TextureAtlasFrame
    property layer : String
    property rotated : Bool
    property sourceSize : TextureAtlasSourceSize
    property spriteSourceSize : TextureAtlasFrame
    property tag : String
    property trimmed : Bool
  end

  class TextureAtlas
    include JSON::Serializable

    property frames : Array(TextureAtlasSprite)
  end
end