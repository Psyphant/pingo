class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper
  protect_from_forgery
  #force_ssl

  helper :all # include all helpers, all the time
  helper_method :my_pins

  private

  before_action :set_locale

  def auth_user
    redirect_to new_user_registration_url unless user_signed_in?
  end

  def set_locale
    I18n.locale = user_signed_in? ? current_user.locale.to_sym : I18n.default_locale
  end

  def my_pins
    @my_pins = Pin.where(:user_id => @current_user.id).to_a
  end

  def mobile_browser?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|iPad|Android)/]
  end
  helper_method :mobile_browser?

end
