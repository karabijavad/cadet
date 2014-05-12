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

      def get_point_layer(layer_name, xprop="lat", yprop="lng")
        Layer.new(@underlying.getOrCreatePointLayer(layer_name, xprop, yprop))
      end

    end
  end
end
