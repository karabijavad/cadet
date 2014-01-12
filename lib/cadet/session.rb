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

    def create_node
      Cadet::Node.new(@db.createNode())
    end
    def get_node(id)
      Cadet::Node.new(@db.getNodeById(id))
    end
    def find_node(label, key, value)
      Cadet::Node.new(@db.findNodesByLabelAndProperty(label, key, value))
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
  end
end
