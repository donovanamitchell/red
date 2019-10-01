require "./renderables"
require "./renderable"

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
    renderables = Renderables.new("./assets/texture-1")

    characters = [
      Renderable.new(SF.vector2i(50, 30), "character", renderables.find_texture_location("character")),
      Renderable.new(SF.vector2i(100, 100), "character", renderables.find_texture_location("character")),
    ]

    renderables.update(characters: characters)

    while @render_window.open?
      while event = @render_window.poll_event
        case event
        when SF::Event::Closed
          @render_window.close
        when SF::Event::MouseButtonReleased
          pixel_pos = SF::Mouse.get_position(@render_window)
          world_pos = @render_window.map_pixel_to_coords(pixel_pos, @render_window.view)
          pp world_pos
          pp renderables.intersecting_renderables(world_pos)
        end
      end

      @render_window.clear(SF::Color::Black)

      @render_window.draw(renderables)

      @render_window.display
    end
  end
end