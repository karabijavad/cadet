module Cadet
  class Node < PropertyContainer
    attr_accessor :underlying
    include_package "org.neo4j.graphdb"

    def initialize(db, node)
      @db = db
      @underlying = node
    end

    def add_label(label)
      @underylying.addLabel(DynamicLabel.label(label))
      self
    end

    def set_property(property, value)
      @underylying.setProperty(property, value)
    end
    def get_property(property)
      @underylying.getProperty(property)
    end

    def get_relationships(direction, type)
      @underylying.getRelationships(direction, type)
    end
    def create_outgoing(to, type)
      @underylying.createRelationshipTo(to.node, DynamicRelationshipType.withName(type))
    end
    def outgoing(type)
      Cadet::RelationshipTraverser.new(self, Direction::OUTGOING, type)
    end
    def incoming(type)
      Cadet::RelationshipTraverser.new(self, Direction::INCOMING, type)
    end

  end
end
