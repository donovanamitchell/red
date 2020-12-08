class Card
  property art_name : String
  property frame_name : String
  property text : String

  def initialize(@text, @art_name, @frame_name)

  end
end

class CardGameObject < Red::GameObject
  OFFSET = SF.vector2i(2,2)
  property card : Card
  property art : Red::Renderable
  property frame : Red::Renderable

  def initialize(@position, @card, @render_order = 0)
    @art = Red::Renderable.new(@card.art_name, "")
    @frame = Red::Renderable.new(@card.frame_name, "")
  end

  def hitbox_contains?(point)
    frame.hitbox_contains?(position, point)
  end

  def objects_at(point)
    hitbox_contains?(point) ? [self] : [] of Red::GameObject
  end

  def quads
    frame.new_verticies(position).concat(art.new_verticies(position + OFFSET))
  end

  def start_animation(_animation_key) ; end

  def update ; end
end
