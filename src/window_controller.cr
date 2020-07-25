require "./manual_graphics_organizer"
require "./renderable"
require "./colored_renderable"
require "./game_object"
require "./palette"

class WindowController
  def initialize(@window_width : Int32, @window_height : Int32, @view_multiplier : Int32)
    @render_window = SF::RenderWindow.new(
      SF::VideoMode.new(
        @window_width * view_multiplier, @window_height * view_multiplier
      ),
      "Test Window"
    )

    # TODO: not here
    @atlas_filename = "./assets/atlas"
    @tileset = SF::Texture.from_file("#{@atlas_filename}.png")
    file = File.new("#{@atlas_filename}.json")
    AnimationLibrary.load_assets(file)
    file.close

    palette = Palette.new
    palette.insert_palette({
      0_u8 => SF::Color.new(0,0,0),
      64_u8 => SF::Color.new(255,79,21),
      128_u8 => SF::Color.new(255,159,72),
      192_u8 => SF::Color.new(255,85,85),
      255_u8 => SF::Color.new(255,255,215)
    })
    palette.insert_palette({
      0_u8 => SF::Color.new(0,0,0),
      64_u8 => SF::Color.new(255,255,255),
      128_u8 => SF::Color.new(0,0,255),
      192_u8 => SF::Color.new(0,128,192),
      255_u8 => SF::Color.new(153,217,234)
    })
    @palette_shader_texture = SF::Texture.from_image(palette.generate_image)

    @view = SF::View.new(SF.float_rect(0, 0, @window_width, @window_height))
    @render_window.view = @view
    @game_objects = [] of GameObject
  end

  def intersecting_game_objects(pos : SF::Vector2f)
    @game_objects.select { |game_object| game_object.hitbox_contains?(pos) }
  end

  def open
    selected_game_obj = nil
    graphics_organizer = ManualGraphicsOrganizer.new()

    # render order
    # background
    # characters
    # frame
    # card art
    # card frame
    background = GameObject.new(
      SF.vector2i(4, 4),
      Renderable.new("background", ""),
      0
    )
    background_frame = GameObject.new(
      SF.vector2i(0, 0),
      Renderable.new("frame", ""),
      3
    )
    card_arts = [
      GameObject.new(
        SF.vector2i(6, 170),
        Renderable.new("card_art", ""),
        4
      )
    ]
    card_frames = [
      GameObject.new(
        SF.vector2i(4, 168),
        Renderable.new("card_frame", ""),
        5
      )
    ]

    characters = [
      GameObject.new(
        SF.vector2i(50, 100),
        Renderable.new("fireman", "Idle"),
        2,
        true
      ),
      GameObject.new(
        SF.vector2i(50, 30),
        ColoredRenderable.new(
          "fireman",
          "Idle",
          {
            "Flames" => SF::Color.new(255,128,192),
            "Suit" => SF::Color.new(128,255,255)
          }
        ),
        2,
        true
      ),
      GameObject.new(
        SF.vector2i(100, 100),
        ColoredRenderable.new("test_stripes", "", { "Layer" => SF::Color::Cyan }),
        2,
        true
      )
    ]

    # @game_objects << background
    @game_objects << background_frame
    @game_objects.concat(card_arts)
    @game_objects.concat(card_frames)
    @game_objects.concat(characters)
    # graphics_organizer.insert_game_obj(background, 0)

    graphics_organizer.insert_layer(0, 2, @tileset, nil)
    graphics_organizer.insert_layer(2, 5, @tileset, nil)

    characters.each { |character| graphics_organizer.insert_game_obj(character, @tileset) }
    graphics_organizer.insert_game_obj(background_frame, @tileset)

    card_arts.each { |card| graphics_organizer.insert_game_obj(card, @tileset) }
    card_frames.each { |card| graphics_organizer.insert_game_obj(card, @tileset) }


    fireman_2 = GameObject.new(
      SF.vector2i(100, 40),
      Renderable.new("fireman", "Idle"),
      2,
      true
    )
    @game_objects << fireman_2
    palette_shader = SF::Shader.new
    palette_shader.load_from_file("./assets/palette_shader.frag", SF::Shader::Fragment)
    palette_shader.set_parameter("Palette", @palette_shader_texture)
    palette_shader.set_parameter("Texture", @tileset)
    palette_shader.set_parameter("PaletteIndex", 1)
    palette_shader.set_parameter("PaletteSize", 1)

    graphics_organizer.insert_layer(2, 2, @tileset, palette_shader)
    graphics_organizer.insert_game_obj(fireman_2, @tileset, palette_shader)


    fireman_3 = GameObject.new(
      SF.vector2i(150, 30),
      Renderable.new("fireman", "Idle"),
      2,
      true
    )
    @game_objects << fireman_3
    palette_shader = SF::Shader.new
    palette_shader.load_from_file("./assets/palette_shader.frag", SF::Shader::Fragment)
    palette_shader.set_parameter("Palette", @palette_shader_texture)
    palette_shader.set_parameter("Texture", @tileset)
    palette_shader.set_parameter("PaletteIndex", 0)
    palette_shader.set_parameter("PaletteSize", 1)

    graphics_organizer.insert_layer(2, 2, @tileset, palette_shader)
    graphics_organizer.insert_game_obj(fireman_3, @tileset, palette_shader)

    graphics_organizer.update

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
          selected_game_objs = intersecting_game_objects(world_pos)
          # Log.debug { world_pos.pretty_inspect }
          # Log.debug { selected_game_objs.pretty_inspect }
          selected_game_obj = selected_game_objs.find { |obj| obj.selectable? }
          Log.debug { selected_game_obj.pretty_inspect }
        when SF::Event::KeyReleased
          next unless selected_game_obj
          # TODO: nOT ThIs
          # ^ command pattern
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
        @game_objects.each { |game_object| game_object.update }
        graphics_organizer.update
        lag -= TIME_PER_UPDATE
      end

      # render
      # @render_window.clear(SF::Color::Black)
      @render_window.clear(SF::Color.new(222,222,222))
      @render_window.draw(graphics_organizer)
      @render_window.display
    end
  end
end