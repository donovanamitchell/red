require "json"

class AnimationLibrary
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

  class AnimationFrame
    property order : Int32
    property x : Int32
    property y : Int32
    property w : Int32
    property h : Int32

    def initialize(@order : Int32, sprite : TextureAtlasSprite)
      @x = sprite.frame.x
      @y = sprite.frame.y
      @w = sprite.frame.w
      @h = sprite.frame.h
    end
  end

  class Animation
    def initialize()
      @frames = [] of AnimationFrame
    end

    def new_frame(order : Int32, sprite : TextureAtlasSprite)
      # TODO: put it in the right order
      # no guarantees around order except uniqueness
      raise "Unimplemented" if !@frames.empty? && @frames.last.order > order

      @frames.push(AnimationFrame.new(order, sprite))
    end
  end

  class Asset
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

    pp @assets
  end

  private def texture_mapping(atlas_filename : String)
    File.open(atlas_filename) do |file|
      TextureAtlas.from_json(file)
    end
  end
end