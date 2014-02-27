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

    def transaction
      tx = @db.beginTx
      begin
        yield tx
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
      if match = /^get_a_([A-z]*)_by_([A-z]*)/.match(name)
        self.instance_eval "
          def #{name}(value)
            get_node :#{match.captures[0]}, :#{match.captures[1]}, value
          end
        "
        self.send(name, *args)
      end
    end

  end
end
