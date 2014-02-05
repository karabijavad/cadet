require 'java'

[
"concurrentlinkedhashmap-lru-1.3.1.jar",
"lucene-core-3.6.2.jar",
"neo4j-graph-algo-2.0.0.jar",
"neo4j-graph-matching-2.0.0.jar",
"neo4j-kernel-2.0.0.jar",
"neo4j-lucene-index-2.0.0.jar",
"neo4j-shell-2.0.0.jar"
].each { |file| require "neo4j/#{file}" }

require 'cadet/session'
require 'cadet/property_container'
require 'cadet/node'
require 'cadet/relationship_traverser'
require 'cadet/batch_inserter/batch_inserter'
require 'cadet/batch_inserter/node'
require 'cadet/cadet_index/index_provider'
require 'cadet/cadet_index/index'
require 'cadet/dynamic_relationshiptype'
require 'cadet/dynamic_label'