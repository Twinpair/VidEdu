# Rails.application.config.middleware.use OmniAuth::Builder do
# #  provider :google_oauth2, ENV['  '], ENV[''], scope: 'userinfo.profile,youtube'
#     provider :google_oauth2, '561247181954-hd6k9iumec5schpcenni8mv6nmekpqhf.apps.googleusercontent.com', 'hnKZDHlgIHAeBruJ2GZy9442', scope: 'userinfo.profile,youtube', 'email,profile'

#   #OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?
# end

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
# end

# Custom scope supporting youtube. If you are customizing scopes, remember
  # to include the default scopes 'email' and 'profile'
  #
  # provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {
  #   :scope => 'http://gdata.youtube.com,email,profile,plus.me'
  # }