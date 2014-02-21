module Cadet
  module Test
    class Session < Cadet::Session
      include_package "org.neo4j.test"

      def self.open
        new TestGraphDatabaseFactory.new.newImpermanentDatabase
      end

    end
  end
end
