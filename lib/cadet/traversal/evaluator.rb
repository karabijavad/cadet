module Cadet
  module Traversal
    class Evaluator
      include_package "org.neo4j.graphdb.traversal"

      def initialize
        @evaluator = Evaluators.toDepth(2)
      end

      def evaluator
        @evaluator
      end
    end
  end
end
