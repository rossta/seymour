require 'spec_helper'

describe Seymour::ActivityFeed do

  let(:owner) { mock("User", :id => 123) }
  let(:feed) { Seymour::ActivityFeed.new(owner) }

  describe "activity_ids" do
    it "should return an empty list initially" do
      feed.activity_ids.should == []
    end
  end

  describe "push" do
    it "adds id of given activity to activity_ids" do
      feed.push mock("Activity", :id => 456)
      feed.activity_ids.should == [456]
    end
  end
  
  describe "owner" do
    it "should return given owner" do
      feed.owner.should == owner
    end
  end
end
