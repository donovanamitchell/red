require "./game_object"
require "./renderable"

class Renderables < SF::Transformable
  include SF::Drawable

  property renderable_game_objs : Array(GameObject)

  def initialize(texture_filename)
    super()

    # TODO turn AnimationLibrary into singleton?
    @animation_library = AnimationLibrary.new("#{texture_filename}.json")

    @verticies = SF::VertexArray.new(SF::Quads)
    @tileset = SF::Texture.from_file("#{texture_filename}.png")

    # render order
    # background
    # characters
    # frame
    # card art
    # card frame
    @background = GameObject.new(
      SF.vector2i(4, 4),
      Renderable.new(
        "background",
        find_texture_location("background"),
      ),
      0.0
    )
    @background_frame = GameObject.new(
      SF.vector2i(0, 0),
      Renderable.new(
        "frame",
        find_texture_location("frame"),
      ),
      3.0
    )
    @card_arts = [
      GameObject.new(
        SF.vector2i(6, 170),
        Renderable.new(
          "card_art",
          find_texture_location("card_art"),
        ),
        4.0
      )
    ]
    @card_frames = [
      GameObject.new(
        SF.vector2i(4, 168),
        Renderable.new(
          "card_frame",
          find_texture_location("card_frame"),
        ),
        5.0
      )
    ]
    @renderable_game_objs = [] of GameObject
    @renderable_game_objs << @background
    @renderable_game_objs << @background_frame
    @renderable_game_objs.concat(@card_arts)
    @renderable_game_objs.concat(@card_frames)

    update
  end

  def draw(target : SF::RenderTarget, states : SF::RenderStates)
    states.transform *= transform()
    states.texture = @tileset
    target.draw(@verticies, states)
  end

  def find_texture_location(texture_name : String)
    asset = @animation_library.assets[texture_name]

    raise "Please use a real texture" unless asset

    # TODO ugh
    asset.animations.first_value.frames.first
  end

  def insert_game_obj(game_object : GameObject)
    index = @renderable_game_objs.index do |obj|
      obj.render_order > game_object.render_order
    end
    index ||= -1
    @renderable_game_objs.insert(index, game_object)
  end

  def intersecting_game_objs(target : SF::Vector2f)
    @renderable_game_objs.select { |game_object| game_object.hitbox_contains?(target) }
  end

  # TODO: private?
  def update
    # TODO: there is a possiblitity we don't want to render all of these
    @verticies.resize(4 * @renderable_game_objs.size)

    @renderable_game_objs.each do |game_object|
      game_object.quad.each { |vertex| @verticies.append(vertex) }
    end
  end
end