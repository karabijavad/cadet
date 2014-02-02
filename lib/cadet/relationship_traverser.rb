module Cadet
  class RelationshipTraverser
    include Enumerable
    include_package "org.neo4j.graphdb"

    def initialize(node, direction, type)
      @node = node
      @type = type
      @direction = direction

      @relationships = node.get_relationships(direction, DynamicRelationshipType.withName(type))
    end

    def each
      @relationships.each do |rel|
        yield rel.getOtherNode(@node.node)
      end
    end

    def << (othernode)
      if @direction == Direction::OUTGOING
        @node.createRelationshipTo othernode
      elsif @direction == Direction::INCOMING
        othernode.createRelationshipTo @node
      end
    end
  end
end
