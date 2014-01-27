module Cadet
  class BatchInserter < Cadet::Session
    include_package "org.neo4j.unsafe.batchinsert"

    def self.open(location)
      @db = new BatchInserters.inserter(location)
    end

    def transaction
      yield
    end

    def constraint(label, property)
      @db.createDeferredConstraint(org.neo4j.graphdb.DynamicLabel.label(label)).assertPropertyIsUnique(property)
    end
  end
end
