require 'java'

["concurrentlinkedhashmap-lru-1.3.1.jar",
"geronimo-jta_1.1_spec-1.1.1.jar",
"lucene-core-3.6.2.jar",
"neo4j-cypher-2.0.0.jar",
"neo4j-cypher-commons-2.0.0.jar",
"neo4j-cypher-compiler-1.9-2.0.0.jar",
"neo4j-cypher-compiler-2.0-2.0.0.jar",
"neo4j-graph-algo-2.0.0.jar",
"neo4j-graph-matching-2.0.0.jar",
"neo4j-jmx-2.0.0.jar",
"neo4j-kernel-2.0.0.jar",
"neo4j-lucene-index-2.0.0.jar",
"neo4j-shell-2.0.0.jar",
"neo4j-udc-2.0.0.jar",
"org.apache.servicemix.bundles.jline-0.9.94_1.jar",
"parboiled-core-1.1.6.jar",
"parboiled-scala_2.10-1.1.6.jar",
"scala-library-2.10.3.jar",
"server-api-2.0.0.jar"].each { |file| require "neo4j/#{file}" }

require 'cadet/session'
require 'cadet/node'
require 'cadet/traversal/description'
require 'cadet/traversal/evaluator'
require 'cadet/traversal/path'
require 'cadet/batch_inserter/batch_inserter'
require 'cadet/batch_inserter/node'
require 'cadet/index_provider/index_provider'
