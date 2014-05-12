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

      def within_envelope(point, a, b, c, d)
        @underlying.index.search(
          org.neo4j.collections.rtree.filter.SearchCoveredByEnvelope.new(
            @underlying.index.getEnvelopeDecoder,
            org.neo4j.collections.rtree.Envelope.new(0, 1000, 20000, 30000)
          )
        )
        # Cadet::Session.current_session.underlying
        #   .index.forNodes(@underlying.getName, org.neo4j.gis.spatial.indexprovider.SpatialIndexProvider::SIMPLE_POINT_CONFIG)
        #   .query("withinDistance",{
        #       "point" => point.to_java(:Double),
        #       "distanceInKm" => distance.to_f
        #   })
      end

    end
  end
end
