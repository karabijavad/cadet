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

    def transaction
      tx = @db.beginTx()
      begin
        yield tx
        tx.success()
      ensure
        tx.close()
      end
    end

    # def self.getNodeById(db, id)
    #   new(db.getNodeById(id))
    # end
    # def self.findNodesByLabelAndProperty(db, label, key, value)
    #   new(db.findNodesByLabelAndProperty(label, key, value))
    # end
  end
end
