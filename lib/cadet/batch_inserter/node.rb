module Cadet
  module BatchInserter
    class Node < Cadet::Node
      include_package "org.neo4j.graphdb"
      def create_outgoing(to, type, properties = {})
        @db.createRelationship(@underlying, to.underlying, DynamicRelationshipType.withName(type), properties)
      end

      def set_property(property, val)
        @db.setNodeProperty @underlying, property, val
      end

      def get_property(property)
        @db.getNodeProperties(@underlying)[property]
      end

      def get_relationships(direction, type)
      end
    end
  end
end
