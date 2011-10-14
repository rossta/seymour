require 'spec_helper'

describe Seymour::ActivityFeed do

  let(:owner) { mock("User", :id => 123) }
  let(:feed) { Seymour::ActivityFeed.new(owner) }

  describe "class methods" do
    describe "feed_classes" do
      it "should provide a list of feed sub classes" do
        Seymour::ActivityFeed.feed_classes.should include(EventFeed)
      end
    end

    describe "distribute" do
      it "should push given activity to activities destination feeds" do
        event_feed  = EventFeed.new(mock_model("Event"))
        activity    = mock_model("Activity")

        activity.should_receive(:destination_feeds).and_return([event_feed])
        event_feed.should_receive(:push).with(activity)

        Seymour::ActivityFeed.distribute(activity)
      end
    end
  end

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

  describe "remove" do
    it "removes id from list" do
      activity_1 = mock("Activity", :id => 456)
      activity_2 = mock("Activity", :id => 789)
      feed.push activity_1
      feed.push activity_2

      feed.remove activity_1

      feed.activity_ids.should == [activity_2.id]
    end
  end

  describe "owner" do
    it "should return given owner" do
      feed.owner.should == owner
    end
  end
end
