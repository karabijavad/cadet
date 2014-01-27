module Cadet
  class BatchInserter < Cadet::Session
    include_package "org.neo4j.unsafe.batchinsert"

    def self.open(location)
      new BatchInserters.inserter(location)
    end

  end
end
