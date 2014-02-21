require 'spec_helper'
require 'tmpdir'

describe Cadet::BatchInserter do

  it "should work" do
    Dir.mktmpdir do |tmpdir|
      db = Cadet::BatchInserter::Session.open(tmpdir)
      db.transaction do
        javad     = db.get_a_Person_by_name "Javad"
        ellen     = db.get_a_Person_by_name "Ellen"

        javad.outgoing(:lives_in) << db.get_a_City_by_name("Chicago")
        ellen.outgoing(:lives_in) << db.get_a_City_by_name("Chicago")
      end
      db.close

      db = Cadet::Session.open(tmpdir)
      db.transaction do
        javad     = db.get_a_Person_by_name "Javad"
        ellen     = db.get_a_Person_by_name "Ellen"

        javad.outgoing(:lives_in).to_a.should == ellen.outgoing(:lives_in).to_a
      end
      db.close
    end
  end
end
