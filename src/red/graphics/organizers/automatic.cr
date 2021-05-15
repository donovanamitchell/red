require "../../game_objects"
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
        include GameObjects

        property layers : Array(Layers::Layer)
        property layer_registry : Hash(GameObject.class, Layers::Layer.class)

        def initialize()
          super()
          @layers = [] of Layers::Layer
          @verticies = Hash(
            GameObject,
            Graph::Vertex(Tuple(GameObject, SF::Texture | Nil, SF::Shader | Nil))
          ).new
          @clean = true
          @dag = Graph::DirectedAcyclic(
            Tuple(GameObject, SF::Texture | Nil, SF::Shader | Nil)
          ).new
          @layer_registry = Hash(
            GameObject.class,
            Layers::Layer.class
          ).new
          @layer_registry[RenderableGameObject] = Layers::RenderableLayer
          @layer_registry[DrawableGameObject] = Layers::DrawableLayer
          @layer_registry[NilGameObject] = Layers::RenderableLayer
        end

        def arrange(below : GameObject, above : GameObject)
          @dag.add_edge(@verticies[below], @verticies[above])
          @clean = false
        end

        def arrange(below : GameObject, graph_above : Graph::DirectedAcyclic(GameObject))
          graph_above.verticies.each do |above|
            arrange(below, above)
          end
        end

        def arrange(graph_below : Graph::DirectedAcyclic(GameObject), above : GameObject)
          graph_below.verticies.each do |below|
            arrange(below, above)
          end
        end

        def draw(target : SF::RenderTarget, states : SF::RenderStates)
          recompute_layers unless @clean

          @layers.each do |layer|
            layer.draw(target, states)
          end
        end

        def insert_game_obj(game_object : GameObject,
            layer_texture : Nil | SF::Texture,
            layer_shader : Nil | SF::Shader = nil
          )
          # TODO: what if the game_object already exists in the DAG?
          vertex = @dag.add_vertex({ game_object, layer_texture, layer_shader })
          @verticies[game_object] = vertex
          @clean = false
        end

        # TODO: perhaps change the texture,shader pairs to a hash then change
        # constructor to accept named arguments
        # double splatting a union is not supported, so that's a no
        def lookup_and_create_layer(game_object, texture, shader)
          layer_class = @layer_registry[game_object.class]?

          if layer_class.nil?
            if game_object.is_a?(RenderableGameObject)
              @layer_registry[game_object.class] = Layers::RenderableLayer
              layer_class = Layers::RenderableLayer
            elsif game_object.is_a?(SF::Drawable)
              @layer_registry[game_object.class] = Layers::DrawableLayer
              layer_class = Layers::DrawableLayer
            end
          end

          if layer_class.nil?
            # TODO: Better errors
            raise "#{game_object.class} not registered. Register GameObject and Layer classes with 'register' method"
          end

          layer_class.new(
            texture: texture,
            shader: shader,
            render_range_begin: Int32::MIN,
            render_range_end: Int32::MAX
          )
        end

        def recompute_layers
          @layers = [] of Layers::Layer
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

          Log.debug { sorted_list.pretty_inspect }

          _, first_texture, first_shader = sorted_list.first
          layer = Layers::RenderableLayer.new(first_texture, first_shader, Int32::MIN, Int32::MAX)
          @layers << layer

          sorted_list.each do |game_object, texture, shader|
            if layer.insert?(game_object, texture, shader)
              layer.insert(game_object)
            else
              # TODO: make layers not require begin/end range
              # or perhaps not use the Layer at all
              layer = lookup_and_create_layer(game_object, texture, shader)

              layer.insert(game_object)
              @layers << layer
            end
          end
          @clean = true
        end

        def register(game_object : GameObject.class, layer : Layers::Layer.class)
          @layer_registry[game_object] = layer
        end

        def remove_game_obj(game_object : GameObject)
          vertex = @verticies.delete(game_object)
          @dag.remove_vertex(vertex) if vertex

          @clean = false
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