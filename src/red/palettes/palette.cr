module Red
  module Palettes
    class Palette
      property color_maps : Array(Hash(UInt8, SF::Color))

      def initialize
        @color_maps = [] of Hash(UInt8, SF::Color)
      end

      # TODO: Docs for this BS
      # The fragment shader is checking the red value against a table
      # (which is actually a texture). The image is not actually indexed, but is an
      # ordinary png because we're trying to run with absolute minimum textures.
      #
      # In short, This is hella wrong for how palette swapping should work in an
      # ideal world, and I am an idiot for trying
      def insert_palette(palette : Hash(UInt8, SF::Color))
        color_maps << palette
        color_maps.size - 1
      end

      # TODO: Hella wasted space here
      def generate_image
        image = SF::Image.new(256, @color_maps.size, SF::Color::Magenta)
        @color_maps.each_with_index do |color_map, index|
          color_map.each do |red_value, color|
            image.set_pixel(red_value, index, color)
          end
        end
        image
      end
    end
  end
end
