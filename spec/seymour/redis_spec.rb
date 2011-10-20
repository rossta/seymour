require 'spec_helper'

describe "Seymour.redis" do

  describe "redis" do
    it "can set a namespace through a url-like string" do
      Seymour.redis.should be_a(Redis::Namespace)
      :seymour.should == Seymour.redis.namespace
      Seymour.redis = 'localhost:9736/namespace'
      'namespace'.should == Seymour.redis.namespace
    end
  end

end
