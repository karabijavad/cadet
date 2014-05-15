module Cadet
  module Spatial
    class Session
      include Cadet::Proxy

      class << self
        attr_accessor :current_session

        def open(session, &block)
          @current_session = new(session)
          @current_session.instance_exec(@current_session, &block) if block_given?
          @current_session
        end
      end

      def initialize(session)
        @underlying = org.neo4j.gis.spatial.SpatialDatabaseService.new(session.underlying)
      end

      def get_point_layer(layer_name)
        Layer.new(Cadet::Session.current_session.underlying.index.forNodes(layer_name, org.neo4j.gis.spatial.indexprovider.SpatialIndexProvider::SIMPLE_POINT_CONFIG))
      end

    end
  end
end
