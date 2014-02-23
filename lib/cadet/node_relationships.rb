module Cadet
  class NodeRelationships
    include Enumerable
    include_package "org.neo4j.graphdb"

    def initialize(node, direction, type)
      @node = node
      @type = type
      @direction = direction
    end

    def each
      @node.get_relationships(@direction, @type).each do |rel|
        yield Node.new(rel.getOtherNode(@node.underlying))
      end
    end

    def << (othernode)
      @direction == Direction::OUTGOING ? @node.create_outgoing(othernode, @type) : othernode.create_outgoing(@node, @type)
    end

    def outgoing(type)
      PathTraverser.new to_a, Direction::OUTGOING, type
    end
    def incoming(type)
      PathTraverser.new to_a, Direction::INCOMING, type
    end

    def ==(other)
      self.to_a == other.to_a
    end

  end
end
