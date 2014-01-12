require 'java'

Dir["neo4j/*.jar"].each {|file| require file }

require 'cadet/session'
require 'cadet/node'
