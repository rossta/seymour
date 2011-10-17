require 'spec_helper'

describe Seymour::ActsAsActivity do

  describe "TestActivity in dummy app" do
    let(:activity)  { Factory(:test_activity) }
    let(:user)      { activity.actor }

    describe "render_html" do
      it "should render activity html" do
        activity.render_html.should == "<p>Bob tested an activity</p>"
      end
    end

    describe "distribute" do
      it "should push activity to audiences" do
        feed = mock(UserFeed)
        TestActivity.stub!(:feeds_for).and_return([feed])
        feed.should_receive(:push).with(activity)
        activity.distribute
      end
    end

    describe "feeds" do
      before(:each) do
        activity.stub!(:authors).and_return([])
        activity.stub!(:events).and_return([])
      end

      it "should create event feed for each event" do
        event = mock_model(Event)
        activity.should_receive(:events).and_return [event]
        event_feed = mock(EventFeed)
        EventFeed.should_receive(:new).with(event).and_return(event_feed)
        activity.feeds.should include(event_feed)
      end

      it "should create user feed for each author" do
        user_1 = mock_model(User)
        user_2 = mock_model(User)
        activity.should_receive(:authors).and_return [user_1, user_2]
        user_feed_1 = mock(UserFeed)
        user_feed_2 = mock(UserFeed)
        UserFeed.should_receive(:new).ordered.with(user_1).and_return(user_feed_1)
        UserFeed.should_receive(:new).ordered.with(user_2).and_return(user_feed_2)

        feeds = activity.feeds
        feeds.should include(user_feed_1)
        feeds.should include(user_feed_2)
      end
    end

    describe "class methods" do
      describe "audience" do
        it "should add events and authors audience names" do
          TestActivity.audience_names.should include(:events)
          TestActivity.audience_names.should include(:authors)
        end

        it "should set up feed class names" do
          TestActivity.feed_class_names.should include("UserFeed")
          TestActivity.feed_class_names.should include("EventFeed")
        end
      end
    end
  end
end
