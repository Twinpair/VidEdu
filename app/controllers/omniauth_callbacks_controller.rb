# class OmniauthCallbacksController < ApplicationController
#     def all
#         user = User.from_omniauth(request.env["omniauth.auth"])
    
#         if user.persisted?
#             sign_in_and_redirect user, notice: "Signed in"
#         else
#             session["devise.user_attributes"] = user.attributes
#             redirect_to new_user_registration_url
#         end
#     end

#     alias_method :facebook, :all
#     alias_method :twitter, :all
#     #alias_method :google, :all
# end

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
     
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
 
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end


    def all
        user = User.from_omniauth(request.env["omniauth.auth"])
    
        if user.persisted?
            sign_in_and_redirect user, notice: "Signed in"
        else
            session["devise.user_attributes"] = user.attributes
            redirect_to new_user_registration_url
        end
    end

    def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    # unless user
    #     user = User.create(name: data["name"],
    #        email: data["email"],
    #        password: Devise.friendly_token[0,20]
    #     )
    # end
    user
end

    alias_method :facebook, :all
    alias_method :twitter, :all


end