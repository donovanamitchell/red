class ShadedLayer < Layer
  property shader : SF::Shader

  def initialize(@texture, @render_order, @shader)
    super(@texture, @render_order)
  end

  def draw(target : SF::RenderTarget, states : SF::RenderStates)
    states.transform *= transform()
    states.texture = @texture
    states.shader = @shader
    target.draw(@verticies, states)
  end
end