module Cadet
  module BatchInserter
    class Node < Cadet::Node
      include_package "org.neo4j.graphdb"

      def initialize(db, node)
        @db = db
        @underlying = node
      end

      def create_outgoing(to, type, properties = {})
        rel_type = DynamicRelationshipType.withName(type)
        @db.createRelationship(@underlying, to.underlying, rel_type, properties)
      end

      def set_property(prop, val)
        @db.setNodeProperties @underlying, {prop => val}
      end

      def get_relationships(direction, type)
      end
    end
  end
end
