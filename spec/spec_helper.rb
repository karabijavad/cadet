require 'cadet'

def quick_neo4j
  test_neo4j do |db|
    db.transaction do |tx|
      yield db, tx
    end
  end
end

def test_neo4j
  db = Cadet::Test::Session.open
  yield db
  db.close
end