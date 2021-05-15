require "./layer"
require "../../game_objects"

module Red
  module Graphics
    module Layers
      class RenderableLayer < Layer
        property shader : Nil | SF::Shader
        property texture : SF::Texture

        def initialize(
            texture = nil,
            shader = nil,
            render_range_begin = Int32::MIN,
            render_range_end = Int32::MAX
          )
          @texture = texture || SF::Texture.new
          @shader = shader
          @render_range_begin = render_range_begin
          @render_range_end = render_range_end
          super(render_range_begin: render_range_begin, render_range_end: render_range_end)
          @verticies = SF::VertexArray.new(SF::Quads)
        end

        def insert?(object, texture : Nil | SF::Texture, shader : Nil | SF::Shader)
          object.is_a?(GameObjects::RenderableGameObject) &&
          object.render_order <= render_range_end &&
          object.render_order >= render_range_begin &&
          @texture == texture &&
          @shader == shader
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

        def update
          # TODO: this is an underestimate, not the exact size
          @verticies.resize(4 * @objects.size)

          @objects.each do |object|
            object.quads.each { |vertex| @verticies.append(vertex) }
          end
        end
      end
    end
  end
end
