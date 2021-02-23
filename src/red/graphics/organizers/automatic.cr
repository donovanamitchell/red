require "../../graph"
require "../layers"

module Red
  module Graphics
    module Organizers
      # The purpose of this object is to organize the renderable game objects in
      # groups (layers) that can be drawn at the same time.
      # This organizer automaticaly creates and deletes the layers containing the
      # gameobjects
      class Automatic < SF::Transformable
        include SF::Drawable

        property layers : Array(Layers::RenderableLayer)

        def initialize
          super()
          @layers = [] of Layers::RenderableLayer
          @verticies = Hash(
            GameObject,
            Graph::Vertex(Tuple(GameObject, SF::Texture, SF::Shader | Nil))
          ).new
          @clean = true
          @dag = Graph::DirectedAcyclic(
            Tuple(GameObject, SF::Texture, SF::Shader | Nil)
          ).new
        end

        def arrange(below : GameObject, above : GameObject)
          @dag.add_edge(@verticies[below], @verticies[above])
          @clean = false
        end

        def draw(target : SF::RenderTarget, states : SF::RenderStates)
          recompute_layers unless @clean

          @layers.each do |layer|
            layer.draw(target, states)
          end
        end

        def insert_game_obj(game_object : GameObject,
            layer_texture : SF::Texture,
            layer_shader : Nil | SF::Shader = nil
          )

          # TODO: what if the game_object already exists in the DAG?
          vertex = @dag.add_vertex({ game_object, layer_texture, layer_shader })
          @verticies[game_object] = vertex
          @clean = false
        end

        def recompute_layers
          @layers = [] of Layers::RenderableLayer
          return if @verticies.empty?

          # what a mess
          # TODO: give a better default?
          # almost all of my texture in the test are from the same texture
          current_texture_shader = @verticies.first[1].value
          # layers are sorted topologically and grouped by Texture/Shader
          sorted_list = @dag.topological_sort do |set|
            next_vertex = set.find do |vertex|
              vertex.value[1] == current_texture_shader[1] &&
              vertex.value[2] == current_texture_shader[2]
            end

            unless next_vertex
              next_vertex = set.first
              # TODO: give a better default?
              current_texture_shader = next_vertex.value
            end

            next_vertex
          end

          _, first_texture, first_shader = sorted_list.first
          layer = Layers::RenderableLayer.new(first_texture, first_shader, Int32::MIN, Int32::MAX)
          @layers << layer

          sorted_list.each do |game_object, texture, shader|
            if layer.insert?(game_object, texture, shader)
              layer.insert(game_object)
            else
              # TODO: make layers not require begin/end range
              # or perhaps not use the Layer at all
              layer = Layers::RenderableLayer.new(texture, shader, Int32::MIN, Int32::MAX)
              layer.insert(game_object)
              @layers << layer
            end
          end
          @clean = true
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