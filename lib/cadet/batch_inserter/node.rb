module Cadet
  module BatchInserter
    class Node < Cadet::Node
      include_package "org.neo4j.graphdb"

      def initialize(db, node)
        @db = db
        @node = node
      end

      def self.make(db, props = {}, label = '')
        node = db.createNode props, DynamicLabel.label(label)
        new db, node
      end

      def create_outgoing(to, type, properties = {})
        rel_type = DynamicRelationshipType.withName(type)
        @db.createRelationship(@node, to.node, rel_type, properties)
      end

      def set_property(prop, val)
        data = {}
        data[prop] = val
        @db.setNodeProperties(@node, data)
      end

      def get_relationships(direction, type)
      end
    end
  end
end
