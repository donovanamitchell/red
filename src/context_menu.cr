class ContextMenu
  class BackgroundRenderable < Red::Renderables::Renderable
    def initialize(size : SF::Vector2(Int32))
      @size = size
      super("card_art", "")
    end

    def new_vertex(layer, corner, offset)
      SF::Vertex.new(
        # Here we ignore the actual width of the texture and stretch it accross
        # our desired w/h
        SF.vector2(
          (corner[0] * @size.x) + offset.x,
          (corner[1] * @size.y) + offset.y
        ),
        tex_coords: SF.vector2(
          layer.x + (corner[0] * layer.w),
          layer.y + (corner[1] * layer.h)
        ),
        color: SF::Color::Blue
      )
    end
  end

  property items : Array(Tuple(String, Red::Inputs::Command))
  property visible : Bool
  property font : SF::Font
  property size : SF::Vector2(Int32)

  # TODO: make size calculated by default
  def initialize(@size, @render_order : Int32, @items, @font, @tileset : SF::Texture)
    @position = SF.vector2i(0,0)
    @text = SF::Text.new(@items.map(&.first).join("\n"), @font)
    @text.character_size = 7
    @text.color = SF::Color::White
    @text_game_object = TextGameObject.new(
      @position,
      @render_order,
      @text
    )
    @background = Red::GameObjects::RenderableGameObject.new(
      @position,
      BackgroundRenderable.new(@size),
      @render_order
    )
    @visible = false
  end

  def show_for(position, game_object)
    @position = position
    @background.position = position
    @text_game_object.position = position
    @visible = true
    Red::Graphics::Organizers.insert_game_obj(@background, @tileset, nil)
    Red::Graphics::Organizers.insert_game_obj(@text_game_object, nil, nil)
    Red::Graphics::Organizers.arrange(game_object, @background)
    Red::Graphics::Organizers.arrange(@background, @text_game_object)
  end

  def hide
    @visible = false
    Red::Graphics::Organizers.remove_game_obj(@text_game_object)
    Red::Graphics::Organizers.remove_game_obj(@background)
  end
end
