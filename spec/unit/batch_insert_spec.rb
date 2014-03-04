require 'spec_helper'
require 'tmpdir'

describe Cadet::BatchInserter do

  it "should create an instance of cadet session, for test and normal sessions" do
    Cadet::BatchInserter::Session.open(Dir.mktmpdir).class.should == Cadet::BatchInserter::Session
  end

  it "it should accept multiple relationships" do
    at = Dir.mktmpdir
    Cadet::BatchInserter::Session.open(at) do
      self.class.should == Cadet::BatchInserter::Session

      transaction do
        javad   = Person_by_name("Javad")
        chicago = City_by_name("Chicago")
        houston = City_by_name("Houston")

        javad.outgoing(:lives_in) << chicago
        javad.outgoing(:lives_in) << houston
      end
    end

    Cadet::Session.open(at) do
      self.class.should == Cadet::Session

      transaction do
        javad   = Person_by_name("Javad")
        houston = City_by_name("Houston")
        chicago = City_by_name("Chicago")

        # the order matters here, unfortunately.
        # TODO: find a way for [chicago, houston] to also work
        javad.outgoing(:lives_in).should == [houston, chicago]
      end
    end
  end
end
