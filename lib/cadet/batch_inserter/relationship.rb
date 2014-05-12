module Cadet
  module BatchInserter
    class Relationship < Cadet::Relationship
      include Cadet::PropertyContainer

      def == other_rel
        @underlying == other_rel
      end

      def set_property (property, value)
        Cadet::BatchInserter::Session.current_session.set_relationship_property(self, property, value)
      end

      def get_property (property)
        Cadet::BatchInserter::Session.current_session.get_relationship_properties(self)[property]
      end

    end
  end
end
