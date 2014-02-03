module Cadet
  class Node
    attr_accessor :node
    include_package "org.neo4j.graphdb"

    def initialize(node)
      @node = node
    end

    def add_label(label)
      @node.addLabel(DynamicLabel.label(label))
      self
    end

    def []= (property, value)
      set_property property, value
    end
    def set_property(property, value)
      @node.setProperty(property, value)
    end
    def [] (key)
      @node.getProperty(property.to_s)
    end
    def get_property(property)
      @node.getProperty(property)
    end

    def get_relationships(direction, type)
      @node.getRelationships(direction, type)
    end
    def create_outgoing(to, type)
      @node.createRelationshipTo(to.node, DynamicRelationshipType.withName(type))
    end
    def outgoing(type)
      Cadet::RelationshipTraverser.new(self, Direction::OUTGOING, type)
    end
    def incoming(type)
      Cadet::RelationshipTraverser.new(self, Direction::INCOMING, type)
    end

  end
end
