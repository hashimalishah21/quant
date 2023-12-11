class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def withings
    if user_signed_in?
      if current_user.has_withings_auth?
        flash[:success] = "You've already synchronized your scale"
      else
        current_user.create_withings_account(
        userid: params["userid"],
        oauth_token: request.env["omniauth.auth"]["credentials"]["token"],
        oauth_verifier: params["oauth_verifier"],
        oauth_token_secret: request.env["omniauth.auth"]["credentials"]["secret"])

        flash[:success] = "Withings scale synchronized"
      end
      redirect_to dashboard_index_path
    else
      flash[:alert] = "You must be signed in to authenticate your Withings scale"
      redirect_to new_user_session_path
    end
  end
end
