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

      def get_relationships(direction, type)
        @db.getRelationships(@underlying).select {|r| r.getType == DynamicRelationshipType.withName(type).name }.map do |rel|
          Relationship.new(rel)
        end
      end

      def == other_node
        @underlying == other_node
      end

      def outgoing(type)
        NodeRelationships.new(self, Direction::OUTGOING, type)
      end
      def incoming(type)
        NodeRelationships.new(self, Direction::INCOMING, type)
      end


    end
  end
end
