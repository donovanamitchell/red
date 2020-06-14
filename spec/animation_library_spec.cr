require "./spec_helper"

# TODO: clean up state inbetween tests
describe AnimationLibrary do
  describe "#load_assets" do
    it "should create an Asset with an Animation" do
      AnimationLibrary.load_assets(
        <<-JSON
        {
          "frames": [
            {
              "filename": "thing",
              "tag": "Action",
              "frame_order": 0,
              "frame": { "x": 40, "y": 220, "w": 1, "h": 1 },
              "trimmed": true,
              "rotated": false,
              "duration": 100,
              "spriteSourceSize": { "x": 4, "y": 5, "w": 1, "h": 1 },
              "sourceSize": { "w": 32, "h": 31 }
            },
            {
              "filename": "thing",
              "tag": "Action",
              "frame_order": 1,
              "frame": { "x": 30, "y": 0, "w": 10, "h": 12 },
              "trimmed": true,
              "rotated": false,
              "duration": 100,
              "spriteSourceSize": { "x": 2, "y": 20, "w": 10, "h": 12 },
              "sourceSize": { "w": 32, "h": 32 }
            }
          ],
          #{metadata}
        }
        JSON
      )

      asset = AnimationLibrary.assets["thing"]

      asset.should be_a(AnimationLibrary::Asset)
      asset.animations["Action"].should be_a(Animation)
      asset.animations["Action"].frames.size.should eq(2)

      first_frame = asset.animations["Action"].frames[0]
      second_frame = asset.animations["Action"].frames[1]

      first_frame.order.should eq 0
      first_frame.x.should eq 40
      first_frame.y.should eq 220
      first_frame.w.should eq 1
      first_frame.h.should eq 1
      first_frame.x_offset.should eq 4
      first_frame.y_offset.should eq 5
      first_frame.full_w.should eq 32
      first_frame.full_h.should eq 31

      second_frame.order.should eq 1
      second_frame.x.should eq 30
      second_frame.y.should eq 0
      second_frame.w.should eq 10
      second_frame.h.should eq 12
      second_frame.x_offset.should eq 2
      second_frame.y_offset.should eq 20
      second_frame.full_w.should eq 32
      second_frame.full_h.should eq 32
    end

    it "can create an asset without named animations" do
      AnimationLibrary.load_assets(
        <<-JSON
        {
          "frames": [
            {
              "filename": "background",
              "tag": "",
              "frame_order": 0,
              "frame": { "x": 248, "y": 0, "w": 240, "h": 160 },
              "trimmed": false,
              "rotated": false,
              "duration": 100,
              "spriteSourceSize": { "x": 0, "y": 0, "w": 240, "h": 160 },
              "sourceSize": { "w": 240, "h": 160 }
            }
          ],
          #{metadata}
        }
        JSON
      )

      asset = AnimationLibrary.assets["background"]

      asset.should be_a(AnimationLibrary::Asset)
      asset.animations[""].should be_a(Animation)
      asset.animations[""].frames.size.should eq(1)
    end

    it "can load animations across multiple files" do
      AnimationLibrary.load_assets(
        <<-JSON
        {
          "frames": [
            {
              "filename": "jack",
              "tag": "run",
              "frame_order": 0,
              "frame": { "x": 248, "y": 0, "w": 240, "h": 160 },
              "trimmed": false,
              "rotated": false,
              "duration": 100,
              "spriteSourceSize": { "x": 0, "y": 0, "w": 240, "h": 160 },
              "sourceSize": { "w": 240, "h": 160 }
            }
          ],
          #{metadata}
        }
        JSON
      )
      AnimationLibrary.load_assets(
        <<-JSON
        {
          "frames": [
            {
              "filename": "jack",
              "tag": "run",
              "frame_order": 1,
              "frame": { "x": 248, "y": 0, "w": 240, "h": 160 },
              "trimmed": false,
              "rotated": false,
              "duration": 100,
              "spriteSourceSize": { "x": 0, "y": 0, "w": 240, "h": 160 },
              "sourceSize": { "w": 240, "h": 160 }
            }
          ],
          #{metadata}
        }
        JSON
      )

      asset = AnimationLibrary.assets["jack"]
      asset.animations["run"].frames.size.should eq(2)
    end

    it "can load frames out of order" do
      AnimationLibrary.load_assets(
        <<-JSON
        {
          "frames": [
            {
              "filename": "hands",
              "tag": "Idle",
              "frame_order": 20,
              "frame": { "x": 40, "y": 220, "w": 10, "h": 12 },
              "trimmed": true,
              "rotated": false,
              "duration": 100,
              "spriteSourceSize": { "x": 2, "y": 20, "w": 10, "h": 12 },
              "sourceSize": { "w": 32, "h": 32 }
            },
            {
              "filename": "hands",
              "tag": "Idle",
              "frame_order": 10,
              "frame": { "x": 30, "y": 220, "w": 10, "h": 12 },
              "trimmed": true,
              "rotated": false,
              "duration": 100,
              "spriteSourceSize": { "x": 2, "y": 20, "w": 10, "h": 12 },
              "sourceSize": { "w": 32, "h": 32 }
            },
            {
              "filename": "hands",
              "tag": "Idle",
              "frame_order": 12,
              "frame": { "x": 264, "y": 218, "w": 11, "h": 12 },
              "trimmed": true,
              "rotated": false,
              "duration": 100,
              "spriteSourceSize": { "x": 1, "y": 20, "w": 11, "h": 12 },
              "sourceSize": { "w": 32, "h": 32 }
            }
          ],
          #{metadata}
        }
        JSON
      )

      asset = AnimationLibrary.assets["hands"]

      asset.animations["Idle"].frames.size.should eq(3)
      frame_order = asset.animations["Idle"].frames.map { |frame| frame.order }
      frame_order[0].should eq(10)
      frame_order[1].should eq(12)
      frame_order[2].should eq(20)
    end
  end
end

def metadata
  <<-JSON
  "meta": {
    "app": "http://www.aseprite.org/",
    "version": "1.2.19.2-x64",
    "image": "atlas.png",
    "format": "RGBA8888",
    "size": { "w": 496, "h": 232 },
    "scale": "1"
  }
  JSON
end