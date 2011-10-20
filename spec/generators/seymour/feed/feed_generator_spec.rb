require 'spec_helper'

# Generators are not automatically loaded by Rails
require 'generators/seymour/feed/feed_generator'

describe Seymour::FeedGenerator do
  # Tell the generator where to put its output (what it thinks of as Rails.root)
  destination File.expand_path("../../../../../tmp", __FILE__)

  before { prepare_destination }

  describe 'no arguments' do
    before { run_generator %w(dashboard)  }

    describe 'app/models/feeds/dashboard_feed.rb' do
      subject { file('app/models/feeds/dashboard_feed.rb') }
      it { should exist }
      it { should contain "class DashboardFeed < Seymour::Feed" }
    end

  end
end
