require 'spec_helper'

describe Seymour::ActsAsActivity do

  describe "destination_feeds" do

    it "should return empty array if none specified" do
      IgnoredActivity.destination_feeds.should be_empty
    end

    it "should return specified feed classes" do
      EventActivity.destination_feeds.should include(EventFeed)
    end
    
    it "should allow class_name of feed to be specified" do
      
    end

  end

end
