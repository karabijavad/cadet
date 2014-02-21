require 'cadet'

def tmp_neo4j
  Dir.mktmpdir do |tmpdir|
    db = Cadet::Session.open(tmpdir)
      db.transaction do
        yield db
      end
    db.close
  end
end