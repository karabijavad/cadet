require 'java'

Dir["../neo4j-lib/*.jar"].each {|file| require file }

require 'session/session'
require 'node/node'

db = Cadet::Session.open("/tmp/db")
Cadet::Node.create(db)
Cadet::Session.close(db)
