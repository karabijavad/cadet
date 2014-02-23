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

      def get_relationships(direction, type)
        @db.getRelationships(@underlying).map { |rel|
          Relationship.new(rel, @db)
        }.select { |rel|
          rel.type == DynamicRelationshipType.withName(type)
        }
      end

      def == other_node
        @underlying == other_node.underlying
      end

      def outgoing(type)
        NodeRelationships.new(self, Cadet::Direction::OUTGOING, type, @db)
      end
      def incoming(type)
        NodeRelationships.new(self, Cadet::Direction::INCOMING, type, @db)
      end

    end
  end
end
