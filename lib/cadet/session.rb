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
    def transaction
      Cadet::Transaction.transaction(@db) do
        yield
      end
    end
    def create_node
      Cadet::Node.create(@db)
    end
    def create_relationship(from, to, type)
      Cadet::Relationship.create(from, to, type)
    end
  end
end

