require 'spec_helper'

describe Seymour::Distributable do

  class DistributableActivity
    include Seymour::Distributable
    audience :users, :admin
    audience :events, :batch_size => 100
    audience :soccer_teams, :feed => "TeamFeed"

    attr_accessor :users, :admin, :soccer_teams, :events
  end

  describe "class methods" do
    describe "audience" do
      it "should list audience names" do
        audience_names = DistributableActivity.audience_names
        audience_names.should include(:users)
        audience_names.should include(:admin)
        audience_names.should include(:soccer_teams)
        audience_names.should include(:events)
      end

      it "should list activity feed classes" do
        feed_class_names = DistributableActivity.feed_class_names
        feed_class_names.should include('UserFeed')
        feed_class_names.should include('AdminFeed')
        feed_class_names.should include('TeamFeed')
        feed_class_names.should include('EventFeed')
      end

    end

    describe "feeding" do
      let(:activity) { DistributableActivity.new }

      before(:each) do
        activity.soccer_teams = []
        activity.events = []
        @user   = mock_model(User)
        @admin  = mock_model(User)
        activity.users = [@user]
        activity.admin = [@admin]
      end

      describe "feeds_for" do
        it "should build feed for each audience member" do
          DistributableActivity.feeds_for(activity).size.should == 2
        end

        it "should assign owner to correct feed type" do
          feed_1, feed_2 = DistributableActivity.feeds_for(activity)
          feed_1.should be_a(UserFeed)
          feed_1.owner.should == @user
          feed_2.should be_a(AdminFeed)
          feed_2.owner.should == @admin
        end

        it "should use default batch size if iterating on arel scope" do
          activity.users = User.scoped
          activity.users.should_receive(:find_each).with(:batch_size => 500)
          DistributableActivity.feeds_for(activity)
        end

        it "should use specified batch size if iterating on arel scope" do
          activity.events = Event.scoped
          activity.events.should_receive(:find_each).with(:batch_size => 100)
          DistributableActivity.feeds_for(activity)
        end
      end

      describe "distribute" do
        it "should push activity to each feed" do
          feed = UserFeed.new(mock_model(User))
          DistributableActivity.stub!(:tap_feeds_for).with(activity).and_yield(feed)
          feed.should_receive(:push).with(activity)
          DistributableActivity.distribute(activity)
        end
      end
    end

  end

  describe "instance methods" do
    describe "distribute" do
      it "should push itself to audience feeds" do
        activity = DistributableActivity.new
        feed = UserFeed.new(mock_model(User))
        DistributableActivity.stub!(:tap_feeds_for).with(activity).and_yield(feed)
        feed.should_receive(:push).with(activity)
        activity.distribute
      end
    end
  end
end
