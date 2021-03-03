require "./texture_atlas_json_mapping"

module Red
  module Animations
    class Frame
      struct Anchor
        property name : String
        property x : Int32
        property y : Int32
        def initialize(@name, @x, @y) ; end
      end

      # TODO: replace with JSON serializer class? All the data is already in there
      struct Layer
        property name : String
        property x : Int32
        property y : Int32
        property w : Int32
        property h : Int32
        property x_offset : Int32
        property y_offset : Int32
        property offset : SF::Vector2(Int32)

        def initialize(@name, @x, @y, @w, @h, @x_offset, @y_offset)
          @offset = SF.vector2(@x_offset, @y_offset)
        end
      end

      property order : Int32
      property full_w : Int32
      property full_h : Int32
      property duration_ms : Int32
      property primary_anchor : Anchor
      property anchors : Array(Anchor)
      property layers : Array(Layer)

      def initialize(@order : Int32, sprite : TextureAtlasSprite)
        @layers = [
          Layer.new(
            sprite.layer,
            sprite.frame.x,
            sprite.frame.y,
            sprite.frame.w,
            sprite.frame.h,
            sprite.spriteSourceSize.x,
            sprite.spriteSourceSize.y
          )
        ]

        @full_w = sprite.sourceSize.w
        @full_h = sprite.sourceSize.h
        @duration_ms = sprite.duration
        sprite_anchors = sprite.anchors
        @anchors = if !sprite_anchors.nil?
          sprite_anchors.map do |anchor|
            Anchor.new(x: anchor.x, y: anchor.y, name: anchor.name)
          end
        else
          [] of Anchor
        end
        @primary_anchor = @anchors.find(
          Anchor.new(x: sprite.frame.x, y: sprite.frame.y, name: "primary")
        ) do |anchor|
          anchor.name == "primary"
        end
        @anchors << @primary_anchor if @anchors.empty?
      end

      # TODO Can I do this better?
      def contains?(position : SF::Vector2, point : SF::Vector2)
        @layers.any? do |layer|
          SF::IntRect.new(
            position + layer.offset,
            SF.vector2i(layer.w, layer.h)
          ).contains?(point)
        end
      end

      def insert_layer(sprite : TextureAtlasSprite)
        @layers << Layer.new(
          sprite.layer,
          sprite.frame.x,
          sprite.frame.y,
          sprite.frame.w,
          sprite.frame.h,
          sprite.spriteSourceSize.x,
          sprite.spriteSourceSize.y
        )
      end
    end
  end
end
