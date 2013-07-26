class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  include ActionView::Helpers::TextHelper
  protect_from_forgery
  force_ssl
  
  helper :all # include all helpers, all the time  
  helper_method :my_jobs
  
  private
  
  def auth_user
    redirect_to new_user_registration_url unless user_signed_in?
  end
  
  def my_jobs
    @my_jobs = Job.joins("LEFT JOIN `jobs_workers` ON jobs.id = jobs_workers.job_id").where('jobs_workers.user_id' => @current_user.id).to_a
  end
  
end
