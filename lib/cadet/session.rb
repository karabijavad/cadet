module Cadet
  class Session
    def initialize(db)
      @db = db
    end

    def self.current_session
      @@current_session
    end

    def self.open(location = nil, &block)
      (location ?
        new(org.neo4j.graphdb.factory.GraphDatabaseFactory.new.newEmbeddedDatabase(location)) :
        new(org.neo4j.test.TestGraphDatabaseFactory.new.newImpermanentDatabase))
      .tap do |session|
        @@current_session = session
        if block_given?
          session.instance_exec(session, &block)
          session.close
        end
      end
    end

    def close
      @db.shutdown
    end

    def create_node(label, properties, indexing_property = nil)
      Node.new(@db.createNode).tap do |n|
        n.add_label label
        properties.each { |prop, val| n[prop] = val }
      end
    end

    def find_node(label, property, value)
      ( node = org.neo4j.helpers.collection.IteratorUtil.firstOrNull(@db.findNodesByLabelAndProperty(DynamicLabel.label(label), property, value)) ) ?
        Node.new(node) : nil
    end

    def get_node(label, property, value)
      find_node(label, property, value) || create_node(label, {property.to_sym => value})
    end

    def get_transaction
      Transaction.new(self)
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

    def method_missing(name, *args, &block)
      case name
        when /^([A-z_]*)_by_([A-z_]*)$/
            self.class.class_eval "
              def #{name}(value)
                get_node :#{$1}, :#{$2}, value
              end"
            return self.send(name, *args, &block)

        when /^create_([A-z_]*)$/
          self.class.class_eval "
            def #{name}(value)
              create_node :#{$1}, value
            end"
          return self.send(name, *args, &block)
        else
          raise NotImplementedError
      end
    end

  end
end
