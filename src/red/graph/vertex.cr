module Red
  module Graph
    class Vertex(T)
      getter value : T
      getter successors : Set(Vertex(T))
      getter parents : Set(Vertex(T))

      def initialize(@value : T)
        @successors = Set(Vertex(T)).new
        @parents = Set(Vertex(T)).new
      end

      def add_edge(vertex : Vertex(T))
        vertex.add_parent(self)
        @successors.add?(vertex)
      end

      def add_parent(vertex : Vertex(T))
        @parents.add?(vertex)
      end

      def remove_edge(vertex : Vertex(T))
        vertex.remove_parent(self)
        @successors.delete(vertex)
      end

      def remove_parent(vertex : Vertex(T))
        @parents.delete(vertex)
      end
    end
  end
end