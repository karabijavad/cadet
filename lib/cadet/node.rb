module Cadet
  class Node
    attr_accessor :node
    include_package "org.neo4j.graphdb"

    def initialize(node)
      @node = node
    end
    def create_outgoing(to, type)
      @node.createRelationshipTo(to.node, DynamicRelationshipType.withName(type))
    end
    def add_label(label)
      @node.addLabel(DynamicLabel.label(label))
      self
    end

    def set_property(property, value)
      @node.setProperty(property, value)
    end
    def get_property(property)
      @node.getProperty(property.to_s)
    end

    def get_relationships(direction, type)
      @node.getRelationships(direction, type)
    end

    def outgoing(type)
      Cadet::RelationshipTraverser.new(self, Direction::OUTGOING, type)
    end
    def incoming(type)
      Cadet::RelationshipTraverser.new(self, Direction::INCOMING, type)
    end

    def []= (key, value)
      set_property key, value
    end
    def [] (key)
      get_property key
    end
  end
end
