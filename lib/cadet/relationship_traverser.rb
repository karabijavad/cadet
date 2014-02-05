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
      @node.underlying.get_relationships(@direction, DynamicRelationshipType.withName(@type)).each do |rel|
        yield Node.new rel.getOtherNode(@node.underlying)
      end
    end

    def << (othernode)
      if @direction == Direction::OUTGOING
        @node.create_outgoing othernode, @type
      elsif @direction == Direction::INCOMING
        othernode.create_outgoing @node, @type
      end
    end
  end
end
