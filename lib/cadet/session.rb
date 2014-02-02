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

    def create_node_with(label, props = {})
      n = Cadet::Node.new @db.createNode
      n.add_label label
      n.set_properties props
      n
    end

    def find_node_by_label_and_property(label, key, value)
      node = IteratorUtil.firstOrNull @db.findNodesByLabelAndProperty(DynamicLabel.label(label), key, value)
      node ? Cadet::Node.new(node) : null
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
      if match = /get_a_([A-Z][A-Za-z]*)$/.match(name.to_s)
        return get_a_node match.captures.first, args[0], args[1]
      end
    end

    def get_a_node(label, property, value, default_values = {})
      n = find_node_by_label_and_property(label, property, value)
      if n.nil?
        h = {}
        h[property] = value
        n = create_node_with label, h.merge(default_values)
      end
      n
    end

  end
end
