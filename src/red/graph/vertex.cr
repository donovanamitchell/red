module Red
  module Graph
    class Vertex(T)
      getter value : T
      getter edges : Set(Vertex(T))

      def initialize(@value : T, @edges = Set(Vertex(T)).new)
      end

      def add_edge(vertex : Vertex(T))
        edges.add?(vertex)
      end

      def remove_edge(vertex : Vertex(T))
        edges.delete(vertex)
      end

      def successors
        edges
      end
    end
  end
end