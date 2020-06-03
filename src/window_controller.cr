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
    selected_game_obj = nil
    renderables = Renderables.new("./assets/atlas")

    characters = [
      GameObject.new(
        SF.vector2i(50, 30),
        Renderable.new("fireman", "Idle"),
        2.0,
        true
      ),
      GameObject.new(
        SF.vector2i(100, 100),
        Renderable.new("character", ""),
        2.0,
        true
      )
    ]

    characters.each do |character|
      renderables.insert_game_obj(character)
    end
    renderables.update

    # https://gameprogrammingpatterns.com/game-loop.html
    previous = Time.utc
    lag = Time::Span.zero
    while @render_window.open?
      current = Time.utc
      elapsed = current - previous
      previous = current
      lag += elapsed

      # process input
      while event = @render_window.poll_event
        case event
        when SF::Event::Closed
          @render_window.close
        when SF::Event::MouseButtonReleased
          pixel_pos = SF::Mouse.get_position(@render_window)
          world_pos = @render_window.map_pixel_to_coords(pixel_pos, @render_window.view)
          game_objs = renderables.intersecting_game_objs(world_pos)
          Log.debug { world_pos.pretty_inspect }
          # Log.debug { game_objs.pretty_inspect }
          selected_game_obj = game_objs.find { |obj| obj.selectable? }
          Log.debug { selected_game_obj.pretty_inspect }
        when SF::Event::KeyReleased
          next unless selected_game_obj
          # TODO: nOT ThIs
          case event.code
          when SF::Keyboard::Num0
            selected_game_obj.start_animation("Idle")
          when SF::Keyboard::Num1
            selected_game_obj.start_animation("Death")
          when SF::Keyboard::Num2
            selected_game_obj.start_animation("Injured")
          when SF::Keyboard::Num3
            selected_game_obj.start_animation("Buff")
          when SF::Keyboard::Num4
            selected_game_obj.start_animation("Ranged")
          when SF::Keyboard::Num5
            selected_game_obj.start_animation("Melee")
          else
            nil
          end
        else
          nil
        end
      end

      # variable time step
      # probably way overkill, but hey, this is for fun
      while lag >= TIME_PER_UPDATE
        # TODO: Renderables probably shouldn't be controlling the game update
        # Then again, perhaps it should.
        renderables.update
        lag -= TIME_PER_UPDATE
      end

      # render
      @render_window.clear(SF::Color::Black)
      @render_window.draw(renderables)
      @render_window.display
    end
  end
end