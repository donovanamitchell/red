module Red
  class Layer < SF::Transformable
    include SF::Drawable

    getter render_range_end : Int32
    getter render_range_begin : Int32
    property renderable_game_objs : Array(GameObject)
    property shader : Nil | SF::Shader
    property texture : SF::Texture

    def initialize(@texture, @shader, @render_range_begin, @render_range_end)
      super()
      @verticies = SF::VertexArray.new(SF::Quads)
      @renderable_game_objs = [] of GameObject
    end

    # TODO: cite source
    # Minimize state changes, batch similar/identical things to draw together
    # Minimize draw calls
    # Minimize target changes
    # Minimize the number of shader changes, if there are similar shaders,
    #   figure out how you can combine them and differentiate via uniforms
    def draw(target : SF::RenderTarget, states : SF::RenderStates)
      states.transform *= transform()
      states.texture = @texture
      unless @shader.nil?
        # TODO: dumb, check again 0.35.1
        states.shader = @shader.not_nil!
      end
      target.draw(@verticies, states)
    end

    def insert_game_obj(game_object : GameObject)
      # TODO: better errors
      raise "#{game_object.render_order} outside range #{render_range_end}" unless @render_range_end >= game_object.render_order
      raise "#{game_object.render_order} outside range #{render_range_begin}" unless @render_range_begin <= game_object.render_order

      # TODO: optimize? BST?
      index = @renderable_game_objs.index do |obj|
        obj.render_order > game_object.render_order
      end
      index ||= -1
      @renderable_game_objs.insert(index, game_object)
    end

    def set_render_range_begin(range_begin)
      removed_game_objects = [] of GameObject
      if range_begin > @render_range_begin
        while @renderable_game_objs.first && range_begin > @renderable_game_objs.first.render_order
          removed_game_objects << @renderable_game_objs.shift
        end
      end

      @render_range_begin = range_begin

      removed_game_objects
    end

    def set_render_range_end(range_end)
      removed_game_objects = [] of GameObject
      if range_end < @render_range_end
        while @renderable_game_objs.last && range_end < @renderable_game_objs.last.render_order
          removed_game_objects << @renderable_game_objs.pop
        end
      end

      @render_range_end = range_end

      removed_game_objects
    end

    def update
      # TODO: this is an underestimate, not the exact size
      @verticies.resize(4 * @renderable_game_objs.size)

      @renderable_game_objs.each do |game_object|
        game_object.quads.each { |vertex| @verticies.append(vertex) }
      end
    end
  end
end