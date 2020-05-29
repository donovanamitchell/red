require "./animation"
require "./animation_frame"
require "./texture_atlas_json_mapping"

# TODO rename to atlas?
class AnimationLibrary
  # TODO: move all these to appropriate places
  class Asset
    getter animations : Hash(String, Animation)

    def initialize
      @animations = Hash(String, Animation).new
    end

    def new_frame(animation_name : String, order : Int32, sprite : TextureAtlasSprite)
      unless @animations.has_key?(animation_name)
        @animations[animation_name] = Animation.new
      end

      @animations[animation_name].new_frame(order, sprite)
    end
  end

  getter assets : Hash(String, Asset)

  def initialize(atlas_filename : String)
    @assets = Hash(String, Asset).new

    texture_mapping(atlas_filename).frames.each do |frame|
      filename_parts = frame.filename.split("/")
      # TODO: raise a better exception
      raise "Unimplemented" if filename_parts.size != 3

      name = filename_parts[0]
      animation_name = filename_parts[1]
      animation_frame = filename_parts[2].to_i32

      unless @assets.has_key?(name)
        @assets[name] = Asset.new
      end

      @assets[name].new_frame(animation_name, animation_frame, frame)
    end
  end

  private def texture_mapping(atlas_filename : String)
    File.open(atlas_filename) do |file|
      TextureAtlas.from_json(file)
    end
  end
end