module Cadet
  module BatchInserter
    class Relationship < Cadet::Relationship
      attr_accessor :underlying

      def get_other_node(node)
        if node.underlying == @underlying.getStartNode
          return @underlying.getEndNode
        else
          return @underlying.getStartNode
        end
      end

      def type
        DynamicRelationshipType.withName(@underlying.getType.name.to_sym)
      end

    end
  end
end
