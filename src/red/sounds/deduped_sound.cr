require "./sound"

module Red
  module Sounds
    class DedupedSound < Sound
      property buffer : SF::SoundBuffer

      def initialize(@buffer)
        @sound_source = SF::Sound.new(@buffer)
      end

      def enqueue?(active_sounds : Array(Sound))
        active_sounds.none? do |sound|
          sound.is_a?(DedupedSound) && sound.buffer == buffer
        end
      end
    end
  end
end
