require "./texture_atlas_json_mapping"

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