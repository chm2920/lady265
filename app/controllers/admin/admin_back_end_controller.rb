class Admin::AdminBackEndController < ApplicationController
  
  #before_filter :require_admin
  
  layout "admin_back_end"
  
  def require_admin
    if session[:user_id].nil? || session[:user_id]!=1
      redirect_to "/"
    end
  end
  
end
