module Red
  module Graphics
    module Layers
      abstract class Layer < SF::Transformable
        include SF::Drawable

        getter render_range_end : Int32
        getter render_range_begin : Int32
        property objects : Array(GameObjects::GameObject)

        # https://crystal-lang.org/reference/syntax_and_semantics/splats_and_tuples.html
        # **_unused_named_args captures any additional named arguments that are
        # in the NamedTuple, but are not used by this initializer. This feels
        # kind of bad, but allows Layer to be initialized with any shaped
        # arguments.
        def initialize(render_range_begin = Int32::MIN, render_range_end = Int32::MAX, **_unused_named_args)
          @render_range_begin = render_range_begin
          @render_range_end = render_range_end
          @objects = [] of GameObjects::GameObject
          super()
        end

        def insert(object : GameObjects::GameObject)
          # TODO: better errors
          raise "#{object.render_order} outside range end #{render_range_end}" unless @render_range_end >= object.render_order
          raise "#{object.render_order} outside range begin #{render_range_begin}" unless @render_range_begin <= object.render_order

          # TODO: optimize?
          index = @objects.index do |obj|
            obj.render_order > object.render_order
          end
          index ||= -1
          @objects.insert(index, object)
        end

        def insert?(object : GameObjects::GameObject, _texture, _shader)
          object.render_order <= render_range_end &&
          object.render_order >= render_range_begin
        end

        def set_render_range_begin(range_begin)
          removed_objects = [] of GameObjects::GameObject
          if range_begin > @render_range_begin
            while @objects.first && range_begin > @objects.first.render_order
              removed_objects << @objects.shift
            end
          end

          @render_range_begin = range_begin

          removed_objects
        end

        def set_render_range_end(range_end)
          removed_objects = [] of GameObjects::GameObject
          if range_end < @render_range_end
            while @objects.last && range_end < @objects.last.render_order
              removed_objects << @objects.pop
            end
          end

          @render_range_end = range_end

          removed_objects
        end

        abstract def update
      end
    end
  end
end
