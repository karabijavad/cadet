module Cadet
  module BatchInserter
    class Relationship < Cadet::Relationship
      attr_accessor :underlying

      def == other_rel
        @underlying == other_rel
      end

      def []= (property, value)
        Cadet::BatchInserter::Session.current_session.db.setRelationshipProperty(@underlying, property.to_java_string, value)
      end

      def [] (property)
        Cadet::BatchInserter::Session.current_session.db.getRelationshipProperties(@underlying)[property]
      end

    end
  end
end
