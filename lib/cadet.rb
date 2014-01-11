require 'java'

Dir["../../neo4j-lib/*.jar"].each {|file| require file }

require_relative './cadet/session'
require_relative './cadet/node'

#db = Cadet::Session.open("/tmp/db")
#Cadet::Node.create(db)
#Cadet::Session.close(db)
