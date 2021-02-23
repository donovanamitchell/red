require "../layers"
require "../../game_object"

module Red
  module Graphics
    module Organizers
      # The purpose of this object is to organize the renderable game objects in
      # groups (layers) that can be drawn at the same time.
      class Manual < SF::Transformable
        include SF::Drawable

        property layers : Array(Layers::RenderableLayer)

        def initialize()
          super()
          @layers = [] of Layers::RenderableLayer
        end

        def draw(target : SF::RenderTarget, states : SF::RenderStates)
          @layers.each do |layer|
            layer.draw(target, states)
          end
        end

        def insert_game_obj(game_object : GameObject,
                            texture : SF::Texture,
                            shader : SF::Shader | Nil = nil)
          layer = @layers.find do |l|
            l.insert?(game_object) &&
            l.texture == texture &&
            l.shader == shader
          end

          # TODO: better errors
          raise "appropriate layer not found" unless layer

          layer.insert(game_object)
        end

        def insert_layer(render_range_begin, render_range_end, texture, shader)
          layer = Layers::RenderableLayer.new(
            texture, shader, render_range_begin, render_range_end
          )

          # TODO: optimize? BST?
          index = @layers.index do |obj|
            obj.render_range_end > render_range_end
          end

          index ||= -1
          @layers.insert(index, layer)

          layer
        end

        def update
          @layers.each do |layer|
            layer.update
          end
        end
      end
    end
  end
end
