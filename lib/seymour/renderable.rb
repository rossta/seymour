module Seymour

  class RenderError < RuntimeError
  end

  module Renderable
    extend ActiveSupport::Concern

    def render_html
      render("seymour/render", "activity", "seymour.activity" => self)
    rescue RenderError
      return nil
    end

    def render(controller_name, action_name, env = {})
      # TODO define proper server name
        # { "REQUEST_URI" => "", "SERVER_NAME" => 'http://www.example.com' }.merge(env))

      env = Rack::MockRequest.env_for("/",
        { "REQUEST_URI" => "", "SERVER_NAME" => '' }.merge(env))

      controller_class = "#{controller_name}_controller".classify.constantize

      status, headers, response = controller_class.action(action_name.to_sym).call(env)
      raise RenderError.new("#{controller_name}##{action_name}") unless status.to_i == 200
      response.body
    end

  end

end