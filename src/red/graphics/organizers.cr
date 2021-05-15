require "./organizers/automatic"
require "./organizers/manual"

module Red
  module Graphics
    module Organizers
      @@organizer = Red::Graphics::Organizers::Automatic.new

      def self.organizer
        @@organizer
      end

      def self.organizer=(organizer)
        @@organizer = organizer
      end

      def self.arrange(below, above)
        @@organizer.arrange(below, above)
      end

      def self.insert_game_obj(game_object, tileset, shader)
        @@organizer.insert_game_obj(game_object, tileset, shader)
      end

      def self.remove_game_obj(game_object)
        @@organizer.remove_game_obj(game_object)
      end

      def self.register(**args)
        @@organizer.register(**args)
      end

      def self.update(**args)
        @@organizer.update(**args)
      end
    end
  end
end
