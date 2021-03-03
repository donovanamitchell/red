require "json"

module Red
  module Animations
    module Serializers
      class Size
        include JSON::Serializable

        property w : Int32
        property h : Int32
      end
    end
  end
end
