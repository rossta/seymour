require 'spec_helper'

describe Seymour::Feed do

  module FactoryHelper
    def new_owner
      stub_model(User)
    end

    def new_activity(attrs = {})
      mock_model(Activity, attrs)
    end
  end
  include FactoryHelper

  let(:owner) { new_owner }
  let(:feed)  { Seymour::Feed.new(owner) }

  class ListFeed < Seymour::Feed
    key do
      "feed::#{owner.id}"
    end

    store :list
  end

  class ZsetFeed < Seymour::Feed
    store :zset
  end

  describe "class methods" do
    describe "feed_classes" do
      it "should provide a list of feed sub classes" do
        Seymour::Feed.feed_classes.should include(EventFeed)
      end
    end

    describe "distribute" do
      it "should call activity distribute on activity" do
        activity    = new_activity
        activity.should_receive(:distribute)
        Seymour::Feed.distribute(activity)
      end
    end

    describe "key" do
      it "should override default feed key" do
        feed = ListFeed.new(owner)
        feed.key.should == "feed::#{owner.id}"
      end
    end

    describe "store" do
      it "should default to list feed" do
        feed.store.should be_a(Seymour::Store::List)
      end

      it "should set type of storage to list" do
        feed = ListFeed.new(owner)
        feed.store.should be_a(Seymour::Store::List)
      end

      it "should set type of storage to zset" do
        feed = ZsetFeed.new(owner)
        feed.store.should be_a(Seymour::Store::Zset)
      end
    end
  end

  describe "activity_ids" do
    it "should return an empty list initially" do
      feed.activity_ids.should == []
    end
  end

  describe "owner" do
    it "should return given owner" do
      feed.owner.should == owner
    end
  end

  describe "key" do
    it "should return default" do
      feed.send(:key).should == "#{owner.class.name}:#{owner.id}/seymour::feed"
    end
  end

  describe "list feed" do
    describe "push" do
      it "prepends id of given activity to activity_ids" do
        feed.push new_activity(:id => 123)
        feed.activity_ids.should == [123]

        feed.push new_activity(:id => 456)
        feed.activity_ids.should == [456, 123]
      end

      it "new feed with same owner pushes to same list" do
        new_feed = Seymour::Feed.new(owner)

        feed.push new_activity(:id => 123)
        new_feed.push new_activity(:id => 456)

        feed.activity_ids.should == [456, 123]
        new_feed.activity_ids.should == [456, 123]
      end

      it "new feed with different owner pushes to different list" do
        new_owner = mock_model(User)
        new_feed = Seymour::Feed.new(new_owner)

        feed.push new_activity(:id => 123)
        new_feed.push new_activity(:id => 456)

        feed.activity_ids.should == [123]
        new_feed.activity_ids.should == [456]
      end

    end

    describe "bulk_push" do
      it "should accept multiple values" do
        feed.bulk_push [new_activity(:id => 123), new_activity(:id => 456)]
        feed.activity_ids.should == [456, 123]
      end

      it "should not append duplicates" do
        feed.bulk_push [new_activity(:id => 123), new_activity(:id => 456), new_activity(:id => 123)]
        feed.activity_ids.should == [456, 123]
      end
    end

    describe "sort" do
      it "should sort list in desc order by default" do
        feed.bulk_push [new_activity(:id => 456), new_activity(:id => 123)]
        feed.sort!
        feed.activity_ids.should == [456, 123]
      end
    end

    describe "insert_and_order" do
      it "should insert activities into the list" do
        activities = [new_activity(:id => 123), new_activity(:id => 456)]
        feed.insert_and_order(activities)

        feed.activity_ids.should == [456, 123]
      end

      it "should reorder activities by id" do
        feed.push new_activity(:id => 123)
        feed.push new_activity(:id => 456)

        activities = [new_activity(:id => 234), new_activity(:id => 789)]

        feed.insert_and_order(activities)

        feed.activity_ids.should == [789, 456, 234, 123]
      end

      it "should not allow duplicates" do
        feed.push new_activity(:id => 123)
        feed.push new_activity(:id => 456)

        activities = [new_activity(:id => 123), new_activity(:id => 789)]

        feed.insert_and_order(activities)

        feed.activity_ids.should == [789, 456, 123]
      end
    end

    describe "remove" do
      it "removes activity from list by id" do
        activity_1 = new_activity(:id => 456)
        activity_2 = new_activity(:id => 789)
        feed.push activity_1
        feed.push activity_2

        feed.remove activity_1

        feed.activity_ids.should == [activity_2.id]
      end
    end

    describe "remove_id" do
      it "removes activity_id from list" do
        activity_1 = new_activity(:id => 456)
        activity_2 = new_activity(:id => 789)
        feed.push activity_1
        feed.push activity_2

        feed.remove_id activity_1.id

        feed.activity_ids.should == [activity_2.id]
      end
    end
  end

  describe "zset" do
    let(:feed)  { ZsetFeed.new(owner) }

    describe "push" do
      it "returns ids sorted by score, highest to lowest" do
        feed.push new_activity(:id => 123, :score => 1)
        feed.push new_activity(:id => 456, :score => 3)
        feed.activity_ids.should == [456, 123]
      end

      it "returns accepts score as second arg" do
        feed.push new_activity(:id => 123), 2
        feed.push new_activity(:id => 456), 1
        feed.activity_ids.should == [123, 456]
      end

      it "returns ordered by id when scores equal" do
        feed.push new_activity(:id => 456), 1
        feed.push new_activity(:id => 123), 1
        feed.activity_ids.should == [456, 123]
      end

      it "does not add duplicates but updates score" do
        feed.push new_activity(:id => 123), 2
        feed.push new_activity(:id => 456), 1
        feed.push new_activity(:id => 456), 3
        feed.activity_ids.should == [456, 123]
      end
    end

    describe "bulk_push" do
      it "should accept multiple values" do
        feed.bulk_push [new_activity(:id => 123, :score => 1), new_activity(:id => 456, :score => 3)]
        feed.activity_ids.should == [456, 123]
      end

      it "should not append duplicates" do
        feed.bulk_push [new_activity(:id => 123, :score => 2),
          new_activity(:id => 456, :score => 1), new_activity(:id => 123, :score => 3)]
        feed.activity_ids.should == [123, 456]
      end
    end

    describe "union" do
      it "should store union of given feeds" do
        feed_1 = ZsetFeed.new(new_owner)
        feed_2 = ZsetFeed.new(new_owner)

        feed_1.push new_activity(:id => 456), 2
        feed_2.push new_activity(:id => 123), 1
        feed_2.push new_activity(:id => 789), 3

        feed_1.activity_ids.should == [456]
        feed_2.activity_ids.should == [789, 123]

        feed.union [feed_1, feed_2]
        feed.activity_ids.should == [789, 456, 123]
      end
    end

    describe "intersect" do
      it "should store intersection of given feeds" do
        feed.bulk_push [new_activity(:id => 456), new_activity(:id => 123)]
        feed.sort!
        feed.activity_ids.should == [456, 123]
      end
    end

    #
    # describe "insert_and_order" do
    #   it "should insert activities into the list" do
    #     activities = [new_activity(:id => 123), new_activity(:id => 456)]
    #     feed.insert_and_order(activities)
    #
    #     feed.activity_ids.should == [456, 123]
    #   end
    #
    #   it "should reorder activities by id" do
    #     feed.push new_activity(:id => 123)
    #     feed.push new_activity(:id => 456)
    #
    #     activities = [new_activity(:id => 234), new_activity(:id => 789)]
    #
    #     feed.insert_and_order(activities)
    #
    #     feed.activity_ids.should == [789, 456, 234, 123]
    #   end
    #
    #   it "should not allow duplicates" do
    #     feed.push new_activity(:id => 123)
    #     feed.push new_activity(:id => 456)
    #
    #     activities = [new_activity(:id => 123), new_activity(:id => 789)]
    #
    #     feed.insert_and_order(activities)
    #
    #     feed.activity_ids.should == [789, 456, 123]
    #   end
    # end
    #
    describe "remove" do
      it "removes activity from list by id" do
        activity_1 = new_activity(:id => 456)
        activity_2 = new_activity(:id => 789)
        feed.push activity_1, 2
        feed.push activity_2, 1

        feed.remove activity_1

        feed.activity_ids.should == [activity_2.id]
      end
    end

    describe "remove_id" do
      it "removes activity_id from list" do
        activity_1 = new_activity(:id => 456)
        activity_2 = new_activity(:id => 789)
        feed.push activity_1, 2
        feed.push activity_2, 1

        feed.remove_id activity_1.id

        feed.activity_ids.should == [activity_2.id]
      end
    end
  end
end
