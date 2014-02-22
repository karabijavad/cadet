require 'spec_helper'
require 'tmpdir'

describe Cadet::BatchInserter do

  it "should work" do
    tmpdir = quick_batch_neo4j do |db|
      javad     = db.get_node(:Person, :name, "Javad")
      ellen     = db.get_node(:Person, :name, "Ellen")
      javad[:age] = 25

      javad.outgoing(:lives_in) << db.get_node(:City, :name, "Chicago")
      ellen.outgoing(:lives_in) << db.get_node(:City, :name, "Chicago")
    end

    quick_normal_neo4j(tmpdir) do |db|
      javad     = db.get_node(:Person, :name, "Javad")
      ellen     = db.get_node(:Person, :name, "Ellen")

      javad.outgoing(:lives_in).to_a.should == ellen.outgoing(:lives_in).to_a
      javad[:age].should == 25
    end

  end
end
