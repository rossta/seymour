require 'spec_helper'

describe "TestActivity" do

  describe "TestActivity in dummy app" do
    let(:activity)  { FactoryGirl.create(:test_activity) }
    let(:user)      { activity.actor }

    describe "render_html" do
      it "should render activity html" do
        activity.render_html.should == "<p>Bob tested an activity</p>"
      end
    end

    describe "distribute" do
      it "should push activity to audiences" do
        activity.distribute
        UserFeed.new(activity.actor).activity_ids.should == [activity.id]
      end
    end

    describe "feeds" do
      before(:each) do
        activity.stub!(:users).and_return([])
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
        activity.should_receive(:users).and_return [user_1, user_2]
        user_feed_1 = mock(UserFeed)
        user_feed_2 = mock(UserFeed)
        UserFeed.should_receive(:new).ordered.with(user_1).and_return(user_feed_1)
        UserFeed.should_receive(:new).ordered.with(user_2).and_return(user_feed_2)

        feeds = activity.feeds
        feeds.should include(user_feed_1)
        feeds.should include(user_feed_2)
      end
    end
  end
end
