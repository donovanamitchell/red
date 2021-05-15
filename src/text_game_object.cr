class TextGameObject < Red::GameObjects::DrawableGameObject
  def initialize(@position, @render_order, @text : SF::Text)
    @text.set_position(@position.x, @position.y)
  end

  def hitbox_contains?(point)
    false
  end

  def objects_at(point)
    [] of Red::GameObjects::GameObject
  end

  def position=(position)
    @position = position
    @text.set_position(@position.x, @position.y)
  end

  def start_animation(animation_key) ; end

  def update ; end

  def draw(target : SF::RenderTarget, states : SF::RenderStates)
    target.draw(@text)
  end
end
