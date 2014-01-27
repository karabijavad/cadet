module Cadet
  class BatchInserter
    include_package "org.neo4j.unsafe.batchinsert"

    def initialize(bi)
      @bi = bi
    end

    def self.open(location)
      new BatchInserters.inserter(location)
    end

    def close
      @bi.shutdown
    end
  end
end
