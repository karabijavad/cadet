require 'spec_helper'
require 'tmpdir'

describe Cadet::BatchInserter do

  it "should create an instance of cadet session, for test and normal sessions" do
    Cadet::BatchInserter::Session.open(Dir.mktmpdir).class.should == Cadet::BatchInserter::Session
  end

  it "it should also work in batch insert mode" do
    at = Dir.mktmpdir
    Cadet::BatchInserter::Session.open(at) do
      self.class.should == Cadet::BatchInserter::Session

      transaction do
        Person_by_name("Javad").lives_in_to City_by_name("Chicago")
        Person_by_name("Javad").lives_in_to City_by_name("Houston")

        City_by_name("Chicago").city_of_to State_by_name("Illinois")
        City_by_name("Houston").city_of_to State_by_name("Texas")

        Person_by_name("Javad")[:birth_year]   = 1988
        City_by_name("Chicago")[:abbreviation] = "CHI"
        City_by_name("Houston")[:abbreviation] = "HOU"
      end
    end

    Cadet::Session.open(at) do
      transaction do
        Person_by_name("Javad").outgoing(:lives_in).should =~ [City_by_name("Houston"), City_by_name("Chicago")]
        Person_by_name("Javad").outgoing(:lives_in).should =~ [City_by_name("Chicago"), City_by_name("Houston")]

        Person_by_name("Javad").outgoing(:lives_in).outgoing(:city_of).should == [State_by_name("Texas"), State_by_name("Illinois")]
        Person_by_name("Javad").outgoing(:lives_in).outgoing(:city_of).to_a.should =~ [State_by_name("Illinois"), State_by_name("Texas")]

        Person_by_name("Javad")[:birth_year].should     == 1988
        City_by_name("Chicago")[:abbreviation].should == "CHI"
        City_by_name("Houston")[:abbreviation].should == "HOU"
      end
    end
  end

  it "should allow access to the cadet database session singleton object" do
    Cadet::BatchInserter::Session.open(Dir.mktmpdir) do |session|
      Cadet::BatchInserter::Session.current_session.should == session
    end
  end
end
