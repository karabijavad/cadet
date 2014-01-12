module Cadet
  class Session
    def initialize(db)
      @db = db
    end

    def self.open(location)
      new(org.neo4j.graphdb.factory.GraphDatabaseFactory.new.newEmbeddedDatabase(location))
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
      @db.findNodesByLabelAndProperty(org.neo4j.graphdb.DynamicLabel.label(label), key, value).each do |n|
        result << Cadet::Node.new(n)
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
      begin
        @db.schema()
          .constraintFor(org.neo4j.graphdb.DynamicLabel.label(label))
          .assertPropertyIsUnique(property)
          .create()
      rescue org.neo4j.graphdb.ConstraintViolationException => e
        # assuming the constraint already exists.
        # ignore, so that ruby scripts may 'create' the constraint multiple
        # times without worry of their script breaking.
      end
    end

  end
end
