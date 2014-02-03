module Cadet
  module BatchInserter
    class Node < Cadet::Node
      attr_accessor :underlying

      include_package "org.neo4j.graphdb"

      def initialize(db, node)
        @db = db
        @underlying = node
      end

      def self.make(db, props = {}, label = '')
        node = db.createNode props, DynamicLabel.label(label)
        new db, node
      end

      def create_outgoing(to, type, properties = {})
        rel_type = DynamicRelationshipType.withName(type)
        @db.createRelationship(@underlying, to.underlying, rel_type, properties)
      end

      def set_property(prop, val)
        data = {}
        data[prop.to_s] = val
        @db.setNodeProperties(@underlying, data)
      end

      def get_relationships(direction, type)
      end
    end
  end
end
