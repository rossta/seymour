require 'spec_helper'

describe Seymour::Distributable do

  class DistributableActivity
    include Seymour::Distributable
    audience :users, :admin
    audience :events,       :batch_size => 100
    audience :soccer_teams, :feed => "TeamFeed"
    audience :followers,    :feed => %w[ DashboardFeed EmailDigest ]

    AUDIENCES = [:users, :admin, :soccer_teams, :events, :followers]

    AUDIENCES.each do |audience_name|
      attr_writer audience_name

      define_method(audience_name) do
        instance_variable_get("@#{audience_name}") || []
      end
    end
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

      it "should support multiple feeds for an audience" do
        DistributableActivity.audience_names.should include(:followers)
        DistributableActivity.feed_class_names.should include("DashboardFeed")
        DistributableActivity.feed_class_names.should include("EmailDigest")
      end

    end

    describe "feeding" do
      let(:activity) { DistributableActivity.new }

      before(:each) do
        @user   = mock_model(User)
        @admin  = mock_model(User)
        activity.users = [@user]
        activity.admin = [@admin]
      end

      describe "feeds_for" do
        it "should build feed for each audience member" do
          DistributableActivity.feeds_for(activity).size.should == 2
        end

        it "should return all assigned feed types" do
          feed_classes = DistributableActivity.feeds_for(activity).map(&:class)
          feed_classes.should include(UserFeed)
          feed_classes.should include(AdminFeed)
        end

        it "should assign owners to correct feed type" do
          feeds = DistributableActivity.feeds_for(activity)
          user_feed   = feeds.detect { |feed| feed.is_a?(UserFeed) }
          admin_feed  = feeds.detect { |feed| feed.is_a?(AdminFeed) }

          user_feed.owner.should  == @user
          admin_feed.owner.should == @admin
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
    end

    describe "actions on activity" do
      let(:activity) { DistributableActivity.new }
      let(:feed) { UserFeed.new(mock_model(User)) }

      before(:each) do
        DistributableActivity.stub!(:tap_feeds_for).with(activity).and_yield(feed)
      end

      describe "distribute" do
        it "should push activity to each feed" do
          feed.should_receive(:push).with(activity)
          DistributableActivity.distribute(activity)
        end
      end

      describe "remove" do
        it "should remove activity from each feed" do
          feed.should_receive(:remove).with(activity)
          DistributableActivity.remove(activity)
        end
      end
    end
  end

  describe "instance methods" do
    let(:activity) { DistributableActivity.new }
    let(:feed) { UserFeed.new(mock_model(User)) }

    before(:each) do
      DistributableActivity.stub!(:tap_feeds_for).with(activity).and_yield(feed)
    end

    describe "distribute" do
      it "should push itself to audience feeds" do
        feed.should_receive(:push).with(activity)
        activity.distribute
      end
    end

    describe "remove" do
      it "should remove itself from audience feeds" do
        feed.should_receive(:remove).with(activity)
        activity.remove
      end
    end
  end
end
