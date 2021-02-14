require "./red/manual_graphics_organizer"
require "./red/renderable"
require "./red/renderable_game_object"
require "./red/nil_game_object"
require "./red/colored_renderable"
require "./red/palette"
require "./red/input_context"
require "./animation_command"
require "./switch_context_command"
require "./card"
require "./draw_card_command"
require "./deck"
require "./hand"

class WindowController
  @selected_game_obj : Red::GameObject

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
    Red::AnimationLibrary.load_assets(file)
    file.close

    palette = Red::Palette.new
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

    # TODO: also not here
    @no_selection_input_context = Red::InputContext.new()
    click_command = SwitchContextCommand.new(->update_input_context)
    @no_selection_input_context.register(
      SF::Event::MouseButtonReleased,
      click_command
    )

    @input_context = @no_selection_input_context

    @fireteam = [] of Red::RenderableGameObject
    @fireteam_input_context = Red::InputContext.new()
    @fireteam_input_context.register(
      SF::Keyboard::Num0,
      AnimationCommand.new("Idle")
    )
    @fireteam_input_context.register(
      SF::Keyboard::Num1,
      AnimationCommand.new("Death")
    )
    @fireteam_input_context.register(
      SF::Keyboard::Num2,
      AnimationCommand.new("Injured")
    )
    @fireteam_input_context.register(
      SF::Keyboard::Num3,
      AnimationCommand.new("Buff")
    )
    @fireteam_input_context.register(
      SF::Keyboard::Num4,
      AnimationCommand.new("Ranged")
    )
    @fireteam_input_context.register(
      SF::Keyboard::Num5,
      AnimationCommand.new("Melee")
    )
    @fireteam_input_context.register(
      SF::Event::MouseButtonReleased,
      click_command
    )

    cards = [
      Card.new("Bang", "card_art", "card_frame"),
      Card.new("Pew", "card_art", "card_frame"),
      Card.new("Pow", "card_art", "card_frame"),
      Card.new("Zap", "card_art", "card_frame"),
      Card.new("Zotz", "card_art", "card_frame"),
      Card.new("Bap", "card_art", "card_frame"),
      Card.new("Bop", "card_art", "card_frame"),
      Card.new("Boop", "card_art", "card_frame"),
      Card.new("Bonk", "card_art", "card_frame"),
      Card.new("Bink", "card_art", "card_frame"),
      Card.new("Some Really Really Long Text to Test With", "squiggles", "card_frame")
    ]
    @deck = Deck.new(cards)
    @deck.shuffle
    @hand = Deck.new([] of Card)
    @discard = Deck.new([] of Card)
    @deck_game_object = Red::RenderableGameObject.new(
      SF.vector2i(4, 220 - 48 - 4),
      Red::Renderable.new("card_back", ""),
      4
    )
    # TODO: something to do relative positioning
    @hand_game_object = HandGameObject.new(
      SF.vector2i(4 + 36 + 4, 220 - 48 - 4),
      Red::Renderable.new("hand_area", ""),
      @hand,
      4
    )

    @hand_input_context = Red::InputContext.new()
    @hand_input_context.register(
      SF::Keyboard::Num0,
      DrawCardCommand.new(@deck, @hand)
    )
    @hand_input_context.register(
      SF::Event::MouseButtonReleased,
      click_command
    )

    @view = SF::View.new(SF.float_rect(0, 0, @window_width, @window_height))
    @render_window.view = @view
    @game_objects = [] of Red::GameObject
    @nil_game_object = Red::NilGameObject.new
    @selected_game_obj = @nil_game_object
  end

  def intersecting_game_objects(pos : SF::Vector2f)
    intersecting_game_objects = [] of Red::GameObject
    @game_objects.each do |game_object|
      intersecting_game_objects.concat(game_object.objects_at(pos))
    end
    intersecting_game_objects
  end

  def update_input_context
    pixel_pos = SF::Mouse.get_position(@render_window)
    world_pos = @render_window.map_pixel_to_coords(pixel_pos, @render_window.view)

    # TODO: Object for input context switching?
    @selected_game_obj = intersecting_game_objects(world_pos).find(@nil_game_object) do |obj|
      if(obj.in?(@fireteam))
        @input_context = @fireteam_input_context
        true
      elsif(obj == @hand_game_object)
        @input_context = @hand_input_context
        true
      else
        false
      end
    end

    Log.debug { @selected_game_obj.pretty_inspect }
  end

  def open
    graphics_organizer = Red::ManualGraphicsOrganizer.new()
    graphics_organizer.insert_layer(0, 2, @tileset, nil)
    graphics_organizer.insert_layer(2, 5, @tileset, nil)

    # render order
    # background
    # characters
    # frame
    # card art
    # card frame
    background = Red::RenderableGameObject.new(
      SF.vector2i(4, 4),
      Red::Renderable.new("background", ""),
      0
    )
    background_frame = Red::RenderableGameObject.new(
      SF.vector2i(0, 0),
      Red::Renderable.new("frame", ""),
      3
    )
    @fireteam = [
      Red::RenderableGameObject.new(
        SF.vector2i(50, 100),
        Red::Renderable.new("fireman", "Idle"),
        2
      ),
      Red::RenderableGameObject.new(
        SF.vector2i(50, 30),
        Red::ColoredRenderable.new(
          "fireman",
          "Idle",
          {
            "Flames" => SF::Color.new(255,128,192),
            "Suit" => SF::Color.new(128,255,255)
          }
        ),
        2
      ),
      Red::RenderableGameObject.new(
        SF.vector2i(100, 100),
        Red::ColoredRenderable.new("test_stripes", "", { "Layer" => SF::Color::Cyan }),
        2
      ),
      Red::RenderableGameObject.new(
        SF.vector2i(150, 60),
        Red::Renderable.new("snoopy", "Idle"),
        2
      )
    ]

    # @game_objects << background
    @game_objects << background_frame
    @game_objects << @deck_game_object
    @game_objects << @hand_game_object
    @game_objects.concat(@fireteam)
    # graphics_organizer.insert_game_obj(background, 0)

    # TODO: bit of a pain to add to both @game_objects and graphics organizer
    graphics_organizer.insert_game_obj(@deck_game_object, @tileset)
    graphics_organizer.insert_game_obj(@hand_game_object, @tileset)

    @fireteam.each { |character| graphics_organizer.insert_game_obj(character, @tileset) }
    graphics_organizer.insert_game_obj(background_frame, @tileset)

    fireman_2 = Red::RenderableGameObject.new(
      SF.vector2i(100, 40),
      Red::Renderable.new("fireman", "Idle"),
      2
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

    fireman_3 = Red::RenderableGameObject.new(
      SF.vector2i(150, 30),
      Red::Renderable.new("fireman", "Idle"),
      2
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
        else
          command = @input_context.handle(event)
          command.execute(@selected_game_obj)
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