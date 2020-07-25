require "./renderable"

class GameObject
  property position : SF::Vector2(Int32)
  property render_order : Int32
  property renderable : Renderable

  def initialize(@position, @renderable, @render_order = 0, @selectable = false)

  end

  def hitbox_contains?(point)
    @renderable.hitbox_contains?(position, point)
  end

  # TODO: only get a new one when there's been a change
  def quads
    @renderable.new_verticies(position)
  end

  def selectable?
    @selectable
  end

  # TODO: Private, this should be triggered by updates to the state
  # TODO: What do when the key is not found?
  def start_animation(animation_key)
    @renderable.start_animation(animation_key)
  end

  def update
    renderable.next_frame
  end
end