require "./layer"

# The purpose of this object is to organize the renderable game objects in
# groups (layers) that can be drawn at the same time.
class ManualGraphicsOrganizer < SF::Transformable
  include SF::Drawable

  property layers : Array(Layer)

  def initialize()
    super()
    @layers = [] of Layer
  end

  def draw(target : SF::RenderTarget, states : SF::RenderStates)
    @layers.each do |layer|
      layer.draw(target, states)
    end
  end

  def insert_game_obj(game_object : GameObject,
                      texture : SF::Texture,
                      shader : SF::Shader | Nil = nil)
    layer = @layers.find do |l|
      game_object.render_order <= l.render_range_end &&
      game_object.render_order >= l.render_range_begin &&
      l.texture == texture &&
      l.shader == shader
    end

    # TODO: better errors
    raise "appropriate layer not found" unless layer

    layer.insert_game_obj(game_object)
  end

  def insert_layer(render_range_begin, render_range_end, texture, shader)
    layer = Layer.new(
      texture, shader, render_range_begin, render_range_end
    )

    # TODO: optimize? BST?
    index = @layers.index do |obj|
      obj.render_range_end > render_range_end
    end

    index ||= -1
    @layers.insert(index, layer)

    layer
  end

  def update
    @layers.each do |layer|
      layer.update
    end
  end
end