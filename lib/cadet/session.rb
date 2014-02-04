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
      n = Node.new @db.createNode
      n.add_label label
      n[property] = value
      n
    end

    def find_node(label, property, value)
      node = IteratorUtil.firstOrNull @db.findNodesByLabelAndProperty(DynamicLabel.label(label), property, value)
      node ? Node.new(node) : null
    end

    def get_node(label, property, value)
      create_node(label, property, value) unless find_node(label, property, value)
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
        .create
    end

    def method_missing(name, *args)
      if match = /^get_a_([A-Z][A-Za-z]*)_by_([A-z]*)/.match(name)
        return get_node match.captures[0], match.captures[1], args[0]
      end
    end

  end
end
