module JavaIO
  include_package "java.io"
end

module Cadet
  class Session
    @@current_session = nil

    def self.current_session
      @@current_session
    end

    def initialize(underlying)
      @underlying = underlying
    end

    def self.open(location = nil, &block)
      if location
        location = JavaIO::File.new(location)
      end
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
      @underlying.shutdown
    end

    def create_node(label, properties, indexing_property = nil)
      Node.new(@underlying.createNode).tap do |n|
        n.add_label label
        properties.each do |prop, val|
          val = val.to_java_string if val.is_a? Symbol
          n[prop] = val
        end
      end
    end

    def find_node(label, property, value)
      label = DynamicLabel.label(label)
      found = @underlying.findNode(label, property.to_s, value)
      if found
        return Node.new(found)
      else
        return nil
      end
      # xxx = @underlying.findNodes(label, property.to_s, value)
      #
      # if org.neo4j.helpers.ArrayUtil.isEmpty(xxx)
      #   return Nil
      # else
      #   return Node.new(xxx[0])
      # end
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
        result = yield(tx)
        tx.success
      ensure
        tx.close
      end
      result
    end

    def constraint(label, property)
      @underlying.schema
        .constraintFor(DynamicLabel.label(label))
        .assertPropertyIsUnique(property)
        .create()
    end

    def begin_tx
      @underlying.beginTx
    end

    def index(label, property)
      #create index
      @underlying.schema
        .indexFor( DynamicLabel.label( label ) )
        .on( property )
        .create()
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
            def #{name}(value = {})
              create_node :#{$1}, value
            end"
          return self.send(name, *args, &block)
      end
    end

  end
end
