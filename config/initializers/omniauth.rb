Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :google_oauth2, ENV['  '], ENV[''], scope: 'userinfo.profile,youtube'
    provider :google_oauth2, '561247181954-hd6k9iumec5schpcenni8mv6nmekpqhf.apps.googleusercontent.com', 'hnKZDHlgIHAeBruJ2GZy9442', scope: 'userinfo.profile,youtube'

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?
end