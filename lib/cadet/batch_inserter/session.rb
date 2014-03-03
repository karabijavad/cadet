module Cadet
  module BatchInserter
    class Session < Cadet::Session

      def initialize(db)
        @index_provider = CadetIndex::IndexProvider.new(db)
        super db
      end

      def close
        @index_provider.shutdown
        super
      end

      def self.open(location, &block)
        session = new org.neo4j.unsafe.batchinsert.BatchInserters.inserter(location)
        if block_given?
          session.dsl(&block)
          session.close
        end
        session
      end

      def constraint(label, property)
        @db.createDeferredConstraint(DynamicLabel.label(label))
          .assertPropertyIsUnique(property)
          .create()
      end

      def find_node(label, property, value)
        index = @index_provider.nodeIndex(label)

        (node = index.get(property.to_sym, value).first) ?
          Node.new(node, @db) : nil
      end

      def create_node(label, properties, indexing_property = nil)
        Node.new(@db.createNode(properties.inject({}){|result,(k,v)| result[k.to_java_string] = v; result}, DynamicLabel.label(label)), @db).tap do |n|
          @index_provider.nodeIndex(label).add(n.underlying, indexing_property.to_sym, properties[indexing_property]) if indexing_property
        end
      end

      def get_transaction
        Cadet::BatchInserter::Transaction.new(self)
      end

    end
  end
end
