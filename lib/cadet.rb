require 'java'

Dir["../neo4j-community-2.0.0/lib/*.jar"].each {|file| require file }

module Cadet
  module Session
    def self.open
      org.neo4j.graphdb.factory.GraphDatabaseFactory.new.newEmbeddedDatabase("/home/javad/cadet/neo4j-community-2.0.0/data/graph.db")
    end
    def self.close(db)
      db.shutdown()
    end
  end
end

module Cadet
  module Node
    def self.create(db)
      a = Time.now
      begin
        tx = db.beginTx()
        1000.times { db.createNode() }
        tx.success()
      ensure
        tx.close()
      end
      puts Time.now - a
    end
  end
end

db = Cadet::Session.open()
Cadet::Node.create(db)
Cadet::Session.close(db)
