require "./frame"
require "./texture_atlas_json_mapping"

module Red
  module Animations
    class Animation
      getter frames

      def initialize()
        @frames = [] of Frame
      end

      def new_frame(order : Int32, sprite : TextureAtlasSprite)
        frame = @frames.find { |f| f.order == order }
        if frame
          frame.insert_layer(sprite)
        else
          # TODO: optimize? BST?
          index = @frames.index do |frame|
            frame.order > order
          end
          index ||= -1

          @frames.insert(index, Frame.new(order, sprite))
        end
      end
    end
  end
end
