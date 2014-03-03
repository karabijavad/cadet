module Cadet
  module Test
    class Session < Cadet::Session

      def self.open(&block)
        session = new org.neo4j.test.TestGraphDatabaseFactory.new.newImpermanentDatabase
        if block_given?
          session.dsl(&block)
          session.close
        end
        session
      end

    end
  end
end
