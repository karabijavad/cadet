module Cadet
  module Node
    def self.create(db)
      db.createNode()
    end
    def self.addLabel(node, label)
      node.addLabel(org.neo4j.graphdb.DynamicLabel.label(label))
    end
    def self.getNodeById(db, id)
      db.getNodeById(id)
    end
    def self.getRelationshipById(db, id)
      db.getRelationshipById(id)
    end
    def self.findNodesByLabelAndProperty(db, label, key, value)
      db.findNodesByLabelAndProperty(label, key, value)
    end
  end
end

