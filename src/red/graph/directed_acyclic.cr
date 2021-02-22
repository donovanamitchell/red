module Red
  module Graph
    class DirectedAcyclic(T)
      getter verticies : Set(Vertex(T))

      def initialize(@verticies = Set(Vertex(T)).new)
      end

      def add_edge(from_vertex : Vertex(T), to_vertex : Vertex(T))
        from_vertex.add_edge(to_vertex)
      end

      def add_vertex(value : T)
        vertex = Vertex(T).new(value)
        verticies.add?(vertex)
        vertex
      end

      def add_vertex(vertex : Vertex(T))
        verticies.add?(vertex)
        vertex
      end

      def remove_edge(from_vertex : Vertex(T), to_vertex : Vertex(T))
        from_vertex.remove_edge(to_vertex)
      end

      def remove_vertex(vertex : Vertex(T))
        vertex.parents.each do |parent|
          parent.remove_edge(vertex)
        end
        verticies.delete(vertex)
      end

      # Kahn's Algorithm
      # TODO: memoize and recompute on vertex modification
      def topological_sort(&block : Set(Vertex(T)) -> Vertex(T))
        sorted_list = [] of T
        exposed_verticies = Set(Vertex(T)).new
        predecessor_hash = Hash(Vertex(T), Set(Vertex(T))).new

        verticies.each do |vertex|
          exposed_verticies << vertex if vertex.parents.empty?
          predecessor_hash[vertex] = vertex.parents.dup
        end

        while !exposed_verticies.empty?
          vertex = yield exposed_verticies

          exposed_verticies.delete(vertex)
          sorted_list << vertex.value

          vertex.successors.each do |successor|
            predecessor_hash[successor].delete(vertex)

            if predecessor_hash[successor].empty?
              exposed_verticies << successor
            end
          end
        end

        if sorted_list.size < verticies.size
          raise "Cycle found in acyclic graph"
        end

        sorted_list
      end
    end
  end
end