module Cadet
  module BatchInserter
    class Relationship < Cadet::Relationship
      attr_accessor :underlying

      def == other_rel
        @underlying == other_rel
      end

      def []= (property, value)
        Cadet::BatchInserter::Session.current_session.set_relationship_property(self, property, value)
      end

      def [] (property)
        Cadet::BatchInserter::Session.current_session.get_relationship_properties(self)[property]
      end

    end
  end
end
