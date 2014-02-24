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

      def outgoing(type)
        NodeRelationships.new(self, Cadet::Direction::OUTGOING, type)
      end

      def get_relationships(direction, type)
        # not implemented in batch inserter mode. though, it could be done.
        # the assumption is that this shouldnt be necessary, as batch inserter mode
        # should be about inserting data, not querying data
        raise NotImplementedError
      end

    end
  end
end
