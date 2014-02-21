module Cadet
  module Test
    class Session < Cadet::Session
      include_package "org.neo4j.graphdb"
      include_package "org.neo4j.unsafe.batchinsert"
      include_package "org.neo4j.index.impl.lucene"
      include_package "org.neo4j.helpers.collection"
      include_package "org.neo4j.graphdb.GraphDatabaseService"
      include_package "org.neo4j.graphdb.Node"
      include_package "org.neo4j.graphdb.Transaction"
      include_package "org.neo4j.graphdb.factory.GraphDatabaseSettings"
      include_package "org.neo4j.test"



      def self.open
        new TestGraphDatabaseFactory.new.newImpermanentDatabase
      end

    end
  end
end
