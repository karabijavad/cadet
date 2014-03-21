module Cadet
  module BatchInserter
    class Session < Cadet::Session

      def initialize(db)
        @index_provider = CadetIndex::IndexProvider.new(db)
        @db = db
      end

      def index_on(label, property, node)
        @index_provider[label].add(node.underlying, property.to_sym, node[property])
      end

      def close
        @index_provider.shutdown
        super
      end

      def self.current_session
        @@current_session
      end

      def self.open(location, &block)
        new(org.neo4j.unsafe.batchinsert.BatchInserters.inserter(location)).tap do |session|
          @@current_session = session
          if block_given?
            session.instance_exec(session, &block)
            session.close
          end
        end
      end

      def constraint(label, property)
        @db.createDeferredConstraint(DynamicLabel.label(label))
          .assertPropertyIsUnique(property)
          .create()
      end

      def find_node(label, property, value)
        (node = @index_provider[label].get(property.to_sym, value).first) ?
          Node.new(node, @db) : nil
      end

      def create_node(label, properties)
        Node.new(@db.createNode(properties.inject({}){|result,(k,v)| result[k.to_java_string] = v; result}, DynamicLabel.label(label)), @db)
      end

      def get_node(label, property, value)
        find_node(label, property, value) || create_node(label, {property.to_sym => value}).tap { |n|  index_on(label, property, n) }
      end

      def get_transaction
        Transaction.new(self)
      end

    end
  end
end
