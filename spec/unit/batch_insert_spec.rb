require 'spec_helper'
require 'tmpdir'

describe Cadet::BatchInserter do

  it "should set a nodes property" do
    tmpdir = quick_batch_neo4j do |db|
      javad = db.get_node(:Person, :name, "Javad")
      javad[:age] = 25
    end

    quick_normal_neo4j(tmpdir) do |db|
      javad = db.get_node(:Person, :name, "Javad")
      javad[:age].should == 25
    end
  end

  it "should create a relationship" do
    tmpdir = quick_batch_neo4j do |db|
      javad = db.get_node(:Person, :name, "Javad")
      ellen = db.get_node(:Person, :name, "Ellen")

      javad.outgoing(:knows) << ellen
    end

    quick_normal_neo4j(tmpdir) do |db|
      javad = db.get_node(:Person, :name, "Javad")
      ellen = db.get_node(:Person, :name, "Ellen")

      javad.outgoing(:knows).to_a.should == [ellen]
    end
  end

  it "should create a node with a set of properties, and index that node on a specified property" do
    tmpdir = quick_batch_neo4j do |db|
      javad = db.create_node_with(:Person, {name: "Javad", age: 25}, :name)
    end

    quick_normal_neo4j(tmpdir) do |db|
      javad = db.get_node(:Person, :name, "Javad")

      javad[:name].should == "Javad"
      javad[:age].should == 25
    end
  end

  it "should retrieve the same node, for the same label-key-value" do
    tmpdir = quick_batch_neo4j do |db|
      javad = db.get_node(:Person, :name, "Javad")
      ellen = db.get_node(:Person, :name, "Ellen")

      javad.outgoing(:lives_in) << db.get_node(:City, :name, "Chicago")
      ellen.outgoing(:lives_in) << db.get_node(:City, :name, "Chicago")
    end

    quick_normal_neo4j(tmpdir) do |db|
      javad = db.get_node(:Person, :name, "Javad")
      ellen = db.get_node(:Person, :name, "Ellen")

      javad.outgoing(:lives_in).to_a.should == ellen.outgoing(:lives_in).to_a
    end
  end
end
