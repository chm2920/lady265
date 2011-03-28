class AccountController < ApplicationController
  
  layout false
  
  def login
    if request.post?
      #session[:admin_id] = Admin.find(:first).id
      redirect_to :action => 'main'
    end
  end
  
  def main
    
  end
  
  def desktop
    
  end
  
  def logout
    redirect_to :action => 'login'
  end
  
end
