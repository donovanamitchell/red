require "./layer"
# TODO: Finish all of this

# The purpose of this object is to organize the renderable game objects in
# groups (layers) that can be drawn at the same time.
# This organizer automaticaly creates and deletes the layers containing the
# gameobjects
class AutoGraphicsOrganizer < SF::Transformable
  include SF::Drawable

  property layers : Array(Layer)

  def initialize(texture_filename : String)
    super()
    @texture_filename = texture_filename
    @layers = [] of Layer


    # TODO: Hmmmmm... Not here
    file = File.new("#{@texture_filename}.json")
    AnimationLibrary.load_assets(file)
    file.close
  end

  def draw(target : SF::RenderTarget, states : SF::RenderStates)
    @layers.each do |layer|
      layer.draw(target, states)
    end
  end

  # The next time I look at this I will hate me.
  def find_or_create_layer(order, texture, shader)
    if @layers.size == 0
      layer = Layer.new(texture, shader, Int32::MIN, Int32::MAX)
      @layers << layer
      return layer
    end

    index = @layers.index(@layers.size) do |layer|
      order <= layer.render_range_end && order >= layer.render_range_begin
    end
    # The layer must be in this layer or the next before the beginning range
    # exceeds the order.

    # 0..6 L1
    # 6..7 L2
    # 7..7 L3
    # 7..7 L4
    # 7..7 L5
    # 7..9 L6

    # The question comes, if L6 and L2 share the same shader and texture,
    # to which does the new GameObject with render order 7 belong? It does
    # not matter, because if the render orders of several objects are equal,
    # the order they are rendered in does not matter (or they wouldn't share
    # orders in the first place)
    while index < @layers.size && @layers[index].render_range_begin <= order
      if (
        order <= @layers[index].render_range_end &&
        order >= @layers[index].render_range_begin &&
        @layers[index].texture == texture &&
        @layers[index].shader == shader
      )
        return layer
      end
      index = index + 1
    end
    # @layers[index] is the insertion point if we exit out of this loop without
    # finding a suitable layer ??? what about 2 in example below ??? is it
    # always i - 1 ???

    # 0..1 L1
    # 1..1 L2
    # 1..3 L3
    # 3..3 L4
    # 3..4 L5

    # If we are inserting a GameObject 2 with a new texture, we will have to
    # break L3 into 1..2 and 2..3 chunks and a new layer 2..2.

    # We will never have to break more than one layer, because previous
    # layers must have an end of less than or equal to this layer's start
    # and the next layers must have a start of greater than or equal to this
    # layer's end.


    # We will never have to preform a merge of two layers in this function,
    # because two adjacent layers would already have to be joinable. For
    # that to occur, a layer must have been deleted and that should have
    # performed the join
    # untrue? insert L2 - 2 into below
    # 0..1 L1    0..1 L1
    # 1..1 L2 -> 1..1 L2
    # 1..5 L1    1..2 L1 If this layer only contains 1s then it would be best to reduce
    #            2..2 L2
    #            2..5 L1

    # 0..2 L1
    # 2..5 L2

    # In an insertion into L2 with a 3, if either 2..3 or 3..5 is empty, that
    # empty layer can be taken over by the new layer

    # We may have to extend the range of a layer. If 3 is inserted into above
    # and shares texture with L1 and L2 is empty up to 5, L2 would split into
    # 2..3 and 3..5. If 2..3 is empty, L1 can extend its range to 0..3.

    if @layers[index].render_range_begin == order
      layer = Layer.new(texture, shader, order, order)
      @layers.insert(index - 1, layer)
      return layer
    end

    # TODO: I think this is guaranteed at this point
    if @layers[index].render_range_begin < order && @layers[index].render_range_end
      layer_to_split = @layers[index]
      old_layer_begin = layer_to_split.render_range_begin
      new_layer_objects = layer.set_render_range_begin(order)
      if new_layer_objects.size == 0
        # TODO: potentially merge into previous layer if compatible
        layer = Layer.new(texture, shader, old_layer_begin, order)
        @layers.insert(index - 1, layer)
        return layer
      elsif layer_to_split.size == 0
        layer = Layer.new(texture, shader, old_layer_begin, order)
        layer.renderable_game_objs = new_layer_objects
        @layers.insert(index - 1, layer)

        layer_to_split.shader = shader
        layer_to_split.texture = texture
        return layer_to_split
      else
        layer = Layer.new(texture, shader, order, order)
        @layers.insert(index - 1, layer)

        split_layer = Layer.new(texture, shader, old_layer_begin, order)
        split_layer.renderable_game_objs = new_layer_objects

        @layers.insert(index - 1, split_layer)
        return layer
      end
    end
  end

  def insert_game_obj(game_object : GameObject,
      layer_texture : SF::Texture,
      layer_shader : SF::Shader | Nil = nil)
  layer = find_or_create_layer(game_object.order, layer_texture, layer_shader)
  layer.insert_game_obj(game_object)
  end

  def update
    @layers.each do |layer|
      layer.update
    end
  end
end