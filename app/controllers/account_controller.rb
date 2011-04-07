# coding: utf-8
class AccountController < ApplicationController
  
  layout false
  
  def login
  end
  
  def login_rst
    if !params[:name].blank? && !params[:password].blank?
      adminname = params[:name]
      password = Digest::MD5.hexdigest(params[:password])
      @admin = Admin.find_by_adminname(adminname)
      if @admin.nil?
        @login_rst = 0
        @err_msg = "用户名密码错误。"
      else
        if @admin.password == password
          @login_rst = 1
          session[:admin_id] = @admin.id
        else
          @login_rst = 0
          @err_msg = "用户名密码错误!"
        end
      end            
    else
      @login_rst = 0
      @err_msg = "用户名密码不能为空。"
    end
    if @login_rst==1
      redirect_to :action => 'main'
    else
      render :action => "login"
    end
  end
  
  def main
    if session[:admin_id].nil?
      redirect_to "/"
    end
  end
  
  def desktop
    
  end
  
  def logout
    session[:admin_id] = nil
    redirect_to :action => 'login'
  end
  
end
