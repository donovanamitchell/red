require "json"
require "./anchor"
require "./bounds"
require "./size"

module Red
  module Animations
    module Serializers
      class Sprite
        include JSON::Serializable

        property anchors : Array(Anchor) | Nil
        property duration : Int32
        property filename : String
        property frame_order : Int32
        property frame : Bounds
        property layer : String
        property rotated : Bool
        property sourceSize : Size
        property spriteSourceSize : Bounds
        property tag : String
        property trimmed : Bool
      end
    end
  end
end
