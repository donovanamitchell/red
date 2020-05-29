require "./renderables"
require "./renderable"
require "./game_object"

class WindowController
  def initialize(@window_width : Int32, @window_height : Int32, @view_multiplier : Int32)
    @render_window = SF::RenderWindow.new(
      SF::VideoMode.new(
        @window_width * view_multiplier, @window_height * view_multiplier
      ),
      "Test Window"
    )

    @view = SF::View.new(SF.float_rect(0, 0, @window_width, @window_height))
    @render_window.view = @view
  end

  def open
    renderables = Renderables.new("./assets/atlas")

    characters = [
      GameObject.new(
        SF.vector2i(50, 30),
        Renderable.new( "fireman", renderables.find_texture_location("fireman")),
        2.0
      ),
      GameObject.new(
        SF.vector2i(100, 100),
        Renderable.new( "character", renderables.find_texture_location("character")),
        2.0
      )
    ]

    characters.each do |character|
      renderables.insert_game_obj(character)
    end
    renderables.update

    while @render_window.open?
      while event = @render_window.poll_event
        case event
        when SF::Event::Closed
          @render_window.close
        when SF::Event::MouseButtonReleased
          pixel_pos = SF::Mouse.get_position(@render_window)
          world_pos = @render_window.map_pixel_to_coords(pixel_pos, @render_window.view)
          pp world_pos
          pp renderables.intersecting_game_objs(world_pos)
        else
          nil
        end
      end

      @render_window.clear(SF::Color::Black)

      @render_window.draw(renderables)

      @render_window.display
    end
  end
end