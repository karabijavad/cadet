require 'java'

Dir["./neo4j-lib/*.jar"].each {|file| puts file; require file }

require 'cadet/session'
require 'cadet/node'
