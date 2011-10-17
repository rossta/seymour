require 'spec_helper'

describe Seymour::Renderable do
  describe "render" do
    let(:response) { mock(ActionDispatch::Response, :body => 'Lots of activity going on') }
    let(:activity) { Factory(:test_activity) }

    before(:each) do
      ok_rack_response = lambda { |env| ['200', {}, response ] }
      Seymour::RenderController.stub!(:action).and_return ok_rack_response
    end

    it "should render activity partial via render controller" do
      response = activity.render("seymour/render", "activity", "seymour.activity" => activity)
      response.should == 'Lots of activity going on'
    end

    it "should raise RenderError if response not OK" do
      bad_rack_response = lambda { |env| ['500', {}, response ] }
      Seymour::RenderController.stub!(:action).and_return bad_rack_response
      calling_render = lambda {
        activity.render("seymour/render", "activity", "seymour.activity" => activity)
      }
      calling_render.should raise_error(Seymour::RenderError)
    end
  end
end
