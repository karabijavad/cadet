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
        n.add_label label.to_s
        n[property.to_s] = value
      end
    end

    def find_node(label, property, value)
      node = IteratorUtil.firstOrNull @db.findNodesByLabelAndProperty(DynamicLabel.label(label), property, value)
      node ? Node.new(node) : null
    end

    def get_node(label, property, value)
      label    = label.to_s
      property = property.to_s

      n = find_node(label, property, value)
      if n.nil?
        return create_node(label, property, value)
      else
        return n
      end
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
        .constraintFor(DynamicLabel.label(label.to_s))
        .assertPropertyIsUnique(property.to_s)
        .create()
    end

    def method_missing(name, *args)
      if match = /^get_a_([A-Z][A-Za-z]*)_by_([A-z]*)/.match(name)
        return get_node match.captures[0], match.captures[1], args[0]
      end
    end

  end
end
