require 'spec_helper'

describe Seymour::ActivityFeed do

  let(:owner) { mock_model(User) }
  let(:feed)  { Seymour::ActivityFeed.new(owner) }

  describe "class methods" do
    describe "feed_classes" do
      it "should provide a list of feed sub classes" do
        Seymour::ActivityFeed.feed_classes.should include(EventFeed)
      end
    end

    describe "distribute" do
      it "should call activity distribute on activity" do
        activity    = mock_model(Activity)
        activity.should_receive(:distribute)
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
    it "prepends id of given activity to activity_ids" do
      feed.push mock_model(Activity, :id => 123)
      feed.activity_ids.should == [123]

      feed.push mock_model(Activity, :id => 456)
      feed.activity_ids.should == [456, 123]
    end

    it "new feed with same owner pushes to same list" do
      new_feed = Seymour::ActivityFeed.new(owner)

      feed.push mock_model(Activity, :id => 123)
      new_feed.push mock_model(Activity, :id => 456)

      feed.activity_ids.should == [456, 123]
      new_feed.activity_ids.should == [456, 123]
    end

    it "new feed with different owner pushes to different list" do
      new_owner = mock_model(User)
      new_feed = Seymour::ActivityFeed.new(new_owner)

      feed.push mock_model(Activity, :id => 123)
      new_feed.push mock_model(Activity, :id => 456)

      feed.activity_ids.should == [123]
      new_feed.activity_ids.should == [456]
    end
  end

  describe "remove" do
    it "removes activity from list by id" do
      activity_1 = mock_model(Activity, :id => 456)
      activity_2 = mock_model(Activity, :id => 789)
      feed.push activity_1
      feed.push activity_2

      feed.remove activity_1

      feed.activity_ids.should == [activity_2.id]
    end
  end

  describe "remove_id" do
    it "removes activity_id from list" do
      activity_1 = mock_model(Activity, :id => 456)
      activity_2 = mock_model(Activity, :id => 789)
      feed.push activity_1
      feed.push activity_2

      feed.remove_id activity_1.id

      feed.activity_ids.should == [activity_2.id]
    end
  end

  describe "owner" do
    it "should return given owner" do
      feed.owner.should == owner
    end
  end
end
