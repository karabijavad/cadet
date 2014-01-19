module Cadet
  class Session
    include_package "org.neo4j.graphdb"
    include_package "org.neo4j.graphdb.factory"

    def initialize(db)
      @db = db
    end

    def self.open(location)
      new GraphDatabaseFactory.new.newEmbeddedDatabase(location)
    end
    def close
      @db.shutdown
    end

    def create_empty_node
      Cadet::Node.new @db.createNode
    end

    def create_node_with(label, props)
      n = Cadet::Node.new @db.createNode
      n.add_label label
      n.set_properties props
      n
    end

    def get_node_by_id(id)
      Cadet::Node.new @db.getNodeById(id)
    end

    def find_nodes_by_label_and_property(label, key, value)
      result = []
      #findNodesByLabelAndProperty
      #Returns all nodes having the label, and the wanted property value.
      @db.findNodesByLabelAndProperty(DynamicLabel.label(label), key, value).each do |node|
        result << Cadet::Node.new(node)
      end
      result
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
        .constraintFor DynamicLabel.label(label)
        .assertPropertyIsUnique property
        .create
    end

    def method_missing(name, *args)
      if match = /create_([A-Z][A-Za-z]*)$/.match(name.to_s)
        return create_node_with match.captures.first, args[0]
      end
      if match = /get_a_([A-Z][A-Za-z]*)$/.match(name.to_s)
        return get_a_node match.captures.first, args[0], args[1]
      end
    end

    def get_a_node(label, property, value)
      n = find_nodes_by_label_and_property(label, property, value).first
      if n.nil?
        h = {}
        h[property] = value
        n = create_node_with label, h
      end
      n
    end

    def traverser
      Cadet::Traversal::Description.new @db.traversalDescription
    end

  end
end
