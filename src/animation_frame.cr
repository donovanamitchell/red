require "./texture_atlas_json_mapping"

class AnimationFrame
  property order : Int32
  property x : Int32
  property y : Int32
  property w : Int32
  property h : Int32
  property x_offset : Int32
  property y_offset : Int32
  property offset : SF::Vector2(Int32)
  property full_w : Int32
  property full_h : Int32
  property duration_ms : Int32
  property anchor : SF::Vector2(Int32)

  def initialize(@order : Int32, sprite : TextureAtlasSprite)
    @x = sprite.frame.x
    @y = sprite.frame.y
    @w = sprite.frame.w
    @h = sprite.frame.h
    @x_offset = sprite.spriteSourceSize.x
    @y_offset = sprite.spriteSourceSize.y
    @offset = SF.vector2(@x_offset, @y_offset)
    @full_w = sprite.sourceSize.w
    @full_h = sprite.sourceSize.h
    @duration_ms = sprite.duration
    anchors = sprite.anchors
    if !anchors.nil? && anchors.size > 0
      json_anchor = anchors.first
      @anchor = SF.vector2(json_anchor.x, json_anchor.y)
    else
      @anchor = SF.vector2(@x, @y)
    end
  end
end