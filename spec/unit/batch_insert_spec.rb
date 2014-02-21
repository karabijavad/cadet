require 'spec_helper'
require 'tmpdir'

describe Cadet::BatchInserter do

  it "should work" do
    Dir.mktmpdir do |tmpdir|
      db = Cadet::BatchInserter::Session.open(tmpdir)
      db.transaction do
        javad = db.get_node :Person, :name, "Javad"
        ellen = db.get_node :Person, :name, "Ellen"

        javad.outgoing(:knows) << ellen
      end
      db.close

      db = Cadet::Session.open(tmpdir)
      db.transaction do
        javad = db.get_node :Person, :name, "Javad"
        ellen = db.get_node :Person, :name, "Ellen"

        javad.outgoing(:knows).to_a.should == [ellen]
      end
      db.close
    end
  end

end
