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

  def new_quad
    @renderable.new_quad(position)
  end
end