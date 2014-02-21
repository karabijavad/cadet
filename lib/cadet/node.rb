module Cadet
  class Node < PropertyContainer
    attr_accessor :underlying
    include_package "org.neo4j.graphdb"

    def initialize(node, db = nil)
      @db = db
      @underlying = node
    end

    def add_label(label)
      @underlying.addLabel(DynamicLabel.label(label))
      self
    end
    def labels
      @underlying.getLabels().map(&:name)
    end

    def set_property(property, value)
      @underlying.setProperty(property.to_s, value)
    end
    def get_property(property)
      @underlying.getProperty(property.to_s)
    end

    def get_relationships(direction, type)
      @underlying.getRelationships(direction, type.to_s)
    end
    def create_outgoing(to, type)
      @underlying.createRelationshipTo(to.underlying, DynamicRelationshipType.withName(type))
    end
    def outgoing(type)
      Cadet::RelationshipTraverser.new(self, Direction::OUTGOING, type)
    end
    def incoming(type)
      Cadet::RelationshipTraverser.new(self, Direction::INCOMING, type)
    end

  end
end
