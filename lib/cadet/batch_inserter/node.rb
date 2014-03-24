module Cadet
  module BatchInserter
    class Node < Cadet::Node

      def create_outgoing(to, type, properties = {})
        Cadet::BatchInserter::Session.current_session.create_relationship(self, to, type, properties)
      end

      def []= (property, value)
        Cadet::BatchInserter::Session.current_session.set_node_property self, property, value
      end

      def [] (property)
        Cadet::BatchInserter::Session.current_session.get_node_properties(self, property)
      end

      def == other_node
        @underlying == other_node
      end

      def outgoing(type)
        NodeTraverser.new(self, :outgoing, type)
      end

      def each_relationship(direction, type)
        # not implemented in batch inserter mode. though, it could be done.
        # the assumption is that this shouldnt be necessary, as batch inserter mode
        # should be about inserting data, not querying data
        raise NotImplementedError
      end

    end
  end
end
