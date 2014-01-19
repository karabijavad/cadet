module Cadet
  module Traversal
    class Description
      include_package "org.neo4j.graphdb"

      def initialize(description)
        @description = description
        self
      end

      def relationships(relationship_names)
        relationship_names.each do |rel_name|
          @description = @description.relationships DynamicRelationshipType.withName(rel_name)
        end
        self
      end

      def evaluator(evaluator)
        @description = @description.evaluator evaluator.evaluator
        self
      end

      def traverse(start_node)
        @description.traverse(start_node.node).map do |path|
          Cadet::Traversal::Path.new path
        end
      end
    end
  end
end
