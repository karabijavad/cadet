module Cadet
  module BatchInserter
    class NodeRelationships < Cadet::NodeRelationships
      include Enumerable
      include_package "org.neo4j.graphdb"

      def initialize(node, direction, type, db)
        @node = node
        @type = type
        @direction = direction
        @db = db
      end

      def each
        @node.get_relationships(@direction, @type).each do |rel|
          yield Cadet::BatchInserter::Node.new(rel.get_other_node(@node), @db)
        end
      end

      def << (othernode)
        @direction == Cadet::Direction::OUTGOING ? @node.create_outgoing(othernode, @type) : othernode.create_outgoing(@node, @type)
      end

      def outgoing(type)
        PathTraverser.new to_a, Cadet::Direction::OUTGOING, type, @db
      end
      def incoming(type)
        PathTraverser.new to_a, Cadet::Direction::INCOMING, type, @db
      end

      def ==(other)
        self.to_a == other.to_a
      end
    end
  end
end
