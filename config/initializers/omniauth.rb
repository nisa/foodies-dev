Rails.application.config.middleware.use OmniAuth::Builder do
  # :scope parameter specifies the requested permissions for graph api. if you set it to empty, it will only pull the basic info. Default values for this is 'email, offline_access'
  # provide Site URL as http://localhost:3000/ in your facebook app. Now you will be able to access it from your development machine
  facebook_options = {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}, :scope => ''}

  provider :facebook, APP_CONFIG['facebook']['APP_ID'], APP_CONFIG['facebook']['APP_SECRET'], facebook_options
  provider :google_oauth2, APP_CONFIG['google']['CLIENT-ID'], APP_CONFIG['google']['CLIENT-SECRET']
end

