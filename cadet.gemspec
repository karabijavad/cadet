# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "cadet/version"

Gem::Specification.new do |s|
  s.name        = "cadet"
  s.version     = Cadet::VERSION
  s.platform    = "java"
  s.authors     = "Javad Karabi"
  s.email       = "karabijavad@gmail.com"
  s.homepage    = "https://github.com/karabijavad/cadet"
  s.summary     = "ruby wrapper to Neo4j java API"
  s.description = "ruby wrapper to Neo4j java API"
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib", "neo4j-lib"]

end
