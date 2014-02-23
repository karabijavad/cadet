module Cadet
  module BatchInserter
    class Node < Cadet::Node
      include_package "org.neo4j.graphdb"

      def create_outgoing(to, type, properties = {})
        @db.createRelationship(@underlying, to.underlying, DynamicRelationshipType.withName(type), properties)
      end

      def []= (property, value)
        @db.setNodeProperty @underlying, property.to_java_string, value
      end

      def [] (property)
        @db.getNodeProperties(@underlying)[property.to_java_string]
      end

      def == other_node
        @underlying == other_node
      end

    end
  end
end
