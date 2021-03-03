require "../../../spec_helper"

module Red
  module Graphics
    module Organizers
      describe Automatic do
        describe "init" do
          it "should have no layers" do
            organizer = Automatic.new
            organizer.layers.size.should eq(0)
          end

          it "doesn't throw an error when recomputing empty layers" do
            organizer = Automatic.new
            organizer.recompute_layers
            organizer.layers.size.should eq(0)
          end
        end
        describe "insert_game_obj" do
          it "should create a new layer if empty" do
            texture = SF::Texture.new
            shader = SF::Shader.new
            organizer = Automatic.new
            game_object = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)

            organizer.insert_game_obj(game_object, texture, shader)
            organizer.recompute_layers

            organizer.layers.size.should eq(1)
            layer = organizer.layers.first
            layer.texture.should be(texture)
            layer.shader.should be(shader)
            layer.objects.size.should eq(1)
            layer.objects.first.should be(game_object)
          end

          it "should add to the layer if the object can be rendered in it" do
            texture = SF::Texture.new
            shader = SF::Shader.new
            organizer = Automatic.new
            game_object_1 = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)
            game_object_2 = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)

            organizer.insert_game_obj(game_object_1, texture, shader)
            organizer.insert_game_obj(game_object_2, texture, shader)
            organizer.recompute_layers

            organizer.layers.size.should eq(1)
            layer = organizer.layers.first
            layer.objects.size.should eq(2)
            layer.objects.should contain(game_object_1)
            layer.objects.should contain(game_object_2)
          end

          it "should create a new layer if a layer does not match the texture" do
            texture_1 = SF::Texture.new
            texture_2 = SF::Texture.new
            shader = SF::Shader.new
            organizer = Automatic.new
            game_object_1 = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)
            game_object_2 = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)

            organizer.insert_game_obj(game_object_1, texture_1, shader)
            organizer.insert_game_obj(game_object_2, texture_2, shader)
            organizer.recompute_layers

            organizer.layers.size.should eq(2)
            textures = organizer.layers.map(&.texture)
            textures.should contain(texture_1)
            textures.should contain(texture_2)
            organizer.layers.each do |layer|
              layer.objects.size.should eq(1)
              object = layer.objects.first
              if layer.texture == texture_1
                object.should be(game_object_1)
              else
                object.should be(game_object_2)
              end
            end
          end

          it "should create a layer if a layer does not match the shader" do
            shader_1 = SF::Shader.new
            shader_2 = SF::Shader.new
            texture = SF::Texture.new
            organizer = Automatic.new
            game_object_1 = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)
            game_object_2 = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)

            organizer.insert_game_obj(game_object_1, texture, shader_1)
            organizer.insert_game_obj(game_object_2, texture, shader_2)
            organizer.recompute_layers

            organizer.layers.size.should eq(2)
            shaders = organizer.layers.map(&.shader)
            shaders.should contain(shader_1)
            shaders.should contain(shader_2)
            organizer.layers.each do |layer|
              layer.objects.size.should eq(1)
              object = layer.objects.first
              if layer.shader == shader_1
                object.should be(game_object_1)
              else
                object.should be(game_object_2)
              end
            end
          end

          it "can have a nil shader" do
            texture = SF::Texture.new
            organizer = Automatic.new
            game_object = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)
            organizer.insert_game_obj(game_object, texture)
            organizer.recompute_layers

            organizer.layers.size.should eq(1)
            layer = organizer.layers.first
            layer.texture.should be(texture)
            layer.shader.should be(nil)
            layer.objects.size.should eq(1)
            layer.objects.first.should be(game_object)
          end
        end

        describe "arrange" do
          # b
          # | \
          # a  c
          # where a, b, c share the same texture and shader
          it "should order the objects according to the graph" do
            texture = SF::Texture.new
            organizer = Automatic.new
            a = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)
            b = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)
            c = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)
            organizer.insert_game_obj(a, texture)
            organizer.insert_game_obj(b, texture)
            organizer.insert_game_obj(c, texture)
            organizer.arrange(a, b)
            organizer.arrange(c, b)
            organizer.recompute_layers

            organizer.layers.size.should eq(1)
            layer = organizer.layers.first
            layer.objects.size.should eq(3)
            # two possible orderings, [a, c, b]; [c, a, b]
            first_object = layer.objects[0]
            second_object = layer.objects[1]
            third_object = layer.objects[2]
            if first_object.same?(a)
              first_object.should be(a)
              second_object.should be(c)
              third_object.should be(b)
            else
              second_object.should be(c)
              second_object.should be(a)
              third_object.should be(b)
            end
          end

          it "should resolve ties based on the last used texture and shader" do
            a = SF::Texture.new
            b = SF::Texture.new
            organizer = Automatic.new
            object_1 = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)
            object_2 = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)
            object_3 = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)

            organizer.insert_game_obj(object_1, b)
            organizer.insert_game_obj(object_2, a)
            organizer.insert_game_obj(object_3, b)
            organizer.recompute_layers

            organizer.layers.size.should eq(2)
            # two possible orderings, [[b, b], [a]]; [[a], [b, b]]
            layer_b = organizer.layers[0]
            layer_a = organizer.layers[1]
            if layer_a.texture.same?(b)
              layer_a = organizer.layers[0]
              layer_b = organizer.layers[1]
            end

            layer_a.texture.should be(a)
            layer_b.texture.should be(b)
            layer_a.objects.should contain(object_2)
            layer_b.objects.should contain(object_1)
            layer_b.objects.should contain(object_3)
          end

          it "should throw an error if there is a cycle" do
            texture = SF::Texture.new
            organizer = Automatic.new
            object_1 = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)
            object_2 = GameObjects::RenderableGameObject.new(SF.vector2(0,0), Renderables::NilRenderable.new)
            organizer.insert_game_obj(object_1, texture)
            organizer.insert_game_obj(object_2, texture)

            expect_raises(Exception, "Cycle found in acyclic graph") do
              organizer.arrange(object_1, object_2)
              organizer.arrange(object_2, object_1)
              organizer.recompute_layers
            end
          end
        end
      end
    end
  end
end
