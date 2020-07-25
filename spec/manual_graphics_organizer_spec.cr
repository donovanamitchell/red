require "./spec_helper"

describe ManualGraphicsOrganizer do
  describe "insert_layer" do
    it "should add a new layer with the given range, texture and shader" do\
      texture = SF::Texture.new
      shader = SF::Shader.new
      graphics_organizer = ManualGraphicsOrganizer.new()
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
      graphics_organizer = ManualGraphicsOrganizer.new()
      graphics_organizer.insert_layer(10000, 10001, texture, nil)

      graphics_organizer.layers.size.should eq 1
      layer = graphics_organizer.layers.first
      layer.render_range_end.should eq 10001
      layer.render_range_begin.should eq 10000
      layer.texture.should be(texture)
      layer.shader.should be_nil
    end

    it "should order by range end" do

    end
  end

  describe "insert_game_obj" do
    it "should insert into a layer matching render order, range and shader" do

    end

    it "should raise an exception if a layer does not hold the render order" do

    end

    it "should raise an exception if a layer does not match the texture" do

    end

    it "should raise an exception if a layer does not match the shader" do

    end

    it "should keep the layers ordered by render ranges" do

    end
  end
end
