require "json"

module Red
  module Animations
    module Serializers
      class Bounds
        include JSON::Serializable

        property x : Int32
        property y : Int32
        property w : Int32
        property h : Int32
      end
    end
  end
end
