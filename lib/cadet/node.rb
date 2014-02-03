module Cadet
  class Node < PropertyContainer
    include_package "org.neo4j.graphdb"

    def initialize(node)
      @underlying = node
    end
    def create_outgoing(to, type)
      @underlying.createRelationshipTo(to.node, DynamicRelationshipType.withName(type))
    end
    def add_label(label)
      @underlying.addLabel(DynamicLabel.label(label))
      self
    end

    def set_property(property, value)
      @underlying.setProperty(property, value)
    end

    def get_relationships(direction, type)
      @underlying.getRelationships(direction, type)
    end

    def outgoing(type)
      Cadet::RelationshipTraverser.new(self, Direction::OUTGOING, type)
    end
    def incoming(type)
      Cadet::RelationshipTraverser.new(self, Direction::INCOMING, type)
    end
  end
end
