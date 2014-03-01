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

    def create_node_with(label, properties, indexing_property=nil)
      Node.new(@db.createNode).tap do |n|
          n.add_label label
          properties.each do |prop, val|
            n[prop] = val
          end
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

    def dsl(&block)
      DSL.new(self).instance_exec(self, &block)
      self
    end

    def transaction
      tx = get_transaction
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

    def begin_tx
      @db.beginTx
    end
  end
end
