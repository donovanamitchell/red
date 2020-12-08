require "./spec_helper"

module Red
  describe ManualGraphicsOrganizer do
    describe "insert_layer" do
      it "should add a new layer with the given range, texture and shader" do
          texture = SF::Texture.new
          shader = SF::Shader.new
          graphics_organizer = ManualGraphicsOrganizer.new
          graphics_organizer.insert_layer(0, 9999, texture, shader)

          graphics_organizer.layers.size.should eq 1
          layer = graphics_organizer.layers.first
          layer.render_range_end.should eq 9999
          layer.render_range_begin.should eq 0
          layer.texture.should be(texture)
          layer.shader.should be(shader)
        end

      it "can have a nil shader" do
        texture = SF::Texture.new
        graphics_organizer = ManualGraphicsOrganizer.new
        graphics_organizer.insert_layer(10000, 10001, texture, nil)

        graphics_organizer.layers.size.should eq 1
        layer = graphics_organizer.layers.first
        layer.render_range_end.should eq 10001
        layer.render_range_begin.should eq 10000
        layer.texture.should be(texture)
        layer.shader.should be_nil
      end

      it "should order by range end" do
        texture = SF::Texture.new
        graphics_organizer = ManualGraphicsOrganizer.new

        layer_1 = graphics_organizer.insert_layer(-34, -1, texture, nil)
        layer_2 = graphics_organizer.insert_layer(0, 99, texture, nil)
        layer_5 = graphics_organizer.insert_layer(200, 900, texture, nil)
        layer_4 = graphics_organizer.insert_layer(100, 101, texture, nil)
        layer_3 = graphics_organizer.insert_layer(87, 100, texture, nil)
        layer_0 = graphics_organizer.insert_layer(-99, -99, texture, nil)

        graphics_organizer.layers[0].should be(layer_0)
        graphics_organizer.layers[1].should be(layer_1)
        graphics_organizer.layers[2].should be(layer_2)
        graphics_organizer.layers[3].should be(layer_3)
        graphics_organizer.layers[4].should be(layer_4)
        graphics_organizer.layers[5].should be(layer_5)
      end
    end

    describe "insert_game_obj" do
      it "should insert into a layer matching render order, range and shader" do
        texture = SF::Texture.new
        shader = SF::Shader.new
        graphics_organizer = ManualGraphicsOrganizer.new
        layer = graphics_organizer.insert_layer(0, 9999, texture, shader)
        game_object = RenderableGameObject.new(SF.vector2(0,0), NilRenderable.new, 0)

        graphics_organizer.insert_game_obj(game_object, texture, shader)

        layer.renderable_game_objs.size.should eq(1)
        layer.renderable_game_objs.first.should be(game_object)
      end

      it "should match a nil shader" do
        texture = SF::Texture.new
        graphics_organizer = ManualGraphicsOrganizer.new
        layer = graphics_organizer.insert_layer(0, 9999, texture, nil)
        game_object = RenderableGameObject.new(SF.vector2(0,0), NilRenderable.new, 0)

        graphics_organizer.insert_game_obj(game_object, texture)

        layer.renderable_game_objs.size.should eq(1)
        layer.renderable_game_objs.first.should be(game_object)
      end

      it "should raise an exception if a layer does not hold the render order" do
        texture = SF::Texture.new
        graphics_organizer = ManualGraphicsOrganizer.new
        layer = graphics_organizer.insert_layer(0, 9999, texture, nil)
        game_object = RenderableGameObject.new(SF.vector2(0,0), NilRenderable.new, 10000)

        expect_raises(Exception, "appropriate layer not found") do
          graphics_organizer.insert_game_obj(game_object, texture)
        end

        layer.renderable_game_objs.size.should eq(0)
      end

      it "should raise an exception if a layer does not match the texture" do
        texture = SF::Texture.new
        graphics_organizer = ManualGraphicsOrganizer.new
        shader = SF::Shader.new
        layer = graphics_organizer.insert_layer(0, 9999, texture, shader)
        game_object = RenderableGameObject.new(SF.vector2(0,0), NilRenderable.new, 222)

        expect_raises(Exception, "appropriate layer not found") do
          graphics_organizer.insert_game_obj(game_object, SF::Texture.new, shader)
        end

        layer.renderable_game_objs.size.should eq(0)
      end

      it "should raise an exception if a layer does not match the shader" do
        texture = SF::Texture.new
        graphics_organizer = ManualGraphicsOrganizer.new
        shader = SF::Shader.new
        layer = graphics_organizer.insert_layer(0, 9999, texture, shader)
        game_object = RenderableGameObject.new(SF.vector2(0,0), NilRenderable.new, 322)

        expect_raises(Exception, "appropriate layer not found") do
          graphics_organizer.insert_game_obj(game_object, texture, SF::Shader.new)
        end

        layer.renderable_game_objs.size.should eq(0)
      end
    end
  end
end
