module Cadet
  module BatchInserter
    class Node < Cadet::Node
      attr_accessor :node

      def initialize(db, node)
        @db = db
        @node = node
      end

      def self.make(db, props = {}, label = '')
        node = db.createNode props, org.neo4j.graphdb.DynamicLabel.label(label)
        new db, node
      end

      def create_outgoing(to, type, properties = {})
        rel_type = org.neo4j.graphdb.DynamicRelationshipType.withName(type)
        @db.createRelationship(@node, to.node, rel_type, properties)
      end
      def set_properties(props)
        @db.setNodeProperties(@node, props)
      end
    end
  end
end
