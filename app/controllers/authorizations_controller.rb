class AuthorizationsController < ApplicationController
  before_filter :require_user, :only => [:destroy]

  def create
    omniauth = request.env['omniauth.auth'] #this is where you get all the data from your provider through omniauth
    @auth = Authorization.find_from_hash(omniauth)
    @registered_user = User.find_by_email(omniauth['info']['email'])
    
    if @auth
      flash[:notice] = "Welcome back #{omniauth['provider']} user."
      log_in_and_redirect(@auth.user)
    elsif @registered_user
        user = @registered_user
        Authorization.create({:user_id => user.id, :provider => omniauth['provider'], :uid => omniauth['uid']}, :without_protection => true)
        log_in_and_redirect(user)
        flash[:notice] = "Signed in successfully."
    else
        user = User.new
        user.apply_omniauth(omniauth)
        user.reset_persistence_token
        if user.save(:validate => false)
          Authorization.create({:user_id => user.id, :provider => omniauth['provider'], :uid => omniauth['uid']}, :without_protection => true)
          flash[:notice] = "User created and signed in successfully."
          log_in_and_redirect(user)
        else
          session[:omniauth] = omniauth.except('extra')
          redirect_to register_path
        end
    end  
  end
  
  def destroy
    @authorization = current_user.authorizations.find(params[:id])
    flash[:notice] = "Successfully deleted #{@authorization.provider} authentication."
    @authorization.destroy
    redirect_to authorizations_url
  end

  private

  def log_in_and_redirect(user)
    unless current_user
      user_session = UserSession.new(User.find_by_single_access_token(user.single_access_token))
      user_session.save
    end
    redirect_to root_url
  end

end
