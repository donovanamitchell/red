class Card
  property art_name : String
  property frame_name : String
  property text : String

  def initialize(@text, @art_name, @frame_name)

  end
end

class CardGameObject < Red::GameObjects::GameObject
  OFFSET = SF.vector2i(2,2)
  property art : Red::Renderables::Renderable
  property frame : Red::Renderables::Renderable

  def initialize(@position, card, @render_order = 0)
    @art = Red::Renderables::Renderable.new(card.art_name, "")
    @frame = Red::Renderables::Renderable.new(card.frame_name, "")
  end

  def hitbox_contains?(point)
    frame.hitbox_contains?(position, point)
  end

  def objects_at(point)
    hitbox_contains?(point) ? [self] : [] of Red::GameObjects::GameObject
  end

  def quads
    frame.new_verticies(position).concat(art.new_verticies(position + OFFSET))
  end

  def start_animation(_animation_key) ; end

  def update ; end
end
