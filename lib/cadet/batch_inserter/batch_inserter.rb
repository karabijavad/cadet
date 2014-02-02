module Cadet
  module BatchInserter
    class Session < Cadet::Session
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
        index = @index_provider.nodeIndex label, {"type" => "exact"}
      end

      def find_node_by_label_and_property(label, property, value)
        index = @index_provider.nodeIndex label, {"type" => "exact"}
        result = IteratorUtil.firstOrNull(index.get(property, value))
        if result
          return Node.new(@db, result)
        else
          return nil
        end
      end

      def create_node_with(label, props={})
        n = Node.make @db, props, label

        index = @index_provider.nodeIndex label, {"type" => "exact"}
        index.add(n.node, props)
        n
      end
    end
  end
end
