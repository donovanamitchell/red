module Red
  module Graphics
    module Layers
      abstract class Layer(T) < SF::Transformable
        include SF::Drawable

        getter render_range_end : Int32
        getter render_range_begin : Int32
        property objects : Array(T)

        # not sure if I need this or not with the include Drawable
        # abstract def draw(target : SF::RenderTarget, states : SF::RenderStates)
        def initialize(@render_range_begin, @render_range_end)
          @objects = [] of T
          super()
        end

        def insert(object : T)
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

        def insert?(object : T)
          object.render_order <= render_range_end &&
          object.render_order >= render_range_begin
        end

        def set_render_range_begin(range_begin)
          removed_objects = [] of T
          if range_begin > @render_range_begin
            while @objects.first && range_begin > @objects.first.render_order
              removed_objects << @objects.shift
            end
          end

          @render_range_begin = range_begin

          removed_objects
        end

        def set_render_range_end(range_end)
          removed_objects = [] of T
          if range_end < @render_range_end
            while @objects.last && range_end < @objects.last.render_order
              removed_objects << @objects.pop
            end
          end

          @render_range_end = range_end

          removed_objects
        end
      end
    end
  end
end
