module Cadet
  class PathTraverser
    include Enumerable
    include_package "org.neo4j.graphdb"

    def initialize(nodes, direction, type)
      @nodes = nodes
      @direction = direction
      @type = type
    end

    def each
      if @direction == Direction::OUTGOING
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
      PathTraverser.new(to_a, Direction::OUTGOING, type)
    end
    def incoming(type)
      PathTraverser.new(to_a, Direction::INCOMING, type)
    end

  end
end
