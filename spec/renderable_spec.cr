require "./spec_helper"

describe Renderable do
  before_all do
    AnimationLibrary.load_assets(
      <<-JSON
      {
        "frames": [
          {
            "filename": "jimothy",
            "tag": "Full",
            "frame_order": 0,
            "frame": { "x": 40, "y": 220, "w": 32, "h": 32 },
            "trimmed": false,
            "rotated": false,
            "duration": 100,
            "spriteSourceSize": { "x": 0, "y": 0, "w": 32, "h": 32 },
            "sourceSize": { "w": 32, "h": 32 }
          },
          {
            "filename": "jimothy",
            "tag": "Trimmed",
            "frame_order": 1,
            "frame": { "x": 40, "y": 220, "w": 5, "h": 10 },
            "trimmed": true,
            "rotated": false,
            "duration": 100,
            "spriteSourceSize": { "x": 4, "y": 5, "w": 5, "h": 10 },
            "sourceSize": { "w": 32, "h": 32 }
          },
          {
            "filename": "jimothy",
            "tag": "Action",
            "frame_order": 2,
            "frame": { "x": 40, "y": 220, "w": 5, "h": 10 },
            "trimmed": true,
            "rotated": false,
            "duration": 100,
            "spriteSourceSize": { "x": 8, "y": 11, "w": 5, "h": 10 },
            "sourceSize": { "w": 32, "h": 32 }
          },
          {
            "filename": "jimothy",
            "tag": "Action",
            "frame_order": 3,
            "frame": { "x": 30, "y": 0, "w": 10, "h": 12 },
            "trimmed": true,
            "rotated": false,
            "duration": 100,
            "spriteSourceSize": { "x": 2, "y": 20, "w": 10, "h": 12 },
            "sourceSize": { "w": 32, "h": 32 }
          }
        ],
        "meta": {
          "app": "http://www.aseprite.org/",
          "version": "1.2.19.2-x64",
          "image": "atlas.png",
          "format": "RGBA8888",
          "size": { "w": 496, "h": 232 },
          "scale": "1"
        }
      }
      JSON
    )
  end

  describe "#hitbox_contains?" do
    describe "when the animation frame has no offset" do
      it "should be true for the corners" do
        renderable = Renderable.new("jimothy", "Full")
        position = SF.vector2(100,23)
        renderable.hitbox_contains?(position, SF.vector2(100,23)).should be_true
        renderable.hitbox_contains?(position, SF.vector2(100,54)).should be_true
        renderable.hitbox_contains?(position, SF.vector2(131,23)).should be_true
        renderable.hitbox_contains?(position, SF.vector2(131,54)).should be_true
      end

      it "should be true for interior points" do
        renderable = Renderable.new("jimothy", "Full")
        position = SF.vector2(3,22)
        renderable.hitbox_contains?(position, SF.vector2(20,45)).should be_true
      end

      it "should be false on the exerior" do
        renderable = Renderable.new("jimothy", "Full")
        position = SF.vector2(44,41)
        renderable.hitbox_contains?(position, SF.vector2(43,45)).should be_false
        renderable.hitbox_contains?(position, SF.vector2(53,40)).should be_false
        renderable.hitbox_contains?(position, SF.vector2(77,50)).should be_false
        renderable.hitbox_contains?(position, SF.vector2(44,75)).should be_false
      end
    end

    # When the animation frame (x) is offset from the actual image boundary (+)
    # because the transparency/border has been trimmed from it.
    #
    #    ++++++++
    #    +      +
    #    +   xx +
    #    +   xx +
    #    +      +
    #    ++++++++
    #
    # "x": 4, "y": 5, "w": 5, "h": 10
    describe "when the animation frame has an offset" do
      it "should be true for the corners" do
        renderable = Renderable.new("jimothy", "Trimmed")
        position = SF.vector2(10,12)
        renderable.hitbox_contains?(position, SF.vector2(14,17)).should be_true
        renderable.hitbox_contains?(position, SF.vector2(18,17)).should be_true
        renderable.hitbox_contains?(position, SF.vector2(14,26)).should be_true
        renderable.hitbox_contains?(position, SF.vector2(18,26)).should be_true
      end

      it "should be true for interior points" do
        renderable = Renderable.new("jimothy", "Trimmed")
        position = SF.vector2(21,52)
        renderable.hitbox_contains?(position, SF.vector2(29,60)).should be_true
      end

      it "should be false on points that have been trimmed" do
        renderable = Renderable.new("jimothy", "Trimmed")
        position = SF.vector2(10,12)
        renderable.hitbox_contains?(position, SF.vector2(13,20)).should be_false
        renderable.hitbox_contains?(position, SF.vector2(19,16)).should be_false
        renderable.hitbox_contains?(position, SF.vector2(19,24)).should be_false
        renderable.hitbox_contains?(position, SF.vector2(17,30)).should be_false
      end
    end
  end

  describe "#new_quad" do
    it "should return an array of the 4 corner verticies of the quad" do
      renderable = Renderable.new("jimothy", "Full")
      quad = renderable.new_quad(SF.vector2(101, 1010))
      quad.each { |vertex| vertex.should be_a(SF::Vertex) }
      quad[0].position.x.should eq(101)
      quad[0].position.y.should eq(1010)
      quad[0].tex_coords.x.should eq(40)
      quad[0].tex_coords.y.should eq(220)
      quad[1].position.x.should eq(133)
      quad[1].position.y.should eq(1010)
      quad[1].tex_coords.x.should eq(72)
      quad[1].tex_coords.y.should eq(220)
      quad[2].position.x.should eq(133)
      quad[2].position.y.should eq(1042)
      quad[2].tex_coords.x.should eq(72)
      quad[2].tex_coords.y.should eq(252)
      quad[3].position.x.should eq(101)
      quad[3].position.y.should eq(1042)
      quad[3].tex_coords.x.should eq(40)
      quad[3].tex_coords.y.should eq(252)
    end

    # "x": 4, "y": 5, "w": 5, "h": 10
    it "should handle trimmed edges" do
      renderable = Renderable.new("jimothy", "Trimmed")
      quad = renderable.new_quad(SF.vector2(101, 1010))
      quad.each { |vertex| vertex.should be_a(SF::Vertex) }
      quad[0].position.x.should eq(105)
      quad[0].position.y.should eq(1015)
      quad[0].tex_coords.x.should eq(40)
      quad[0].tex_coords.y.should eq(220)
      quad[1].position.x.should eq(110)
      quad[1].position.y.should eq(1015)
      quad[1].tex_coords.x.should eq(45)
      quad[1].tex_coords.y.should eq(220)
      quad[2].position.x.should eq(110)
      quad[2].position.y.should eq(1025)
      quad[2].tex_coords.x.should eq(45)
      quad[2].tex_coords.y.should eq(230)
      quad[3].position.x.should eq(105)
      quad[3].position.y.should eq(1025)
      quad[3].tex_coords.x.should eq(40)
      quad[3].tex_coords.y.should eq(230)
    end
  end

  describe "#next_frame" do
    it "should not change frame until the required duration" do
      renderable = Renderable.new("jimothy", "Action")
      first_frame = AnimationLibrary.assets["jimothy"].animations["Action"].frames[0]
      second_frame = AnimationLibrary.assets["jimothy"].animations["Action"].frames[1]

      updates_per_frame = 1 + (first_frame.duration_ms / Renderable::MS_PER_UPDATE)
      updates_per_frame.ceil.to_i.times do
        renderable.animation_frame.should be(first_frame)
        renderable.next_frame
      end
      renderable.animation_frame.should be(second_frame)
    end

    it "should revert to the default animation after the last frame" do
      renderable = Renderable.new("jimothy", "Trimmed")
      renderable.start_animation("Action")
      renderable.remaining_ms = 100
      default_frame = AnimationLibrary.assets["jimothy"].animations["Trimmed"].frames.first

      updates_per_frame = 1 + (200 / Renderable::MS_PER_UPDATE)
      updates_per_frame.ceil.to_i.times do
        renderable.next_frame
      end
      renderable.animation_frame.should be(default_frame)
    end

    it "should sometimes wait a cycle if the updates per frame is a decimal" do
      renderable = Renderable.new("jimothy", "Trimmed")
      # TODO: This
    end
  end

  describe "#start_animation" do
    it "should set the frame to the first in the animation" do
      renderable = Renderable.new("jimothy", "Trimmed")
      renderable.start_animation("Action")
      frame = AnimationLibrary.assets["jimothy"].animations["Action"].frames.first

      renderable.animation_frame.should be(frame)
    end

    it "should add to the remaining ms" do
      renderable = Renderable.new("jimothy", "Trimmed")
      ms = renderable.remaining_ms
      renderable.start_animation("Action")

      renderable.remaining_ms.should eq(ms + 100)
    end
  end
end
