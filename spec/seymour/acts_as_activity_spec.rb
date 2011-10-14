require 'spec_helper'

describe Seymour::ActsAsActivity do

  describe "class methods" do
    describe "feed_classes" do

      it "should return empty array if none specified" do
        IgnoredActivity.feed_classes.should be_empty
      end

      it "should return specified feed classes" do
        EventActivity.feed_classes.should include(EventFeed)
      end

      it "should allow class_name of feed to be specified" do
        EventActivity.feed_classes.should include(PlayerFeed)
      end

    end
  end

  describe "distribute" do
    it "should push activity to feed_classes" do
      feed      = mock(EventFeed)
      activity  = EventActivity.create!

      EventFeed.should_receive(:new).and_return(feed)
      feed.should_receive(:push).with(activity)
      activity.distribute
    end
  end

end
