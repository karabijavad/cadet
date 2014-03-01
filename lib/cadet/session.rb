module Cadet
  class Session
    include_package "org.neo4j.graphdb"
    include_package "org.neo4j.graphdb.factory"
    include_package "org.neo4j.unsafe.batchinsert"
    include_package "org.neo4j.helpers.collection"

    def initialize(db)
      @db = db
    end

    def self.open(location)
      new GraphDatabaseFactory.new.newEmbeddedDatabase(location)
    end
    def close
      @db.shutdown
    end

    def create_node(label, property, value)
      Node.new(@db.createNode).tap do |n|
        n.add_label label
        n[property] = value
      end
    end

    def find_node(label, property, value)
      ( node = IteratorUtil.firstOrNull(@db.findNodesByLabelAndProperty(DynamicLabel.label(label), property, value)) ) ?
        Node.new(node) : nil
    end

    def get_node(label, property, value)
      find_node(label, property, value) || create_node(label, property, value)
    end

    def get_transaction
      Transaction.new(self)
    end

    def transaction(&block)
      tx = get_transaction
      begin
        tx.instance_eval &block
        tx.success
      ensure
        tx.close
      end
    end

    def constraint(label, property)
      @db.schema
        .constraintFor(DynamicLabel.label(label))
        .assertPropertyIsUnique(property)
        .create()
    end

    def method_missing(name, *args)
      if match = /^(get_a_)?([A-z_]*)_by_([A-z_]*)/.match(name)
        self.class.class_eval "
          def #{name}(value)
            get_node :#{match.captures[1]}, :#{match.captures[2]}, value
          end
        "
        return self.send(name, *args)
      elsif match = /^create_([A-z_]*)_on_([A-z_]*)/.match(name)
        self.class.class_eval "
          def #{name}(value)
            create_node_with :#{match.captures[0]}, value, :#{match.captures[1]}
          end
        "
        return self.send(name, *args)
      end

    end

    def begin_tx
      @db.beginTx
    end
  end
end
