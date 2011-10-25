module Seymour
  # This controller is not mapped to a route, as that would be a security issue
  # It's used internally by Activity#html, etc. --BH
  class RenderController < ActionController::Base
    include ActionController::Rendering
    helper :all

    def activity
      render :partial => "activities/activity", :locals => {
        :activity => request.env["seymour.activity"]
      }
    end

  end
end
