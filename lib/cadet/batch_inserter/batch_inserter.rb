module Cadet
  module BatchInserter
    class Session < Cadet::Session
      include_package "org.neo4j.graphdb"
      include_package "org.neo4j.unsafe.batchinsert"
      include_package "org.neo4j.index.impl.lucene"
      include_package "org.neo4j.helpers.collection"

      def initialize(db)
        @db = db
        @index_provider = Cadet::CadetIndex::IndexProvider.new(db)
      end

      def close
        @index_provider.shutdown
        super
      end

      def self.open(location)
        new BatchInserters.inserter(location)
      end

      def transaction
        yield
      end

      def constraint(label, property)
        @db.createDeferredConstraint(DynamicLabel.label(label))
          .assertPropertyIsUnique(property)
          .create()
      end

      def find_node(label, property, value)
        index = @index_provider.nodeIndex label, {"type" => "exact"}
        result = IteratorUtil.firstOrNull(index.get(property, value))
        if result
          return Node.new(result, @db)
        else
          return nil
        end
      end

      def create_node(label, property, value)
        n = Node.new(@db.createNode({property => value}, DynamicLabel.label(label)), @db)
        index = @index_provider.nodeIndex label, {"type" => "exact"}
        index.add(n.underlying, property, value)
        n
      end
    end
  end
end
