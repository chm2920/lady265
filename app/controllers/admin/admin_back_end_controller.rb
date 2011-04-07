class Admin::AdminBackEndController < ApplicationController
  
  before_filter :require_admin
  
  layout "admin_back_end"
  
  def require_admin
    if session[:admin_id].nil?
      redirect_to "/"
    end
  end
  
end
