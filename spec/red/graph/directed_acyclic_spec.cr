require "../../spec_helper"

module Red
  module Graph
    describe DirectedAcyclic(Int32) do
      describe "add_vertex" do
        it "adds a vertex" do
          vertex = Vertex(Int32).new(1)
          dag = DirectedAcyclic(Int32).new

          dag.add_vertex(vertex)
          dag.verticies.size.should eq(1)
          dag.verticies.first.should be(vertex)
        end

        it "can also be called with a value T to create a vertex" do
          dag = DirectedAcyclic(Int32).new

          vertex = dag.add_vertex(1)
          vertex.value.should eq(1)
          dag.verticies.size.should eq(1)
          dag.verticies.first.should be(vertex)
        end
      end

      describe "add_edge" do
        it "should add an edge from vertex to vertex" do
          from_vertex = Vertex(Int32).new(1)
          to_vertex = Vertex(Int32).new(1)
          dag = DirectedAcyclic(Int32).new(Set{from_vertex, to_vertex})

          dag.add_edge(from_vertex, to_vertex)

          from_vertex.successors.size.should eq(1)
          from_vertex.successors.first.should be(to_vertex)
        end

        # it should probably check to make sure the verticies are in the DAG
      end

      describe "remove_edge" do
        it "should remove an edge" do
          from_vertex = Vertex(Int32).new(1)
          to_vertex = Vertex(Int32).new(1)
          dag = DirectedAcyclic(Int32).new(Set{from_vertex, to_vertex})

          dag.add_edge(from_vertex, to_vertex)
          dag.remove_edge(from_vertex, to_vertex)

          from_vertex.successors.size.should eq(0)
        end
      end

      describe "remove_vertex" do
        it "should remove the vertex" do
          vertex = Vertex(Int32).new(1)
          dag = DirectedAcyclic(Int32).new

          dag.add_vertex(vertex)
          dag.remove_vertex(vertex)
          dag.verticies.size.should eq(0)
        end
        # it should probably remove edges to the vertex as well
      end

      describe "topological_sort" do
        it "should return an empty array if empty" do
          dag = DirectedAcyclic(Int32).new
          sorted_list = dag.topological_sort { |x| x.first }

          sorted_list.size.should eq(0)
          sorted_list.should be_a(Array(Int32))
        end

        #  1
        # / \
        # | 2
        # | /
        #  3
        it "should sort topologically" do
          dag = DirectedAcyclic(Int32).new
          vertex_1 = Vertex(Int32).new(1)
          vertex_2 = Vertex(Int32).new(2)
          vertex_3 = Vertex(Int32).new(3)

          dag.add_vertex(vertex_3)
          dag.add_vertex(vertex_2)
          dag.add_vertex(vertex_1)
          dag.add_edge(vertex_1, vertex_2)
          dag.add_edge(vertex_1, vertex_3)
          dag.add_edge(vertex_2, vertex_3)

          sorted_list = dag.topological_sort { |x| x.first }

          sorted_list.size.should eq(3)
          sorted_list[0].should eq(1)
          sorted_list[1].should eq(2)
          sorted_list[2].should eq(3)
        end

        it "shouldn't modify the DAG while traversing" do
          dag = DirectedAcyclic(Int32).new
          vertex_1 = Vertex(Int32).new(1)
          vertex_2 = Vertex(Int32).new(2)
          vertex_3 = Vertex(Int32).new(3)

          dag.add_vertex(vertex_3)
          dag.add_vertex(vertex_2)
          dag.add_vertex(vertex_1)
          dag.add_edge(vertex_1, vertex_2)
          dag.add_edge(vertex_1, vertex_3)
          dag.add_edge(vertex_2, vertex_3)

          sorted_list = dag.topological_sort { |x| x.first }

          dag.verticies.size.should eq(3)
          dag.verticies.should contain(vertex_1)
          dag.verticies.should contain(vertex_2)
          dag.verticies.should contain(vertex_3)

          vertex_1.successors.size.should eq(2)
          vertex_1.successors.should contain(vertex_2)
          vertex_1.successors.should contain(vertex_3)

          vertex_2.successors.size.should eq(1)
          vertex_2.successors.should contain(vertex_3)

          vertex_3.successors.size.should eq(0)
        end

        it "should resolve ties using the provided block" do
          dag = DirectedAcyclic(Int32).new

          [27, 4, 365, 77].shuffle.each do |value|
            dag.add_vertex(value)
          end

          sorted_list = dag.topological_sort do |exposed_verticies|
            exposed_verticies.max_by { |vertex| vertex.value % 7 }
          end

          sorted_list.size.should eq(4)
          sorted_list[0].should eq(27)
          sorted_list[1].should eq(4)
          sorted_list[2].should eq(365)
          sorted_list[3].should eq(77)
        end
      end
    end
  end
end