require "./texture_atlas_json_mapping"

module Red
  module Animations
    class NilFrame < Frame
      property order : Int32
      property full_w : Int32
      property full_h : Int32
      property duration_ms : Int32
      property primary_anchor : Anchor
      property anchors : Array(Anchor)
      property layers : Array(Layer)

      def initialize
        @order = 0
        @layers = [] of Layer
        @full_w = 0
        @full_h = 0
        @duration_ms = 0
        @primary_anchor = Anchor.new(x: 0, y: 0, name: "primary")
        @anchors = [@primary_anchor]
      end

      def contains?(position : SF::Vector2, point : SF::Vector2)
        false
      end

      def insert_layer(sprite : TextureAtlasSprite)
        @layers
      end
    end
  end
end
