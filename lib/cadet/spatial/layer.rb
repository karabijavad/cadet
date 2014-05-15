module Cadet
  module Spatial
    class Layer
      include Cadet::Proxy

      def add(node, key, value)
        @underlying.add node.underlying, key, value
      end

      def within_distance_km(point, distance)
        result = @underlying.query("withinDistance", {"point" => point.to_java(:Double), "distanceInKm" => distance.to_java(:Double)}).map do |node|
          Cadet::Node.new(node)
        end
      end

    end
  end
end
