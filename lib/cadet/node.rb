module Cadet
  class Node
    def initialize(node)
      @node = node
    end
    def node
      @node
    end
    def outgoing(to, type)
      @node.createRelationshipTo(to.node, org.neo4j.graphdb.DynamicRelationshipType.withName(type))
    end
    def addLabel(label)
      @node.addLabel(org.neo4j.graphdb.DynamicLabel.label(label))
    end

    def method_missing(:name)
      @node.setProperty(name, val) if name.to_s.end_with? "="
    end

  end
end
