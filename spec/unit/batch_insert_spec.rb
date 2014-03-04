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

        javad.lives_in_to chicago
        javad.lives_in_to houston
      end
    end

    Cadet::Session.open(at) do
      self.class.should == Cadet::Session

      transaction do
        # the order matters here, unfortunately.
        # TODO: find a way for [chicago, houston] to also work
        Person_by_name("Javad").outgoing(:lives_in).should == [City_by_name("Houston"), City_by_name("Chicago")]
      end
    end
  end
end
