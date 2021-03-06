# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/autorun'
require 'spec/rails'

Spec::Runner.configure do |config|
  
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.global_fixtures            = :all
  config.fixture_path = "#{Rails.root}/spec/fixtures"

  def running(&block)
    lambda &block
  end
  
  def cookie(name, value)
    @request.cookies[name.to_s] = CGI::Cookie.new(name.to_s, value.to_s)
  end
  
  def login_as(name)
    @current_user = users(name)
    @request.session[:user_id] = @current_user.id
    cookie :user_id, @current_user.id
    cookie :password_hash, @current_user.password_hash
  end

end


# Always integrate_views in controllers
module Spec
  module Rails
    module Example
      class ControllerExampleGroup
        module ControllerInstanceMethods
          def integrate_views?
            true
          end
        end
      end
    end
  end
end