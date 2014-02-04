module Cadet
  module BatchInserter
    class Node < Cadet::Node
      include_package "org.neo4j.graphdb"
      def create_outgoing(to, type, properties = {})
        @db.createRelationship(@underlying, to.underlying, DynamicRelationshipType.withName(type), properties)
      end

      def set_property(prop, val)
        @db.setNodeProperty @underlying, prop, val
      end

      def get_relationships(direction, type)
      end
    end
  end
end
