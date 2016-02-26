class Users::SessionsController < Devise::SessionsController
  skip_before_action :require_no_authentication, :only => [:new, :create]
end
