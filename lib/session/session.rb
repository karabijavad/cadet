module Cadet
  module Session
    def self.open(location)
      org.neo4j.graphdb.factory.GraphDatabaseFactory.new.newEmbeddedDatabase(location)
    end
    def self.close(db)
      db.shutdown()
    end
  end
end

