require "crsfml"
require "json"
require "./renderable"
require "./texture_location"

class Renderables < SF::Transformable
  include SF::Drawable

  property characters : Array(Renderable)
  @texture_locations : Array(TextureLocation)

  class TextureMapping
    JSON.mapping(
      name: String,
      cells: Array(TextureLocation)
    )
  end

  def initialize(texture_filename)
    super()

    @verticies = SF::VertexArray.new(SF::Quads)
    @tileset = SF::Texture.from_file("#{texture_filename}.png")
    texture_mapping = File.open("#{texture_filename}.json") do |file|
      TextureMapping.from_json(file)
    end
    @texture_locations = texture_mapping.cells

    @card_arts = [
      Renderable.new(SF.vector2i(6, 170), "card_art", find_texture_location("card_art"))
    ]
    @card_frames = [
      Renderable.new(SF.vector2i(4, 168), "card_frame", find_texture_location("card_frame"))
    ]
    @characters = [] of Renderable
    @background = Renderable.new(SF.vector2i(4,4), "background", find_texture_location("background"))
    @background_frame = Renderable.new(SF.vector2i(0,0), "frame", find_texture_location("frame"))

    update
  end

  def draw(target : SF::RenderTarget, states : SF::RenderStates)
    states.transform *= transform()
    states.texture = @tileset
    target.draw(@verticies, states)
  end

  def intersecting_renderables(target : SF::Vector2f)
    renderables.select { |renderable| renderable.hitbox_contains?(target) }
  end


  def find_texture_location(texture_name : String)
    location = @texture_locations.find do |loc|
      loc.name == texture_name
    end

    raise "Please use a real texture" unless location

    location
  end

  # render order
  # background
  # characters
  # frame
  # card art
  # card frame
  def renderables
    objects = [] of Renderable
    objects << @background
    objects.concat(@characters)
    objects << @background_frame
    objects.concat(@card_arts)
    objects.concat(@card_frames)
  end


  def update(*, characters = nil)
    @characters = characters unless characters.nil?

    render_objects = renderables

    @verticies.resize(4 * render_objects.size)

    render_objects.each do |renderable|
      renderable.new_quad.each { |vertex| @verticies.append(vertex) }
    end
  end
end