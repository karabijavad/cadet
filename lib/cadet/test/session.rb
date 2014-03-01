module Cadet
  module Test
    class Session < Cadet::Session

      def self.open
        new org.neo4j.test.TestGraphDatabaseFactory.new.newImpermanentDatabase
      end

    end
  end
end
