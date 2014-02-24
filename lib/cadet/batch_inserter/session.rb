module Cadet
  module BatchInserter
    class Session < Cadet::Session
      include_package "org.neo4j.graphdb"
      include_package "org.neo4j.unsafe.batchinsert"
      include_package "org.neo4j.index.impl.lucene"
      include_package "org.neo4j.helpers.collection"

      def initialize(db)
        @index_provider = CadetIndex::IndexProvider.new(db)
        super db
      end

      def close
        @index_provider.shutdown
        super
      end

      def self.open(location, config = {})
        new BatchInserters.inserter(location, config)
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
        index = @index_provider.nodeIndex(label)

        ( node = IteratorUtil.firstOrNull(index.get(property, value)) ) ?
          Node.new(node, @db) : nil
      end

      def create_node(label, property, value)
        n = Node.new(@db.createNode({property.to_java_string => value}, DynamicLabel.label(label)), @db)
        @index_provider.nodeIndex(label).add(n.underlying, property, value)
        n
      end

      def create_node_with(label, properties, indexing_property = nil)
        n = Node.new(@db.createNode(properties.inject({}){|result,(k,v)| result[k.to_java_string] = v; result}, DynamicLabel.label(label)), @db)
        @index_provider.nodeIndex(label).add(n.underlying, indexing_property, properties[indexing_property]) if indexing_property
        n
      end
    end
  end
end
