require 'cadet'
require 'tmpdir'

def quick_test_neo4j
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

def quick_normal_neo4j(at = nil)
  at ||= Dir.mktmpdir

  normal_neo4j(at) do |db|
    db.transaction do
      yield db
    end
  end
  at
end

def normal_neo4j(at)
  db = Cadet::Session.open(at)
  yield db
  db.close
end

def quick_batch_neo4j(at = nil)
  at ||= Dir.mktmpdir

  batch_neo4j(at) do |db|
    yield db
  end
  at
end

def batch_neo4j(at)
  db = Cadet::BatchInserter::Session.open(at)
  yield db
  db.close
end
