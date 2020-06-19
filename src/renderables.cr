require "./layer"

class Renderables < SF::Transformable
  include SF::Drawable

  property layers : Array(Layer)

  def initialize(texture_filename : String)
    super()
    @texture_filename = texture_filename
    @layers = [] of Layer

    # TODO: Multiple textures?
    @tileset = SF::Texture.from_file("#{texture_filename}.png")
    file = File.new("#{@texture_filename}.json")
    AnimationLibrary.load_assets(file)
    file.close
  end

  def draw(target : SF::RenderTarget, states : SF::RenderStates)
    @layers.each do |layer|
      layer.draw(target, states)
    end
  end

  # TODO: It's unclear at a glance what the difference between the
  # layer.render_order and the game_object.render_order
  # Perhaps determine the layer render order programaticly?
  def insert_game_obj(game_object : GameObject, layer_render_order : Int32)
    layer = @layers.bsearch { |l| l.render_order == layer_render_order }

    layer ||= insert_layer(layer_render_order)

    layer.insert_game_obj(game_object)
  end

  def insert_layer(layer_render_order)
    layer = Layer.new(@tileset, layer_render_order)
    # TODO: optimize? BST?
    index = @layers.index do |obj|
      obj.render_order > layer_render_order
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