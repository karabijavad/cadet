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

    def method_missing(name, *args)
      if name.to_s.end_with? "="
        set_property name.to_s.gsub(/=$/, ''), args[0]
      elsif name.to_s.end_with? "_to"
        create_outgoing args[0], name.to_s.gsub(/_to$/, '')
      end
    end

    def set_property(property, value)
      @node.setProperty(property, value)
    end
    def set_properties(props)
      props.each do |k,v|
        set_property(k.to_s, v)
      end
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
  end
end
