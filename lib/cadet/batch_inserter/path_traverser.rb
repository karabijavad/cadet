module Cadet
  module BatchInserter
    class PathTraverser < Cadet::PathTraverser
      include Enumerable
      include_package "org.neo4j.graphdb"

      def initialize(nodes, direction, type, db = nil)
        @nodes = nodes
        @direction = direction
        @type = type
        @db = db
      end

      def each
        if @direction == Cadet::Direction::OUTGOING
          @nodes.each do |n|
            n.outgoing(@type).each do |o|
              yield o
            end
          end
        else
          @nodes.each do |n|
            n.incoming(@type).each do |o|
              yield o
            end
          end
        end
      end

      def outgoing(type)
        PathTraverser.new(to_a, Cadet::Direction::OUTGOING, type, db)
      end
      def incoming(type)
        PathTraverser.new(to_a, Cadet::Direction::INCOMING, type, db)
      end

      def ==(other)
        self.to_a == other.to_a
      end
    end
  end
end
