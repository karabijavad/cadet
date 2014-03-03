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

      javad.outgoing(:knows).should == [ellen]
    end
  end

  it "should create a node with a set of properties, and index that node on a specified property" do
    tmpdir = quick_batch_neo4j do |db|
      javad = db.create_node(:Person, {name: "Javad", age: 25})
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

      javad.outgoing(:lives_in).should == ellen.outgoing(:lives_in)
    end
  end

  it "should work" do
    tmpdir = quick_batch_neo4j do |db|
      javad       = db.get_node :Person,  :name, "Javad"
      ellen       = db.get_node :Person,  :name, "Ellen"
      trunkclub   = db.get_node :Company, :name, "Trunkclub"
      chicago     = db.get_node :City,    :name, "Chicago"
      us          = db.get_node :Country, :name, "United States"

      javad.outgoing(:works_at) << trunkclub
      trunkclub.outgoing(:located_in) << chicago
      ellen.outgoing(:lives_in) << chicago
      chicago.outgoing(:country) << us
    end

    quick_normal_neo4j(tmpdir) do |db|
      javad       = db.get_node :Person,  :name, "Javad"
      ellen       = db.get_node :Person,  :name, "Ellen"
      trunkclub   = db.get_node :Company, :name, "Trunkclub"
      chicago     = db.get_node :City,    :name, "Chicago"
      us          = db.get_node :Country, :name, "United States"

      javad.outgoing(:works_at).should == [trunkclub]
    end

  end

  it "should work" do
    tmpdir = quick_batch_neo4j do |db|
      javad       = db.get_node :Person,  :name, "Javad"
      ellen       = db.get_node :Person,  :name, "Ellen"
      trunkclub   = db.get_node :Company, :name, "Trunkclub"
      chicago     = db.get_node :City,    :name, "Chicago"
      us          = db.get_node :Country, :name, "United States"

      javad.outgoing(:lives_in) << chicago
      ellen.outgoing(:lives_in) << chicago
    end

    quick_normal_neo4j(tmpdir) do |db|
      javad       = db.get_node :Person,  :name, "Javad"
      ellen       = db.get_node :Person,  :name, "Ellen"
      trunkclub   = db.get_node :Company, :name, "Trunkclub"
      chicago     = db.get_node :City,    :name, "Chicago"
      us          = db.get_node :Country, :name, "United States"

      javad.outgoing(:lives_in).should == [chicago]
      ellen.outgoing(:lives_in).should == [chicago]
    end
  end

  it "should not allow for get_relationships" do
    tmpdir = quick_batch_neo4j do |db|
      javad       = db.get_node :Person,  :name, "Javad"
      ellen       = db.get_node :Person,  :name, "Ellen"
      trunkclub   = db.get_node :Company, :name, "Trunkclub"
      chicago     = db.get_node :City,    :name, "Chicago"
      us          = db.get_node :Country, :name, "United States"

      javad.outgoing(:lives_in) << chicago
      chicago.outgoing(:country) << us

      expect {javad.outgoing(:lives_in).outgoing(:country)}.to raise_error(NotImplementedError)
    end
  end

  xit "should not allow for get_relationships" do
    quick_batch_dsl_neo4j do
      transaction do
        Person_by_name("Javad").lives_in_to City_by_name("Chicago")

        Person_by_name("Javad").outgoing(:lives_in).should == [City_by_name("Chicago")]
      end
    end
  end


end
