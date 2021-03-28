require "./sound"

module Red
  module Sounds
    class RegisteredSound < Sound
      property buffer : SF::SoundBuffer

      def initialize(@buffer)
        @sound_source = SF::Sound.new(@buffer)
      end

      def enqueue?(_active_sounds : Array(Sound))
        true
      end
    end
  end
end
