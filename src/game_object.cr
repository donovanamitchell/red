require "./renderable"

class GameObject
  property position : SF::Vector2(Int32)
  property render_order : Float64
  property renderable : Renderable

  def initialize(@position, @renderable, @render_order)
    
  end

  def hitbox_contains?(point)
    @renderable.hitbox_contains?(position, point)
  end

  # TODO: only get a new one when there's been a change
  def quad
    @renderable.new_quad(position)
  end

  def update
    renderable.next_frame
  end
end