class Layer < SF::Transformable
  include SF::Drawable

  property render_order : Int32
  property renderable_game_objs : Array(GameObject)

  def initialize(tileset : SF::Texture, @render_order)
    super()
    @verticies = SF::VertexArray.new(SF::Quads)
    @tileset = tileset
    @renderable_game_objs = [] of GameObject
  end

  # Minimize state changes, batch similar/identical things to draw together
  # Minimize draw calls
  # Minimize target changes
  # Minimize the number of shader changes, if there are similar shaders,
  #   figure out how you can combine them and differentiate via uniforms
  def draw(target : SF::RenderTarget, states : SF::RenderStates)
    states.transform *= transform()
    states.texture = @tileset
    target.draw(@verticies, states)
  end

  def insert_game_obj(game_object : GameObject)
    # TODO: optimize? BST?
    index = @renderable_game_objs.index do |obj|
      obj.render_order > game_object.render_order
    end
    index ||= -1
    @renderable_game_objs.insert(index, game_object)
  end

  def update
    # TODO: there is a possiblitity we don't want to render all of these
    @verticies.resize(4 * @renderable_game_objs.size)

    @renderable_game_objs.each do |game_object|
      game_object.quad.each { |vertex| @verticies.append(vertex) }
    end
  end
end