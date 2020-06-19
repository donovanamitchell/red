require "./texture_atlas_json_mapping"

class AnimationFrame
  struct Anchor
    property name : String
    property x : Int32
    property y : Int32
    def initialize(@name, @x, @y) ; end
  end
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
  property primary_anchor : Anchor
  property anchors : Array(Anchor)

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
    sprite_anchors = sprite.anchors
    @anchors = if !sprite_anchors.nil?
      sprite_anchors.map do |anchor|
        Anchor.new(x: anchor.x, y: anchor.y, name: anchor.name)
      end
    else
      [] of Anchor
    end
    @primary_anchor = @anchors.find(Anchor.new(x: @x, y: @y, name: "primary")) do |anchor|
      anchor.name == "primary"
    end
    @anchors << @primary_anchor if @anchors.empty?
  end
end