require "./animation"
require "./frame"
require "./serializers"

# TODO rename to atlas?
module Red
  module Animations
    class Atlas
      @@assets = Hash(String, Asset).new

      # TODO: move all these to appropriate places
      class Asset
        getter animations : Hash(String, Animation)

        def initialize
          @animations = Hash(String, Animation).new
        end

        def new_frame(animation_name : String, order : Int32, sprite : Serializers::Sprite)
          unless @animations.has_key?(animation_name)
            @animations[animation_name] = Animation.new
          end

          @animations[animation_name].new_frame(order, sprite)
        end
      end

      def self.assets
        @@assets
      end

      def self.load_assets(atlas_file)
        Serializers::Sprites.from_json(atlas_file).frames.each do |frame|
          name = frame.filename
          animation_name = frame.tag
          animation_frame = frame.frame_order

          unless @@assets.has_key?(name)
            @@assets[name] = Asset.new
          end

          @@assets[name].new_frame(animation_name, animation_frame, frame)
        end
      end
    end
  end
end
