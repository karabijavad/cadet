require 'cadet'

def quick_neo4j
  db = Cadet::Test::Session.open
    db.transaction do |tx|
      yield db, tx
    end
  db.close
end
