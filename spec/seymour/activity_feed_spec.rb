require 'spec_helper'

describe Seymour::ActivityFeed do

  let(:owner) { mock("User", :id => 123) }
  let(:feed) { Seymour::ActivityFeed.new(owner) }

  describe "feed_classes" do

    class Seymour::EventFeed < Seymour::ActivityFeed
    end

    it "should provide a list of feed sub classes" do
      Seymour::ActivityFeed.feed_classes.should == [Seymour::EventFeed]
    end

    after(:each) do
      Seymour::ActivityFeed.reset_classes!
    end
  end

  describe "#activity_ids" do
    it "should return an empty list initially" do
      feed.activity_ids.should == []
    end
  end

  describe "#push" do
    it "adds id of given activity to activity_ids" do
      feed.push mock("Activity", :id => 456)
      feed.activity_ids.should == [456]
    end
  end

  describe "#owner" do
    it "should return given owner" do
      feed.owner.should == owner
    end
  end
end
