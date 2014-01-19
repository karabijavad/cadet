module Cadet
  module Traversal
    class Description
      def initialize(description)
        @description = description
      end
      def traverse(start_node)
        @description.traverse(start_node.node)
      end
    end
  end
end
