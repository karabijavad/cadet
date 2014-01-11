require 'java'

Dir["neo4j-lib/*.jar"].each {|file| require file }

require 'cadet/session'
require 'cadet/node'
