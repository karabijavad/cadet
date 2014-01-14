module Cadet
  class Session
    include_package "org.neo4j.graphdb"
    include_package "org.neo4j.graphdb.factory"

    def initialize(db)
      @db = db
    end

    def self.open(location)
      new(GraphDatabaseFactory.new.newEmbeddedDatabase(location))
    end
    def close
      @db.shutdown()
    end

    def create_node(opts = {})
      Cadet::Node.new(@db.createNode())
    end
    def get_node_by_id(id)
      Cadet::Node.new(@db.getNodeById(id))
    end

    def find_nodes_by_label_and_property(label, key, value)
      result = []
      #findNodesByLabelAndProperty
      #Returns all nodes having the label, and the wanted property value.
      @db.findNodesByLabelAndProperty(DynamicLabel.label(label), key, value).each do |node|
        result << Cadet::Node.new(node)
      end
      result
    end

    def transaction
      tx = @db.beginTx()
      begin
        yield tx
        tx.success()
      ensure
        tx.close()
      end
    end

    def constraint(label, property)
      @db.schema()
        .constraintFor(DynamicLabel.label(label))
        .assertPropertyIsUnique(property)
        .create()
    end

  end
end
