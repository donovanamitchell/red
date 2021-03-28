module Red
  module Sounds
    abstract class Sound
      property sound_source : SF::SoundSource

      # Abstract classes shouldn't complain about initialization
      # https://github.com/crystal-lang/crystal/issues/2827
      private def initialize(@sound_source)
      end

      abstract def enqueue?(active_sounds : Array(Sound))

      def paused?
        sound_source.status.paused?
      end

      def play
        sound_source.play
      end

      def playing?
        sound_source.status.playing?
      end

      def stopped?
        sound_source.status.stopped?
      end
    end
  end
end
