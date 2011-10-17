require 'spec_helper'

describe Seymour::Distributable do

  class DistributableActivity
    include Seymour::Distributable
    audience :users, :admin
    audience :soccer_teams, :feed => "TeamFeed"

    attr_accessor :users, :admin, :soccer_teams
  end

  describe "class methods" do
    describe "audience" do
      it "should list audience names" do
        audience_names = DistributableActivity.audience_names
        audience_names.should include(:users)
        audience_names.should include(:admin)
        audience_names.should include(:soccer_teams)
      end

      it "should list activity feed classes" do
        feed_class_names = DistributableActivity.feed_class_names
        feed_class_names.should include('UserFeed')
        feed_class_names.should include('AdminFeed')
        feed_class_names.should include('TeamFeed')
      end
    end

    describe "feeds_for" do
      let(:activity) { DistributableActivity.new }

      before(:each) do
        activity.soccer_teams = []
        @user   = mock_model(User)
        @admin  = mock_model(User)
        activity.users = [@user]
        activity.admin = [@admin]
      end

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
    end
  end

  describe "instance methods" do
    describe "distribute" do
      it "should push itself to audience feeds" do
        activity = DistributableActivity.new
        feed = UserFeed.new(mock_model(User))
        DistributableActivity.stub!(:feeds_for).with(activity).and_return([feed])
        feed.should_receive(:push).with(activity)
        activity.distribute
      end
    end
  end
end
