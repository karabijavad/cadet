module Cadet
  module BatchInserter
    class Session < Cadet::Session

      def initialize(underlying)
        @index_provider = CadetIndex::IndexProvider.new(underlying)
        @underlying = underlying
      end

      def index_on(label, property, node)
        @index_provider[label].add(node.underlying, property.to_sym, node[property])
      end

      def close
        @index_provider.shutdown
        super
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
        @underlying.createDeferredConstraint(DynamicLabel.label(label))
          .assertPropertyIsUnique(property)
          .create()
      end

      def find_node(label, property, value)
        (node = @index_provider[label].get(property.to_sym, value).first) ?
          Node.new(node) : nil
      end

      def create_node(label, properties)
        Node.new(@underlying.createNode(properties.inject({}){|result,(k,v)| result[k.to_java_string] = v; result}, DynamicLabel.label(label)))
      end

      def get_node(label, property, value)
        find_node(label, property, value) || create_node(label, {property.to_sym => value}).tap { |n|  index_on(label, property, n) }
      end

      def get_transaction
        Transaction.new(self)
      end

      def create_relationship(from, to, type, properties)
        Relationship.new @underlying.createRelationship(from.underlying, to.underlying, DynamicRelationshipType.withName(type), properties)
      end

      def get_node_properties(node, property)
        @underlying.getNodeProperties(node.underlying)[property.to_java_string]
      end

      def set_node_property(node, property, value)
        @underlying.setNodeProperty node.underlying, property.to_java_string, value
      end
    end
  end
end
