# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # render new.rhtml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.iphone # new.iphone.erb
    end
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      self.current_user.update_attribute(:facebook_id, fbsession.session_user_id)
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end