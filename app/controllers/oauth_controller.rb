class OauthController < ApplicationController

  def facebook
    user = User.find_or_create_by_fb_auth_hash(request.env['omniauth.auth'])
    login_user(user)

    flash[:success] = "Logged in with facebook!"
    redirect_to "#" + user_path(user)
  end

end