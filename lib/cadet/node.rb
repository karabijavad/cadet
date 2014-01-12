module Cadet
  class Node
    def initialize(node)
      @node = node
    end
    def node
      @node
    end
    def self.create(db)
      new(db.createNode())
    end
    def self.getNodeById(db, id)
      new(db.getNodeById(id))
    end
    def self.findNodesByLabelAndProperty(db, label, key, value)
      new(db.findNodesByLabelAndProperty(label, key, value))
    end
    def outgoing(to, type)
      @node.createRelationshipTo(to.node, org.neo4j.graphdb.DynamicRelationshipType.withName(type))
    end
    def addLabel(label)
      @node.addLabel(org.neo4j.graphdb.DynamicLabel.label(label))
    end
  end
end

