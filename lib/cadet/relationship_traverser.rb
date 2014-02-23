module Cadet
  class RelationshipTraverser
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
      result = []
      each do |n|
        n.outgoing(type).each do |o|
          result << o
        end
      end
      result
    end
  end
end
