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
      n.set_property property, value
      n
    end

    def find_node(label, key, value)
      node = IteratorUtil.firstOrNull @db.findNodesByLabelAndProperty(DynamicLabel.label(label), key, value)
      node ? Node.new(node) : null
    end

    def goc_node(label, property, value)
      n = find_node label, property, value
      if n.nil?
        n = create_node label, property, value
        n[property] = value
      end
      n
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
      if match = /^get_a_([A-Z][A-Za-z]*)_by_([A-z]*)/.match(name.to_s)
        return goc_node match.captures[0], match.captures[1], args[0]
      end
    end

  end
end
