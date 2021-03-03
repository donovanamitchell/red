require "json"
require "./sprite"

module Red
  module Animations
    module Serializers
      class Sprites
        include JSON::Serializable

        property frames : Array(Sprite)
      end
    end
  end
end
