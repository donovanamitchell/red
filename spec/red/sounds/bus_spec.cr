require "../../spec_helper"
require "./test_sound"

module Red
  module Sounds
    describe Bus do
      describe "enqueue" do
        it "should add the sound to the queue" do
          sound = TestSound.new
          bus = Bus.new
          bus.enqueue(sound)
          bus.sound_queue.should contain(sound)
        end
      end

      describe "update" do
        it "should play enqueued sounds" do
          sound = TestSound.new
          bus = Bus.new
          bus.enqueue(sound)
          bus.update
          bus.active_sounds.should contain(sound)
          sound.times_play_called.should eq(1)
        end

        it "should not play sounds which do should not be played" do
          sound = TestSound.new
          sound.enqueue = ->(_active_sounds : Array(Sound)) { false }
          bus = Bus.new
          bus.enqueue(sound)
          bus.update
          bus.active_sounds.should_not contain(sound)
          sound.times_play_called.should eq(0)
        end

        it "should remove the sound from the queue" do
          sound = TestSound.new
          bus = Bus.new
          bus.enqueue(sound)
          bus.update
          bus.sound_queue.should_not contain(sound)
        end

        it "should pass any playing sounds to the sound" do
          sound_1 = TestSound.new
          sound_2 = TestSound.new
          sound_2.enqueue = ->(active_sounds : Array(Sound)) do
            active_sounds.should_not contain(sound_2)
            active_sounds.should contain(sound_1)
            false
          end

          bus = Bus.new
          bus.enqueue(sound_1)
          bus.update
          bus.enqueue(sound_2)
          bus.update
          bus.active_sounds.should contain(sound_1)
          bus.active_sounds.should_not contain(sound_2)
        end
      end
    end
  end
end
