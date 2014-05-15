module Cadet
  module Spatial
    class Layer
      include Cadet::Proxy

      def add(node)
        @underlying.add node.underlying
      end
      def count
        @underlying.index.count
      end

    end
  end
end
