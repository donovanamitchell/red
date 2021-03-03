require "json"

module Red
  module Animations
    module Serializers
      class Anchor
        include JSON::Serializable

        property x : Int32
        property y : Int32
        property name : String
      end
    end
  end
end
