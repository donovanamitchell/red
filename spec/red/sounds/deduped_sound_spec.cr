require "../../spec_helper"

module Red
  module Sounds
    describe DedupedSound do
      describe "enqueue?" do
        it "returns true if there is not a sound with a matching buffer" do
          sound = DedupedSound.new(SF::SoundBuffer.new)
          active_sounds = [
            DedupedSound.new(SF::SoundBuffer.new)
          ]
          sound.enqueue?(active_sounds).should be_true
        end

        it "returns true if the array is empty" do
          sound = DedupedSound.new(SF::SoundBuffer.new)
          active_sounds = [] of Sound
          sound.enqueue?(active_sounds).should be_true
        end

        it "returns false if there is a sound with a matching buffer" do
          buffer = SF::SoundBuffer.new
          sound = DedupedSound.new(buffer)
          active_sounds = [
            DedupedSound.new(buffer)
          ]
          sound.enqueue?(active_sounds).should be_false
        end
      end
    end
  end
end
